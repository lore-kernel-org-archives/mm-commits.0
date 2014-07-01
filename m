From: akpm@linux-foundation.org
Subject: + mm-hugetlb-generalize-writes-to-nr_hugepages.patch added to -mm tree
Date: Tue, 01 Jul 2014 15:35:42 -0700
Message-ID: <53b337be.XWauVyWmP/I/vwWf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:41217 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaGAWfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 18:35:44 -0400
Received: by mail-oa0-f73.google.com with SMTP id eb12so2377540oac.2
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 15:35:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, lcapitulino@redhat.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: generalize writes to nr_hugepages
has been added to the -mm tree.  Its filename is
     mm-hugetlb-generalize-writes-to-nr_hugepages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-generalize-writes-to-nr_hugepages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-generalize-writes-to-nr_hugepages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hugetlb: generalize writes to nr_hugepages

Three different interfaces alter the maximum number of hugepages for an
hstate:

 - /proc/sys/vm/nr_hugepages for global number of hugepages of the default
   hstate,

 - /sys/kernel/mm/hugepages/hugepages-X/nr_hugepages for global number of
   hugepages for a specific hstate, and

 - /sys/kernel/mm/hugepages/hugepages-X/nr_hugepages/mempolicy for number of
   hugepages for a specific hstate over the set of allowed nodes.

Generalize the code so that a single function handles all of these writes
instead of duplicating the code in two different functions.

This decreases the number of lines of code, but also reduces the size of
.text by about half a percent since set_max_huge_pages() can be inlined.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   61 ++++++++++++++++++++-----------------------------
 1 file changed, 26 insertions(+), 35 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-generalize-writes-to-nr_hugepages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-generalize-writes-to-nr_hugepages
+++ a/mm/hugetlb.c
@@ -1735,21 +1735,13 @@ static ssize_t nr_hugepages_show_common(
 	return sprintf(buf, "%lu\n", nr_huge_pages);
 }
 
-static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
-			struct kobject *kobj, struct kobj_attribute *attr,
-			const char *buf, size_t len)
+static ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
+					   struct hstate *h, int nid,
+					   unsigned long count, size_t len)
 {
 	int err;
-	int nid;
-	unsigned long count;
-	struct hstate *h;
 	NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
 
-	err = kstrtoul(buf, 10, &count);
-	if (err)
-		goto out;
-
-	h = kobj_to_hstate(kobj, &nid);
 	if (hstate_is_gigantic(h) && !gigantic_page_supported()) {
 		err = -EINVAL;
 		goto out;
@@ -1785,6 +1777,23 @@ out:
 	return err;
 }
 
+static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
+					 struct kobject *kobj, const char *buf,
+					 size_t len)
+{
+	struct hstate *h;
+	unsigned long count;
+	int nid;
+	int err;
+
+	err = kstrtoul(buf, 10, &count);
+	if (err)
+		return err;
+
+	h = kobj_to_hstate(kobj, &nid);
+	return __nr_hugepages_store_common(obey_mempolicy, h, nid, count, len);
+}
+
 static ssize_t nr_hugepages_show(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *buf)
 {
@@ -1794,7 +1803,7 @@ static ssize_t nr_hugepages_show(struct
 static ssize_t nr_hugepages_store(struct kobject *kobj,
 	       struct kobj_attribute *attr, const char *buf, size_t len)
 {
-	return nr_hugepages_store_common(false, kobj, attr, buf, len);
+	return nr_hugepages_store_common(false, kobj, buf, len);
 }
 HSTATE_ATTR(nr_hugepages);
 
@@ -1813,7 +1822,7 @@ static ssize_t nr_hugepages_mempolicy_sh
 static ssize_t nr_hugepages_mempolicy_store(struct kobject *kobj,
 	       struct kobj_attribute *attr, const char *buf, size_t len)
 {
-	return nr_hugepages_store_common(true, kobj, attr, buf, len);
+	return nr_hugepages_store_common(true, kobj, buf, len);
 }
 HSTATE_ATTR(nr_hugepages_mempolicy);
 #endif
@@ -2249,36 +2258,18 @@ static int hugetlb_sysctl_handler_common
 			 void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct hstate *h = &default_hstate;
-	unsigned long tmp;
+	unsigned long tmp = h->max_huge_pages;
 	int ret;
 
-	if (!hugepages_supported())
-		return -ENOTSUPP;
-
-	tmp = h->max_huge_pages;
-
-	if (write && hstate_is_gigantic(h) && !gigantic_page_supported())
-		return -EINVAL;
-
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
 	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
 	if (ret)
 		goto out;
 
-	if (write) {
-		NODEMASK_ALLOC(nodemask_t, nodes_allowed,
-						GFP_KERNEL | __GFP_NORETRY);
-		if (!(obey_mempolicy &&
-			       init_nodemask_of_mempolicy(nodes_allowed))) {
-			NODEMASK_FREE(nodes_allowed);
-			nodes_allowed = &node_states[N_MEMORY];
-		}
-		h->max_huge_pages = set_max_huge_pages(h, tmp, nodes_allowed);
-
-		if (nodes_allowed != &node_states[N_MEMORY])
-			NODEMASK_FREE(nodes_allowed);
-	}
+	if (write)
+		ret = __nr_hugepages_store_common(obey_mempolicy, h,
+						  NUMA_NO_NODE, tmp, *length);
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from rientjes@google.com are

mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order.patch
slub-fix-off-by-one-in-number-of-slab-tests.patch
proc-stat-convert-to-single_open_size.patch
fs-seq_file-fallback-to-vmalloc-allocation.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-checkpatch-fixes.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
slab-set-free_limit-for-dead-caches-to-0.patch
slab-add-unlikely-macro-to-help-compiler.patch
slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch
slab-defer-slab_destroy-in-free_block.patch
slab-factor-out-initialization-of-arracy-cache.patch
slab-introduce-alien_cache.patch
slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
slab-remove-a-useless-lockdep-annotation.patch
slab-remove-bad_alien_magic.patch
slub-reduce-duplicate-creation-on-the-first-object.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
mm-vmalloc-constify-allocation-mask.patch
mmhugetlb-make-unmap_ref_private-return-void.patch
mmhugetlb-simplify-error-handling-in-hugetlb_cow.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
lib-add-size-unit-t-p-e-to-memparse.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch


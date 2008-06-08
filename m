From: akpm@linux-foundation.org
Subject: + hugetlb-new-sysfs-interface.patch added to -mm tree
Date: Sun, 08 Jun 2008 12:11:37 -0700
Message-ID: <200806081911.m58JBb8C016143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754597AbYFHTQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:16:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, gregkh@suse.de, nacc@us.ibm.com


The patch titled
     hugetlb: new sysfs interface
has been added to the -mm tree.  Its filename is
     hugetlb-new-sysfs-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: new sysfs interface
From: Nick Piggin <npiggin@suse.de>

Provide new hugepages user APIs that are more suited to multiple hstates
in sysfs.  There is a new directory, /sys/kernel/hugepages.  Underneath
that directory there will be a directory per-supported hugepage size,
e.g.:

/sys/kernel/hugepages/hugepages-64kB
/sys/kernel/hugepages/hugepages-16384kB
/sys/kernel/hugepages/hugepages-16777216kB

corresponding to 64k, 16m and 16g respectively.  Within each
hugepages-size directory there are a number of files, corresponding to the
tracked counters in the hstate, e.g.:

/sys/kernel/hugepages/hugepages-64/nr_hugepages
/sys/kernel/hugepages/hugepages-64/nr_overcommit_hugepages
/sys/kernel/hugepages/hugepages-64/free_hugepages
/sys/kernel/hugepages/hugepages-64/resv_hugepages
/sys/kernel/hugepages/hugepages-64/surplus_hugepages

Of these files, the first two are read-write and the latter three are
read-only.  The size of the hugepage being manipulated is trivially
deducible from the enclosing directory and is always expressed in kB (to
match meminfo).

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-hugepages |   14 
 include/linux/hugetlb.h                          |    2 
 mm/hugetlb.c                                     |  294 ++++++++++---
 3 files changed, 244 insertions(+), 66 deletions(-)

diff -puN /dev/null Documentation/ABI/testing/sysfs-kernel-hugepages
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-hugepages
@@ -0,0 +1,14 @@
+What:		/sys/kernel/hugepages/
+Date:		June 2008
+Contact:	Nishanth Aravamudan <nacc@us.ibm.com>, hugetlb maintainers
+Description:
+		/sys/kernel/hugepages/ contains a number of subdirectories
+		of the form hugepages-<size>kb, where <size> is the page size
+		of the hugepages supported by the kernel/CPU combination.
+
+		Under these directories are a number of files:
+		nr_hugepages - minimum number of hugepages reserved
+		nr_overcommit_hugepages - maximum number that can be allocated
+		free_hugepages - number of hugepages free
+		surplus_hugepages -
+		resv_hugepages -
diff -puN include/linux/hugetlb.h~hugetlb-new-sysfs-interface include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-new-sysfs-interface
+++ a/include/linux/hugetlb.h
@@ -164,6 +164,7 @@ unsigned long hugetlb_get_unmapped_area(
 
 #ifdef CONFIG_HUGETLB_PAGE
 
+#define HSTATE_NAME_LEN 32
 /* Defines one hugetlb page size */
 struct hstate {
 	int hugetlb_next_nid;
@@ -179,6 +180,7 @@ struct hstate {
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
+	char name[HSTATE_NAME_LEN];
 };
 
 void __init hugetlb_add_hstate(unsigned order);
diff -puN mm/hugetlb.c~hugetlb-new-sysfs-interface mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-new-sysfs-interface
+++ a/mm/hugetlb.c
@@ -14,6 +14,7 @@
 #include <linux/mempolicy.h>
 #include <linux/cpuset.h>
 #include <linux/mutex.h>
+#include <linux/sysfs.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -867,72 +868,6 @@ static void __init report_hugepages(void
 	}
 }
 
-static int __init hugetlb_init(void)
-{
-	BUILD_BUG_ON(HPAGE_SHIFT == 0);
-
-	if (!size_to_hstate(HPAGE_SIZE)) {
-		hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
-		parsed_hstate->max_huge_pages = default_hstate_max_huge_pages;
-	}
-	default_hstate_idx = size_to_hstate(HPAGE_SIZE) - hstates;
-
-	hugetlb_init_hstates();
-
-	report_hugepages();
-
-	return 0;
-}
-module_init(hugetlb_init);
-
-/* Should be called on processing a hugepagesz=... option */
-void __init hugetlb_add_hstate(unsigned order)
-{
-	struct hstate *h;
-	if (size_to_hstate(PAGE_SIZE << order)) {
-		printk(KERN_WARNING "hugepagesz= specified twice, ignoring\n");
-		return;
-	}
-	BUG_ON(max_hstate >= HUGE_MAX_HSTATE);
-	BUG_ON(order == 0);
-	h = &hstates[max_hstate++];
-	h->order = order;
-	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
-	hugetlb_init_one_hstate(h);
-	parsed_hstate = h;
-}
-
-static int __init hugetlb_setup(char *s)
-{
-	unsigned long *mhp;
-
-	/*
-	 * !max_hstate means we haven't parsed a hugepagesz= parameter yet,
-	 * so this hugepages= parameter goes to the "default hstate".
-	 */
-	if (!max_hstate)
-		mhp = &default_hstate_max_huge_pages;
-	else
-		mhp = &parsed_hstate->max_huge_pages;
-
-	if (sscanf(s, "%lu", mhp) <= 0)
-		*mhp = 0;
-
-	return 1;
-}
-__setup("hugepages=", hugetlb_setup);
-
-static unsigned int cpuset_mems_nr(unsigned int *array)
-{
-	int node;
-	unsigned int nr = 0;
-
-	for_each_node_mask(node, cpuset_current_mems_allowed)
-		nr += array[node];
-
-	return nr;
-}
-
 #ifdef CONFIG_SYSCTL
 #ifdef CONFIG_HIGHMEM
 static void try_to_free_low(struct hstate *h, unsigned long count)
@@ -1030,6 +965,233 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_SYSFS
+#define HSTATE_ATTR_RO(_name) \
+	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
+
+#define HSTATE_ATTR(_name) \
+	static struct kobj_attribute _name##_attr = \
+		__ATTR(_name, 0644, _name##_show, _name##_store)
+
+static struct kobject *hugepages_kobj;
+static struct kobject *hstate_kobjs[HUGE_MAX_HSTATE];
+
+static struct hstate *kobj_to_hstate(struct kobject *kobj)
+{
+	int i;
+	for (i = 0; i < HUGE_MAX_HSTATE; i++)
+		if (hstate_kobjs[i] == kobj)
+			return &hstates[i];
+	BUG();
+	return NULL;
+}
+
+static ssize_t nr_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h = kobj_to_hstate(kobj);
+	return sprintf(buf, "%lu\n", h->nr_huge_pages);
+}
+static ssize_t nr_hugepages_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	int err;
+	unsigned long input;
+	struct hstate *h = kobj_to_hstate(kobj);
+
+	err = strict_strtoul(buf, 10, &input);
+	if (err)
+		return 0;
+
+	h->max_huge_pages = set_max_huge_pages(h, input);
+
+	return count;
+}
+HSTATE_ATTR(nr_hugepages);
+
+static ssize_t nr_overcommit_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h = kobj_to_hstate(kobj);
+	return sprintf(buf, "%lu\n", h->nr_overcommit_huge_pages);
+}
+static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	int err;
+	unsigned long input;
+	struct hstate *h = kobj_to_hstate(kobj);
+
+	err = strict_strtoul(buf, 10, &input);
+	if (err)
+		return 0;
+
+	spin_lock(&hugetlb_lock);
+	h->nr_overcommit_huge_pages = input;
+	spin_unlock(&hugetlb_lock);
+
+	return count;
+}
+HSTATE_ATTR(nr_overcommit_hugepages);
+
+static ssize_t free_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h = kobj_to_hstate(kobj);
+	return sprintf(buf, "%lu\n", h->free_huge_pages);
+}
+HSTATE_ATTR_RO(free_hugepages);
+
+static ssize_t resv_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h = kobj_to_hstate(kobj);
+	return sprintf(buf, "%lu\n", h->resv_huge_pages);
+}
+HSTATE_ATTR_RO(resv_hugepages);
+
+static ssize_t surplus_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h = kobj_to_hstate(kobj);
+	return sprintf(buf, "%lu\n", h->surplus_huge_pages);
+}
+HSTATE_ATTR_RO(surplus_hugepages);
+
+static struct attribute *hstate_attrs[] = {
+	&nr_hugepages_attr.attr,
+	&nr_overcommit_hugepages_attr.attr,
+	&free_hugepages_attr.attr,
+	&resv_hugepages_attr.attr,
+	&surplus_hugepages_attr.attr,
+	NULL,
+};
+
+static struct attribute_group hstate_attr_group = {
+	.attrs = hstate_attrs,
+};
+
+static int __init hugetlb_sysfs_add_hstate(struct hstate *h)
+{
+	int retval;
+
+	hstate_kobjs[h - hstates] = kobject_create_and_add(h->name,
+							hugepages_kobj);
+	if (!hstate_kobjs[h - hstates])
+		return -ENOMEM;
+
+	retval = sysfs_create_group(hstate_kobjs[h - hstates],
+							&hstate_attr_group);
+	if (retval)
+		kobject_put(hstate_kobjs[h - hstates]);
+
+	return retval;
+}
+
+static void __init hugetlb_sysfs_init(void)
+{
+	struct hstate *h;
+	int err;
+
+	hugepages_kobj = kobject_create_and_add("hugepages", kernel_kobj);
+	if (!hugepages_kobj)
+		return;
+
+	for_each_hstate(h) {
+		err = hugetlb_sysfs_add_hstate(h);
+		if (err)
+			printk(KERN_ERR "Hugetlb: Unable to add hstate %s",
+								h->name);
+	}
+}
+#else
+static void __init hugetlb_sysfs_init(void)
+{
+}
+#endif
+
+static int __init hugetlb_init(void)
+{
+	BUILD_BUG_ON(HPAGE_SHIFT == 0);
+
+	if (!size_to_hstate(HPAGE_SIZE)) {
+		hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
+		parsed_hstate->max_huge_pages = default_hstate_max_huge_pages;
+	}
+	default_hstate_idx = size_to_hstate(HPAGE_SIZE) - hstates;
+
+	hugetlb_init_hstates();
+
+	report_hugepages();
+
+	hugetlb_sysfs_init();
+
+	return 0;
+}
+module_init(hugetlb_init);
+
+static void __exit hugetlb_exit(void)
+{
+	struct hstate *h;
+
+	for_each_hstate(h) {
+		kobject_put(hstate_kobjs[h - hstates]);
+	}
+
+	kobject_put(hugepages_kobj);
+}
+module_exit(hugetlb_exit);
+
+/* Should be called on processing a hugepagesz=... option */
+void __init hugetlb_add_hstate(unsigned order)
+{
+	struct hstate *h;
+	if (size_to_hstate(PAGE_SIZE << order)) {
+		printk(KERN_WARNING "hugepagesz= specified twice, ignoring\n");
+		return;
+	}
+	BUG_ON(max_hstate >= HUGE_MAX_HSTATE);
+	BUG_ON(order == 0);
+	h = &hstates[max_hstate++];
+	h->order = order;
+	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
+	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
+					huge_page_size(h)/1024);
+	hugetlb_init_one_hstate(h);
+	parsed_hstate = h;
+}
+
+static int __init hugetlb_setup(char *s)
+{
+	unsigned long *mhp;
+
+	/*
+	 * !max_hstate means we haven't parsed a hugepagesz= parameter yet,
+	 * so this hugepages= parameter goes to the "default hstate".
+	 */
+	if (!max_hstate)
+		mhp = &default_hstate_max_huge_pages;
+	else
+		mhp = &parsed_hstate->max_huge_pages;
+
+	if (sscanf(s, "%lu", mhp) <= 0)
+		*mhp = 0;
+
+	return 1;
+}
+__setup("hugepages=", hugetlb_setup);
+
+static unsigned int cpuset_mems_nr(unsigned int *array)
+{
+	int node;
+	unsigned int nr = 0;
+
+	for_each_node_mask(node, cpuset_current_mems_allowed)
+		nr += array[node];
+
+	return nr;
+}
+
 int hugetlb_sysctl_handler(struct ctl_table *table, int write,
 			   struct file *file, void __user *buffer,
 			   size_t *length, loff_t *ppos)
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
vt-fix-vc_resize-locking.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-abstract-numa-round-robin-selection.patch
mm-introduce-non-panic-alloc_bootmem.patch
mm-export-prep_compound_page-to-mm.patch
hugetlb-support-larger-than-max_order.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
hugetlb-introduce-pud_huge.patch
x86-support-gb-hugepages-on-64-bit.patch
x86-add-hugepagesz-option-on-64-bit.patch
hugetlb-override-default-huge-page-size.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
powerpc-define-support-for-16g-hugepages.patch
fs-check-for-statfs-overflow.patch
powerpc-support-multiple-hugepage-sizes.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch


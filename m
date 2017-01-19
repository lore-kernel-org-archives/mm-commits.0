From: akpm@linux-foundation.org
Subject: + mm-ksm-improve-deduplication-of-zero-pages-with-colouring.patch added to -mm tree
Date: Thu, 19 Jan 2017 13:23:18 -0800
Message-ID: <58812e46.8JvkR9VlP0KISMwB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751231AbdASVYO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2017 16:24:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imbrenda@linux.vnet.ibm.com, aarcange@redhat.com, borntraeger@de.ibm.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: improve deduplication of zero pages with colouring
has been added to the -mm tree.  Its filename is
     mm-ksm-improve-deduplication-of-zero-pages-with-colouring.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-improve-deduplication-of-zero-pages-with-colouring.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-improve-deduplication-of-zero-pages-with-colouring.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
Subject: mm/ksm: improve deduplication of zero pages with colouring

Some architectures have a set of zero pages (coloured zero pages) instead
of only one zero page, in order to improve the cache performance.  In
those cases, the kernel samepage merger (KSM) would merge all the
allocated pages that happen to be filled with zeroes to the same
deduplicated page, thus losing all the advantages of coloured zero pages.

This behaviour is noticeable when a process accesses large arrays of
allocated pages containing zeroes.  A test I conducted on s390 shows that
there is a speed penalty when KSM merges such pages, compared to not
merging them or using actual zero pages from the start without breaking
the COW.

This patch fixes this behaviour.  When coloured zero pages are present,
the checksum of a zero page is calculated during initialisation, and
compared with the checksum of the current canditate during merging.  In
case of a match, the normal merging routine is used to merge the page with
the correct coloured zero page, which ensures the candidate page is
checked to be equal to the target zero page.

A sysfs entry is also added to toggle this behaviour, since it can
potentially introduce performance regressions, especially on architectures
without coloured zero pages.  The default value is disabled, for backwards
compatibility.

With this patch, the performance with KSM is the same as with non
COW-broken actual zero pages, which is also the same as without KSM.

Link: http://lkml.kernel.org/r/1484850953-23941-1-git-send-email-imbrenda@linux.vnet.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 3 deletions(-)

diff -puN mm/ksm.c~mm-ksm-improve-deduplication-of-zero-pages-with-colouring mm/ksm.c
--- a/mm/ksm.c~mm-ksm-improve-deduplication-of-zero-pages-with-colouring
+++ a/mm/ksm.c
@@ -223,6 +223,12 @@ static unsigned int ksm_thread_pages_to_
 /* Milliseconds ksmd should sleep between batches */
 static unsigned int ksm_thread_sleep_millisecs = 20;
 
+/* Checksum of an empty (zeroed) page */
+static unsigned int zero_checksum;
+
+/* Whether to merge empty (zeroed) pages with actual zero pages */
+static bool ksm_use_zero_pages;
+
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
 static unsigned int ksm_merge_across_nodes = 1;
@@ -926,6 +932,7 @@ static int replace_page(struct vm_area_s
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t *pmd;
 	pte_t *ptep;
+	pte_t newpte;
 	spinlock_t *ptl;
 	unsigned long addr;
 	int err = -EFAULT;
@@ -950,12 +957,22 @@ static int replace_page(struct vm_area_s
 		goto out_mn;
 	}
 
-	get_page(kpage);
-	page_add_anon_rmap(kpage, vma, addr, false);
+	/*
+	 * No need to check ksm_use_zero_pages here: we can only have a
+	 * zero_page here if ksm_use_zero_pages was enabled alreaady.
+	 */
+	if (!is_zero_pfn(page_to_pfn(kpage))) {
+		get_page(kpage);
+		page_add_anon_rmap(kpage, vma, addr, false);
+		newpte = mk_pte(kpage, vma->vm_page_prot);
+	} else {
+		newpte = pte_mkspecial(pfn_pte(page_to_pfn(kpage),
+					       vma->vm_page_prot));
+	}
 
 	flush_cache_page(vma, addr, pte_pfn(*ptep));
 	ptep_clear_flush_notify(vma, addr, ptep);
-	set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
+	set_pte_at_notify(mm, addr, ptep, newpte);
 
 	page_remove_rmap(page, false);
 	if (!page_mapped(page))
@@ -1467,6 +1484,23 @@ static void cmp_and_merge_page(struct pa
 		return;
 	}
 
+	/*
+	 * Same checksum as an empty page. We attempt to merge it with the
+	 * appropriate zero page if the user enabled this via sysfs.
+	 */
+	if (ksm_use_zero_pages && (checksum == zero_checksum)) {
+		struct vm_area_struct *vma;
+
+		vma = find_mergeable_vma(rmap_item->mm, rmap_item->address);
+		err = try_to_merge_one_page(vma, page,
+					    ZERO_PAGE(rmap_item->address));
+		/*
+		 * In case of failure, the page was not really empty, so we
+		 * need to continue. Otherwise we're done.
+		 */
+		if (!err)
+			return;
+	}
 	tree_rmap_item =
 		unstable_tree_search_insert(rmap_item, page, &tree_page);
 	if (tree_rmap_item) {
@@ -2233,6 +2267,28 @@ static ssize_t merge_across_nodes_store(
 KSM_ATTR(merge_across_nodes);
 #endif
 
+static ssize_t use_zero_pages_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", ksm_use_zero_pages);
+}
+static ssize_t use_zero_pages_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count)
+{
+	int err;
+	bool value;
+
+	err = kstrtobool(buf, &value);
+	if (err)
+		return -EINVAL;
+
+	ksm_use_zero_pages = value;
+
+	return count;
+}
+KSM_ATTR(use_zero_pages);
+
 static ssize_t pages_shared_show(struct kobject *kobj,
 				 struct kobj_attribute *attr, char *buf)
 {
@@ -2290,6 +2346,7 @@ static struct attribute *ksm_attrs[] = {
 #ifdef CONFIG_NUMA
 	&merge_across_nodes_attr.attr,
 #endif
+	&use_zero_pages_attr.attr,
 	NULL,
 };
 
@@ -2304,6 +2361,11 @@ static int __init ksm_init(void)
 	struct task_struct *ksm_thread;
 	int err;
 
+	/* The correct value depends on page size and endianness */
+	zero_checksum = calc_checksum(ZERO_PAGE(0));
+	/* Default to false for backwards compatibility */
+	ksm_use_zero_pages = false;
+
 	err = ksm_slab_init();
 	if (err)
 		goto out;
_

Patches currently in -mm which might be from imbrenda@linux.vnet.ibm.com are

mm-ksm-improve-deduplication-of-zero-pages-with-colouring.patch


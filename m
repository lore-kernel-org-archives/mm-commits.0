From: akpm@linux-foundation.org
Subject: [patch 002/124] mm/ksm: improve deduplication of zero pages with
 colouring
Date: Fri, 24 Feb 2017 14:55:39 -0800
Message-ID: <58b0b9eb.6sR2S+ltMg8jO66F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36938 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdBXWzk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:55:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, imbrenda@linux.vnet.ibm.com, aarcange@redhat.com, borntraeger@de.ibm.com, hughd@google.com

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

[akpm@linux-foundation.org: make zero_checksum and ksm_use_zero_pages __read_mostly, per Andrea]
[imbrenda@linux.vnet.ibm.com: documentation for coloured zero pages deduplication]
  Link: http://lkml.kernel.org/r/1484927522-1964-1-git-send-email-imbrenda@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/1484850953-23941-1-git-send-email-imbrenda@linux.vnet.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/ksm.txt |   14 +++++++
 mm/ksm.c                 |   68 +++++++++++++++++++++++++++++++++++--
 2 files changed, 79 insertions(+), 3 deletions(-)

diff -puN Documentation/vm/ksm.txt~mm-ksm-improve-deduplication-of-zero-pages-with-colouring Documentation/vm/ksm.txt
--- a/Documentation/vm/ksm.txt~mm-ksm-improve-deduplication-of-zero-pages-with-colouring
+++ a/Documentation/vm/ksm.txt
@@ -80,6 +80,20 @@ run              - set 0 to stop ksmd fr
                    Default: 0 (must be changed to 1 to activate KSM,
                                except if CONFIG_SYSFS is disabled)
 
+use_zero_pages   - specifies whether empty pages (i.e. allocated pages
+                   that only contain zeroes) should be treated specially.
+                   When set to 1, empty pages are merged with the kernel
+                   zero page(s) instead of with each other as it would
+                   happen normally. This can improve the performance on
+                   architectures with coloured zero pages, depending on
+                   the workload. Care should be taken when enabling this
+                   setting, as it can potentially degrade the performance
+                   of KSM for some workloads, for example if the checksums
+                   of pages candidate for merging match the checksum of
+                   an empty page. This setting can be changed at any time,
+                   it is only effective for pages merged after the change.
+                   Default: 0 (normal KSM behaviour as in earlier releases)
+
 The effectiveness of KSM and MADV_MERGEABLE is shown in /sys/kernel/mm/ksm/:
 
 pages_shared     - how many shared pages are being used
diff -puN mm/ksm.c~mm-ksm-improve-deduplication-of-zero-pages-with-colouring mm/ksm.c
--- a/mm/ksm.c~mm-ksm-improve-deduplication-of-zero-pages-with-colouring
+++ a/mm/ksm.c
@@ -223,6 +223,12 @@ static unsigned int ksm_thread_pages_to_
 /* Milliseconds ksmd should sleep between batches */
 static unsigned int ksm_thread_sleep_millisecs = 20;
 
+/* Checksum of an empty (zeroed) page */
+static unsigned int zero_checksum __read_mostly;
+
+/* Whether to merge empty (zeroed) pages with actual zero pages */
+static bool ksm_use_zero_pages __read_mostly;
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

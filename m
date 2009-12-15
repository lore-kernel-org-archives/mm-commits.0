From: akpm@linux-foundation.org
Subject: [merged] ksm-remove-unswappable-max_kernel_pages.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:53:56 -0800
Message-ID: <200912152153.nBFLru3F015319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934005AbZLOWQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:16:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, chrisw@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: remove unswappable max_kernel_pages
has been removed from the -mm tree.  Its filename was
     ksm-remove-unswappable-max_kernel_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: remove unswappable max_kernel_pages
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Now that ksm pages are swappable, and the known holes plugged, remove
mention of unswappable kernel pages from KSM documentation and comments.

Remove the totalram_pages/4 initialization of max_kernel_pages.  In fact,
remove max_kernel_pages altogether - we can reinstate it if removal turns
out to break someone's script; but if we later want to limit KSM's memory
usage, limiting the stable nodes would not be an effective approach.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/ksm.txt |   22 ++++++-------------
 mm/Kconfig               |    2 -
 mm/ksm.c                 |   41 +------------------------------------
 3 files changed, 10 insertions(+), 55 deletions(-)

diff -puN Documentation/vm/ksm.txt~ksm-remove-unswappable-max_kernel_pages Documentation/vm/ksm.txt
--- a/Documentation/vm/ksm.txt~ksm-remove-unswappable-max_kernel_pages
+++ a/Documentation/vm/ksm.txt
@@ -16,9 +16,9 @@ by sharing the data common between them.
 application which generates many instances of the same data.
 
 KSM only merges anonymous (private) pages, never pagecache (file) pages.
-KSM's merged pages are at present locked into kernel memory for as long
-as they are shared: so cannot be swapped out like the user pages they
-replace (but swapping KSM pages should follow soon in a later release).
+KSM's merged pages were originally locked into kernel memory, but can now
+be swapped out just like other user pages (but sharing is broken when they
+are swapped back in: ksmd must rediscover their identity and merge again).
 
 KSM only operates on those areas of address space which an application
 has advised to be likely candidates for merging, by using the madvise(2)
@@ -44,20 +44,12 @@ includes unmapped gaps (though working o
 and might fail with EAGAIN if not enough memory for internal structures.
 
 Applications should be considerate in their use of MADV_MERGEABLE,
-restricting its use to areas likely to benefit.  KSM's scans may use
-a lot of processing power, and its kernel-resident pages are a limited
-resource.  Some installations will disable KSM for these reasons.
+restricting its use to areas likely to benefit.  KSM's scans may use a lot
+of processing power: some installations will disable KSM for that reason.
 
 The KSM daemon is controlled by sysfs files in /sys/kernel/mm/ksm/,
 readable by all but writable only by root:
 
-max_kernel_pages - set to maximum number of kernel pages that KSM may use
-                   e.g. "echo 100000 > /sys/kernel/mm/ksm/max_kernel_pages"
-                   Value 0 imposes no limit on the kernel pages KSM may use;
-                   but note that any process using MADV_MERGEABLE can cause
-                   KSM to allocate these pages, unswappable until it exits.
-                   Default: quarter of memory (chosen to not pin too much)
-
 pages_to_scan    - how many present pages to scan before ksmd goes to sleep
                    e.g. "echo 100 > /sys/kernel/mm/ksm/pages_to_scan"
                    Default: 100 (chosen for demonstration purposes)
@@ -75,7 +67,7 @@ run              - set 0 to stop ksmd fr
 
 The effectiveness of KSM and MADV_MERGEABLE is shown in /sys/kernel/mm/ksm/:
 
-pages_shared     - how many shared unswappable kernel pages KSM is using
+pages_shared     - how many shared pages are being used
 pages_sharing    - how many more sites are sharing them i.e. how much saved
 pages_unshared   - how many pages unique but repeatedly checked for merging
 pages_volatile   - how many pages changing too fast to be placed in a tree
@@ -87,4 +79,4 @@ pages_volatile embraces several differen
 proportion there would also indicate poor use of madvise MADV_MERGEABLE.
 
 Izik Eidus,
-Hugh Dickins, 24 Sept 2009
+Hugh Dickins, 17 Nov 2009
diff -puN mm/Kconfig~ksm-remove-unswappable-max_kernel_pages mm/Kconfig
--- a/mm/Kconfig~ksm-remove-unswappable-max_kernel_pages
+++ a/mm/Kconfig
@@ -212,7 +212,7 @@ config KSM
 	  Enable Kernel Samepage Merging: KSM periodically scans those areas
 	  of an application's address space that an app has advised may be
 	  mergeable.  When it finds pages of identical content, it replaces
-	  the many instances by a single resident page with that content, so
+	  the many instances by a single page with that content, so
 	  saving memory until one or another app needs to modify the content.
 	  Recommended for use with KVM, or with other duplicative applications.
 	  See Documentation/vm/ksm.txt for more information: KSM is inactive
diff -puN mm/ksm.c~ksm-remove-unswappable-max_kernel_pages mm/ksm.c
--- a/mm/ksm.c~ksm-remove-unswappable-max_kernel_pages
+++ a/mm/ksm.c
@@ -179,9 +179,6 @@ static unsigned long ksm_pages_unshared;
 /* The number of rmap_items in use: to calculate pages_volatile */
 static unsigned long ksm_rmap_items;
 
-/* Limit on the number of unswappable pages used */
-static unsigned long ksm_max_kernel_pages;
-
 /* Number of pages ksmd should scan in one batch */
 static unsigned int ksm_thread_pages_to_scan = 100;
 
@@ -943,14 +940,6 @@ static struct page *try_to_merge_two_pag
 {
 	int err;
 
-	/*
-	 * The number of nodes in the stable tree
-	 * is the number of kernel pages that we hold.
-	 */
-	if (ksm_max_kernel_pages &&
-	    ksm_max_kernel_pages <= ksm_pages_shared)
-		return NULL;
-
 	err = try_to_merge_with_ksm_page(rmap_item, page, NULL);
 	if (!err) {
 		err = try_to_merge_with_ksm_page(tree_rmap_item,
@@ -1850,8 +1839,8 @@ static ssize_t run_store(struct kobject 
 	/*
 	 * KSM_RUN_MERGE sets ksmd running, and 0 stops it running.
 	 * KSM_RUN_UNMERGE stops it running and unmerges all rmap_items,
-	 * breaking COW to free the unswappable pages_shared (but leaves
-	 * mm_slots on the list for when ksmd may be set running again).
+	 * breaking COW to free the pages_shared (but leaves mm_slots
+	 * on the list for when ksmd may be set running again).
 	 */
 
 	mutex_lock(&ksm_thread_mutex);
@@ -1876,29 +1865,6 @@ static ssize_t run_store(struct kobject 
 }
 KSM_ATTR(run);
 
-static ssize_t max_kernel_pages_store(struct kobject *kobj,
-				      struct kobj_attribute *attr,
-				      const char *buf, size_t count)
-{
-	int err;
-	unsigned long nr_pages;
-
-	err = strict_strtoul(buf, 10, &nr_pages);
-	if (err)
-		return -EINVAL;
-
-	ksm_max_kernel_pages = nr_pages;
-
-	return count;
-}
-
-static ssize_t max_kernel_pages_show(struct kobject *kobj,
-				     struct kobj_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%lu\n", ksm_max_kernel_pages);
-}
-KSM_ATTR(max_kernel_pages);
-
 static ssize_t pages_shared_show(struct kobject *kobj,
 				 struct kobj_attribute *attr, char *buf)
 {
@@ -1948,7 +1914,6 @@ static struct attribute *ksm_attrs[] = {
 	&sleep_millisecs_attr.attr,
 	&pages_to_scan_attr.attr,
 	&run_attr.attr,
-	&max_kernel_pages_attr.attr,
 	&pages_shared_attr.attr,
 	&pages_sharing_attr.attr,
 	&pages_unshared_attr.attr,
@@ -1968,8 +1933,6 @@ static int __init ksm_init(void)
 	struct task_struct *ksm_thread;
 	int err;
 
-	ksm_max_kernel_pages = totalram_pages / 4;

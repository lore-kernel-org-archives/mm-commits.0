From: akpm@linux-foundation.org
Subject: [merged]
 mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified.patch removed from -mm tree
Date: Mon, 28 Sep 2015 11:15:56 -0700
Message-ID: <560983dc.Wtd8IXwDrIlGZHwQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbbI1SP5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:15:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, boaz@plexistor.com, david@fromorbit.com, jack@suse.cz, matthew.r.wilcox@intel.com, yigal@plexistor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: VMA with vm_ops->pfn_mkwrite wants to be write-notified
has been removed from the -mm tree.  Its filename was
     mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, dax: VMA with vm_ops->pfn_mkwrite wants to be write-notified

For VM_PFNMAP and VM_MIXEDMAP we use vm_ops->pfn_mkwrite instead of
vm_ops->page_mkwrite to notify abort write access.  This means we want
vma->vm_page_prot to be write-protected if the VMA provides this vm_ops.

A theoretical scenario that will cause these missed events is:

  On writable mapping with vm_ops->pfn_mkwrite, but without
  vm_ops->page_mkwrite: read fault followed by write access to the pfn. 
  Writable pte will be set up on read fault and write fault will not be
  generated.

I found it examining Dave's complaint on generic/080:

	http://lkml.kernel.org/g/20150831233803.GO3902@dastard

Although I don't think it's the reason.

It shouldn't be a problem for ext2/ext4 as they provide both pfn_mkwrite
and page_mkwrite.

[akpm@linux-foundation.org: add local vm_ops to avoid 80-cols mess]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yigal Korman <yigal@plexistor.com>
Acked-by: Boaz Harrosh <boaz@plexistor.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified mm/mmap.c
--- a/mm/mmap.c~mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified
+++ a/mm/mmap.c
@@ -1490,13 +1490,14 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
 int vma_wants_writenotify(struct vm_area_struct *vma)
 {
 	vm_flags_t vm_flags = vma->vm_flags;
+	const struct vm_operations_struct *vm_ops = vma->vm_ops;
 
 	/* If it was private or non-writable, the write bit is already clear */
 	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
 		return 0;
 
 	/* The backer wishes to know when pages are first written to? */
-	if (vma->vm_ops && vma->vm_ops->page_mkwrite)
+	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
 		return 1;
 
 	/* The open routine did something to the protections that pgprot_modify
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch


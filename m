From: akpm@linux-foundation.org
Subject: +
 mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified.patch added
 to -mm tree
Date: Tue, 15 Sep 2015 16:41:33 -0700
Message-ID: <55f8acad.jDBTPatmVOEJP7bT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbbIOXle (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 19:41:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, boaz@plexistor.com, david@fromorbit.com, jack@suse.cz, matthew.r.wilcox@intel.com, yigal@plexistor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: VMA with vm_ops->pfn_mkwrite wants to be write-notified
has been added to the -mm tree.  Its filename is
     mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1498,7 +1498,8 @@ int vma_wants_writenotify(struct vm_area
 		return 0;
 
 	/* The backer wishes to know when pages are first written to? */
-	if (vma->vm_ops && vma->vm_ops->page_mkwrite)
+	if (vma->vm_ops &&
+			(vma->vm_ops->page_mkwrite || vma->vm_ops->pfn_mkwrite))
 		return 1;
 
 	/* The open routine did something to the protections that pgprot_modify
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified.patch
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


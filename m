From: akpm@linux-foundation.org
Subject: + mm-meminit-suppress-unused-memory-variable-warning.patch added
 to -mm tree
Date: Tue, 07 Jul 2015 14:58:42 -0700
Message-ID: <559c4b92.3hbYxIUCf73IImo3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbbGGV6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 17:58:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, fengguang.wu@intel.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, meminit: suppress unused memory variable warning
has been added to the -mm tree.  Its filename is
     mm-meminit-suppress-unused-memory-variable-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-suppress-unused-memory-variable-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-suppress-unused-memory-variable-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm, meminit: suppress unused memory variable warning

The kbuild test robot reported the following

  tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
  head:   14a6f1989dae9445d4532941bdd6bbad84f4c8da
  commit: 3b242c66ccbd60cf47ab0e8992119d9617548c23 x86: mm: enable deferred struct page initialisation on x86-64
  date:   3 days ago
  config: x86_64-randconfig-x006-201527 (attached as .config)
  reproduce:
    git checkout 3b242c66ccbd60cf47ab0e8992119d9617548c23
    # save the attached .config to linux build tree
    make ARCH=x86_64

  All warnings (new ones prefixed by >>):

     mm/page_alloc.c: In function 'early_page_uninitialised':
  >> mm/page_alloc.c:247:6: warning: unused variable 'nid' [-Wunused-variable]
       int nid = early_pfn_to_nid(pfn);

It's due to the NODE_DATA macro ignoring the nid parameter on !NUMA
configurations.  This patch avoids the warning by not declaring nid.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-meminit-suppress-unused-memory-variable-warning mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-suppress-unused-memory-variable-warning
+++ a/mm/page_alloc.c
@@ -246,9 +246,7 @@ static inline void reset_deferred_memini
 /* Returns true if the struct page for the pfn is uninitialised */
 static inline bool __meminit early_page_uninitialised(unsigned long pfn)
 {
-	int nid = early_pfn_to_nid(pfn);
-
-	if (pfn >= NODE_DATA(nid)->first_deferred_pfn)
+	if (pfn >= NODE_DATA(early_pfn_to_nid(pfn))->first_deferred_pfn)
 		return true;
 
 	return false;
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-meminit-suppress-unused-memory-variable-warning.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
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
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch


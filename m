From: akpm@linux-foundation.org
Subject: + mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch
 added to -mm tree
Date: Thu, 23 Jul 2015 12:27:16 -0700
Message-ID: <55b14014.CLmJwU3J9I8NF3zg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbbGWT1R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jul 2015 15:27:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com, hpa@zytor.com, luto@amacapital.net, minchan@kernel.org, mingo@elte.hu, oleg@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, madvise: use vma_is_anonymous() to check for anon VMA
has been added to the -mm tree.  Its filename is
     mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch

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
Subject: mm, madvise: use vma_is_anonymous() to check for anon VMA

!vma->vm_file is not reliable to detect anon VMA, because not all
drivers bother set it. Let's use vma_is_anonymous() instead.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/madvise.c~mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma mm/madvise.c
--- a/mm/madvise.c~mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma
+++ a/mm/madvise.c
@@ -393,7 +393,7 @@ static int madvise_free_single_vma(struc
 		return -EINVAL;
 
 	/* MADV_FREE works for only anon vma at the moment */
-	if (vma->vm_file)
+	if (!vma_is_anonymous(vma))
 		return -EINVAL;
 
 	start = max(vma->vm_start, start_addr);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-fix-status-code-move_pages-returns-for-zero-page.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch
dax-move-dax-related-functions-to-a-new-header.patch
thp-prepare-for-dax-huge-pages.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
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
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-mark-most-vm_operations_struct-const.patch
x86-mpx-do-not-set-vm_ops-on-mpx-vmas.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch
mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch
mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch


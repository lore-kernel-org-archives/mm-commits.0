From: akpm@linux-foundation.org
Subject: + vm_flags-vm_flags_t-and-__nocast.patch added to -mm tree
Date: Mon, 03 Aug 2015 14:19:01 -0700
Message-ID: <55bfdac5.rGQHGykZGyBjElP9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbbHCVTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2015 17:19:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, hannes@cmpxchg.org, oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop __nocast from vm_flags_t definition
has been added to the -mm tree.  Its filename is
     vm_flags-vm_flags_t-and-__nocast.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vm_flags-vm_flags_t-and-__nocast.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vm_flags-vm_flags_t-and-__nocast.patch

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
Subject: mm: drop __nocast from vm_flags_t definition

__nocast does no good for vm_flags_t. It only produces useless sparse
warnings.

Let's drop it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm_types.h~vm_flags-vm_flags_t-and-__nocast include/linux/mm_types.h
--- a/include/linux/mm_types.h~vm_flags-vm_flags_t-and-__nocast
+++ a/include/linux/mm_types.h
@@ -244,7 +244,7 @@ struct page_frag_cache {
 	bool pfmemalloc;
 };
 
-typedef unsigned long __nocast vm_flags_t;
+typedef unsigned long vm_flags_t;
 
 /*
  * A region containing a mapping of a non-memory backed file under NOMMU
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

user_ns-use-correct-check-for-single-threadedness.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch
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
mempolicy-get-rid-of-duplicated-check-for-vmavm_pfnmap-in-queue_pages_range.patch
vm_flags-vm_flags_t-and-__nocast.patch
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
fix-list_poison12-offset.patch
use-poison_pointer_delta-for-poison-pointers.patch
remove-not-used-poison-pointer-macros.patch
mm-mark-most-vm_operations_struct-const.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch
mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch
mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch


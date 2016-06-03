From: akpm@linux-foundation.org
Subject: +
 mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
 added to -mm tree
Date: Fri, 03 Jun 2016 13:16:30 -0700
Message-ID: <5751e59e.GW38Fj0bskYwNQRj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbcFCUQb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2016 16:16:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, ebru.akagunduz@gmail.com, kirill.shutemov@linux.intel.com, riel@redhat.com, sergey.senozhatsky.work@gmail.com, sfr@canb.auug.org.au, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix
has been added to the -mm tree.  Its filename is
     mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix

update comment to match new code

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix
+++ a/mm/huge_memory.c
@@ -2512,8 +2512,8 @@ static void collapse_huge_page(struct mm
 	if (allocstall == curr_allocstall && swap != 0) {
 		/*
 		 * __collapse_huge_page_swapin always returns with mmap_sem
-		 * locked. If it fails, release mmap_sem and jump directly
-		 * label out. Continuing to collapse causes inconsistency.
+		 * locked.  If it fails, release mmap_sem and jump directly
+		 * out.  Continuing to collapse causes inconsistency.
 		 */
 		if (!__collapse_huge_page_swapin(mm, vma, address, pmd)) {
 			mem_cgroup_cancel_charge(new_page, memcg, true);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-fix-overflow-in-vm_map_ram-fix.patch
revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


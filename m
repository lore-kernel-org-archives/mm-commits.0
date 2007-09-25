From: akpm@linux-foundation.org
Subject: + xen-execves-error-paths-dont-pin-the-mm-before-unpinning.patch added to -mm tree
Date: Tue, 25 Sep 2007 12:52:36 -0700
Message-ID: <200709251952.l8PJqa9k001687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54712 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754444AbXIYTws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 15:52:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com, osth@freesurf.ch


The patch titled
     xen: execve's error paths don't pin the mm before unpinning
has been added to the -mm tree.  Its filename is
     xen-execves-error-paths-dont-pin-the-mm-before-unpinning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xen: execve's error paths don't pin the mm before unpinning
From: Jeremy Fitzhardinge <jeremy@goop.org>

execve's error paths don't activate (and therefore pin) the mm before
calling exit_mmap to free it up, so don't try to unpin unless it is
actually pinned.  This prevents a BUG_ON from triggering.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: <osth@freesurf.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/mmu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/i386/xen/mmu.c~xen-execves-error-paths-dont-pin-the-mm-before-unpinning arch/i386/xen/mmu.c
--- a/arch/i386/xen/mmu.c~xen-execves-error-paths-dont-pin-the-mm-before-unpinning
+++ a/arch/i386/xen/mmu.c
@@ -559,6 +559,9 @@ void xen_exit_mmap(struct mm_struct *mm)
 	put_cpu();
 
 	spin_lock(&mm->page_table_lock);
-	xen_pgd_unpin(mm->pgd);
+
+	/* pgd may not be pinned in the error exit path of execve */
+	if (PagePinned(virt_to_page(mm->pgd)))
+		xen_pgd_unpin(mm->pgd);
 	spin_unlock(&mm->page_table_lock);
 }
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-execves-error-paths-dont-pin-the-mm-before-unpinning.patch
git-net.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fix-the-softlockup-watchdog-to-actually-work.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe.patch
core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix.patch
core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe.patch
core_pattern-fix-up-a-few-miscellaneous-bugs.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
unify-dma_bit_mask-definitions-v31.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch

From: akpm@linux-foundation.org
Subject: - xen-dont-bother-trying-to-set-cr4.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:15:34 -0700
Message-ID: <200709202115.l8KLFYXV002921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35476 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752465AbXITV2i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     xen: don't bother trying to set cr4
has been removed from the -mm tree.  Its filename was
     xen-dont-bother-trying-to-set-cr4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xen: don't bother trying to set cr4
From: Jeremy Fitzhardinge <jeremy@goop.org>

Xen ignores all updates to cr4, and some versions will kill the domain if
you try to change its value.  Just ignore all changes.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/enlighten.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/xen/enlighten.c~xen-dont-bother-trying-to-set-cr4 arch/i386/xen/enlighten.c
--- a/arch/i386/xen/enlighten.c~xen-dont-bother-trying-to-set-cr4
+++ a/arch/i386/xen/enlighten.c
@@ -623,8 +623,8 @@ static unsigned long xen_read_cr2_direct
 
 static void xen_write_cr4(unsigned long cr4)
 {
-	/* never allow TSC to be disabled */
-	native_write_cr4(cr4 & ~X86_CR4_TSD);
+	/* Just ignore cr4 changes; Xen doesn't allow us to do
+	   anything anyway. */
 }
 
 static unsigned long xen_read_cr3(void)
_

Patches currently in -mm which might be from jeremy@goop.org are

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
add-missing-newlines-to-some-uses-of-dev_level-messages.patch

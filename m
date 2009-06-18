From: akpm@linux-foundation.org
Subject: [merged] ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:23 -0700
Message-ID: <200906182246.n5IMkNRC005430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758065AbZFRW6l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, geert@linux-m68k.org, gerg@snapgear.com, roland@redhat.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     ptrace: remove PT_DTRACE from m68k, m68knommu
has been removed from the -mm tree.  Its filename was
     ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: remove PT_DTRACE from m68k, m68knommu
From: Oleg Nesterov <oleg@redhat.com>

m68k sets PT_DTRACE in trap_c() but never uses it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/traps.c            |    1 -
 arch/m68knommu/kernel/asm-offsets.c |    1 -
 arch/m68knommu/kernel/traps.c       |    1 -
 3 files changed, 3 deletions(-)

diff -puN arch/m68k/kernel/traps.c~ptrace-remove-pt_dtrace-from-m68k-m68knommu arch/m68k/kernel/traps.c
--- a/arch/m68k/kernel/traps.c~ptrace-remove-pt_dtrace-from-m68k-m68knommu
+++ a/arch/m68k/kernel/traps.c
@@ -1057,7 +1057,6 @@ asmlinkage void trap_c(struct frame *fp)
 	if (fp->ptregs.sr & PS_S) {
 		if ((fp->ptregs.vector >> 2) == VEC_TRACE) {
 			/* traced a trapping instruction */
-			current->ptrace |= PT_DTRACE;
 		} else
 			bad_super_trap(fp);
 		return;
diff -puN arch/m68knommu/kernel/asm-offsets.c~ptrace-remove-pt_dtrace-from-m68k-m68knommu arch/m68knommu/kernel/asm-offsets.c
--- a/arch/m68knommu/kernel/asm-offsets.c~ptrace-remove-pt_dtrace-from-m68k-m68knommu
+++ a/arch/m68knommu/kernel/asm-offsets.c
@@ -73,7 +73,6 @@ int main(void)
 	DEFINE(TRAP_TRACE, TRAP_TRACE);
 
 	DEFINE(PT_PTRACED, PT_PTRACED);
-	DEFINE(PT_DTRACE, PT_DTRACE);
 
 	DEFINE(THREAD_SIZE, THREAD_SIZE);
 
diff -puN arch/m68knommu/kernel/traps.c~ptrace-remove-pt_dtrace-from-m68k-m68knommu arch/m68knommu/kernel/traps.c
--- a/arch/m68knommu/kernel/traps.c~ptrace-remove-pt_dtrace-from-m68k-m68knommu
+++ a/arch/m68knommu/kernel/traps.c
@@ -200,7 +200,6 @@ asmlinkage void trap_c(struct frame *fp)
 	if (fp->ptregs.sr & PS_S) {
 		if ((fp->ptregs.vector >> 2) == VEC_TRACE) {
 			/* traced a trapping instruction */
-			current->ptrace |= PT_DTRACE;
 		} else
 			bad_super_trap(fp);
 		return;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch


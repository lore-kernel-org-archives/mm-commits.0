From: akpm@linux-foundation.org
Subject: + ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch added to -mm tree
Date: Thu, 23 Apr 2009 17:01:51 -0700
Message-ID: <200904240001.n3O01p9P004697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbZDXAHW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 20:07:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, geert@linux-m68k.org, gerg@snapgear.com, roland@redhat.com, zippel@linux-m68k.org


The patch titled
     ptrace: remove PT_DTRACE from m68k, m68knommu
has been added to the -mm tree.  Its filename is
     ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: remove PT_DTRACE from m68k, m68knommu
From: Oleg Nesterov <oleg@redhat.com>

m68k sets PT_DTRACE in trap_c() but never uses it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@snapgear.com>
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

slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch


From: akpm@linux-foundation.org
Subject: - x86_64-ia32-ptrace-thread_area-fix.patch removed from -mm tree
Date: Mon, 12 Nov 2007 20:07:41 -0800
Message-ID: <200711130407.lAD47fCr025243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760663AbXKMEIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 23:08:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: ia32 ptrace THREAD_AREA fix
has been removed from the -mm tree.  Its filename was
     x86_64-ia32-ptrace-thread_area-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: ia32 ptrace THREAD_AREA fix
From: Roland McGrath <roland@redhat.com>

The addr argument to PTRACE_GET_THREAD_AREA and PTRACE_SET_THREAD_AREA is
not a magic constant.  It's derived from the segment register values being
used, which are computed originally from the index used with
set_thread_area.  The value does not need to match what a native i386
kernel would accept.  It needs to match the segment selectors that can
actually be in use in this 32-bit process.  The 64-bit ptrace support for
PTRACE_GET_THREAD_AREA (normally used only on 32-bit processes) is correct,
but the 32-bit emulation of ptrace is broken.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ptrace32.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN arch/x86/ia32/ptrace32.c~x86_64-ia32-ptrace-thread_area-fix arch/x86/ia32/ptrace32.c
--- a/arch/x86/ia32/ptrace32.c~x86_64-ia32-ptrace-thread_area-fix
+++ a/arch/x86/ia32/ptrace32.c
@@ -243,8 +243,6 @@ static long ptrace32_siginfo(unsigned re
 	return ret;
 }
 
-#define COMPAT_GDT_ENTRY_TLS_MIN 6
-
 asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 {
 	struct task_struct *child;
@@ -263,6 +261,8 @@ asmlinkage long sys32_ptrace(long reques
 	case PTRACE_SYSCALL:
 	case PTRACE_OLDSETOPTIONS:
 	case PTRACE_SETOPTIONS:
+	case PTRACE_SET_THREAD_AREA:
+	case PTRACE_GET_THREAD_AREA:
 		return sys_ptrace(request, pid, addr, data);
 
 	default:
@@ -286,12 +286,6 @@ asmlinkage long sys32_ptrace(long reques
 	case PTRACE_SETSIGINFO:
 	case PTRACE_GETSIGINFO:
 		return ptrace32_siginfo(request, pid, addr, data);
-
-	case PTRACE_SET_THREAD_AREA:
-	case PTRACE_GET_THREAD_AREA:
-		return sys_ptrace(request, pid,
-			addr + GDT_ENTRY_TLS_MIN - COMPAT_GDT_ENTRY_TLS_MIN,
-			data);
 	}
 
 	child = ptrace_get_task_struct(pid);
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
i386-and-x86_64-randomize-brk.patch
i386-and-x86_64-randomize-brk-fix.patch
i386-and-x86_64-randomize-brk-fix-2.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch

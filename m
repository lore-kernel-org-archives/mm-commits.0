From: akpm@linux-foundation.org
Subject: [merged] frv-dont-turn-on-tif_syscall_trace-unconditionally-in-syscall-prologue.patch removed from -mm tree
Date: Thu, 11 Jun 2009 14:25:12 -0700
Message-ID: <200906112125.n5BLPCXe018158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbZFKVZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 17:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: don't turn on TIF_SYSCALL_TRACE unconditionally in syscall prologue
has been removed from the -mm tree.  Its filename was
     frv-dont-turn-on-tif_syscall_trace-unconditionally-in-syscall-prologue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: don't turn on TIF_SYSCALL_TRACE unconditionally in syscall prologue
From: David Howells <dhowells@redhat.com>

Don't turn on TIF_SYSCALL_TRACE unconditionally in syscall prologue in
FRV's entry.S.  This was originally for debugging stuff and should have
been removed a long time ago.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/entry.S |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/frv/kernel/entry.S~frv-dont-turn-on-tif_syscall_trace-unconditionally-in-syscall-prologue arch/frv/kernel/entry.S
--- a/arch/frv/kernel/entry.S~frv-dont-turn-on-tif_syscall_trace-unconditionally-in-syscall-prologue
+++ a/arch/frv/kernel/entry.S
@@ -886,7 +886,6 @@ system_call:
 	bnc		icc0,#0,__syscall_badsys
 
 	ldi		@(gr15,#TI_FLAGS),gr4
-	ori		gr4,#_TIF_SYSCALL_TRACE,gr4
 	andicc		gr4,#_TIF_SYSCALL_TRACE,gr0,icc0
 	bne		icc0,#0,__syscall_trace_entry
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-duplicate-output_buffer-of-e03.patch
rework-fix-is_single_threaded.patch
use-round_jiffies-for-slow-work-thread-pools-cull-and-oom-timers.patch
kmap_types-make-most-arches-use-generic-header-file.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
mutex-subsystem-synchro-test-module.patch


From: akpm@linux-foundation.org
Subject: + frv-dont-turn-on-tif_syscall_trace-unconditionally-in-syscall-prologue.patch added to -mm tree
Date: Mon, 27 Apr 2009 12:54:48 -0700
Message-ID: <200904271954.n3RJsmwQ028728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758295AbZD0T4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Apr 2009 15:56:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, roland@redhat.com


The patch titled
     frv: don't turn on TIF_SYSCALL_TRACE unconditionally in syscall prologue
has been added to the -mm tree.  Its filename is
     frv-dont-turn-on-tif_syscall_trace-unconditionally-in-syscall-prologue.patch

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
rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch
frv-utrace-remove-in-kernel-strace-code.patch
frv-utrace-implement-tif_notify_resume.patch
frv-dont-turn-on-tif_syscall_trace-unconditionally-in-syscall-prologue.patch
frv-utrace-implement-tracehooks.patch
frv-duplicate-output_buffer-of-e03.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
kmap_types-make-most-arches-use-generic-header-file.patch
flat-fix-data-sections-alignment.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
mutex-subsystem-synchro-test-module.patch


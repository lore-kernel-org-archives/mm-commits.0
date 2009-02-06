From: akpm@linux-foundation.org
Subject: [merged] x86-prevent-kprobes-from-catching-spurious-page-faults.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:38:36 -0800
Message-ID: <200902061938.n16JcaGf012565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675AbZBFTko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:40:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, fche@redhat.com, hpa@zytor.com, jkenisto@us.ibm.com, mathieu.desnoyers@polymtl.ca, mingo@elte.hu, npiggin@suse.de, stable@kernel.org, tglx@linu


The patch titled
     x86: prevent kprobes from catching spurious page faults
has been removed from the -mm tree.  Its filename was
     x86-prevent-kprobes-from-catching-spurious-page-faults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: prevent kprobes from catching spurious page faults
From: Masami Hiramatsu <mhiramat@redhat.com>

Prevent kprobes from catching spurious faults which will cause infinite
recursive page-fault and memory corruption by stack overflow.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/fault.c~x86-prevent-kprobes-from-catching-spurious-page-faults arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~x86-prevent-kprobes-from-catching-spurious-page-faults
+++ a/arch/x86/mm/fault.c
@@ -603,8 +603,6 @@ void __kprobes do_page_fault(struct pt_r
 
 	si_code = SEGV_MAPERR;
 
-	if (notify_page_fault(regs))
-		return;
 	if (unlikely(kmmio_fault(regs, address)))
 		return;
 
@@ -634,6 +632,9 @@ void __kprobes do_page_fault(struct pt_r
 		if (spurious_fault(address, error_code))
 			return;
 
+		/* kprobes don't want to hook the spurious faults. */
+		if (notify_page_fault(regs))
+			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
 		 * fault we could otherwise deadlock.
@@ -641,6 +642,9 @@ void __kprobes do_page_fault(struct pt_r
 		goto bad_area_nosemaphore;
 	}
 
+	/* kprobes don't want to hook the spurious faults. */
+	if (notify_page_fault(regs))
+		return;
 
 	/*
 	 * It's safe to allow irq's after cr2 has been saved and the
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch
kprobes-cleanup-aggr_kprobe-related-code.patch
kprobes-move-export_symbol_gpl-just-after-function-definitions.patch
kprobes-cleanup-comment-style-in-kprobesh.patch
kprobes-rename-kprobe_enabled-to-kprobes_all_disarmed.patch
kprobes-support-per-kprobe-disabling.patch
kprobes-support-kretprobe-and-jprobe-per-probe-disabling.patch


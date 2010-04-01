From: akpm@linux-foundation.org
Subject: + x86-handle-overlapping-mptables.patch added to -mm tree
Date: Thu, 01 Apr 2010 11:51:00 -0700
Message-ID: <201004011851.o31Ip1uC002638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757545Ab0DASwB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 14:52:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, hpa@zytor.com, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de, trenn@suse.de, yinghai@kernel.org


The patch titled
     x86: handle overlapping mptables
has been added to the -mm tree.  Its filename is
     x86-handle-overlapping-mptables.patch

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
Subject: x86: handle overlapping mptables
From: Andi Kleen <andi@firstfloor.org>

We found a system where the MP table MPC and MPF structures overlap.

That doesn't really matter because the mptable is not used anyways with ACPI,
but it leads to a panic in the early allocator due to the overlapping
reservations in 2.6.33.

Earlier kernels handled this without problems.

Simply change these reservations to reserve_early_overlap_ok to avoid
the panic.

Reported-by: Thomas Renninger <trenn@suse.de>
Tested-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/mpparse.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/mpparse.c~x86-handle-overlapping-mptables arch/x86/kernel/mpparse.c
--- a/arch/x86/kernel/mpparse.c~x86-handle-overlapping-mptables
+++ a/arch/x86/kernel/mpparse.c
@@ -664,7 +664,7 @@ static void __init smp_reserve_memory(st
 {
 	unsigned long size = get_mpc_size(mpf->physptr);
 
-	reserve_early(mpf->physptr, mpf->physptr+size, "MP-table mpc");
+	reserve_early_overlap_ok(mpf->physptr, mpf->physptr+size, "MP-table mpc");
 }
 
 static int __init smp_scan_config(unsigned long base, unsigned long length)
@@ -693,7 +693,7 @@ static int __init smp_scan_config(unsign
 			       mpf, (u64)virt_to_phys(mpf));
 
 			mem = virt_to_phys(mpf);
-			reserve_early(mem, mem + sizeof(*mpf), "MP-table mpf");
+			reserve_early_overlap_ok(mem, mem + sizeof(*mpf), "MP-table mpf");
 			if (mpf->physptr)
 				smp_reserve_memory(mpf);
 
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
x86-handle-overlapping-mptables.patch
modpost-support-objects-with-more-than-64k-sections.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
kmod-add-init-function-to-usermodehelper.patch
exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch


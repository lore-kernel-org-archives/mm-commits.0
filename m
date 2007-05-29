From: akpm@linux-foundation.org
Subject: + x86-fix-oprofile-double-free-was-re-multiple-free.patch added to -mm tree
Date: Tue, 29 May 2007 15:31:21 -0700
Message-ID: <200705292231.l4TMVLa5013262@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842AbXE2Wbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 18:31:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisw@sous-sol.org, ak@suse.de, alan@lxorguk.ukuu.org.uk, cebbert@redhat.com, davej@redhat.com


The patch titled
     x86: fix oprofile double free
has been added to the -mm tree.  Its filename is
     x86-fix-oprofile-double-free-was-re-multiple-free.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: fix oprofile double free
From: Chris Wright <chrisw@sous-sol.org>

Chuck reports that the recent fix from Andi to oprofile
6c977aad03a18019015035958c65b6729cd0574c introduces a double free.  Each
cpu's cpu_msrs is setup to point to cpu 0's, which causes free_msrs to free
cpu 0's pointers for_each_possible_cpu.  Rather than copy the pointers, do
a deep copy instead.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Jones <davej@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/oprofile/nmi_int.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/i386/oprofile/nmi_int.c~x86-fix-oprofile-double-free-was-re-multiple-free arch/i386/oprofile/nmi_int.c
--- a/arch/i386/oprofile/nmi_int.c~x86-fix-oprofile-double-free-was-re-multiple-free
+++ a/arch/i386/oprofile/nmi_int.c
@@ -211,8 +211,14 @@ static int nmi_setup(void)
 	/* Assume saved/restored counters are the same on all CPUs */
 	model->fill_in_addresses(&cpu_msrs[0]);
 	for_each_possible_cpu (cpu) {
-		if (cpu != 0)
-			cpu_msrs[cpu] = cpu_msrs[0];
+		if (cpu != 0) {
+			memcpy(cpu_msrs[cpu].counters, cpu_msrs[0].counters,
+				sizeof(struct op_msr) * model->num_counters);
+
+			memcpy(cpu_msrs[cpu].controls, cpu_msrs[0].controls,
+				sizeof(struct op_msr) * model->num_controls);
+		}
+
 	}
 	on_each_cpu(nmi_save_registers, NULL, 0, 1);
 	on_each_cpu(nmi_cpu_setup, NULL, 0, 1);
_

Patches currently in -mm which might be from chrisw@sous-sol.org are

x86-fix-oprofile-double-free-was-re-multiple-free.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-update.patch

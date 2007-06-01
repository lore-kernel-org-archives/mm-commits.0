From: akpm@linux-foundation.org
Subject: - x86-fix-oprofile-double-free-was-re-multiple-free.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:22 -0700
Message-ID: <200706011747.l51HlL52015120@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761368AbXFARrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisw@sous-sol.org, acme@redhat.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, cebbert@redhat.com, davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     x86: fix oprofile double free
has been removed from the -mm tree.  Its filename was
     x86-fix-oprofile-double-free-was-re-multiple-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: fix oprofile double free
From: Chris Wright <chrisw@sous-sol.org>

Chuck reports that the recent fix from Andi to oprofile
6c977aad03a18019015035958c65b6729cd0574c introduces a double free.  Each
cpu's cpu_msrs is setup to point to cpu 0's, which causes free_msrs to free
cpu 0's pointers for_each_possible_cpu.  Rather than copy the pointers, do
a deep copy instead.

[acme@redhat.com: allocate_msrs() was using for_each_online_cpu()]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Jones <davej@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/oprofile/nmi_int.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN arch/i386/oprofile/nmi_int.c~x86-fix-oprofile-double-free-was-re-multiple-free arch/i386/oprofile/nmi_int.c
--- a/arch/i386/oprofile/nmi_int.c~x86-fix-oprofile-double-free-was-re-multiple-free
+++ a/arch/i386/oprofile/nmi_int.c
@@ -154,7 +154,7 @@ static int allocate_msrs(void)
 	size_t counters_size = sizeof(struct op_msr) * model->num_counters;
 
 	int i;
-	for_each_online_cpu(i) {
+	for_each_possible_cpu(i) {
 		cpu_msrs[i].counters = kmalloc(counters_size, GFP_KERNEL);
 		if (!cpu_msrs[i].counters) {
 			success = 0;
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

origin.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-update.patch

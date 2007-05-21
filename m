From: akpm@linux-foundation.org
Subject: - x86_64-fix-oprofile-smp.patch removed from -mm tree
Date: Mon, 21 May 2007 13:09:52 -0700
Message-ID: <200705212009.l4LK9pwI018792@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51983 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765555AbXEUUOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 16:14:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, ak@suse.de, bcrl@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64: fix oprofile SMP
has been removed from the -mm tree.  Its filename was
     x86_64-fix-oprofile-smp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: fix oprofile SMP
From: Davide Libenzi <davidel@xmailserver.org>

This fixes oprofile being broken on x86-64 SMP.  The current reservation
runs on all CPUs, but the ones following the first, will fail since the
reservation bitmap has an 1 in the MSR entry.

The reservation code should really run once, and their addresses used on
other CPUs.  There are other solutions to this, but this is the simplest
and shorter one that came in my mind.  Tested in my dual Opteron 252, and
working fine here.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Benjamin LaHaise <bcrl@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/oprofile/nmi_int.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff -puN arch/i386/oprofile/nmi_int.c~x86_64-fix-oprofile-smp arch/i386/oprofile/nmi_int.c
--- a/arch/i386/oprofile/nmi_int.c~x86_64-fix-oprofile-smp
+++ a/arch/i386/oprofile/nmi_int.c
@@ -130,8 +130,19 @@ static void nmi_cpu_save_registers(struc
 static void nmi_save_registers(void * dummy)
 {
 	int cpu = smp_processor_id();
-	struct op_msrs * msrs = &cpu_msrs[cpu];
-	model->fill_in_addresses(msrs);
+	struct op_msrs *msrs = &cpu_msrs[cpu];
+
+	/*
+	 * Use the CPU#0 already allocated addresses as reference.
+	 */
+	if (cpu != 0) {
+		const struct op_msrs *rmsrs = &cpu_msrs[0];
+
+		memcpy(msrs->counters, rmsrs->counters,
+		       model->num_counters * sizeof(msrs->counters[0]));
+		memcpy(msrs->controls, rmsrs->controls,
+		       model->num_controls * sizeof(msrs->controls[0]));
+	}
 	nmi_cpu_save_registers(msrs);
 }
 
@@ -195,6 +206,7 @@ static struct notifier_block profile_exc
 static int nmi_setup(void)
 {
 	int err=0;
+	struct op_msrs *msrs;
 
 	if (!allocate_msrs())
 		return -ENOMEM;
@@ -203,6 +215,14 @@ static int nmi_setup(void)
 		free_msrs();
 		return err;
 	}
+	/*
+	 * MSR reservation should happen only once with the current API,
+	 * otherwise CPU other then the first would fail to allocate.
+	 * We do it here, and then we propagate the CPU#0 addresses to
+	 * other CPUs.
+	 */
+	msrs = &cpu_msrs[0];
+	model->fill_in_addresses(msrs);
 
 	/* We need to serialize save and setup for HT because the subset
 	 * of msrs are distinct for save and setup operations
_

Patches currently in -mm which might be from davidel@xmailserver.org are

signalfd-retrieve-multiple-signals-with-one-read-call.patch

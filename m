From: akpm@linux-foundation.org
Subject: + acpi-dont-call-acpi_processor_init-if-acpi-is-disabled.patch added to -mm tree
Date: Wed, 05 Aug 2009 17:48:30 -0700
Message-ID: <200908060048.n760mUNw024816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806AbZHFAuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 20:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, jens@leia.mcbone.net, lenb@kernel.org, mingo@elte.hu


The patch titled
     acpi: don't call acpi_processor_init if acpi is disabled
has been added to the -mm tree.  Its filename is
     acpi-dont-call-acpi_processor_init-if-acpi-is-disabled.patch

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
Subject: acpi: don't call acpi_processor_init if acpi is disabled
From: Yinghai Lu <yinghai@kernel.org>

Jens reported early_ioremap messages with old ASUS board...

> [    1.507461] pci 0000:00:09.0: Firmware left e100 interrupts enabled;
> disabling
> [    1.532778] early_ioremap(3fffd080, 0000005c) [0] => Pid: 1, comm:
> swapper Not tainted 2.6.31-rc4 #36
> [    1.561007] Call Trace:
> [    1.568638]  [<c136e48b>] ? printk+0x18/0x1d
> [    1.581734]  [<c15513ff>] __early_ioremap+0x74/0x1e9
> [    1.596898]  [<c15515aa>] early_ioremap+0x1a/0x1c
> [    1.611270]  [<c154a187>] __acpi_map_table+0x18/0x1a
> [    1.626451]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
> [    1.642129]  [<c119459c>] acpi_tb_verify_table+0x20/0x49
> [    1.658321]  [<c1193e50>] acpi_get_table_with_size+0x53/0xa1
> [    1.675553]  [<c1193eae>] acpi_get_table+0x10/0x15
> [    1.690192]  [<c155cc19>] acpi_processor_init+0x23/0xab
> [    1.706126]  [<c1001043>] do_one_initcall+0x33/0x180
> [    1.721279]  [<c155cbf6>] ? acpi_processor_init+0x0/0xab
> [    1.737479]  [<c106893a>] ? register_irq_proc+0xaa/0xc0
> [    1.753411]  [<c10689b7>] ? init_irq_proc+0x67/0x80
> [    1.768316]  [<c15405e7>] kernel_init+0x120/0x176
> [    1.782678]  [<c15404c7>] ? kernel_init+0x0/0x176
> [    1.797062]  [<c10038b7>] kernel_thread_helper+0x7/0x10
> [    1.812984] 00000080 + ffe00000

that is rather later.
acpi_gbl_permanent_mmap should be set in acpi_early_init()
if acpi is not disabled

and we have
> [    0.000000] ASUS P2B-DS detected: force use of acpi=ht

just don't load acpi_processor_init...

Reported-and-tested-by: Jens Rosenboom <jens@leia.mcbone.net>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/acpi/processor_core.c~acpi-dont-call-acpi_processor_init-if-acpi-is-disabled drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-dont-call-acpi_processor_init-if-acpi-is-disabled
+++ a/drivers/acpi/processor_core.c
@@ -1137,6 +1137,9 @@ static int __init acpi_processor_init(vo
 {
 	int result = 0;
 
+	if (acpi_disabled)
+		return 0;
+
 	memset(&errata, 0, sizeof(errata));
 
 #ifdef CONFIG_SMP
@@ -1185,6 +1188,9 @@ out_proc:
 
 static void __exit acpi_processor_exit(void)
 {
+	if (acpi_disabled)
+		return;
+
 	acpi_processor_ppc_exit();
 
 	acpi_thermal_cpufreq_exit();
_

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch
acpi-dont-call-acpi_processor_init-if-acpi-is-disabled.patch


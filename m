From: akpm@linux-foundation.org
Subject: + sata_mv-fix-loop-with-last-port.patch added to -mm tree
Date: Fri, 08 Feb 2008 13:45:18 -0800
Message-ID: <200802082145.m18LjIUT014898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758665AbYBHVqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:46:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, htejun@gmail.com, jeff@garzik.org, mlord@pobox.com, yinghai.lu@Sun.COM


The patch titled
     sata_mv: fix loop with last port
has been added to the -mm tree.  Its filename is
     sata_mv-fix-loop-with-last-port.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sata_mv: fix loop with last port
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

commit f351b2d638c3cb0b95adde3549b7bfaf3f991dfa
        sata_mv: Support SoC controllers

caused a panic:

scsi 4:0:0:0: Direct-Access     ATA      HITACHI HDS7225S V44O PQ: 0 ANSI: 5
sd 4:0:0:0: [sde] 488390625 512-byte hardware sectors (250056 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sde] 488390625 512-byte hardware sectors (250056 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde:<1>BUG: unable to handle kernel NULL pointer dereference at 000000000000001a
IP: [<ffffffff806262c7>] mv_interrupt+0x21c/0x4cc
PGD 0
Oops: 0000 [1] SMP
CPU 3
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.24-smp-08636-g0afc2ed-dirty #26
RIP: 0010:[<ffffffff806262c7>]  [<ffffffff806262c7>] mv_interrupt+0x21c/0x4cc
RSP: 0000:ffff8102050bbec8  EFLAGS: 00010297
RAX: 0000000000000008 RBX: 0000000000000000 RCX: 0000000000000003
RDX: 0000000000008000 RSI: 0000000000000286 RDI: ffff8102035180e0
RBP: 0000000000000001 R08: 0000000000000003 R09: ffff8102036613e0
R10: 0000000000000002 R11: ffffffff8061474c R12: ffff8102035bf828
R13: 0000000000000008 R14: ffff81020348ece8 R15: ffffc20002cb2000
FS:  0000000000000000(0000) GS:ffff810405025700(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000000001a CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff810405094000, task ffff8102050b28c0)
Stack:  000000010000000c 0002040000220400 0000001100000002 ffff81020348eda8
 0000000000000001 ffff8102035f2cc0 0000000000000000 0000000000000000
 0000000000000018 0000000000000000 0000000000000000 ffffffff80269ee8
Call Trace:
 <IRQ>  [<ffffffff80269ee8>] ? handle_IRQ_event+0x25/0x53
 [<ffffffff8026b393>] ? handle_fasteoi_irq+0x90/0xc8
 [<ffffffff802218e2>] ? do_IRQ+0xf1/0x15f
 [<ffffffff8021df24>] ? default_idle+0x0/0x55
 [<ffffffff8021f361>] ? ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8023010c>] ? lapic_next_event+0x0/0xa
 [<ffffffff8021df55>] ? default_idle+0x31/0x55
 [<ffffffff8021df50>] ? default_idle+0x2c/0x55
 [<ffffffff8021df24>] ? default_idle+0x0/0x55
 [<ffffffff8021e00b>] ? cpu_idle+0x92/0xb8

Code: 41 14 85 c0 89 44 24 14 0f 84 9d 02 00 00 f7 d0 01 d6 41 89 d5 89 41 14 8b 41 14 89 34 24 e9 7e 02 00 00 49 63 c5 49 8b 5c c6 48 <f6> 43 1a 80 4c 8b a3 20 37 00 00 0f 85 62 02 00 00 31 c9 41 83
RIP  [<ffffffff806262c7>] mv_interrupt+0x21c/0x4cc
 RSP <ffff8102050bbec8>
CR2: 000000000000001a
---[ end trace 2583b5f7a5350584 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!

last_port already include port0 base.  This patch change use last_port
directly, and move pp assignment later.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Acked-by: Mark Lord <mlord@pobox.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_mv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/ata/sata_mv.c~sata_mv-fix-loop-with-last-port drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~sata_mv-fix-loop-with-last-port
+++ a/drivers/ata/sata_mv.c
@@ -1716,14 +1716,16 @@ static void mv_host_intr(struct ata_host
 	VPRINTK("ENTER, hc%u relevant=0x%08x HC IRQ cause=0x%08x\n",
 		hc, relevant, hc_irq_cause);
 
-	for (port = port0; port < port0 + last_port; port++) {
+	for (port = port0; port < last_port; port++) {
 		struct ata_port *ap = host->ports[port];
-		struct mv_port_priv *pp = ap->private_data;
+		struct mv_port_priv *pp;
 		int have_err_bits, hard_port, shift;
 
 		if ((!ap) || (ap->flags & ATA_FLAG_DISABLED))
 			continue;
 
+		pp = ap->private_data;
+
 		shift = port << 1;		/* (port * 2) */
 		if (port >= MV_PORTS_PER_HC) {
 			shift++;	/* skip bit 8 in the HC Main IRQ reg */
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
sata_mv-fix-loop-with-last-port.patch
git-x86.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch

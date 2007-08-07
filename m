From: akpm@linux-foundation.org
Subject: + remove-bdput-from-do_open-in-fs-block_devc.patch added to -mm tree
Date: Tue, 07 Aug 2007 15:24:45 -0700
Message-ID: <200708072224.l77MOjNY008010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757902AbXHGWZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:25:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rafalbilski@interia.pl, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     Remove bdput from do_open() in fs/block_dev.c
has been added to the -mm tree.  Its filename is
     remove-bdput-from-do_open-in-fs-block_devc.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: Remove bdput from do_open() in fs/block_dev.c
=46rom: Rafa=B3 Bilski <rafalbilski@interia.pl>

I mistyped
# echo /dev/hdc1 >/sys/module/block2mtd/parameters/block2mt
instead of sdc1. There is no /dev/hdc1. I have DVD-ROM as /dev/hdc.
# dmesg
block2mtd: version $Revision: 1.30 $
block2mtd: error: cannot open device /dev/hdc1
Looks right, but tray is locked. And it doesn't want to get out.
# eject
hdc: irq timeout: status=3D0xd0 { Busy }
ide: failed opcode was: unknown
WARNING: at kernel/irq/resend.c:70 check_irq_resend()
 [<c013444b>] check_irq_resend+0xab/0xc0
 [<c0133e2a>] enable_irq+0x4a/0xa0
 [<c02c26e7>] ide_error+0x47/0xa0
 [<c02d1e60>] cdrom_newpc_intr+0x0/0x300
 [<c02c2bc0>] ide_timer_expiry+0x1e0/0x2d0
 [<c02c29e0>] ide_timer_expiry+0x0/0x2d0
 [<c011b986>] run_timer_softirq+0x116/0x160
 [<c0127e75>] hrtimer_interrupt+0x165/0x1a0
 [<c0118772>] __do_softirq+0x42/0x90
 [<c01187e6>] do_softirq+0x26/0x30
 [<c0118aaa>] irq_exit+0x5a/0x60
 [<c0104817>] do_IRQ+0x47/0x80
 [<c0102c23>] common_interrupt+0x23/0x30
 [<c0281a46>] acpi_processor_idle+0x162/0x380
 [<c0100d0e>] cpu_idle+0x4e/0x70
 [<c0524ac5>] start_kernel+0x1f5/0x240
 [<c05243a0>] unknown_bootoption+0x0/0x1e0
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Removing bdput from do_open() in fs/block_dev.c seems to be a cure for =
irq
timeout.

Signed-off-by: Rafa=B3 Bilski <rafalbilski@interia.pl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN fs/block_dev.c~remove-bdput-from-do_open-in-fs-block_devc fs/=
block_dev.c
--- a/fs/block_dev.c~remove-bdput-from-do_open-in-fs-block_devc
+++ a/fs/block_dev.c
@@ -1120,7 +1120,6 @@ static int do_open(struct block_device *
 	disk =3D get_gendisk(bdev->bd_dev, &part);
 	if (!disk) {
 		unlock_kernel();
-		bdput(bdev);
 		return ret;
 	}
 	owner =3D disk->fops->owner;
_

Patches currently in -mm which might be from rafalbilski@interia.pl are

remove-bdput-from-do_open-in-fs-block_devc.patch
remove-bdput-from-do_open-in-fs-block_devc-fix.patch

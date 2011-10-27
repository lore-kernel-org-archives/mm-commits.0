From: akpm@linux-foundation.org
Subject: [merged] parport_pc-release-io-region-properly-if-unsupported-ite887x-card-is-found.patch removed from -mm tree
Date: Thu, 27 Oct 2011 16:09:01 -0700
Message-ID: <201110272309.p9RN91io008694@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:49178 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab1J0XKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2011 19:10:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, alan@linux.intel.com, bjorn.helgaas@hp.com, gregkh@suse.de, krahn@niehs.nih.gov, ndevos@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parport_pc: release IO region properly if unsupported ITE887x card is found
has been removed from the -mm tree.  Its filename was
     parport_pc-release-io-region-properly-if-unsupported-ite887x-card-is-found.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: parport_pc: release IO region properly if unsupported ITE887x card is found

sio_ite_8872_probe() bails out if it detects no-parallel (1S, 2S) or
unknown card.

It doesn't call release_region() on the previously allocated resource
though.  This causes

  (a) leak of the resource
  (b) kernel oops when parport module is removed and /proc/ioports is read. This
      is because the string that has been associated to the IO port region
      is a static char array inside the already removed module.

Let's call release_region() properly before baling out.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Niels de Vos <ndevos@redhat.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Joe Krahn <krahn@niehs.nih.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/parport/parport_pc.c~parport_pc-release-io-region-properly-if-unsupported-ite887x-card-is-found drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport_pc-release-io-region-properly-if-unsupported-ite887x-card-is-found
+++ a/drivers/parport/parport_pc.c
@@ -2595,14 +2595,17 @@ static int __devinit sio_ite_8872_probe(
 		break;
 	case 0x6:
 		printk(KERN_INFO "parport_pc: ITE8873 found (1S)\n");
+		release_region(inta_addr[i], 32);
 		return 0;
 	case 0x8:
 		printk(KERN_INFO "parport_pc: ITE8874 found (2S)\n");
+		release_region(inta_addr[i], 32);
 		return 0;
 	default:
 		printk(KERN_INFO "parport_pc: unknown ITE887x\n");
 		printk(KERN_INFO "parport_pc: please mail 'lspci -nvv' "
 			"output to Rich.Liu@ite.com.tw\n");
+		release_region(inta_addr[i], 32);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch
maintainers-add-aslr-maintainer.patch
binfmt_elf-fix-pie-execution-with-randomization-disabled.patch


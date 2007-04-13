From: akpm@linux-foundation.org
Subject: - cciss-unregister-from-scsi-before-tearing-down-device-resources.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:28:16 -0700
Message-ID: <200704132328.l3DNSGDI012508@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60324 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030892AbXDMX2W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:28:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: unregister from SCSI before tearing down device resources
has been removed from the -mm tree.  Its filename was
     cciss-unregister-from-scsi-before-tearing-down-device-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: unregister from SCSI before tearing down device resources
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

We must unregister from SCSI before we unmap device resources and unhook
the IRQ handler.  Otherwise, SCSI may send us more requests, and we won't
be able to handle them.

I see the following oops during every reboot of my HP DL360:

    ...
    Unmounting local filesystems...done.
    Rebooting... Completed flushing cache on controller 0
    BUG: unable to handle kernel paging request at virtual address f8808040
     printing eip:
    c02dc72b
    *pde = 02120067
    *pte = 00000000
    Oops: 0002 [#1]
    SMP
    Modules linked in:
    CPU:    1
    EIP:    0060:[<c02dc72b>]    Not tainted VLI
    EFLAGS: 00010046   (2.6.21-rc6 #1)
    EIP is at SA5_submit_command+0xb/0x20
    eax: f8808000   ebx: f7a00000   ecx: f79f0000   edx: 37a00000
    esi: f79f0000   edi: 00000000   ebp: 00000000   esp: dd717a44
    ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
    Process khelper (pid: 1427, ti=dd716000 task=c2260a70 task.ti=dd716000)
    Stack: c02df2c0 f7a00000 f7a00000 00d41008 c02df691 00000000 00000010 00000002
	   00000001 f79f0000 f7fff844 c1398420 00000000 00000000 00001000 230a3020
	   69666564 5420656e 50434f49 465f544b 4853554c 44414552 0a312009 66656423
    Call Trace:
     [<c02df2c0>] start_io+0x80/0x120
     [<c02df691>] do_cciss_request+0x331/0x350
     [<c014242a>] mempool_alloc+0x2a/0xe0
     [<c020ad71>] blk_alloc_request+0x61/0x80
     [<c020b02e>] get_request+0x15e/0x1e0
     [<c01595e0>] cache_alloc_refill+0xb0/0x1e0
     [<c021049d>] as_update_rq+0x2d/0x80
     [<c0210d28>] as_add_request+0x68/0x90
     [<c0207f99>] elv_insert+0x119/0x160
     [<c020bd0b>] __make_request+0xcb/0x320
     [<c0122ee0>] lock_timer_base+0x20/0x50
     [<c0123096>] del_timer+0x56/0x60
     [<c020a7b8>] blk_remove_plug+0x38/0x70
     [<c020a815>] __generic_unplug_device+0x25/0x30
     [<c020a835>] generic_unplug_device+0x15/0x30
    ...

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff -puN drivers/block/cciss.c~cciss-unregister-from-scsi-before-tearing-down-device-resources drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-unregister-from-scsi-before-tearing-down-device-resources
+++ a/drivers/block/cciss.c
@@ -3423,6 +3423,25 @@ static void cciss_remove_one(struct pci_
 		       "already be removed \n");
 		return;
 	}
+
+	remove_proc_entry(hba[i]->devname, proc_cciss);
+	unregister_blkdev(hba[i]->major, hba[i]->devname);
+
+	/* remove it from the disk list */
+	for (j = 0; j < CISS_MAX_LUN; j++) {
+		struct gendisk *disk = hba[i]->gendisk[j];
+		if (disk) {
+			request_queue_t *q = disk->queue;
+
+			if (disk->flags & GENHD_FL_UP)
+				del_gendisk(disk);
+			if (q)
+				blk_cleanup_queue(q);
+		}
+	}
+
+	cciss_unregister_scsi(i);	/* unhook from SCSI subsystem */
+
 	/* Turn board interrupts off  and send the flush cache command */
 	/* sendcmd will turn off interrupt, and send the flush...
 	 * To write all data in the battery backed cache to disks */
@@ -3444,22 +3463,6 @@ static void cciss_remove_one(struct pci_
 #endif				/* CONFIG_PCI_MSI */
 
 	iounmap(hba[i]->vaddr);
-	cciss_unregister_scsi(i);	/* unhook from SCSI subsystem */
-	unregister_blkdev(hba[i]->major, hba[i]->devname);
-	remove_proc_entry(hba[i]->devname, proc_cciss);
-
-	/* remove it from the disk list */
-	for (j = 0; j < CISS_MAX_LUN; j++) {
-		struct gendisk *disk = hba[i]->gendisk[j];
-		if (disk) {
-			request_queue_t *q = disk->queue;
-
-			if (disk->flags & GENHD_FL_UP)
-				del_gendisk(disk);
-			if (q)
-				blk_cleanup_queue(q);
-		}
-	}
 
 	pci_free_consistent(hba[i]->pdev, hba[i]->nr_cmds * sizeof(CommandList_struct),
 			    hba[i]->cmd_pool, hba[i]->cmd_pool_dhandle);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
git-ia64.patch
move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch
pnpacpi-sets-pnpdev-devarchdata.patch
pnpacpi-sets-pnpdev-devarchdata-fix.patch
efi-warn-only-for-pre-100-system-tables.patch
pnpbios_thread_init-dont-use-clone_sighand.patch
pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi.patch
pnp-workaround-hp-bios-defect-that-leaves-smcf010-device-partly-enabled.patch
smsc-ircc2-tidy-up-module-parameter-checking.patch
smsc-ircc2-add-pnp-support.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
use-menuconfig-objects-pnp.patch

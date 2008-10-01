From: akpm@linux-foundation.org
Subject: - drivers-block-use-div_round_up.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:51:52 -0700
Message-ID: <200810012151.m91Lpq30005965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbYJAVwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:52:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block: Use DIV_ROUND_UP
has been removed from the -mm tree.  Its filename was
     drivers-block-use-div_round_up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block: Use DIV_ROUND_UP
From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c    |    8 ++++----
 drivers/block/cpqarray.c |    2 +-
 drivers/block/floppy.c   |    8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/block/cciss.c~drivers-block-use-div_round_up drivers/block/cciss.c
--- a/drivers/block/cciss.c~drivers-block-use-div_round_up
+++ a/drivers/block/cciss.c
@@ -3460,8 +3460,8 @@ static int __devinit cciss_init_one(stru
 	       hba[i]->intr[SIMPLE_MODE_INT], dac ? "" : " not");
 
 	hba[i]->cmd_pool_bits =
-	    kmalloc(((hba[i]->nr_cmds + BITS_PER_LONG -
-		      1) / BITS_PER_LONG) * sizeof(unsigned long), GFP_KERNEL);
+	    kmalloc(DIV_ROUND_UP(hba[i]->nr_cmds, BITS_PER_LONG)
+			* sizeof(unsigned long), GFP_KERNEL);
 	hba[i]->cmd_pool = (CommandList_struct *)
 	    pci_alloc_consistent(hba[i]->pdev,
 		    hba[i]->nr_cmds * sizeof(CommandList_struct),
@@ -3493,8 +3493,8 @@ static int __devinit cciss_init_one(stru
 	/* command and error info recs zeroed out before
 	   they are used */
 	memset(hba[i]->cmd_pool_bits, 0,
-	       ((hba[i]->nr_cmds + BITS_PER_LONG -
-		 1) / BITS_PER_LONG) * sizeof(unsigned long));
+	       DIV_ROUND_UP(hba[i]->nr_cmds, BITS_PER_LONG)
+			* sizeof(unsigned long));
 
 	hba[i]->num_luns = 0;
 	hba[i]->highest_lun = -1;
diff -puN drivers/block/cpqarray.c~drivers-block-use-div_round_up drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~drivers-block-use-div_round_up
+++ a/drivers/block/cpqarray.c
@@ -424,7 +424,7 @@ static int __init cpqarray_register_ctlr
 		hba[i]->pci_dev, NR_CMDS * sizeof(cmdlist_t),
 		&(hba[i]->cmd_pool_dhandle));
 	hba[i]->cmd_pool_bits = kcalloc(
-		(NR_CMDS+BITS_PER_LONG-1)/BITS_PER_LONG, sizeof(unsigned long),
+		DIV_ROUND_UP(NR_CMDS, BITS_PER_LONG), sizeof(unsigned long),
 		GFP_KERNEL);
 
 	if (!hba[i]->cmd_pool_bits || !hba[i]->cmd_pool)
diff -puN drivers/block/floppy.c~drivers-block-use-div_round_up drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-use-div_round_up
+++ a/drivers/block/floppy.c
@@ -1355,20 +1355,20 @@ static void fdc_specify(void)
 	}
 
 	/* Convert step rate from microseconds to milliseconds and 4 bits */
-	srt = 16 - (DP->srt * scale_dtr / 1000 + NOMINAL_DTR - 1) / NOMINAL_DTR;
+	srt = 16 - DIV_ROUND_UP(DP->srt * scale_dtr / 1000, NOMINAL_DTR);
 	if (slow_floppy) {
 		srt = srt / 4;
 	}
 	SUPBOUND(srt, 0xf);
 	INFBOUND(srt, 0);
 
-	hlt = (DP->hlt * scale_dtr / 2 + NOMINAL_DTR - 1) / NOMINAL_DTR;
+	hlt = DIV_ROUND_UP(DP->hlt * scale_dtr / 2, NOMINAL_DTR);
 	if (hlt < 0x01)
 		hlt = 0x01;
 	else if (hlt > 0x7f)
 		hlt = hlt_max_code;
 
-	hut = (DP->hut * scale_dtr / 16 + NOMINAL_DTR - 1) / NOMINAL_DTR;
+	hut = DIV_ROUND_UP(DP->hut * scale_dtr / 16, NOMINAL_DTR);
 	if (hut < 0x1)
 		hut = 0x1;
 	else if (hut > 0xf)
@@ -2385,7 +2385,7 @@ static void rw_interrupt(void)
 
 #ifdef FLOPPY_SANITY_CHECK
 	if (nr_sectors / ssize >
-	    (in_sector_offset + current_count_sectors + ssize - 1) / ssize) {
+	    DIV_ROUND_UP(in_sector_offset + current_count_sectors, ssize)) {
 		DPRINT("long rw: %x instead of %lx\n",
 		       nr_sectors, current_count_sectors);
 		printk("rs=%d s=%d\n", R_SECTOR, SECTOR);
_

Patches currently in -mm which might be from julia@diku.dk are

git-v4l-dvb.patch
git-infiniband.patch
git-ieee1394.patch
git-async_tx.patch
git-net.patch
git-mtd.patch
git-sound.patch
git-cpufreq.patch
git-gfs2.patch
git-ubifs.patch
git-block.patch
drivers-media-common-tuners-drop-code-after-return-or-goto.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
fs-namespacec-drop-code-after-return.patch
drivers-misc-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch


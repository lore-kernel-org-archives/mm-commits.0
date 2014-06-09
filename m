From: akpm@linux-foundation.org
Subject: [merged] fs-hpfs-use-__func__-for-logging.patch removed from -mm
 tree
Date: Mon, 09 Jun 2014 12:32:52 -0700
Message-ID: <53960be4.Pdrk7OPVgRDuTJqC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaFITcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:32:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mikulas@artax.karlin.mff.cuni.cz, fabf@skynet.be

Subject: [merged] fs-hpfs-use-__func__-for-logging.patch removed from -mm tree
To: fabf@skynet.be,mikulas@artax.karlin.mff.cuni.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:32:52 -0700


The patch titled
     Subject: fs/hpfs: use __func__ for logging
has been removed from the -mm tree.  Its filename was
     fs-hpfs-use-__func__-for-logging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/hpfs: use __func__ for logging

Normalize function display fx() using __func__

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/buffer.c |   12 ++++++------
 fs/hpfs/dnode.c  |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/hpfs/buffer.c~fs-hpfs-use-__func__-for-logging fs/hpfs/buffer.c
--- a/fs/hpfs/buffer.c~fs-hpfs-use-__func__-for-logging
+++ a/fs/hpfs/buffer.c
@@ -55,7 +55,7 @@ void *hpfs_map_sector(struct super_block
 	if (bh != NULL)
 		return bh->b_data;
 	else {
-		pr_warn("hpfs_map_sector: read error\n");
+		pr_warn("%s(): read error\n", __func__);
 		return NULL;
 	}
 }
@@ -76,7 +76,7 @@ void *hpfs_get_sector(struct super_block
 		set_buffer_uptodate(bh);
 		return bh->b_data;
 	} else {
-		pr_warn("hpfs_get_sector: getblk failed\n");
+		pr_warn("%s(): getblk failed\n", __func__);
 		return NULL;
 	}
 }
@@ -93,7 +93,7 @@ void *hpfs_map_4sectors(struct super_blo
 	cond_resched();
 
 	if (secno & 3) {
-		pr_warn("hpfs_map_4sectors: unaligned read\n");
+		pr_warn("%s(): unaligned read\n", __func__);
 		return NULL;
 	}
 
@@ -112,7 +112,7 @@ void *hpfs_map_4sectors(struct super_blo
 
 	qbh->data = data = kmalloc(2048, GFP_NOFS);
 	if (!data) {
-		pr_warn("hpfs_map_4sectors: out of memory\n");
+		pr_warn("%s(): out of memory\n", __func__);
 		goto bail4;
 	}
 
@@ -145,7 +145,7 @@ void *hpfs_get_4sectors(struct super_blo
 	hpfs_lock_assert(s);
 
 	if (secno & 3) {
-		pr_warn("hpfs_get_4sectors: unaligned read\n");
+		pr_warn("%s(): unaligned read\n", __func__);
 		return NULL;
 	}
 
@@ -161,7 +161,7 @@ void *hpfs_get_4sectors(struct super_blo
 	}
 
 	if (!(qbh->data = kmalloc(2048, GFP_NOFS))) {
-		pr_warn("hpfs_get_4sectors: out of memory\n");
+		pr_warn("%s(): out of memory\n", __func__);
 		goto bail4;
 	}
 	return qbh->data;
diff -puN fs/hpfs/dnode.c~fs-hpfs-use-__func__-for-logging fs/hpfs/dnode.c
--- a/fs/hpfs/dnode.c~fs-hpfs-use-__func__-for-logging
+++ a/fs/hpfs/dnode.c
@@ -17,7 +17,7 @@ static loff_t get_pos(struct dnode *d, s
 		if (de == fde) return ((loff_t) le32_to_cpu(d->self) << 4) | (loff_t)i;
 		i++;
 	}
-	pr_info("get_pos: not_found\n");
+	pr_info("%s(): not_found\n", __func__);
 	return ((loff_t)le32_to_cpu(d->self) << 4) | (loff_t)1;
 }
 
@@ -94,8 +94,8 @@ static void hpfs_pos_ins(loff_t *p, loff
 	if ((*p & ~0x3f) == (d & ~0x3f) && (*p & 0x3f) >= (d & 0x3f)) {
 		int n = (*p & 0x3f) + c;
 		if (n > 0x3f)
-			pr_warn("hpfs_pos_ins: %08x + %d\n",
-				(int)*p, (int)c >> 8);
+			pr_warn("%s(): %08x + %d\n",
+				__func__, (int)*p, (int)c >> 8);
 		else
 			*p = (*p & ~0x3f) | n;
 	}
@@ -106,8 +106,8 @@ static void hpfs_pos_del(loff_t *p, loff
 	if ((*p & ~0x3f) == (d & ~0x3f) && (*p & 0x3f) >= (d & 0x3f)) {
 		int n = (*p & 0x3f) - c;
 		if (n < 1)
-			pr_warn("hpfs_pos_ins: %08x - %d\n",
-				(int)*p, (int)c >> 8);
+			pr_warn("%s(): %08x - %d\n",
+				__func__, (int)*p, (int)c >> 8);
 		else
 			*p = (*p & ~0x3f) | n;
 	}
@@ -251,7 +251,7 @@ static int hpfs_add_to_dnode(struct inod
 	}
 	go_up:
 	if (namelen >= 256) {
-		hpfs_error(i->i_sb, "hpfs_add_to_dnode: namelen == %d", namelen);
+		hpfs_error(i->i_sb, "%s(): namelen == %d", __func__, namelen);
 		kfree(nd);
 		kfree(nname);
 		return 1;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch


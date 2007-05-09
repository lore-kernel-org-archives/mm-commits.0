From: akpm@linux-foundation.org
Subject: - md-stop-using-csum_partial-for-checksum-calculation-in-md.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:56 -0700
Message-ID: <200705092154.l49Lsu1g003212@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640AbXEIVzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: stop using csum_partial for checksum calculation in md
has been removed from the -mm tree.  Its filename was
     md-stop-using-csum_partial-for-checksum-calculation-in-md.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: stop using csum_partial for checksum calculation in md
From: NeilBrown <neilb@suse.de>

If CONFIG_NET is not selected, csum_partial is not exported, so md.ko cannot
use it.  We shouldn't really be using csum_partial anyway as it is an
internal-to-networking interface.

So replace it with C code to do the same thing.  Speed is not crucial here, so
something simple and correct is best.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff -puN drivers/md/md.c~md-stop-using-csum_partial-for-checksum-calculation-in-md drivers/md/md.c
--- a/drivers/md/md.c~md-stop-using-csum_partial-for-checksum-calculation-in-md
+++ a/drivers/md/md.c
@@ -590,14 +590,41 @@ abort:
 	return ret;
 }
 
+
+static u32 md_csum_fold(u32 csum)
+{
+	csum = (csum & 0xffff) + (csum >> 16);
+	return (csum & 0xffff) + (csum >> 16);
+}
+
 static unsigned int calc_sb_csum(mdp_super_t * sb)
 {
+	u64 newcsum = 0;
+	u32 *sb32 = (u32*)sb;
+	int i;
 	unsigned int disk_csum, csum;
 
 	disk_csum = sb->sb_csum;
 	sb->sb_csum = 0;
-	csum = csum_partial((void *)sb, MD_SB_BYTES, 0);
+
+	for (i = 0; i < MD_SB_BYTES/4 ; i++)
+		newcsum += sb32[i];
+	csum = (newcsum & 0xffffffff) + (newcsum>>32);
+
+
+#ifdef CONFIG_ALPHA
+	/* This used to use csum_partial, which was wrong for several
+	 * reasons including that different results are returned on
+	 * different architectures.  It isn't critical that we get exactly
+	 * the same return value as before (we always csum_fold before
+	 * testing, and that removes any differences).  However as we
+	 * know that csum_partial always returned a 16bit value on
+	 * alphas, do a fold to maximise conformity to previous behaviour.
+	 */
+	sb->sb_csum = md_csum_fold(disk_csum);
+#else
 	sb->sb_csum = disk_csum;
+#endif
 	return csum;
 }
 
@@ -685,7 +712,7 @@ static int super_90_load(mdk_rdev_t *rde
 	if (sb->raid_disks <= 0)
 		goto abort;
 
-	if (csum_fold(calc_sb_csum(sb)) != csum_fold(sb->sb_csum)) {
+	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
 		printk(KERN_WARNING "md: invalid superblock checksum on %s\n",
 			b);
 		goto abort;
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
introduce-freezer-flags-rev-2.patch
git-md-accel.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

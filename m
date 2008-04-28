From: akpm@linux-foundation.org
Subject: - quota-do-not-allow-setting-of-quota-limits-to-too-high-values.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:23 -0700
Message-ID: <200804282156.m3SLuNvO018221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936796AbYD1V42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew.perepechko@sun.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: do not allow setting of quota limits to too high values
has been removed from the -mm tree.  Its filename was
     quota-do-not-allow-setting-of-quota-limits-to-too-high-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: do not allow setting of quota limits to too high values
From: Andrew Perepechko <andrew.perepechko@sun.com>

We should check whether quota limits set via Q_SETQUOTA are not exceeding
limits which quota format is able to handle.

Signed-off-by: Andrew Perepechko <andrew.perepechko@sun.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c            |   22 +++++++++++++++++-----
 fs/quota_v1.c         |    3 +++
 fs/quota_v2.c         |    3 +++
 include/linux/quota.h |    2 ++
 4 files changed, 25 insertions(+), 5 deletions(-)

diff -puN fs/dquot.c~quota-do-not-allow-setting-of-quota-limits-to-too-high-values fs/dquot.c
--- a/fs/dquot.c~quota-do-not-allow-setting-of-quota-limits-to-too-high-values
+++ a/fs/dquot.c
@@ -1709,10 +1709,19 @@ int vfs_get_dqblk(struct super_block *sb
 }
 
 /* Generic routine for setting common part of quota structure */
-static void do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
+static int do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
 {
 	struct mem_dqblk *dm = &dquot->dq_dqb;
 	int check_blim = 0, check_ilim = 0;
+	struct mem_dqinfo *dqi = &sb_dqopt(dquot->dq_sb)->info[dquot->dq_type];
+
+	if ((di->dqb_valid & QIF_BLIMITS &&
+	     (di->dqb_bhardlimit > dqi->dqi_maxblimit ||
+	      di->dqb_bsoftlimit > dqi->dqi_maxblimit)) ||
+	    (di->dqb_valid & QIF_ILIMITS &&
+	     (di->dqb_ihardlimit > dqi->dqi_maxilimit ||
+	      di->dqb_isoftlimit > dqi->dqi_maxilimit)))
+		return -ERANGE;
 
 	spin_lock(&dq_data_lock);
 	if (di->dqb_valid & QIF_SPACE) {
@@ -1744,7 +1753,7 @@ static void do_set_dqblk(struct dquot *d
 			clear_bit(DQ_BLKS_B, &dquot->dq_flags);
 		}
 		else if (!(di->dqb_valid & QIF_BTIME))	/* Set grace only if user hasn't provided his own... */
-			dm->dqb_btime = get_seconds() + sb_dqopt(dquot->dq_sb)->info[dquot->dq_type].dqi_bgrace;
+			dm->dqb_btime = get_seconds() + dqi->dqi_bgrace;
 	}
 	if (check_ilim) {
 		if (!dm->dqb_isoftlimit || dm->dqb_curinodes < dm->dqb_isoftlimit) {
@@ -1752,7 +1761,7 @@ static void do_set_dqblk(struct dquot *d
 			clear_bit(DQ_INODES_B, &dquot->dq_flags);
 		}
 		else if (!(di->dqb_valid & QIF_ITIME))	/* Set grace only if user hasn't provided his own... */
-			dm->dqb_itime = get_seconds() + sb_dqopt(dquot->dq_sb)->info[dquot->dq_type].dqi_igrace;
+			dm->dqb_itime = get_seconds() + dqi->dqi_igrace;
 	}
 	if (dm->dqb_bhardlimit || dm->dqb_bsoftlimit || dm->dqb_ihardlimit || dm->dqb_isoftlimit)
 		clear_bit(DQ_FAKE_B, &dquot->dq_flags);
@@ -1760,21 +1769,24 @@ static void do_set_dqblk(struct dquot *d
 		set_bit(DQ_FAKE_B, &dquot->dq_flags);
 	spin_unlock(&dq_data_lock);
 	mark_dquot_dirty(dquot);
+
+	return 0;
 }
 
 int vfs_set_dqblk(struct super_block *sb, int type, qid_t id, struct if_dqblk *di)
 {
 	struct dquot *dquot;
+	int rc;
 
 	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
 	if (!(dquot = dqget(sb, id, type))) {
 		mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 		return -ESRCH;
 	}
-	do_set_dqblk(dquot, di);
+	rc = do_set_dqblk(dquot, di);
 	dqput(dquot);
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
-	return 0;
+	return rc;
 }
 
 /* Generic routine for getting common part of quota file information */
diff -puN fs/quota_v1.c~quota-do-not-allow-setting-of-quota-limits-to-too-high-values fs/quota_v1.c
--- a/fs/quota_v1.c~quota-do-not-allow-setting-of-quota-limits-to-too-high-values
+++ a/fs/quota_v1.c
@@ -139,6 +139,9 @@ static int v1_read_file_info(struct supe
 		goto out;
 	}
 	ret = 0;
+	/* limits are stored as unsigned 32-bit data */
+	dqopt->info[type].dqi_maxblimit = 0xffffffff;
+	dqopt->info[type].dqi_maxilimit = 0xffffffff;
 	dqopt->info[type].dqi_igrace = dqblk.dqb_itime ? dqblk.dqb_itime : MAX_IQ_TIME;
 	dqopt->info[type].dqi_bgrace = dqblk.dqb_btime ? dqblk.dqb_btime : MAX_DQ_TIME;
 out:
diff -puN fs/quota_v2.c~quota-do-not-allow-setting-of-quota-limits-to-too-high-values fs/quota_v2.c
--- a/fs/quota_v2.c~quota-do-not-allow-setting-of-quota-limits-to-too-high-values
+++ a/fs/quota_v2.c
@@ -59,6 +59,9 @@ static int v2_read_file_info(struct supe
 			sb->s_id);
 		return -1;
 	}
+	/* limits are stored as unsigned 32-bit data */
+	info->dqi_maxblimit = 0xffffffff;
+	info->dqi_maxilimit = 0xffffffff;
 	info->dqi_bgrace = le32_to_cpu(dinfo.dqi_bgrace);
 	info->dqi_igrace = le32_to_cpu(dinfo.dqi_igrace);
 	info->dqi_flags = le32_to_cpu(dinfo.dqi_flags);
diff -puN include/linux/quota.h~quota-do-not-allow-setting-of-quota-limits-to-too-high-values include/linux/quota.h
--- a/include/linux/quota.h~quota-do-not-allow-setting-of-quota-limits-to-too-high-values
+++ a/include/linux/quota.h
@@ -206,6 +206,8 @@ struct mem_dqinfo {
 	unsigned long dqi_flags;
 	unsigned int dqi_bgrace;
 	unsigned int dqi_igrace;
+	qsize_t dqi_maxblimit;
+	qsize_t dqi_maxilimit;
 	union {
 		struct v1_mem_dqinfo v1_i;
 		struct v2_mem_dqinfo v2_i;
_

Patches currently in -mm which might be from andrew.perepechko@sun.com are

origin.patch


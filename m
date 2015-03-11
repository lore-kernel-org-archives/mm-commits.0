From: akpm@linux-foundation.org
Subject: [merged] staging-lustre-convert-return-seq_printf-uses.patch
 removed from -mm tree
Date: Wed, 11 Mar 2015 12:17:37 -0700
Message-ID: <550094d1.xwO/01IwKfyAUo14%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbbCKTRi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 15:17:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, andreas.dilger@intel.com, gregkh@linuxfoundation.org, oleg.drokin@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: lustre: convert "return seq_printf(...)" uses
has been removed from the -mm tree.  Its filename was
     staging-lustre-convert-return-seq_printf-uses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: staging: lustre: convert "return seq_printf(...)" uses

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Convert these "return seq_printf(...)" uses to:

	seq_printf(seq, ...);
	return 0;

Done via cocci script:

@@
struct seq_file *seq;
@@

-	return
	\(seq_printf\|seq_puts\|seq_putc\)(seq,
	...);

+	return 0;

With some additional reformatting and typing post conversion.

Miscellanea:

o convert an rc++ use to a bool
o use seq_puts with fixed strings where appropriate

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/libcfs/hash.c                 |   11 -
 drivers/staging/lustre/lustre/llite/lproc_llite.c           |   88 +++++-----
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c               |   18 +-
 drivers/staging/lustre/lustre/lov/lproc_lov.c               |   30 ++-
 drivers/staging/lustre/lustre/obdclass/linux/linux-module.c |   38 ++--
 drivers/staging/lustre/lustre/obdclass/lprocfs_status.c     |   26 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c          |   25 +-
 drivers/staging/lustre/lustre/osc/lproc_osc.c               |   22 +-
 drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c         |   20 +-
 9 files changed, 163 insertions(+), 115 deletions(-)

diff -puN drivers/staging/lustre/lustre/libcfs/hash.c~staging-lustre-convert-return-seq_printf-uses drivers/staging/lustre/lustre/libcfs/hash.c
--- a/drivers/staging/lustre/lustre/libcfs/hash.c~staging-lustre-convert-return-seq_printf-uses
+++ a/drivers/staging/lustre/lustre/libcfs/hash.c
@@ -2010,11 +2010,12 @@ EXPORT_SYMBOL(cfs_hash_rehash_key);
 
 int cfs_hash_debug_header(struct seq_file *m)
 {
-	return seq_printf(m, "%-*s%6s%6s%6s%6s%6s%6s%6s%7s%8s%8s%8s%s\n",
-		 CFS_HASH_BIGNAME_LEN,
-		 "name", "cur", "min", "max", "theta", "t-min", "t-max",
-		 "flags", "rehash", "count", "maxdep", "maxdepb",
-		 " distribution");
+	seq_printf(m, "%-*s%6s%6s%6s%6s%6s%6s%6s%7s%8s%8s%8s%s\n",
+		   CFS_HASH_BIGNAME_LEN,
+		   "name", "cur", "min", "max", "theta", "t-min", "t-max",
+		   "flags", "rehash", "count", "maxdep", "maxdepb",
+		   " distribution");
+	return 0;
 }
 EXPORT_SYMBOL(cfs_hash_debug_header);
 
diff -puN drivers/staging/lustre/lustre/llite/lproc_llite.c~staging-lustre-convert-return-seq_printf-uses drivers/staging/lustre/lustre/llite/lproc_llite.c
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c~staging-lustre-convert-return-seq_printf-uses
+++ a/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -187,7 +187,8 @@ static int ll_fstype_seq_show(struct seq
 	struct super_block *sb = (struct super_block *)m->private;
 
 	LASSERT(sb != NULL);
-	return seq_printf(m, "%s\n", sb->s_type->name);
+	seq_printf(m, "%s\n", sb->s_type->name);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(ll_fstype);
 
@@ -196,7 +197,8 @@ static int ll_sb_uuid_seq_show(struct se
 	struct super_block *sb = (struct super_block *)m->private;
 
 	LASSERT(sb != NULL);
-	return seq_printf(m, "%s\n", ll_s2sbi(sb)->ll_sb_uuid.uuid);
+	seq_printf(m, "%s\n", ll_s2sbi(sb)->ll_sb_uuid.uuid);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(ll_sb_uuid);
 
@@ -353,17 +355,18 @@ static int ll_max_cached_mb_seq_show(str
 
 	max_cached_mb = cache->ccc_lru_max >> shift;
 	unused_mb = atomic_read(&cache->ccc_lru_left) >> shift;
-	return seq_printf(m,
-			"users: %d\n"
-			"max_cached_mb: %d\n"
-			"used_mb: %d\n"
-			"unused_mb: %d\n"
-			"reclaim_count: %u\n",
-			atomic_read(&cache->ccc_users),
-			max_cached_mb,
-			max_cached_mb - unused_mb,
-			unused_mb,
-			cache->ccc_lru_shrinkers);
+	seq_printf(m,
+		   "users: %d\n"
+		   "max_cached_mb: %d\n"
+		   "used_mb: %d\n"
+		   "unused_mb: %d\n"
+		   "reclaim_count: %u\n",
+		   atomic_read(&cache->ccc_users),
+		   max_cached_mb,
+		   max_cached_mb - unused_mb,
+		   unused_mb,
+		   cache->ccc_lru_shrinkers);
+	return 0;
 }
 
 static ssize_t ll_max_cached_mb_seq_write(struct file *file,
@@ -467,7 +470,8 @@ static int ll_checksum_seq_show(struct s
 	struct super_block *sb = m->private;
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
 
-	return seq_printf(m, "%u\n", (sbi->ll_flags & LL_SBI_CHECKSUM) ? 1 : 0);
+	seq_printf(m, "%u\n", (sbi->ll_flags & LL_SBI_CHECKSUM) ? 1 : 0);
+	return 0;
 }
 
 static ssize_t ll_checksum_seq_write(struct file *file,
@@ -503,7 +507,8 @@ static int ll_max_rw_chunk_seq_show(stru
 {
 	struct super_block *sb = m->private;
 
-	return seq_printf(m, "%lu\n", ll_s2sbi(sb)->ll_max_rw_chunk);
+	seq_printf(m, "%lu\n", ll_s2sbi(sb)->ll_max_rw_chunk);
+	return 0;
 }
 
 static ssize_t ll_max_rw_chunk_seq_write(struct file *file,
@@ -525,15 +530,14 @@ static int ll_rd_track_id(struct seq_fil
 {
 	struct super_block *sb = m->private;
 
-	if (ll_s2sbi(sb)->ll_stats_track_type == type) {
-		return seq_printf(m, "%d\n",
-				ll_s2sbi(sb)->ll_stats_track_id);
+	if (ll_s2sbi(sb)->ll_stats_track_type == type)
+		seq_printf(m, "%d\n", ll_s2sbi(sb)->ll_stats_track_id);
+	else if (ll_s2sbi(sb)->ll_stats_track_type == STATS_TRACK_ALL)
+		seq_puts(m, "0 (all)\n");
+	else
+		seq_puts(m, "untracked\n");
 
-	} else if (ll_s2sbi(sb)->ll_stats_track_type == STATS_TRACK_ALL) {
-		return seq_printf(m, "0 (all)\n");
-	} else {
-		return seq_printf(m, "untracked\n");
-	}
+	return 0;
 }
 
 static int ll_wr_track_id(const char __user *buffer, unsigned long count,
@@ -601,7 +605,8 @@ static int ll_statahead_max_seq_show(str
 	struct super_block *sb = m->private;
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
 
-	return seq_printf(m, "%u\n", sbi->ll_sa_max);
+	seq_printf(m, "%u\n", sbi->ll_sa_max);
+	return 0;
 }
 
 static ssize_t ll_statahead_max_seq_write(struct file *file,
@@ -631,8 +636,8 @@ static int ll_statahead_agl_seq_show(str
 	struct super_block *sb = m->private;
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
 
-	return seq_printf(m, "%u\n",
-			sbi->ll_flags & LL_SBI_AGL_ENABLED ? 1 : 0);
+	seq_printf(m, "%u\n", sbi->ll_flags & LL_SBI_AGL_ENABLED ? 1 : 0);
+	return 0;
 }
 
 static ssize_t ll_statahead_agl_seq_write(struct file *file,
@@ -661,13 +666,14 @@ static int ll_statahead_stats_seq_show(s
 	struct super_block *sb = m->private;
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
 
-	return seq_printf(m,
-			"statahead total: %u\n"
-			"statahead wrong: %u\n"
-			"agl total: %u\n",
-			atomic_read(&sbi->ll_sa_total),
-			atomic_read(&sbi->ll_sa_wrong),
-			atomic_read(&sbi->ll_agl_total));
+	seq_printf(m,
+		   "statahead total: %u\n"
+		   "statahead wrong: %u\n"
+		   "agl total: %u\n",
+		   atomic_read(&sbi->ll_sa_total),
+		   atomic_read(&sbi->ll_sa_wrong),
+		   atomic_read(&sbi->ll_agl_total));
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(ll_statahead_stats);
 
@@ -676,8 +682,8 @@ static int ll_lazystatfs_seq_show(struct
 	struct super_block *sb = m->private;
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
 
-	return seq_printf(m, "%u\n",
-			(sbi->ll_flags & LL_SBI_LAZYSTATFS) ? 1 : 0);
+	seq_printf(m, "%u\n", sbi->ll_flags & LL_SBI_LAZYSTATFS ? 1 : 0);
+	return 0;
 }
 
 static ssize_t ll_lazystatfs_seq_write(struct file *file,
@@ -712,7 +718,8 @@ static int ll_max_easize_seq_show(struct
 	if (rc)
 		return rc;
 
-	return seq_printf(m, "%u\n", ealen);
+	seq_printf(m, "%u\n", ealen);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(ll_max_easize);
 
@@ -727,7 +734,8 @@ static int ll_defult_easize_seq_show(str
 	if (rc)
 		return rc;
 
-	return seq_printf(m, "%u\n", ealen);
+	seq_printf(m, "%u\n", ealen);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(ll_defult_easize);
 
@@ -742,7 +750,8 @@ static int ll_max_cookiesize_seq_show(st
 	if (rc)
 		return rc;
 
-	return seq_printf(m, "%u\n", cookielen);
+	seq_printf(m, "%u\n", cookielen);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(ll_max_cookiesize);
 
@@ -757,7 +766,8 @@ static int ll_defult_cookiesize_seq_show
 	if (rc)
 		return rc;
 
-	return seq_printf(m, "%u\n", cookielen);
+	seq_printf(m, "%u\n", cookielen);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(ll_defult_cookiesize);
 
diff -puN drivers/staging/lustre/lustre/lmv/lproc_lmv.c~staging-lustre-convert-return-seq_printf-uses drivers/staging/lustre/lustre/lmv/lproc_lmv.c
--- a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c~staging-lustre-convert-return-seq_printf-uses
+++ a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
@@ -48,7 +48,8 @@ static int lmv_numobd_seq_show(struct se
 
 	LASSERT(dev != NULL);
 	desc = &dev->u.lmv.desc;
-	return seq_printf(m, "%u\n", desc->ld_tgt_count);
+	seq_printf(m, "%u\n", desc->ld_tgt_count);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(lmv_numobd);
 
@@ -82,7 +83,8 @@ static int lmv_placement_seq_show(struct
 
 	LASSERT(dev != NULL);
 	lmv = &dev->u.lmv;
-	return seq_printf(m, "%s\n", placement_policy2name(lmv->lmv_placement));
+	seq_printf(m, "%s\n", placement_policy2name(lmv->lmv_placement));
+	return 0;
 }
 
 #define MAX_POLICY_STRING_SIZE 64
@@ -130,7 +132,8 @@ static int lmv_activeobd_seq_show(struct
 
 	LASSERT(dev != NULL);
 	desc = &dev->u.lmv.desc;
-	return seq_printf(m, "%u\n", desc->ld_active_tgt_count);
+	seq_printf(m, "%u\n", desc->ld_active_tgt_count);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(lmv_activeobd);
 
@@ -141,7 +144,8 @@ static int lmv_desc_uuid_seq_show(struct
 
 	LASSERT(dev != NULL);
 	lmv = &dev->u.lmv;
-	return seq_printf(m, "%s\n", lmv->desc.ld_uuid.uuid);
+	seq_printf(m, "%s\n", lmv->desc.ld_uuid.uuid);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(lmv_desc_uuid);
 
@@ -171,8 +175,10 @@ static int lmv_tgt_seq_show(struct seq_f
 
 	if (tgt == NULL)
 		return 0;
-	return seq_printf(p, "%d: %s %sACTIVE\n", tgt->ltd_idx,
-			  tgt->ltd_uuid.uuid, tgt->ltd_active ? "" : "IN");
+	seq_printf(p, "%d: %s %sACTIVE\n",
+		   tgt->ltd_idx, tgt->ltd_uuid.uuid,
+		   tgt->ltd_active ? "" : "IN");
+	return 0;
 }
 
 static struct seq_operations lmv_tgt_sops = {
diff -puN drivers/staging/lustre/lustre/lov/lproc_lov.c~staging-lustre-convert-return-seq_printf-uses drivers/staging/lustre/lustre/lov/lproc_lov.c
--- a/drivers/staging/lustre/lustre/lov/lproc_lov.c~staging-lustre-convert-return-seq_printf-uses
+++ a/drivers/staging/lustre/lustre/lov/lproc_lov.c
@@ -48,7 +48,8 @@ static int lov_stripesize_seq_show(struc
 
 	LASSERT(dev != NULL);
 	desc = &dev->u.lov.desc;
-	return seq_printf(m, "%llu\n", desc->ld_default_stripe_size);
+	seq_printf(m, "%llu\n", desc->ld_default_stripe_size);
+	return 0;
 }
 
 static ssize_t lov_stripesize_seq_write(struct file *file,
@@ -79,7 +80,8 @@ static int lov_stripeoffset_seq_show(str
 
 	LASSERT(dev != NULL);
 	desc = &dev->u.lov.desc;
-	return seq_printf(m, "%llu\n", desc->ld_default_stripe_offset);
+	seq_printf(m, "%llu\n", desc->ld_default_stripe_offset);
+	return 0;
 }
 
 static ssize_t lov_stripeoffset_seq_write(struct file *file,
@@ -109,7 +111,8 @@ static int lov_stripetype_seq_show(struc
 
 	LASSERT(dev != NULL);
 	desc = &dev->u.lov.desc;
-	return seq_printf(m, "%u\n", desc->ld_pattern);
+	seq_printf(m, "%u\n", desc->ld_pattern);
+	return 0;
 }
 
 static ssize_t lov_stripetype_seq_write(struct file *file,
@@ -139,8 +142,8 @@ static int lov_stripecount_seq_show(stru
 
 	LASSERT(dev != NULL);
 	desc = &dev->u.lov.desc;
-	return seq_printf(m, "%d\n",
-			(__s16)(desc->ld_default_stripe_count + 1) - 1);
+	seq_printf(m, "%d\n", (__s16)(desc->ld_default_stripe_count + 1) - 1);
+	return 0;
 }
 
 static ssize_t lov_stripecount_seq_write(struct file *file,
@@ -170,7 +173,8 @@ static int lov_numobd_seq_show(struct se
 
 	LASSERT(dev != NULL);
 	desc = &dev->u.lov.desc;
-	return seq_printf(m, "%u\n", desc->ld_tgt_count);
+	seq_printf(m, "%u\n", desc->ld_tgt_count);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(lov_numobd);
 
@@ -181,7 +185,8 @@ static int lov_activeobd_seq_show(struct
 
 	LASSERT(dev != NULL);
 	desc = &dev->u.lov.desc;
-	return seq_printf(m, "%u\n", desc->ld_active_tgt_count);
+	seq_printf(m, "%u\n", desc->ld_active_tgt_count);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(lov_activeobd);
 
@@ -192,7 +197,8 @@ static int lov_desc_uuid_seq_show(struct
 
 	LASSERT(dev != NULL);
 	lov = &dev->u.lov;
-	return seq_printf(m, "%s\n", lov->desc.ld_uuid.uuid);
+	seq_printf(m, "%s\n", lov->desc.ld_uuid.uuid);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(lov_desc_uuid);
 
@@ -228,9 +234,11 @@ static void *lov_tgt_seq_next(struct seq
 static int lov_tgt_seq_show(struct seq_file *p, void *v)
 {
 	struct lov_tgt_desc *tgt = v;
-	return seq_printf(p, "%d: %s %sACTIVE\n", tgt->ltd_index,
-			  obd_uuid2str(&tgt->ltd_uuid),
-			  tgt->ltd_active ? "" : "IN");
+
+	seq_printf(p, "%d: %s %sACTIVE\n",
+		   tgt->ltd_index, obd_uuid2str(&tgt->ltd_uuid),
+		   tgt->ltd_active ? "" : "IN");
+	return 0;
 }
 
 struct seq_operations lov_tgt_sops = {
diff -puN drivers/staging/lustre/lustre/obdclass/linux/linux-module.c~staging-lustre-convert-return-seq_printf-uses drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c~staging-lustre-convert-return-seq_printf-uses
+++ a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -219,21 +219,23 @@ struct miscdevice obd_psdev = {
 #if defined (CONFIG_PROC_FS)
 int obd_proc_version_seq_show(struct seq_file *m, void *v)
 {
-	return seq_printf(m, "lustre: %s\nkernel: %s\nbuild:  %s\n",
-			LUSTRE_VERSION_STRING, "patchless_client",
-			BUILD_VERSION);
+	seq_printf(m, "lustre: %s\nkernel: %s\nbuild:  %s\n",
+		   LUSTRE_VERSION_STRING, "patchless_client", BUILD_VERSION);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(obd_proc_version);
 
 int obd_proc_pinger_seq_show(struct seq_file *m, void *v)
 {
-	return seq_printf(m, "%s\n", "on");
+	seq_printf(m, "%s\n", "on");
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(obd_proc_pinger);
 
 static int obd_proc_health_seq_show(struct seq_file *m, void *v)
 {
-	int rc = 0, i;
+	bool healthy = true;
+	int i;
 
 	if (libcfs_catastrophe)
 		seq_printf(m, "LBUG\n");
@@ -255,25 +257,27 @@ static int obd_proc_health_seq_show(stru
 
 		if (obd_health_check(NULL, obd)) {
 			seq_printf(m, "device %s reported unhealthy\n",
-				      obd->obd_name);
-			rc++;
+				   obd->obd_name);
+			healthy = false;
 		}
 		class_decref(obd, __func__, current);
 		read_lock(&obd_dev_lock);
 	}
 	read_unlock(&obd_dev_lock);
 
-	if (rc == 0)
-		return seq_printf(m, "healthy\n");
+	if (healthy)
+		seq_puts(m, "healthy\n");
+	else
+		seq_puts(m, "NOT HEALTHY\n");
 
-	seq_printf(m, "NOT HEALTHY\n");
 	return 0;
 }
 LPROC_SEQ_FOPS_RO(obd_proc_health);
 
 static int obd_proc_jobid_var_seq_show(struct seq_file *m, void *v)
 {
-	return seq_printf(m, "%s\n", obd_jobid_var);
+	seq_printf(m, "%s\n", obd_jobid_var);
+	return 0;
 }
 
 static ssize_t obd_proc_jobid_var_seq_write(struct file *file,
@@ -299,7 +303,8 @@ LPROC_SEQ_FOPS(obd_proc_jobid_var);
 
 static int obd_proc_jobid_name_seq_show(struct seq_file *m, void *v)
 {
-	return seq_printf(m, "%s\n", obd_jobid_var);
+	seq_printf(m, "%s\n", obd_jobid_var);
+	return 0;
 }
 
 static ssize_t obd_proc_jobid_name_seq_write(struct file *file,
@@ -378,10 +383,11 @@ static int obd_device_list_seq_show(stru
 	else
 		status = "--";
 
-	return seq_printf(p, "%3d %s %s %s %s %d\n",
-			  (int)index, status, obd->obd_type->typ_name,
-			  obd->obd_name, obd->obd_uuid.uuid,
-			  atomic_read(&obd->obd_refcount));
+	seq_printf(p, "%3d %s %s %s %s %d\n",
+		   (int)index, status, obd->obd_type->typ_name,
+		   obd->obd_name, obd->obd_uuid.uuid,
+		   atomic_read(&obd->obd_refcount));
+	return 0;
 }
 
 struct seq_operations obd_device_list_sops = {
diff -puN drivers/staging/lustre/lustre/obdclass/lprocfs_status.c~staging-lustre-convert-return-seq_printf-uses drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c~staging-lustre-convert-return-seq_printf-uses
+++ a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -377,7 +377,8 @@ EXPORT_SYMBOL(lprocfs_register);
 /* Generic callbacks */
 int lprocfs_rd_uint(struct seq_file *m, void *data)
 {
-	return seq_printf(m, "%u\n", *(unsigned int *)data);
+	seq_printf(m, "%u\n", *(unsigned int *)data);
+	return 0;
 }
 EXPORT_SYMBOL(lprocfs_rd_uint);
 
@@ -403,7 +404,8 @@ EXPORT_SYMBOL(lprocfs_wr_uint);
 
 int lprocfs_rd_u64(struct seq_file *m, void *data)
 {
-	return seq_printf(m, "%llu\n", *(__u64 *)data);
+	seq_printf(m, "%llu\n", *(__u64 *)data);
+	return 0;
 }
 EXPORT_SYMBOL(lprocfs_rd_u64);
 
@@ -411,7 +413,8 @@ int lprocfs_rd_atomic(struct seq_file *m
 {
 	atomic_t *atom = data;
 	LASSERT(atom != NULL);
-	return seq_printf(m, "%d\n", atomic_read(atom));
+	seq_printf(m, "%d\n", atomic_read(atom));
+	return 0;
 }
 EXPORT_SYMBOL(lprocfs_rd_atomic);
 
@@ -439,7 +442,8 @@ int lprocfs_rd_uuid(struct seq_file *m,
 	struct obd_device *obd = data;
 
 	LASSERT(obd != NULL);
-	return seq_printf(m, "%s\n", obd->obd_uuid.uuid);
+	seq_printf(m, "%s\n", obd->obd_uuid.uuid);
+	return 0;
 }
 EXPORT_SYMBOL(lprocfs_rd_uuid);
 
@@ -448,7 +452,8 @@ int lprocfs_rd_name(struct seq_file *m,
 	struct obd_device *dev = data;
 
 	LASSERT(dev != NULL);
-	return seq_printf(m, "%s\n", dev->obd_name);
+	seq_printf(m, "%s\n", dev->obd_name);
+	return 0;
 }
 EXPORT_SYMBOL(lprocfs_rd_name);
 
@@ -924,7 +929,8 @@ int lprocfs_rd_num_exports(struct seq_fi
 	struct obd_device *obd = data;
 
 	LASSERT(obd != NULL);
-	return seq_printf(m, "%u\n", obd->obd_num_exports);
+	seq_printf(m, "%u\n", obd->obd_num_exports);
+	return 0;
 }
 EXPORT_SYMBOL(lprocfs_rd_num_exports);
 
@@ -933,7 +939,8 @@ int lprocfs_rd_numrefs(struct seq_file *
 	struct obd_type *class = (struct obd_type *) data;
 
 	LASSERT(class != NULL);
-	return seq_printf(m, "%d\n", class->typ_refcnt);
+	seq_printf(m, "%d\n", class->typ_refcnt);
+	return 0;
 }
 EXPORT_SYMBOL(lprocfs_rd_numrefs);
 
@@ -1606,8 +1613,9 @@ LPROC_SEQ_FOPS_RO(lproc_exp_hash);
 
 int lprocfs_nid_stats_clear_read(struct seq_file *m, void *data)
 {
-	return seq_printf(m, "%s\n",
-			  "Write into this file to clear all nid stats and stale nid entries");
+	seq_printf(m, "%s\n",
+		   "Write into this file to clear all nid stats and stale nid entries");
+	return 0;
 }
 EXPORT_SYMBOL(lprocfs_nid_stats_clear_read);
 
diff -puN drivers/staging/lustre/lustre/obdclass/lu_object.c~staging-lustre-convert-return-seq_printf-uses drivers/staging/lustre/lustre/obdclass/lu_object.c
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c~staging-lustre-convert-return-seq_printf-uses
+++ a/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -2014,18 +2014,19 @@ int lu_site_stats_print(const struct lu_
 	memset(&stats, 0, sizeof(stats));
 	lu_site_stats_get(s->ls_obj_hash, &stats, 1);
 
-	return seq_printf(m, "%d/%d %d/%d %d %d %d %d %d %d %d\n",
-			stats.lss_busy,
-			stats.lss_total,
-			stats.lss_populated,
-			CFS_HASH_NHLIST(s->ls_obj_hash),
-			stats.lss_max_search,
-			ls_stats_read(s->ls_stats, LU_SS_CREATED),
-			ls_stats_read(s->ls_stats, LU_SS_CACHE_HIT),
-			ls_stats_read(s->ls_stats, LU_SS_CACHE_MISS),
-			ls_stats_read(s->ls_stats, LU_SS_CACHE_RACE),
-			ls_stats_read(s->ls_stats, LU_SS_CACHE_DEATH_RACE),
-			ls_stats_read(s->ls_stats, LU_SS_LRU_PURGED));
+	seq_printf(m, "%d/%d %d/%d %d %d %d %d %d %d %d\n",
+		   stats.lss_busy,
+		   stats.lss_total,
+		   stats.lss_populated,
+		   CFS_HASH_NHLIST(s->ls_obj_hash),
+		   stats.lss_max_search,
+		   ls_stats_read(s->ls_stats, LU_SS_CREATED),
+		   ls_stats_read(s->ls_stats, LU_SS_CACHE_HIT),
+		   ls_stats_read(s->ls_stats, LU_SS_CACHE_MISS),
+		   ls_stats_read(s->ls_stats, LU_SS_CACHE_RACE),
+		   ls_stats_read(s->ls_stats, LU_SS_CACHE_DEATH_RACE),
+		   ls_stats_read(s->ls_stats, LU_SS_LRU_PURGED));
+	return 0;
 }
 EXPORT_SYMBOL(lu_site_stats_print);
 
diff -puN drivers/staging/lustre/lustre/osc/lproc_osc.c~staging-lustre-convert-return-seq_printf-uses drivers/staging/lustre/lustre/osc/lproc_osc.c
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c~staging-lustre-convert-return-seq_printf-uses
+++ a/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -289,8 +289,8 @@ static int osc_grant_shrink_interval_seq
 
 	if (obd == NULL)
 		return 0;
-	return seq_printf(m, "%d\n",
-			obd->u.cli.cl_grant_shrink_interval);
+	seq_printf(m, "%d\n", obd->u.cli.cl_grant_shrink_interval);
+	return 0;
 }
 
 static ssize_t osc_grant_shrink_interval_seq_write(struct file *file,
@@ -323,8 +323,8 @@ static int osc_checksum_seq_show(struct
 	if (obd == NULL)
 		return 0;
 
-	return seq_printf(m, "%d\n",
-			obd->u.cli.cl_checksum ? 1 : 0);
+	seq_printf(m, "%d\n", obd->u.cli.cl_checksum ? 1 : 0);
+	return 0;
 }
 
 static ssize_t osc_checksum_seq_write(struct file *file,
@@ -405,7 +405,8 @@ static int osc_resend_count_seq_show(str
 {
 	struct obd_device *obd = m->private;
 
-	return seq_printf(m, "%u\n", atomic_read(&obd->u.cli.cl_resends));
+	seq_printf(m, "%u\n", atomic_read(&obd->u.cli.cl_resends));
+	return 0;
 }
 
 static ssize_t osc_resend_count_seq_write(struct file *file,
@@ -433,7 +434,8 @@ static int osc_contention_seconds_seq_sh
 	struct obd_device *obd = m->private;
 	struct osc_device *od  = obd2osc_dev(obd);
 
-	return seq_printf(m, "%u\n", od->od_contention_time);
+	seq_printf(m, "%u\n", od->od_contention_time);
+	return 0;
 }
 
 static ssize_t osc_contention_seconds_seq_write(struct file *file,
@@ -453,7 +455,8 @@ static int osc_lockless_truncate_seq_sho
 	struct obd_device *obd = m->private;
 	struct osc_device *od  = obd2osc_dev(obd);
 
-	return seq_printf(m, "%u\n", od->od_lockless_truncate);
+	seq_printf(m, "%u\n", od->od_lockless_truncate);
+	return 0;
 }
 
 static ssize_t osc_lockless_truncate_seq_write(struct file *file,
@@ -471,8 +474,9 @@ LPROC_SEQ_FOPS(osc_lockless_truncate);
 static int osc_destroys_in_flight_seq_show(struct seq_file *m, void *v)
 {
 	struct obd_device *obd = m->private;
-	return seq_printf(m, "%u\n",
-			atomic_read(&obd->u.cli.cl_destroy_in_flight));
+
+	seq_printf(m, "%u\n", atomic_read(&obd->u.cli.cl_destroy_in_flight));
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(osc_destroys_in_flight);
 
diff -puN drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c~staging-lustre-convert-return-seq_printf-uses drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c~staging-lustre-convert-return-seq_printf-uses
+++ a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -267,7 +267,8 @@ ptlrpc_lprocfs_req_history_len_seq_show(
 	ptlrpc_service_for_each_part(svcpt, i, svc)
 		total += svcpt->scp_hist_nrqbds;
 
-	return seq_printf(m, "%d\n", total);
+	seq_printf(m, "%d\n", total);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(ptlrpc_lprocfs_req_history_len);
 
@@ -282,7 +283,8 @@ ptlrpc_lprocfs_req_history_max_seq_show(
 	ptlrpc_service_for_each_part(svcpt, i, svc)
 		total += svc->srv_hist_nrqbds_cpt_max;
 
-	return seq_printf(m, "%d\n", total);
+	seq_printf(m, "%d\n", total);
+	return 0;
 }
 
 static ssize_t
@@ -327,8 +329,8 @@ ptlrpc_lprocfs_threads_min_seq_show(stru
 {
 	struct ptlrpc_service *svc = m->private;
 
-	return seq_printf(m, "%d\n",
-			svc->srv_nthrs_cpt_init * svc->srv_ncpts);
+	seq_printf(m, "%d\n", svc->srv_nthrs_cpt_init * svc->srv_ncpts);
+	return 0;
 }
 
 static ssize_t
@@ -371,7 +373,8 @@ ptlrpc_lprocfs_threads_started_seq_show(
 	ptlrpc_service_for_each_part(svcpt, i, svc)
 		total += svcpt->scp_nthrs_running;
 
-	return seq_printf(m, "%d\n", total);
+	seq_printf(m, "%d\n", total);
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(ptlrpc_lprocfs_threads_started);
 
@@ -380,8 +383,8 @@ ptlrpc_lprocfs_threads_max_seq_show(stru
 {
 	struct ptlrpc_service *svc = m->private;
 
-	return seq_printf(m, "%d\n",
-			svc->srv_nthrs_cpt_limit * svc->srv_ncpts);
+	seq_printf(m, "%d\n", svc->srv_nthrs_cpt_limit * svc->srv_ncpts);
+	return 0;
 }
 
 static ssize_t
@@ -1026,7 +1029,8 @@ LPROC_SEQ_FOPS_RO(ptlrpc_lprocfs_timeout
 static int ptlrpc_lprocfs_hp_ratio_seq_show(struct seq_file *m, void *v)
 {
 	struct ptlrpc_service *svc = m->private;
-	return seq_printf(m, "%d", svc->srv_hpreq_ratio);
+	seq_printf(m, "%d", svc->srv_hpreq_ratio);
+	return 0;
 }
 
 static ssize_t ptlrpc_lprocfs_hp_ratio_seq_write(struct file *file,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch


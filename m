From: akpm@linux-foundation.org
Subject: [merged]
 staging-lustre-convert-remaining-uses-of-=-seq_printf.patch removed from
 -mm tree
Date: Wed, 11 Mar 2015 12:17:43 -0700
Message-ID: <550094d7.3zfQm8vaiJ55ruNb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbbCKTRo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 15:17:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, andreas.dilger@intel.com, gregkh@linuxfoundation.org, oleg.drokin@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: lustre: convert remaining uses of "= seq_printf(...)"
has been removed from the -mm tree.  Its filename was
     staging-lustre-convert-remaining-uses-of-=-seq_printf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: staging: lustre: convert remaining uses of "= seq_printf(...)"

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Convert the remaining uses by hand.

Miscellanea:

o Convert fixed string output to seq_puts

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/llite/lproc_llite.c       |   24 +-
 drivers/staging/lustre/lustre/obdclass/lprocfs_status.c |   84 ++++------
 2 files changed, 55 insertions(+), 53 deletions(-)

diff -puN drivers/staging/lustre/lustre/llite/lproc_llite.c~staging-lustre-convert-remaining-uses-of-=-seq_printf drivers/staging/lustre/lustre/llite/lproc_llite.c
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c~staging-lustre-convert-remaining-uses-of-=-seq_printf
+++ a/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -59,7 +59,7 @@ static int ll_blksize_seq_show(struct se
 				cfs_time_shift_64(-OBD_STATFS_CACHE_SECONDS),
 				OBD_STATFS_NODELAY);
 	if (!rc)
-	      rc = seq_printf(m, "%u\n", osfs.os_bsize);
+		seq_printf(m, "%u\n", osfs.os_bsize);
 
 	return rc;
 }
@@ -82,8 +82,9 @@ static int ll_kbytestotal_seq_show(struc
 		while (blk_size >>= 1)
 			result <<= 1;
 
-		rc = seq_printf(m, "%llu\n", result);
+		seq_printf(m, "%llu\n", result);
 	}
+
 	return rc;
 }
 LPROC_SEQ_FOPS_RO(ll_kbytestotal);
@@ -105,8 +106,9 @@ static int ll_kbytesfree_seq_show(struct
 		while (blk_size >>= 1)
 			result <<= 1;
 
-		rc = seq_printf(m, "%llu\n", result);
+		seq_printf(m, "%llu\n", result);
 	}
+
 	return rc;
 }
 LPROC_SEQ_FOPS_RO(ll_kbytesfree);
@@ -128,8 +130,9 @@ static int ll_kbytesavail_seq_show(struc
 		while (blk_size >>= 1)
 			result <<= 1;
 
-		rc = seq_printf(m, "%llu\n", result);
+		seq_printf(m, "%llu\n", result);
 	}
+
 	return rc;
 }
 LPROC_SEQ_FOPS_RO(ll_kbytesavail);
@@ -145,7 +148,8 @@ static int ll_filestotal_seq_show(struct
 				cfs_time_shift_64(-OBD_STATFS_CACHE_SECONDS),
 				OBD_STATFS_NODELAY);
 	if (!rc)
-		 rc = seq_printf(m, "%llu\n", osfs.os_files);
+		seq_printf(m, "%llu\n", osfs.os_files);
+
 	return rc;
 }
 LPROC_SEQ_FOPS_RO(ll_filestotal);
@@ -161,7 +165,8 @@ static int ll_filesfree_seq_show(struct
 				cfs_time_shift_64(-OBD_STATFS_CACHE_SECONDS),
 				OBD_STATFS_NODELAY);
 	if (!rc)
-		 rc = seq_printf(m, "%llu\n", osfs.os_ffree);
+		seq_printf(m, "%llu\n", osfs.os_ffree);
+
 	return rc;
 }
 LPROC_SEQ_FOPS_RO(ll_filesfree);
@@ -169,16 +174,15 @@ LPROC_SEQ_FOPS_RO(ll_filesfree);
 static int ll_client_type_seq_show(struct seq_file *m, void *v)
 {
 	struct ll_sb_info *sbi = ll_s2sbi((struct super_block *)m->private);
-	int rc;
 
 	LASSERT(sbi != NULL);
 
 	if (sbi->ll_flags & LL_SBI_RMT_CLIENT)
-		rc = seq_printf(m, "remote client\n");
+		seq_puts(m, "remote client\n");
 	else
-		rc = seq_printf(m, "local client\n");
+		seq_puts(m, "local client\n");
 
-	return rc;
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(ll_client_type);
 
diff -puN drivers/staging/lustre/lustre/obdclass/lprocfs_status.c~staging-lustre-convert-remaining-uses-of-=-seq_printf drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c~staging-lustre-convert-remaining-uses-of-=-seq_printf
+++ a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -465,7 +465,8 @@ int lprocfs_rd_blksize(struct seq_file *
 			    cfs_time_shift_64(-OBD_STATFS_CACHE_SECONDS),
 			    OBD_STATFS_NODELAY);
 	if (!rc)
-		rc = seq_printf(m, "%u\n", osfs.os_bsize);
+		seq_printf(m, "%u\n", osfs.os_bsize);
+
 	return rc;
 }
 EXPORT_SYMBOL(lprocfs_rd_blksize);
@@ -484,8 +485,9 @@ int lprocfs_rd_kbytestotal(struct seq_fi
 		while (blk_size >>= 1)
 			result <<= 1;
 
-		rc = seq_printf(m, "%llu\n", result);
+		seq_printf(m, "%llu\n", result);
 	}
+
 	return rc;
 }
 EXPORT_SYMBOL(lprocfs_rd_kbytestotal);
@@ -504,8 +506,9 @@ int lprocfs_rd_kbytesfree(struct seq_fil
 		while (blk_size >>= 1)
 			result <<= 1;
 
-		rc = seq_printf(m, "%llu\n", result);
+		seq_printf(m, "%llu\n", result);
 	}
+
 	return rc;
 }
 EXPORT_SYMBOL(lprocfs_rd_kbytesfree);
@@ -524,8 +527,9 @@ int lprocfs_rd_kbytesavail(struct seq_fi
 		while (blk_size >>= 1)
 			result <<= 1;
 
-		rc = seq_printf(m, "%llu\n", result);
+		seq_printf(m, "%llu\n", result);
 	}
+
 	return rc;
 }
 EXPORT_SYMBOL(lprocfs_rd_kbytesavail);
@@ -538,7 +542,7 @@ int lprocfs_rd_filestotal(struct seq_fil
 			    cfs_time_shift_64(-OBD_STATFS_CACHE_SECONDS),
 			    OBD_STATFS_NODELAY);
 	if (!rc)
-		rc = seq_printf(m, "%llu\n", osfs.os_files);
+		seq_printf(m, "%llu\n", osfs.os_files);
 
 	return rc;
 }
@@ -552,7 +556,8 @@ int lprocfs_rd_filesfree(struct seq_file
 			    cfs_time_shift_64(-OBD_STATFS_CACHE_SECONDS),
 			    OBD_STATFS_NODELAY);
 	if (!rc)
-		rc = seq_printf(m, "%llu\n", osfs.os_ffree);
+		seq_printf(m, "%llu\n", osfs.os_ffree);
+
 	return rc;
 }
 EXPORT_SYMBOL(lprocfs_rd_filesfree);
@@ -562,17 +567,18 @@ int lprocfs_rd_server_uuid(struct seq_fi
 	struct obd_device *obd = data;
 	struct obd_import *imp;
 	char *imp_state_name = NULL;
-	int rc = 0;
 
 	LASSERT(obd != NULL);
 	LPROCFS_CLIMP_CHECK(obd);
 	imp = obd->u.cli.cl_import;
 	imp_state_name = ptlrpc_import_state_name(imp->imp_state);
-	rc = seq_printf(m, "%s\t%s%s\n", obd2cli_tgt(obd), imp_state_name,
-			imp->imp_deactive ? "\tDEACTIVATED" : "");
+	seq_printf(m, "%s\t%s%s\n",
+		   obd2cli_tgt(obd), imp_state_name,
+		   imp->imp_deactive ? "\tDEACTIVATED" : "");
 
 	LPROCFS_CLIMP_EXIT(obd);
-	return rc;
+
+	return 0;
 }
 EXPORT_SYMBOL(lprocfs_rd_server_uuid);
 
@@ -580,19 +586,19 @@ int lprocfs_rd_conn_uuid(struct seq_file
 {
 	struct obd_device *obd = data;
 	struct ptlrpc_connection *conn;
-	int rc = 0;
 
 	LASSERT(obd != NULL);
 
 	LPROCFS_CLIMP_CHECK(obd);
 	conn = obd->u.cli.cl_import->imp_connection;
 	if (conn && obd->u.cli.cl_import)
-		rc = seq_printf(m, "%s\n", conn->c_remote_uuid.uuid);
+		seq_printf(m, "%s\n", conn->c_remote_uuid.uuid);
 	else
-		rc = seq_printf(m, "%s\n", "<none>");
+		seq_puts(m, "<none>\n");
 
 	LPROCFS_CLIMP_EXIT(obd);
-	return rc;
+
+	return 0;
 }
 EXPORT_SYMBOL(lprocfs_rd_conn_uuid);
 
@@ -1207,41 +1213,33 @@ static int lprocfs_stats_seq_show(struct
 	struct lprocfs_counter_header   *hdr;
 	struct lprocfs_counter           ctr;
 	int                              idx    = *(loff_t *)v;
-	int                              rc     = 0;
 
 	if (idx == 0) {
 		struct timeval now;
 		do_gettimeofday(&now);
-		rc = seq_printf(p, "%-25s %lu.%lu secs.usecs\n",
-				"snapshot_time", now.tv_sec, (unsigned long)now.tv_usec);
-		if (rc < 0)
-			return rc;
+		seq_printf(p, "%-25s %lu.%lu secs.usecs\n",
+			   "snapshot_time",
+			   now.tv_sec, (unsigned long)now.tv_usec);
 	}
+
 	hdr = &stats->ls_cnt_header[idx];
 	lprocfs_stats_collect(stats, idx, &ctr);
 
-	if (ctr.lc_count == 0)
-		goto out;
-
-	rc = seq_printf(p, "%-25s %lld samples [%s]", hdr->lc_name,
-			ctr.lc_count, hdr->lc_units);
-
-	if (rc < 0)
-		goto out;
+	if (ctr.lc_count != 0) {
+		seq_printf(p, "%-25s %lld samples [%s]",
+			   hdr->lc_name, ctr.lc_count, hdr->lc_units);
+
+		if ((hdr->lc_config & LPROCFS_CNTR_AVGMINMAX) &&
+		    (ctr.lc_count > 0)) {
+			seq_printf(p, " %lld %lld %lld",
+				   ctr.lc_min, ctr.lc_max, ctr.lc_sum);
+			if (hdr->lc_config & LPROCFS_CNTR_STDDEV)
+				seq_printf(p, " %lld", ctr.lc_sumsquare);
+		}
+		seq_putc(p, '\n');
+	}
 
-	if ((hdr->lc_config & LPROCFS_CNTR_AVGMINMAX) && (ctr.lc_count > 0)) {
-		rc = seq_printf(p, " %lld %lld %lld",
-				ctr.lc_min, ctr.lc_max, ctr.lc_sum);
-		if (rc < 0)
-			goto out;
-		if (hdr->lc_config & LPROCFS_CNTR_STDDEV)
-			rc = seq_printf(p, " %lld", ctr.lc_sumsquare);
-		if (rc < 0)
-			goto out;
-	}
-	rc = seq_printf(p, "\n");
-out:
-	return (rc < 0) ? rc : 0;
+	return 0;
 }
 
 static const struct seq_operations lprocfs_stats_seq_sops = {
@@ -2049,12 +2047,12 @@ int lprocfs_obd_rd_max_pages_per_rpc(str
 {
 	struct obd_device *dev = data;
 	struct client_obd *cli = &dev->u.cli;
-	int rc;
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
-	rc = seq_printf(m, "%d\n", cli->cl_max_pages_per_rpc);
+	seq_printf(m, "%d\n", cli->cl_max_pages_per_rpc);
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
-	return rc;
+
+	return 0;
 }
 EXPORT_SYMBOL(lprocfs_obd_rd_max_pages_per_rpc);
 
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


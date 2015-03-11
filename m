From: akpm@linux-foundation.org
Subject: [merged] staging-lustre-convert-uses-of-int-rc-=-seq_printf.patch removed from -mm tree
Date: Wed, 11 Mar 2015 12:17:41 -0700
Message-ID: <550094d5.CJ8TgCCIReZHEeeu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbbCKTRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 15:17:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, andreas.dilger@intel.com, gregkh@linuxfoundation.org, oleg.drokin@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: lustre: convert uses of "int rc = seq_printf(...)"
has been removed from the -mm tree.  Its filename was
     staging-lustre-convert-uses-of-int-rc-=-seq_printf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: staging: lustre: convert uses of "int rc = seq_printf(...)"

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Convert these uses to:

	seq_printf(seq, ...);

	return 0;

Done via cocci script:

@@
struct seq_file *seq;
int i;
@@
-	i = seq_printf(seq,
+	seq_printf(seq,
		   ...);
	...
-	return i;
+	return 0;

@@
struct seq_file *seq;
int i;
@@
-	i = 0;
-	i += seq_printf(seq,
+	seq_printf(seq,
	           ...);
	...
-	return i;
+	return 0;

With some additional reformatting and typing post conversion
to remove the now unnecessary "int i;" declaration.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/fid/lproc_fid.c       |   23 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c   |    5 
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c       |    6 
 drivers/staging/lustre/lustre/osc/lproc_osc.c       |   45 ++---
 drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c |    5 
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c     |   82 ++++------
 6 files changed, 79 insertions(+), 87 deletions(-)

diff -puN drivers/staging/lustre/lustre/fid/lproc_fid.c~staging-lustre-convert-uses-of-int-rc-=-seq_printf drivers/staging/lustre/lustre/fid/lproc_fid.c
--- a/drivers/staging/lustre/lustre/fid/lproc_fid.c~staging-lustre-convert-uses-of-int-rc-=-seq_printf
+++ a/drivers/staging/lustre/lustre/fid/lproc_fid.c
@@ -120,15 +120,14 @@ static int
 lprocfs_fid_space_seq_show(struct seq_file *m, void *unused)
 {
 	struct lu_client_seq *seq = (struct lu_client_seq *)m->private;
-	int rc;
 
 	LASSERT(seq != NULL);
 
 	mutex_lock(&seq->lcs_mutex);
-	rc = seq_printf(m, "[%#llx - %#llx]:%x:%s\n", PRANGE(&seq->lcs_space));
+	seq_printf(m, "[%#llx - %#llx]:%x:%s\n", PRANGE(&seq->lcs_space));
 	mutex_unlock(&seq->lcs_mutex);
 
-	return rc;
+	return 0;
 }
 
 static ssize_t lprocfs_fid_width_seq_write(struct file *file,
@@ -170,30 +169,28 @@ static int
 lprocfs_fid_width_seq_show(struct seq_file *m, void *unused)
 {
 	struct lu_client_seq *seq = (struct lu_client_seq *)m->private;
-	int rc;
 
 	LASSERT(seq != NULL);
 
 	mutex_lock(&seq->lcs_mutex);
-	rc = seq_printf(m, "%llu\n", seq->lcs_width);
+	seq_printf(m, "%llu\n", seq->lcs_width);
 	mutex_unlock(&seq->lcs_mutex);
 
-	return rc;
+	return 0;
 }
 
 static int
 lprocfs_fid_fid_seq_show(struct seq_file *m, void *unused)
 {
 	struct lu_client_seq *seq = (struct lu_client_seq *)m->private;
-	int rc;
 
 	LASSERT(seq != NULL);
 
 	mutex_lock(&seq->lcs_mutex);
-	rc = seq_printf(m, DFID"\n", PFID(&seq->lcs_fid));
+	seq_printf(m, DFID"\n", PFID(&seq->lcs_fid));
 	mutex_unlock(&seq->lcs_mutex);
 
-	return rc;
+	return 0;
 }
 
 static int
@@ -201,17 +198,17 @@ lprocfs_fid_server_seq_show(struct seq_f
 {
 	struct lu_client_seq *seq = (struct lu_client_seq *)m->private;
 	struct client_obd *cli;
-	int rc;
 
 	LASSERT(seq != NULL);
 
 	if (seq->lcs_exp != NULL) {
 		cli = &seq->lcs_exp->exp_obd->u.cli;
-		rc = seq_printf(m, "%s\n", cli->cl_target_uuid.uuid);
+		seq_printf(m, "%s\n", cli->cl_target_uuid.uuid);
 	} else {
-		rc = seq_printf(m, "%s\n", seq->lcs_srv->lss_name);
+		seq_printf(m, "%s\n", seq->lcs_srv->lss_name);
 	}
-	return rc;
+
+	return 0;
 }
 
 LPROC_SEQ_FOPS(lprocfs_fid_space);
diff -puN drivers/staging/lustre/lustre/llite/lproc_llite.c~staging-lustre-convert-uses-of-int-rc-=-seq_printf drivers/staging/lustre/lustre/llite/lproc_llite.c
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c~staging-lustre-convert-uses-of-int-rc-=-seq_printf
+++ a/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -799,11 +799,10 @@ static int ll_xattr_cache_seq_show(struc
 {
 	struct super_block *sb = m->private;
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
-	int rc;
 
-	rc = seq_printf(m, "%u\n", sbi->ll_xattr_cache_enabled);
+	seq_printf(m, "%u\n", sbi->ll_xattr_cache_enabled);
 
-	return rc;
+	return 0;
 }
 
 static ssize_t ll_xattr_cache_seq_write(struct file *file,
diff -puN drivers/staging/lustre/lustre/mdc/lproc_mdc.c~staging-lustre-convert-uses-of-int-rc-=-seq_printf drivers/staging/lustre/lustre/mdc/lproc_mdc.c
--- a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c~staging-lustre-convert-uses-of-int-rc-=-seq_printf
+++ a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
@@ -43,12 +43,12 @@ static int mdc_max_rpcs_in_flight_seq_sh
 {
 	struct obd_device *dev = m->private;
 	struct client_obd *cli = &dev->u.cli;
-	int rc;
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
-	rc = seq_printf(m, "%u\n", cli->cl_max_rpcs_in_flight);
+	seq_printf(m, "%u\n", cli->cl_max_rpcs_in_flight);
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
-	return rc;
+
+	return 0;
 }
 
 static ssize_t mdc_max_rpcs_in_flight_seq_write(struct file *file,
diff -puN drivers/staging/lustre/lustre/osc/lproc_osc.c~staging-lustre-convert-uses-of-int-rc-=-seq_printf drivers/staging/lustre/lustre/osc/lproc_osc.c
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c~staging-lustre-convert-uses-of-int-rc-=-seq_printf
+++ a/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -45,12 +45,12 @@
 static int osc_active_seq_show(struct seq_file *m, void *v)
 {
 	struct obd_device *dev = m->private;
-	int rc;
 
 	LPROCFS_CLIMP_CHECK(dev);
-	rc = seq_printf(m, "%d\n", !dev->u.cli.cl_import->imp_deactive);
+	seq_printf(m, "%d\n", !dev->u.cli.cl_import->imp_deactive);
 	LPROCFS_CLIMP_EXIT(dev);
-	return rc;
+
+	return 0;
 }
 
 static ssize_t osc_active_seq_write(struct file *file,
@@ -80,12 +80,12 @@ static int osc_max_rpcs_in_flight_seq_sh
 {
 	struct obd_device *dev = m->private;
 	struct client_obd *cli = &dev->u.cli;
-	int rc;
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
-	rc = seq_printf(m, "%u\n", cli->cl_max_rpcs_in_flight);
+	seq_printf(m, "%u\n", cli->cl_max_rpcs_in_flight);
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
-	return rc;
+
+	return 0;
 }
 
 static ssize_t osc_max_rpcs_in_flight_seq_write(struct file *file,
@@ -164,16 +164,15 @@ static int osc_cached_mb_seq_show(struct
 	struct obd_device *dev = m->private;
 	struct client_obd *cli = &dev->u.cli;
 	int shift = 20 - PAGE_CACHE_SHIFT;
-	int rc;
 
-	rc = seq_printf(m,
-		      "used_mb: %d\n"
-		      "busy_cnt: %d\n",
-		      (atomic_read(&cli->cl_lru_in_list) +
-			atomic_read(&cli->cl_lru_busy)) >> shift,
-		      atomic_read(&cli->cl_lru_busy));
+	seq_printf(m,
+		   "used_mb: %d\n"
+		   "busy_cnt: %d\n",
+		   (atomic_read(&cli->cl_lru_in_list) +
+		    atomic_read(&cli->cl_lru_busy)) >> shift,
+		   atomic_read(&cli->cl_lru_busy));
 
-	return rc;
+	return 0;
 }
 
 /* shrink the number of caching pages to a specific number */
@@ -215,12 +214,12 @@ static int osc_cur_dirty_bytes_seq_show(
 {
 	struct obd_device *dev = m->private;
 	struct client_obd *cli = &dev->u.cli;
-	int rc;
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
-	rc = seq_printf(m, "%lu\n", cli->cl_dirty);
+	seq_printf(m, "%lu\n", cli->cl_dirty);
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
-	return rc;
+
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(osc_cur_dirty_bytes);
 
@@ -228,12 +227,12 @@ static int osc_cur_grant_bytes_seq_show(
 {
 	struct obd_device *dev = m->private;
 	struct client_obd *cli = &dev->u.cli;
-	int rc;
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
-	rc = seq_printf(m, "%lu\n", cli->cl_avail_grant);
+	seq_printf(m, "%lu\n", cli->cl_avail_grant);
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
-	return rc;
+
+	return 0;
 }
 
 static ssize_t osc_cur_grant_bytes_seq_write(struct file *file,
@@ -274,12 +273,12 @@ static int osc_cur_lost_grant_bytes_seq_
 {
 	struct obd_device *dev = m->private;
 	struct client_obd *cli = &dev->u.cli;
-	int rc;
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
-	rc = seq_printf(m, "%lu\n", cli->cl_lost_grant);
+	seq_printf(m, "%lu\n", cli->cl_lost_grant);
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
-	return rc;
+
+	return 0;
 }
 LPROC_SEQ_FOPS_RO(osc_cur_lost_grant_bytes);
 
diff -puN drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c~staging-lustre-convert-uses-of-int-rc-=-seq_printf drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c~staging-lustre-convert-uses-of-int-rc-=-seq_printf
+++ a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -1328,13 +1328,12 @@ int lprocfs_rd_pinger_recov(struct seq_f
 {
 	struct obd_device *obd = m->private;
 	struct obd_import *imp = obd->u.cli.cl_import;
-	int rc;
 
 	LPROCFS_CLIMP_CHECK(obd);
-	rc = seq_printf(m, "%d\n", !imp->imp_no_pinger_recover);
+	seq_printf(m, "%d\n", !imp->imp_no_pinger_recover);
 	LPROCFS_CLIMP_EXIT(obd);
 
-	return rc;
+	return 0;
 }
 EXPORT_SYMBOL(lprocfs_rd_pinger_recov);
 
diff -puN drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c~staging-lustre-convert-uses-of-int-rc-=-seq_printf drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c~staging-lustre-convert-uses-of-int-rc-=-seq_printf
+++ a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -125,52 +125,50 @@ static struct ptlrpc_enc_page_pool {
  */
 int sptlrpc_proc_enc_pool_seq_show(struct seq_file *m, void *v)
 {
-	int     rc;
-
 	spin_lock(&page_pools.epp_lock);
 
-	rc = seq_printf(m,
-		      "physical pages:	  %lu\n"
-		      "pages per pool:	  %lu\n"
-		      "max pages:	       %lu\n"
-		      "max pools:	       %u\n"
-		      "total pages:	     %lu\n"
-		      "total free:	      %lu\n"
-		      "idle index:	      %lu/100\n"
-		      "last shrink:	     %lds\n"
-		      "last access:	     %lds\n"
-		      "max pages reached:       %lu\n"
-		      "grows:		   %u\n"
-		      "grows failure:	   %u\n"
-		      "shrinks:		 %u\n"
-		      "cache access:	    %lu\n"
-		      "cache missing:	   %lu\n"
-		      "low free mark:	   %lu\n"
-		      "max waitqueue depth:     %u\n"
-		      "max wait time:	   "CFS_TIME_T"/%u\n"
-		      ,
-		      totalram_pages,
-		      PAGES_PER_POOL,
-		      page_pools.epp_max_pages,
-		      page_pools.epp_max_pools,
-		      page_pools.epp_total_pages,
-		      page_pools.epp_free_pages,
-		      page_pools.epp_idle_idx,
-		      get_seconds() - page_pools.epp_last_shrink,
-		      get_seconds() - page_pools.epp_last_access,
-		      page_pools.epp_st_max_pages,
-		      page_pools.epp_st_grows,
-		      page_pools.epp_st_grow_fails,
-		      page_pools.epp_st_shrinks,
-		      page_pools.epp_st_access,
-		      page_pools.epp_st_missings,
-		      page_pools.epp_st_lowfree,
-		      page_pools.epp_st_max_wqlen,
-		      page_pools.epp_st_max_wait, HZ
-		     );
+	seq_printf(m,
+		   "physical pages:	  %lu\n"
+		   "pages per pool:	  %lu\n"
+		   "max pages:	       %lu\n"
+		   "max pools:	       %u\n"
+		   "total pages:	     %lu\n"
+		   "total free:	      %lu\n"
+		   "idle index:	      %lu/100\n"
+		   "last shrink:	     %lds\n"
+		   "last access:	     %lds\n"
+		   "max pages reached:       %lu\n"
+		   "grows:		   %u\n"
+		   "grows failure:	   %u\n"
+		   "shrinks:		 %u\n"
+		   "cache access:	    %lu\n"
+		   "cache missing:	   %lu\n"
+		   "low free mark:	   %lu\n"
+		   "max waitqueue depth:     %u\n"
+		   "max wait time:	   " CFS_TIME_T "/%u\n",
+		   totalram_pages,
+		   PAGES_PER_POOL,
+		   page_pools.epp_max_pages,
+		   page_pools.epp_max_pools,
+		   page_pools.epp_total_pages,
+		   page_pools.epp_free_pages,
+		   page_pools.epp_idle_idx,
+		   get_seconds() - page_pools.epp_last_shrink,
+		   get_seconds() - page_pools.epp_last_access,
+		   page_pools.epp_st_max_pages,
+		   page_pools.epp_st_grows,
+		   page_pools.epp_st_grow_fails,
+		   page_pools.epp_st_shrinks,
+		   page_pools.epp_st_access,
+		   page_pools.epp_st_missings,
+		   page_pools.epp_st_lowfree,
+		   page_pools.epp_st_max_wqlen,
+		   page_pools.epp_st_max_wait,
+		   HZ);
 
 	spin_unlock(&page_pools.epp_lock);
-	return rc;
+
+	return 0;
 }
 
 static void enc_pools_release_free_pages(long npages)
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


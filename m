From: akpm@linux-foundation.org
Subject: + fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch added
 to -mm tree
Date: Thu, 06 Jun 2013 15:04:27 -0700
Message-ID: <51b1076b.E+cQ/bogtMlVZ2iX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab3FFWE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 18:04:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com, akpm@linux-foundation.org

Subject: + fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch added to -mm tree
To: akpm@linux-foundation.org,dchinner@redhat.com,glommer@openvz.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 15:04:27 -0700


The patch titled
     Subject: fs-convert-fs-shrinkers-to-new-scan-count-api-fix
has been added to the -mm tree.  Its filename is
     fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-convert-fs-shrinkers-to-new-scan-count-api-fix

fix warnings

Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/extents_status.c |   17 ++++++++++-------
 fs/gfs2/glock.c          |    8 ++++----
 fs/gfs2/quota.c          |    6 ++++--
 fs/gfs2/quota.h          |    8 ++++----
 fs/mbcache.c             |    8 ++++----
 fs/nfs/dir.c             |    4 ++--
 fs/nfs/internal.h        |    8 ++++----
 fs/nfsd/nfscache.c       |   17 +++++++++--------
 fs/quota/dquot.c         |    6 +++---
 fs/ubifs/shrinker.c      |   15 +++++++++------
 fs/ubifs/ubifs.h         |    6 ++++--
 11 files changed, 57 insertions(+), 46 deletions(-)

diff -puN fs/ext4/extents_status.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix fs/ext4/extents_status.c
--- a/fs/ext4/extents_status.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix
+++ a/fs/ext4/extents_status.c
@@ -878,26 +878,29 @@ int ext4_es_zeroout(struct inode *inode,
 				     EXTENT_STATUS_WRITTEN);
 }
 
-
-static long ext4_es_count(struct shrinker *shrink, struct shrink_control *sc)
+static unsigned long ext4_es_count(struct shrinker *shrink,
+				   struct shrink_control *sc)
 {
-	long nr;
-	struct ext4_sb_info *sbi = container_of(shrink,
-					struct ext4_sb_info, s_es_shrinker);
+	unsigned long nr;
+	struct ext4_sb_info *sbi;
+
+	sbi = container_of(shrink, struct ext4_sb_info, s_es_shrinker);
 
 	nr = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
 	trace_ext4_es_shrink_enter(sbi->s_sb, sc->nr_to_scan, nr);
 	return nr;
 }
 
-static long ext4_es_scan(struct shrinker *shrink, struct shrink_control *sc)
+static unsigned long ext4_es_scan(struct shrinker *shrink,
+				  struct shrink_control *sc)
 {
 	struct ext4_sb_info *sbi = container_of(shrink,
 					struct ext4_sb_info, s_es_shrinker);
 	struct ext4_inode_info *ei;
 	struct list_head *cur, *tmp, scanned;
 	int nr_to_scan = sc->nr_to_scan;
-	int ret = 0, nr_shrunk = 0;
+	int ret = 0;
+	unsigned long nr_shrunk = 0;
 
 	INIT_LIST_HEAD(&scanned);
 
diff -puN fs/gfs2/glock.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix fs/gfs2/glock.c
--- a/fs/gfs2/glock.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix
+++ a/fs/gfs2/glock.c
@@ -1457,16 +1457,16 @@ static long gfs2_scan_glock_lru(int nr)
 	return freed;
 }
 
-static long gfs2_glock_shrink_scan(struct shrinker *shrink,
-				   struct shrink_control *sc)
+static unsigned long gfs2_glock_shrink_scan(struct shrinker *shrink,
+					    struct shrink_control *sc)
 {
 	if (!(sc->gfp_mask & __GFP_FS))
 		return SHRINK_STOP;
 	return gfs2_scan_glock_lru(sc->nr_to_scan);
 }
 
-static long gfs2_glock_shrink_count(struct shrinker *shrink,
-				    struct shrink_control *sc)
+static unsigned long gfs2_glock_shrink_count(struct shrinker *shrink,
+					     struct shrink_control *sc)
 {
 	return vfs_pressure_ratio(atomic_read(&lru_count));
 }
diff -puN fs/gfs2/quota.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix fs/gfs2/quota.c
--- a/fs/gfs2/quota.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix
+++ a/fs/gfs2/quota.c
@@ -75,7 +75,8 @@ static LIST_HEAD(qd_lru_list);
 static atomic_t qd_lru_count = ATOMIC_INIT(0);
 static DEFINE_SPINLOCK(qd_lru_lock);
 
-long gfs2_qd_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
+unsigned long gfs2_qd_shrink_scan(struct shrinker *shrink,
+				  struct shrink_control *sc)
 {
 	struct gfs2_quota_data *qd;
 	struct gfs2_sbd *sdp;
@@ -114,7 +115,8 @@ long gfs2_qd_shrink_scan(struct shrinker
 	return freed;
 }
 
-long gfs2_qd_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
+unsigned long gfs2_qd_shrink_count(struct shrinker *shrink,
+				   struct shrink_control *sc)
 {
 	return vfs_pressure_ratio(atomic_read(&qd_lru_count));
 }
diff -puN fs/gfs2/quota.h~fs-convert-fs-shrinkers-to-new-scan-count-api-fix fs/gfs2/quota.h
--- a/fs/gfs2/quota.h~fs-convert-fs-shrinkers-to-new-scan-count-api-fix
+++ a/fs/gfs2/quota.h
@@ -53,10 +53,10 @@ static inline int gfs2_quota_lock_check(
 	return ret;
 }
 
-extern long gfs2_qd_shrink_count(struct shrinker *shrink,
-				 struct shrink_control *sc);
-extern long gfs2_qd_shrink_scan(struct shrinker *shrink,
-				 struct shrink_control *sc);
+extern unsigned long gfs2_qd_shrink_count(struct shrinker *shrink,
+					  struct shrink_control *sc);
+extern unsigned long gfs2_qd_shrink_scan(struct shrinker *shrink,
+					 struct shrink_control *sc);
 extern const struct quotactl_ops gfs2_quotactl_ops;
 
 #endif /* __QUOTA_DOT_H__ */
diff -puN fs/mbcache.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix fs/mbcache.c
--- a/fs/mbcache.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix
+++ a/fs/mbcache.c
@@ -149,14 +149,14 @@ forget:
  *
  * Returns the number of objects freed.
  */
-static long
+static unsigned long
 mb_cache_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	LIST_HEAD(free_list);
 	struct mb_cache_entry *entry, *tmp;
 	int nr_to_scan = sc->nr_to_scan;
 	gfp_t gfp_mask = sc->gfp_mask;
-	long freed = 0;
+	unsigned long freed = 0;
 
 	mb_debug("trying to free %d entries", nr_to_scan);
 	spin_lock(&mb_cache_spinlock);
@@ -175,11 +175,11 @@ mb_cache_shrink_scan(struct shrinker *sh
 	return freed;
 }
 
-static long
+static unsigned long
 mb_cache_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct mb_cache *cache;
-	long count = 0;
+	unsigned long count = 0;
 
 	spin_lock(&mb_cache_spinlock);
 	list_for_each_entry(cache, &mb_cache_list, c_cache_list) {
diff -puN fs/nfs/dir.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix fs/nfs/dir.c
--- a/fs/nfs/dir.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix
+++ a/fs/nfs/dir.c
@@ -1964,7 +1964,7 @@ static void nfs_access_free_list(struct
 	}
 }
 
-long
+unsigned long
 nfs_access_cache_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	LIST_HEAD(head);
@@ -2009,7 +2009,7 @@ remove_lru_entry:
 	return freed;
 }
 
-long
+unsigned long
 nfs_access_cache_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	return vfs_pressure_ratio(atomic_long_read(&nfs_access_nr_entries));
diff -puN fs/nfs/internal.h~fs-convert-fs-shrinkers-to-new-scan-count-api-fix fs/nfs/internal.h
--- a/fs/nfs/internal.h~fs-convert-fs-shrinkers-to-new-scan-count-api-fix
+++ a/fs/nfs/internal.h
@@ -269,10 +269,10 @@ extern struct nfs_client *nfs_init_clien
 			   const char *ip_addr, rpc_authflavor_t authflavour);
 
 /* dir.c */
-extern long nfs_access_cache_count(struct shrinker *shrink,
-					struct shrink_control *sc);
-extern long nfs_access_cache_scan(struct shrinker *shrink,
-					struct shrink_control *sc);
+extern unsigned long nfs_access_cache_count(struct shrinker *shrink,
+					    struct shrink_control *sc);
+extern unsigned long nfs_access_cache_scan(struct shrinker *shrink,
+					   struct shrink_control *sc);
 struct dentry *nfs_lookup(struct inode *, struct dentry *, unsigned int);
 int nfs_create(struct inode *, struct dentry *, umode_t, bool);
 int nfs_mkdir(struct inode *, struct dentry *, umode_t);
diff -puN fs/nfsd/nfscache.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix fs/nfsd/nfscache.c
--- a/fs/nfsd/nfscache.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix
+++ a/fs/nfsd/nfscache.c
@@ -59,10 +59,10 @@ static unsigned int		longest_chain_cache
 
 static int	nfsd_cache_append(struct svc_rqst *rqstp, struct kvec *vec);
 static void	cache_cleaner_func(struct work_struct *unused);
-static long	nfsd_reply_cache_count(struct shrinker *shrink,
-				       struct shrink_control *sc);
-static long	nfsd_reply_cache_scan(struct shrinker *shrink,
-				      struct shrink_control *sc);
+static unsigned long nfsd_reply_cache_count(struct shrinker *shrink,
+					    struct shrink_control *sc);
+static unsigned long nfsd_reply_cache_scan(struct shrinker *shrink,
+					   struct shrink_control *sc);
 
 static struct shrinker nfsd_reply_cache_shrinker = {
 	.scan_objects = nfsd_reply_cache_scan,
@@ -270,10 +270,10 @@ cache_cleaner_func(struct work_struct *u
 	spin_unlock(&cache_lock);
 }
 
-static long
+static unsigned long
 nfsd_reply_cache_count(struct shrinker *shrink, struct shrink_control *sc)
 {
-	long num;
+	unsigned long num;
 
 	spin_lock(&cache_lock);
 	num = num_drc_entries;
@@ -282,10 +282,11 @@ nfsd_reply_cache_count(struct shrinker *
 	return num;
 }
 
-static long
+static unsigned long
 nfsd_reply_cache_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
-	long freed;
+	unsigned long freed;
+
 	spin_lock(&cache_lock);
 	freed = prune_cache_entries();
 	spin_unlock(&cache_lock);
diff -puN fs/quota/dquot.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix fs/quota/dquot.c
--- a/fs/quota/dquot.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix
+++ a/fs/quota/dquot.c
@@ -687,12 +687,12 @@ int dquot_quota_sync(struct super_block
 }
 EXPORT_SYMBOL(dquot_quota_sync);
 
-static long
+static unsigned long
 dqcache_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct list_head *head;
 	struct dquot *dquot;
-	long freed = 0;
+	unsigned long freed = 0;
 
 	head = free_dquots.prev;
 	while (head != &free_dquots && sc->nr_to_scan) {
@@ -708,7 +708,7 @@ dqcache_shrink_scan(struct shrinker *shr
 	return freed;
 }
 
-static long
+static unsigned long
 dqcache_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	return vfs_pressure_ratio(
diff -puN fs/ubifs/shrinker.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix fs/ubifs/shrinker.c
--- a/fs/ubifs/shrinker.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix
+++ a/fs/ubifs/shrinker.c
@@ -277,9 +277,10 @@ static int kick_a_thread(void)
 	return 0;
 }
 
-long ubifs_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
+unsigned long ubifs_shrink_count(struct shrinker *shrink,
+				 struct shrink_control *sc)
 {
-	long clean_zn_cnt = atomic_long_read(&ubifs_clean_zn_cnt);
+	unsigned long clean_zn_cnt = atomic_long_read(&ubifs_clean_zn_cnt);
 
 	/*
 	 * Due to the way UBIFS updates the clean znode counter it may
@@ -288,10 +289,12 @@ long ubifs_shrink_count(struct shrinker
 	return clean_zn_cnt >= 0 ? clean_zn_cnt : 1;
 }
 
-long ubifs_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
+unsigned long ubifs_shrink_scan(struct shrinker *shrink,
+				struct shrink_control *sc)
 {
-	int nr = sc->nr_to_scan;
-	int freed, contention = 0;
+	unsigned long nr = sc->nr_to_scan;
+	int contention = 0;
+	unsigned long freed;
 	long clean_zn_cnt = atomic_long_read(&ubifs_clean_zn_cnt);
 
 	if (!clean_zn_cnt) {
@@ -324,6 +327,6 @@ long ubifs_shrink_scan(struct shrinker *
 	}
 
 out:
-	dbg_tnc("%d znodes were freed, requested %d", freed, nr);
+	dbg_tnc("%lu znodes were freed, requested %lu", freed, nr);
 	return freed;
 }
diff -puN fs/ubifs/ubifs.h~fs-convert-fs-shrinkers-to-new-scan-count-api-fix fs/ubifs/ubifs.h
--- a/fs/ubifs/ubifs.h~fs-convert-fs-shrinkers-to-new-scan-count-api-fix
+++ a/fs/ubifs/ubifs.h
@@ -1624,8 +1624,10 @@ int ubifs_tnc_start_commit(struct ubifs_
 int ubifs_tnc_end_commit(struct ubifs_info *c);
 
 /* shrinker.c */
-long ubifs_shrink_scan(struct shrinker *shrink, struct shrink_control *sc);
-long ubifs_shrink_count(struct shrinker *shrink, struct shrink_control *sc);
+unsigned long ubifs_shrink_scan(struct shrinker *shrink,
+				struct shrink_control *sc);
+unsigned long ubifs_shrink_count(struct shrinker *shrink,
+				 struct shrink_control *sc);
 
 /* commit.c */
 int ubifs_bg_thread(void *info);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel-fix.patch
drivers-base-cpuc-fix-maxcpus-boot-option-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


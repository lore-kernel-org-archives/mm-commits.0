From: akpm@linux-foundation.org
Subject: [merged]
 hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:51:50 -0700
Message-ID: <552fe8a6.euYCgbIca6Um4anT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbbDPQqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, andi@firstfloor.org, aneesh.kumar@linux.vnet.ibm.com, dave@stgolabs.net, iamjoonsoo.kim@lge.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: accept subpool min_size mount option and setup accordingly
has been removed from the -mm tree.  Its filename was
     hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: accept subpool min_size mount option and setup accordingly

Make 'min_size=<value>' be an option when mounting a hugetlbfs.  This
option takes the same value as the 'size' option.  min_size can be
specified without specifying size.  If both are specified, min_size must
be less that or equal to size else the mount will fail.  If min_size is
specified, then at mount time an attempt is made to reserve min_size
pages.  If the reservation fails, the mount fails.  At umount time, the
reserved pages are released.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   90 +++++++++++++++++++++++++++++---------
 include/linux/hugetlb.h |    3 -
 mm/hugetlb.c            |   25 ++++++++--
 3 files changed, 94 insertions(+), 24 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly
+++ a/fs/hugetlbfs/inode.c
@@ -47,9 +47,10 @@ struct hugetlbfs_config {
 	kuid_t   uid;
 	kgid_t   gid;
 	umode_t mode;
-	long	nr_blocks;
+	long	max_hpages;
 	long	nr_inodes;
 	struct hstate *hstate;
+	long    min_hpages;
 };
 
 struct hugetlbfs_inode_info {
@@ -67,7 +68,7 @@ int sysctl_hugetlb_shm_group;
 enum {
 	Opt_size, Opt_nr_inodes,
 	Opt_mode, Opt_uid, Opt_gid,
-	Opt_pagesize,
+	Opt_pagesize, Opt_min_size,
 	Opt_err,
 };
 
@@ -78,6 +79,7 @@ static const match_table_t tokens = {
 	{Opt_uid,	"uid=%u"},
 	{Opt_gid,	"gid=%u"},
 	{Opt_pagesize,	"pagesize=%s"},
+	{Opt_min_size,	"min_size=%s"},
 	{Opt_err,	NULL},
 };
 
@@ -754,14 +756,38 @@ static const struct super_operations hug
 	.show_options	= generic_show_options,
 };
 
+enum { NO_SIZE, SIZE_STD, SIZE_PERCENT };
+
+/*
+ * Convert size option passed from command line to number of huge pages
+ * in the pool specified by hstate.  Size option could be in bytes
+ * (val_type == SIZE_STD) or percentage of the pool (val_type == SIZE_PERCENT).
+ */
+static long long
+hugetlbfs_size_to_hpages(struct hstate *h, unsigned long long size_opt,
+								int val_type)
+{
+	if (val_type == NO_SIZE)
+		return -1;
+
+	if (val_type == SIZE_PERCENT) {
+		size_opt <<= huge_page_shift(h);
+		size_opt *= h->max_huge_pages;
+		do_div(size_opt, 100);
+	}
+
+	size_opt >>= huge_page_shift(h);
+	return size_opt;
+}
+
 static int
 hugetlbfs_parse_options(char *options, struct hugetlbfs_config *pconfig)
 {
 	char *p, *rest;
 	substring_t args[MAX_OPT_ARGS];
 	int option;
-	unsigned long long size = 0;
-	enum { NO_SIZE, SIZE_STD, SIZE_PERCENT } setsize = NO_SIZE;
+	unsigned long long max_size_opt = 0, min_size_opt = 0;
+	int max_val_type = NO_SIZE, min_val_type = NO_SIZE;
 
 	if (!options)
 		return 0;
@@ -799,10 +825,10 @@ hugetlbfs_parse_options(char *options, s
 			/* memparse() will accept a K/M/G without a digit */
 			if (!isdigit(*args[0].from))
 				goto bad_val;
-			size = memparse(args[0].from, &rest);
-			setsize = SIZE_STD;
+			max_size_opt = memparse(args[0].from, &rest);
+			max_val_type = SIZE_STD;
 			if (*rest == '%')
-				setsize = SIZE_PERCENT;
+				max_val_type = SIZE_PERCENT;
 			break;
 		}
 
@@ -825,6 +851,17 @@ hugetlbfs_parse_options(char *options, s
 			break;
 		}
 
+		case Opt_min_size: {
+			/* memparse() will accept a K/M/G without a digit */
+			if (!isdigit(*args[0].from))
+				goto bad_val;
+			min_size_opt = memparse(args[0].from, &rest);
+			min_val_type = SIZE_STD;
+			if (*rest == '%')
+				min_val_type = SIZE_PERCENT;
+			break;
+		}
+
 		default:
 			pr_err("Bad mount option: \"%s\"\n", p);
 			return -EINVAL;
@@ -832,15 +869,22 @@ hugetlbfs_parse_options(char *options, s
 		}
 	}
 
-	/* Do size after hstate is set up */
-	if (setsize > NO_SIZE) {
-		struct hstate *h = pconfig->hstate;
-		if (setsize == SIZE_PERCENT) {
-			size <<= huge_page_shift(h);
-			size *= h->max_huge_pages;
-			do_div(size, 100);
-		}
-		pconfig->nr_blocks = (size >> huge_page_shift(h));
+	/*
+	 * Use huge page pool size (in hstate) to convert the size
+	 * options to number of huge pages.  If NO_SIZE, -1 is returned.
+	 */
+	pconfig->max_hpages = hugetlbfs_size_to_hpages(pconfig->hstate,
+						max_size_opt, max_val_type);
+	pconfig->min_hpages = hugetlbfs_size_to_hpages(pconfig->hstate,
+						min_size_opt, min_val_type);
+
+	/*
+	 * If max_size was specified, then min_size must be smaller
+	 */
+	if (max_val_type > NO_SIZE &&
+	    pconfig->min_hpages > pconfig->max_hpages) {
+		pr_err("minimum size can not be greater than maximum size\n");
+		return -EINVAL;
 	}
 
 	return 0;
@@ -859,12 +903,13 @@ hugetlbfs_fill_super(struct super_block
 
 	save_mount_options(sb, data);
 
-	config.nr_blocks = -1; /* No limit on size by default */
+	config.max_hpages = -1; /* No limit on size by default */
 	config.nr_inodes = -1; /* No limit on number of inodes by default */
 	config.uid = current_fsuid();
 	config.gid = current_fsgid();
 	config.mode = 0755;
 	config.hstate = &default_hstate;
+	config.min_hpages = -1; /* No default minimum size */
 	ret = hugetlbfs_parse_options(data, &config);
 	if (ret)
 		return ret;
@@ -878,8 +923,15 @@ hugetlbfs_fill_super(struct super_block
 	sbinfo->max_inodes = config.nr_inodes;
 	sbinfo->free_inodes = config.nr_inodes;
 	sbinfo->spool = NULL;
-	if (config.nr_blocks != -1) {
-		sbinfo->spool = hugepage_new_subpool(config.nr_blocks);
+	/*
+	 * Allocate and initialize subpool if maximum or minimum size is
+	 * specified.  Any needed reservations (for minimim size) are taken
+	 * taken when the subpool is created.
+	 */
+	if (config.max_hpages != -1 || config.min_hpages != -1) {
+		sbinfo->spool = hugepage_new_subpool(config.hstate,
+							config.max_hpages,
+							config.min_hpages);
 		if (!sbinfo->spool)
 			goto out_free;
 	}
diff -puN include/linux/hugetlb.h~hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly
+++ a/include/linux/hugetlb.h
@@ -44,7 +44,8 @@ extern int hugetlb_max_hstate __read_mos
 #define for_each_hstate(h) \
 	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
 
-struct hugepage_subpool *hugepage_new_subpool(long nr_blocks);
+struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
+						long min_hpages);
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 
 void reset_vma_resv_huge_pages(struct vm_area_struct *vma);
diff -puN mm/hugetlb.c~hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly
+++ a/mm/hugetlb.c
@@ -61,6 +61,9 @@ DEFINE_SPINLOCK(hugetlb_lock);
 static int num_fault_mutexes;
 static struct mutex *htlb_fault_mutex_table ____cacheline_aligned_in_smp;
 
+/* Forward declaration */
+static int hugetlb_acct_memory(struct hstate *h, long delta);
+
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
 {
 	bool free = (spool->count == 0) && (spool->used_hpages == 0);
@@ -68,12 +71,18 @@ static inline void unlock_or_release_sub
 	spin_unlock(&spool->lock);
 
 	/* If no pages are used, and no other handles to the subpool
-	 * remain, free the subpool the subpool remain */
-	if (free)
+	 * remain, give up any reservations mased on minimum size and
+	 * free the subpool */
+	if (free) {
+		if (spool->min_hpages != -1)
+			hugetlb_acct_memory(spool->hstate,
+						-spool->min_hpages);
 		kfree(spool);
+	}
 }
 
-struct hugepage_subpool *hugepage_new_subpool(long nr_blocks)
+struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
+						long min_hpages)
 {
 	struct hugepage_subpool *spool;
 
@@ -83,7 +92,15 @@ struct hugepage_subpool *hugepage_new_su
 
 	spin_lock_init(&spool->lock);
 	spool->count = 1;
-	spool->max_hpages = nr_blocks;
+	spool->max_hpages = max_hpages;
+	spool->hstate = h;
+	spool->min_hpages = min_hpages;
+
+	if (min_hpages != -1 && hugetlb_acct_memory(h, min_hpages)) {
+		kfree(spool);
+		return NULL;
+	}
+	spool->rsv_hpages = min_hpages;
 
 	return spool;
 }
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

origin.patch


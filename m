From: akpm@osdl.org
Subject: - struct-path-rename-dms-struct-path.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:29 -0800
Message-ID: <200612082001.kB8K1Twm001867@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57838 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946050AbWLHUHR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:07:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, agk@redhat.com, reiserfs-dev@namesys.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     struct path: rename DM's struct path
has been removed from the -mm tree.  Its filename was
     struct-path-rename-dms-struct-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: rename DM's struct path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Rename DM's struct path to struct dm_path to prevent name collision between it
and struct path from fs/namei.c.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Acked-by: Alasdair G Kergon <agk@redhat.com>
Cc: <reiserfs-dev@namesys.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-emc.c           |   10 +++++-----
 drivers/md/dm-hw-handler.h    |    2 +-
 drivers/md/dm-mpath.c         |    6 +++---
 drivers/md/dm-mpath.h         |    4 ++--
 drivers/md/dm-path-selector.h |   12 ++++++------
 drivers/md/dm-round-robin.c   |   12 ++++++------
 6 files changed, 23 insertions(+), 23 deletions(-)

diff -puN drivers/md/dm-emc.c~struct-path-rename-dms-struct-path drivers/md/dm-emc.c
--- a/drivers/md/dm-emc.c~struct-path-rename-dms-struct-path
+++ a/drivers/md/dm-emc.c
@@ -40,7 +40,7 @@ static inline void free_bio(struct bio *
 
 static int emc_endio(struct bio *bio, unsigned int bytes_done, int error)
 {
-	struct path *path = bio->bi_private;
+	struct dm_path *path = bio->bi_private;
 
 	if (bio->bi_size)
 		return 1;
@@ -61,7 +61,7 @@ static int emc_endio(struct bio *bio, un
 	return 0;
 }
 
-static struct bio *get_failover_bio(struct path *path, unsigned data_size)
+static struct bio *get_failover_bio(struct dm_path *path, unsigned data_size)
 {
 	struct bio *bio;
 	struct page *page;
@@ -96,7 +96,7 @@ static struct bio *get_failover_bio(stru
 }
 
 static struct request *get_failover_req(struct emc_handler *h,
-					struct bio *bio, struct path *path)
+					struct bio *bio, struct dm_path *path)
 {
 	struct request *rq;
 	struct block_device *bdev = bio->bi_bdev;
@@ -133,7 +133,7 @@ static struct request *get_failover_req(
 }
 
 static struct request *emc_trespass_get(struct emc_handler *h,
-					struct path *path)
+					struct dm_path *path)
 {
 	struct bio *bio;
 	struct request *rq;
@@ -191,7 +191,7 @@ static struct request *emc_trespass_get(
 }
 
 static void emc_pg_init(struct hw_handler *hwh, unsigned bypassed,
-			struct path *path)
+			struct dm_path *path)
 {
 	struct request *rq;
 	struct request_queue *q = bdev_get_queue(path->dev->bdev);
diff -puN drivers/md/dm-hw-handler.h~struct-path-rename-dms-struct-path drivers/md/dm-hw-handler.h
--- a/drivers/md/dm-hw-handler.h~struct-path-rename-dms-struct-path
+++ a/drivers/md/dm-hw-handler.h
@@ -32,7 +32,7 @@ struct hw_handler_type {
 	void (*destroy) (struct hw_handler *hwh);
 
 	void (*pg_init) (struct hw_handler *hwh, unsigned bypassed,
-			 struct path *path);
+			 struct dm_path *path);
 	unsigned (*error) (struct hw_handler *hwh, struct bio *bio);
 	int (*status) (struct hw_handler *hwh, status_type_t type,
 		       char *result, unsigned int maxlen);
diff -puN drivers/md/dm-mpath.c~struct-path-rename-dms-struct-path drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c~struct-path-rename-dms-struct-path
+++ a/drivers/md/dm-mpath.c
@@ -31,7 +31,7 @@ struct pgpath {
 	struct priority_group *pg;	/* Owning PG */
 	unsigned fail_count;		/* Cumulative failure count */
 
-	struct path path;
+	struct dm_path path;
 };
 
 #define path_to_pgpath(__pgp) container_of((__pgp), struct pgpath, path)
@@ -229,7 +229,7 @@ static void __switch_pg(struct multipath
 
 static int __choose_path_in_pg(struct multipath *m, struct priority_group *pg)
 {
-	struct path *path;
+	struct dm_path *path;
 
 	path = pg->ps.type->select_path(&pg->ps, &m->repeat_count);
 	if (!path)
@@ -957,7 +957,7 @@ static int bypass_pg_num(struct multipat
 /*
  * pg_init must call this when it has completed its initialisation
  */
-void dm_pg_init_complete(struct path *path, unsigned err_flags)
+void dm_pg_init_complete(struct dm_path *path, unsigned err_flags)
 {
 	struct pgpath *pgpath = path_to_pgpath(path);
 	struct priority_group *pg = pgpath->pg;
diff -puN drivers/md/dm-mpath.h~struct-path-rename-dms-struct-path drivers/md/dm-mpath.h
--- a/drivers/md/dm-mpath.h~struct-path-rename-dms-struct-path
+++ a/drivers/md/dm-mpath.h
@@ -11,7 +11,7 @@
 
 struct dm_dev;
 
-struct path {
+struct dm_path {
 	struct dm_dev *dev;	/* Read-only */
 	unsigned is_active;	/* Read-only */
 
@@ -20,6 +20,6 @@ struct path {
 };
 
 /* Callback for hwh_pg_init_fn to use when complete */
-void dm_pg_init_complete(struct path *path, unsigned err_flags);
+void dm_pg_init_complete(struct dm_path *path, unsigned err_flags);
 
 #endif
diff -puN drivers/md/dm-path-selector.h~struct-path-rename-dms-struct-path drivers/md/dm-path-selector.h
--- a/drivers/md/dm-path-selector.h~struct-path-rename-dms-struct-path
+++ a/drivers/md/dm-path-selector.h
@@ -44,7 +44,7 @@ struct path_selector_type {
 	 * Add an opaque path object, along with some selector specific
 	 * path args (eg, path priority).
 	 */
-	int (*add_path) (struct path_selector *ps, struct path *path,
+	int (*add_path) (struct path_selector *ps, struct dm_path *path,
 			 int argc, char **argv, char **error);
 
 	/*
@@ -55,27 +55,27 @@ struct path_selector_type {
 	 * calling the function again.  0 means don't call it again unless
 	 * the path fails.
 	 */
-	struct path *(*select_path) (struct path_selector *ps,
+	struct dm_path *(*select_path) (struct path_selector *ps,
 				     unsigned *repeat_count);
 
 	/*
 	 * Notify the selector that a path has failed.
 	 */
-	void (*fail_path) (struct path_selector *ps, struct path *p);
+	void (*fail_path) (struct path_selector *ps, struct dm_path *p);
 
 	/*
 	 * Ask selector to reinstate a path.
 	 */
-	int (*reinstate_path) (struct path_selector *ps, struct path *p);
+	int (*reinstate_path) (struct path_selector *ps, struct dm_path *p);
 
 	/*
 	 * Table content based on parameters added in ps_add_path_fn
 	 * or path selector status
 	 */
-	int (*status) (struct path_selector *ps, struct path *path,
+	int (*status) (struct path_selector *ps, struct dm_path *path,
 		       status_type_t type, char *result, unsigned int maxlen);
 
-	int (*end_io) (struct path_selector *ps, struct path *path);
+	int (*end_io) (struct path_selector *ps, struct dm_path *path);
 };
 
 /* Register a path selector */
diff -puN drivers/md/dm-round-robin.c~struct-path-rename-dms-struct-path drivers/md/dm-round-robin.c
--- a/drivers/md/dm-round-robin.c~struct-path-rename-dms-struct-path
+++ a/drivers/md/dm-round-robin.c
@@ -21,7 +21,7 @@
  *---------------------------------------------------------------*/
 struct path_info {
 	struct list_head list;
-	struct path *path;
+	struct dm_path *path;
 	unsigned repeat_count;
 };
 
@@ -80,7 +80,7 @@ static void rr_destroy(struct path_selec
 	ps->context = NULL;
 }
 
-static int rr_status(struct path_selector *ps, struct path *path,
+static int rr_status(struct path_selector *ps, struct dm_path *path,
 		     status_type_t type, char *result, unsigned int maxlen)
 {
 	struct path_info *pi;
@@ -106,7 +106,7 @@ static int rr_status(struct path_selecto
  * Called during initialisation to register each path with an
  * optional repeat_count.
  */
-static int rr_add_path(struct path_selector *ps, struct path *path,
+static int rr_add_path(struct path_selector *ps, struct dm_path *path,
 		       int argc, char **argv, char **error)
 {
 	struct selector *s = (struct selector *) ps->context;
@@ -141,7 +141,7 @@ static int rr_add_path(struct path_selec
 	return 0;
 }
 
-static void rr_fail_path(struct path_selector *ps, struct path *p)
+static void rr_fail_path(struct path_selector *ps, struct dm_path *p)
 {
 	struct selector *s = (struct selector *) ps->context;
 	struct path_info *pi = p->pscontext;
@@ -149,7 +149,7 @@ static void rr_fail_path(struct path_sel
 	list_move(&pi->list, &s->invalid_paths);
 }
 
-static int rr_reinstate_path(struct path_selector *ps, struct path *p)
+static int rr_reinstate_path(struct path_selector *ps, struct dm_path *p)
 {
 	struct selector *s = (struct selector *) ps->context;
 	struct path_info *pi = p->pscontext;
@@ -159,7 +159,7 @@ static int rr_reinstate_path(struct path
 	return 0;
 }
 
-static struct path *rr_select_path(struct path_selector *ps,
+static struct dm_path *rr_select_path(struct path_selector *ps,
 				   unsigned *repeat_count)
 {
 	struct selector *s = (struct selector *) ps->context;
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

struct-path-rename-dms-struct-path.patch
struct-path-move-struct-path-from-fs-nameic-into.patch
struct-path-make-ecryptfs-a-user-of-struct-path.patch
vfs-change-struct-file-to-use-struct-path.patch
sysfs-change-uses-of-f_dentry.patch
proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext2-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext4-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
fat-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
isofs-change-uses-of-f_dentry.patch
nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
x86_64-change-uses-of-f_dentry.patch
kernel-change-uses-of-f_dentry.patch
mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch


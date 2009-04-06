From: akpm@linux-foundation.org
Subject: [merged] sgi-gru-macro-for-scanning-all-gru-chiplets.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:39 -0700
Message-ID: <200904061937.n36Jbdqe013030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800AbZDFTvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:51:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-gru: macro for scanning all gru chiplets
has been removed from the -mm tree.  Its filename was
     sgi-gru-macro-for-scanning-all-gru-chiplets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru: macro for scanning all gru chiplets
From: Jack Steiner <steiner@sgi.com>

Add macro for scanning all active GRU chiplets.  Maximum chiplet id is
saved during GRU initialization.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c  |   11 ++---------
 drivers/misc/sgi-gru/grufile.c   |    3 +++
 drivers/misc/sgi-gru/gruprocfs.c |    4 ++--
 drivers/misc/sgi-gru/grutables.h |    9 +++++++--
 4 files changed, 14 insertions(+), 13 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~sgi-gru-macro-for-scanning-all-gru-chiplets drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~sgi-gru-macro-for-scanning-all-gru-chiplets
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -600,18 +600,11 @@ static int gru_unload_all_contexts(void)
 {
 	struct gru_thread_state *gts;
 	struct gru_state *gru;
-	int maxgid, gid, ctxnum;
-	int nodesperblade;
+	int gid, ctxnum;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (num_online_nodes() > 1 &&
-			(uv_node_to_blade_id(1) == uv_node_to_blade_id(0)))
-		nodesperblade = 2;
-	else
-		nodesperblade = 1;
-	maxgid = GRU_CHIPLETS_PER_BLADE * num_online_nodes() / nodesperblade;
-	for (gid = 0; gid < maxgid; gid++) {
+	foreach_gid(gid) {
 		gru = GID_TO_GRU(gid);
 		spin_lock(&gru->gs_lock);
 		for (ctxnum = 0; ctxnum < GRU_NUM_CCH; ctxnum++) {
diff -puN drivers/misc/sgi-gru/grufile.c~sgi-gru-macro-for-scanning-all-gru-chiplets drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~sgi-gru-macro-for-scanning-all-gru-chiplets
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -47,6 +47,7 @@
 struct gru_blade_state *gru_base[GRU_MAX_BLADES] __read_mostly;
 unsigned long gru_start_paddr __read_mostly;
 unsigned long gru_end_paddr __read_mostly;
+unsigned int gru_max_gids __read_mostly;
 struct gru_stats_s gru_stats;
 
 /* Guaranteed user available resources on each node */
@@ -276,6 +277,8 @@ static void gru_init_chiplet(struct gru_
 	gru->gs_dsr_map = (1UL << GRU_DSR_AU) - 1;
 	gru->gs_asid_limit = MAX_ASID;
 	gru_tgh_flush_init(gru);
+	if (gru->gs_gid >= gru_max_gids)
+		gru_max_gids = gru->gs_gid + 1;
 	gru_dbg(grudev, "bid %d, nid %d, gid %d, vaddr %p (0x%lx)\n",
 		bid, nid, gru->gs_gid, gru->gs_gru_base_vaddr,
 		gru->gs_gru_base_paddr);
diff -puN drivers/misc/sgi-gru/gruprocfs.c~sgi-gru-macro-for-scanning-all-gru-chiplets drivers/misc/sgi-gru/gruprocfs.c
--- a/drivers/misc/sgi-gru/gruprocfs.c~sgi-gru-macro-for-scanning-all-gru-chiplets
+++ a/drivers/misc/sgi-gru/gruprocfs.c
@@ -226,7 +226,7 @@ static void seq_stop(struct seq_file *fi
 
 static void *seq_start(struct seq_file *file, loff_t *gid)
 {
-	if (*gid < GRU_MAX_GRUS)
+	if (*gid < gru_max_gids)
 		return gid;
 	return NULL;
 }
@@ -234,7 +234,7 @@ static void *seq_start(struct seq_file *
 static void *seq_next(struct seq_file *file, void *data, loff_t *gid)
 {
 	(*gid)++;
-	if (*gid < GRU_MAX_GRUS)
+	if (*gid < gru_max_gids)
 		return gid;
 	return NULL;
 }
diff -puN drivers/misc/sgi-gru/grutables.h~sgi-gru-macro-for-scanning-all-gru-chiplets drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~sgi-gru-macro-for-scanning-all-gru-chiplets
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -153,6 +153,7 @@
 extern struct gru_stats_s gru_stats;
 extern struct gru_blade_state *gru_base[];
 extern unsigned long gru_start_paddr, gru_end_paddr;
+extern unsigned int gru_max_gids;
 
 #define GRU_MAX_BLADES		MAX_NUMNODES
 #define GRU_MAX_GRUS		(GRU_MAX_BLADES * GRU_CHIPLETS_PER_BLADE)
@@ -406,12 +407,12 @@ struct gru_state {
 							   gru segments (64) */
 	void			*gs_gru_base_vaddr;	/* Virtual address of
 							   gru segments (64) */
-	unsigned char		gs_gid;			/* unique GRU number */
+	unsigned short		gs_gid;			/* unique GRU number */
+	unsigned short		gs_blade_id;		/* blade of GRU */
 	unsigned char		gs_tgh_local_shift;	/* used to pick TGH for
 							   local flush */
 	unsigned char		gs_tgh_first_remote;	/* starting TGH# for
 							   remote flush */
-	unsigned short		gs_blade_id;		/* blade of GRU */
 	spinlock_t		gs_asid_lock;		/* lock used for
 							   assigning asids */
 	spinlock_t		gs_lock;		/* lock used for
@@ -506,6 +507,10 @@ struct gru_blade_state {
 			(i) < GRU_CHIPLETS_PER_BLADE;			\
 			(i)++, (gru)++)
 
+/* Scan all GRUs */
+#define foreach_gid(gid)						\
+	for ((gid) = 0; (gid) < gru_max_gids; (gid)++)
+
 /* Scan all active GTSs on a gru. Note: must hold ss_lock to use this macro. */
 #define for_each_gts_on_gru(gts, gru, ctxnum)				\
 	for ((ctxnum) = 0; (ctxnum) < GRU_NUM_CCH; (ctxnum)++)		\
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch


From: akpm@linux-foundation.org
Subject: + sgi-gru-macro-for-scanning-all-gru-chiplets.patch added to -mm tree
Date: Tue, 27 Jan 2009 16:25:13 -0800
Message-ID: <200901280025.n0S0PD9O004943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813AbZA1AZS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 19:25:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     sgi-gru: macro for scanning all gru chiplets
has been added to the -mm tree.  Its filename is
     sgi-gru-macro-for-scanning-all-gru-chiplets.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -59,6 +59,7 @@
 struct gru_blade_state *gru_base[GRU_MAX_BLADES] __read_mostly;
 unsigned long gru_start_paddr __read_mostly;
 unsigned long gru_end_paddr __read_mostly;
+unsigned int gru_max_gids __read_mostly;
 struct gru_stats_s gru_stats;
 
 /* Guaranteed user available resources on each node */
@@ -288,6 +289,8 @@ static void gru_init_chiplet(struct gru_
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

sgi-gru-add-definitions-of-x86_64-gru-mmrs.patch
sgi-gru-add-definitions-of-ia64-gru-mmrs.patch
sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch
sgi-gru-misc-gru-cleanup.patch
sgi-gru-improvements-to-gru-debug-messages-statistics.patch
sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions.patch
sgi-gru-add-statistics-to-the-gru-context-management-functions.patch
sgi-gru-add-support-for-a-user-to-explicitly-unload-a-gru-context.patch
sgi-gru-asid-context-management-bug-fixes.patch
sgi-gru-restructure-the-gru-vtop-functions.patch
sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts.patch
sgi-gru-macro-for-scanning-all-gru-chiplets.patch
sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver.patch
sgi-gru-support-multiple-pagesizes-in-gru.patch


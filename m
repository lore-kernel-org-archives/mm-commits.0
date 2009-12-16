From: akpm@linux-foundation.org
Subject: [merged] gru-allow-users-to-specify-gru-chiplet-1.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:18 -0800
Message-ID: <200912162040.nBGKeItT013626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965012AbZLPUkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: allow users to specify gru chiplet 1
has been removed from the -mm tree.  Its filename was
     gru-allow-users-to-specify-gru-chiplet-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: allow users to specify gru chiplet 1
From: Jack Steiner <steiner@sgi.com>

Add table & user request infrastructure that is needed to allow users to
specify the blade and chiplet for allocation of GRU contexts.  Use of this
information is in a subsequent patch.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c  |   10 ++++++++++
 drivers/misc/sgi-gru/grulib.h    |    5 +++--
 drivers/misc/sgi-gru/grumain.c   |    2 ++
 drivers/misc/sgi-gru/grutables.h |    2 ++
 4 files changed, 17 insertions(+), 2 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-allow-users-to-specify-gru-chiplet-1 drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-allow-users-to-specify-gru-chiplet-1
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -763,6 +763,16 @@ int gru_set_context_option(unsigned long
 		return -EINVAL;
 
 	switch (req.op) {
+	case sco_blade_chiplet:
+		/* Select blade/chiplet for GRU context */
+		if (req.val1 < -1 || req.val1 >= GRU_MAX_BLADES || !gru_base[req.val1] ||
+		    req.val0 < -1 || req.val0 >= GRU_CHIPLETS_PER_HUB) {
+			ret = -EINVAL;
+		} else {
+			gts->ts_user_blade_id = req.val1;
+			gts->ts_user_chiplet_id = req.val0;
+		}
+		break;
 	case sco_gseg_owner:
  		/* Register the current task as the GSEG owner */
 		gts->ts_tgid_owner = current->tgid;
diff -puN drivers/misc/sgi-gru/grulib.h~gru-allow-users-to-specify-gru-chiplet-1 drivers/misc/sgi-gru/grulib.h
--- a/drivers/misc/sgi-gru/grulib.h~gru-allow-users-to-specify-gru-chiplet-1
+++ a/drivers/misc/sgi-gru/grulib.h
@@ -98,11 +98,12 @@ struct gru_unload_context_req {
 /*
  * Structure used to set context options
  */
-enum {sco_gseg_owner, sco_cch_req_slice};
+enum {sco_gseg_owner, sco_cch_req_slice, sco_blade_chiplet};
 struct gru_set_context_option_req {
 	unsigned long	gseg;
 	int		op;
-	unsigned long	val1;
+	int		val0;
+	long		val1;
 };
 
 /*
diff -puN drivers/misc/sgi-gru/grumain.c~gru-allow-users-to-specify-gru-chiplet-1 drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-allow-users-to-specify-gru-chiplet-1
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -328,6 +328,8 @@ struct gru_thread_state *gru_alloc_gts(s
 	gts->ts_cbr_au_count = cbr_au_count;
 	gts->ts_dsr_au_count = dsr_au_count;
 	gts->ts_user_options = options;
+	gts->ts_user_blade_id = -1;
+	gts->ts_user_chiplet_id = -1;
 	gts->ts_tsid = tsid;
 	gts->ts_ctxnum = NULLCTX;
 	gts->ts_tlb_int_select = -1;
diff -puN drivers/misc/sgi-gru/grutables.h~gru-allow-users-to-specify-gru-chiplet-1 drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-allow-users-to-specify-gru-chiplet-1
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -369,6 +369,8 @@ struct gru_thread_state {
 	long			ts_user_options;/* misc user option flags */
 	pid_t			ts_tgid_owner;	/* task that is using the
 						   context - for migration */
+	short			ts_user_blade_id;/* user selected blade */
+	char			ts_user_chiplet_id;/* user selected chiplet */
 	unsigned short		ts_sizeavail;	/* Pagesizes in use */
 	int			ts_tsid;	/* thread that owns the
 						   structure */
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch


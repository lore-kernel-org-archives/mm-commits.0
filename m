From: akpm@linux-foundation.org
Subject: [merged] sgi-gru-add-support-for-a-user-to-explicitly-unload-a-gru-context.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:31 -0700
Message-ID: <200904061937.n36JbVN9012956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757657AbZDFTj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:39:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-gru: add support for a user to explicitly unload a GRU context
has been removed from the -mm tree.  Its filename was
     sgi-gru-add-support-for-a-user-to-explicitly-unload-a-gru-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru: add support for a user to explicitly unload a GRU context
From: Jack Steiner <steiner@sgi.com>

Add support for a user to explicitly unload a GRU context.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |   36 ++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff -puN drivers/misc/sgi-gru/grufault.c~sgi-gru-add-support-for-a-user-to-explicitly-unload-a-gru-context drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~sgi-gru-add-support-for-a-user-to-explicitly-unload-a-gru-context
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -32,6 +32,7 @@
 #include <linux/device.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <linux/security.h>
 #include <asm/pgtable.h>
 #include "gru.h"
 #include "grutables.h"
@@ -575,6 +576,38 @@ int gru_get_exception_detail(unsigned lo
 /*
  * User request to unload a context. Content is saved for possible reload.
  */
+static int gru_unload_all_contexts(void)
+{
+	struct gru_thread_state *gts;
+	struct gru_state *gru;
+	int maxgid, gid, ctxnum;
+	int nodesperblade;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (num_online_nodes() > 1 &&
+			(uv_node_to_blade_id(1) == uv_node_to_blade_id(0)))
+		nodesperblade = 2;
+	else
+		nodesperblade = 1;
+	maxgid = GRU_CHIPLETS_PER_BLADE * num_online_nodes() / nodesperblade;
+	for (gid = 0; gid < maxgid; gid++) {
+		gru = GID_TO_GRU(gid);
+		spin_lock(&gru->gs_lock);
+		for (ctxnum = 0; ctxnum < GRU_NUM_CCH; ctxnum++) {
+			gts = gru->gs_gts[ctxnum];
+			if (gts && mutex_trylock(&gts->ts_ctxlock)) {
+				spin_unlock(&gru->gs_lock);
+				gru_unload_context(gts, 1);
+				gru_unlock_gts(gts);
+				spin_lock(&gru->gs_lock);
+			}
+		}
+		spin_unlock(&gru->gs_lock);
+	}
+	return 0;
+}
+
 int gru_user_unload_context(unsigned long arg)
 {
 	struct gru_thread_state *gts;
@@ -586,6 +619,9 @@ int gru_user_unload_context(unsigned lon
 
 	gru_dbg(grudev, "gseg 0x%lx\n", req.gseg);
 
+	if (!req.gseg)
+		return gru_unload_all_contexts();
+
 	gts = gru_find_lock_gts(req.gseg);
 	if (!gts)
 		return -EINVAL;
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch


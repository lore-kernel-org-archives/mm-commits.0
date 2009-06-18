From: akpm@linux-foundation.org
Subject: [merged] gru-fixes-to-grudump-utility.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:49:12 -0700
Message-ID: <200906182249.n5IMnCfV008314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758610AbZFRWwy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:52:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: fixes to grudump utility
has been removed from the -mm tree.  Its filename was
     gru-fixes-to-grudump-utility.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: fixes to grudump utility
From: Jack Steiner <steiner@sgi.com>

Minor fixes to the SGI GRU grudump facility:
	- fix address where user data is written
	- add gru number to data passed to user
	- indicate if context is locked

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukdump.c |    8 ++++++--
 drivers/misc/sgi-gru/grulib.h   |    4 ++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/misc/sgi-gru/grukdump.c~gru-fixes-to-grudump-utility drivers/misc/sgi-gru/grukdump.c
--- a/drivers/misc/sgi-gru/grukdump.c~gru-fixes-to-grudump-utility
+++ a/drivers/misc/sgi-gru/grukdump.c
@@ -26,7 +26,7 @@
 
 static int gru_user_copy_handle(void __user **dp, void *s)
 {
-	if (copy_to_user(dp, s, GRU_HANDLE_BYTES))
+	if (copy_to_user(*dp, s, GRU_HANDLE_BYTES))
 		return -1;
 	*dp += GRU_HANDLE_BYTES;
 	return 0;
@@ -109,7 +109,7 @@ static int gru_dump_context(struct gru_s
 {
 	struct gru_dump_context_header hdr;
 	struct gru_dump_context_header __user *uhdr = ubuf;
-	struct gru_context_configuration_handle *cch;
+	struct gru_context_configuration_handle *cch, *ubufcch;
 	struct gru_thread_state *gts;
 	int try, cch_locked, cbrcnt = 0, dsrcnt = 0, bytes = 0, ret = 0;
 	void *grubase;
@@ -125,8 +125,11 @@ static int gru_dump_context(struct gru_s
 	}
 
 	ubuf += sizeof(hdr);
+	ubufcch = ubuf;
 	if (gru_user_copy_handle(&ubuf, cch))
 		goto fail;
+	if (cch_locked)
+		ubufcch->delresp = 0;
 	bytes = sizeof(hdr) + GRU_CACHE_LINE_BYTES;
 
 	if (cch_locked || !lock_cch) {
@@ -155,6 +158,7 @@ static int gru_dump_context(struct gru_s
 		return ret;
 
 	hdr.magic = GRU_DUMP_MAGIC;
+	hdr.gid = gru->gs_gid;
 	hdr.ctxnum = ctxnum;
 	hdr.cbrcnt = cbrcnt;
 	hdr.dsrcnt = dsrcnt;
diff -puN drivers/misc/sgi-gru/grulib.h~gru-fixes-to-grudump-utility drivers/misc/sgi-gru/grulib.h
--- a/drivers/misc/sgi-gru/grulib.h~gru-fixes-to-grudump-utility
+++ a/drivers/misc/sgi-gru/grulib.h
@@ -120,7 +120,7 @@ struct gru_flush_tlb_req {
 enum {dcs_pid, dcs_gid};
 struct gru_dump_chiplet_state_req {
 	unsigned int	op;
-	int		gid;
+	unsigned int	gid;
 	int		ctxnum;
 	char		data_opt;
 	char		lock_cch;
@@ -134,7 +134,7 @@ struct gru_dump_chiplet_state_req {
 #define GRU_DUMP_MAGIC	0x3474ab6c
 struct gru_dump_context_header {
 	unsigned int	magic;
-	unsigned char	gid;
+	unsigned int	gid;
 	unsigned char	ctxnum;
 	unsigned char	cbrcnt;
 	unsigned char	dsrcnt;
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch


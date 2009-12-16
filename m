From: akpm@linux-foundation.org
Subject: [merged] gru-add-debug-option-for-cache-flushing.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:33 -0800
Message-ID: <200912162040.nBGKeXll013652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965014AbZLPUkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: add debug option for cache flushing
has been removed from the -mm tree.  Its filename was
     gru-add-debug-option-for-cache-flushing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: add debug option for cache flushing
From: Jack Steiner <steiner@sgi.com>

Add a debug option to the SGI GRU driver for flushing GRU cache lines from
memory.  In theory this is not needed but it is useful for debugging. 
This has no use by end users.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukdump.c |   13 ++++++++-----
 drivers/misc/sgi-gru/grulib.h   |    2 ++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/misc/sgi-gru/grukdump.c~gru-add-debug-option-for-cache-flushing drivers/misc/sgi-gru/grukdump.c
--- a/drivers/misc/sgi-gru/grukdump.c~gru-add-debug-option-for-cache-flushing
+++ a/drivers/misc/sgi-gru/grukdump.c
@@ -44,7 +44,8 @@ static int gru_user_copy_handle(void __u
 
 static int gru_dump_context_data(void *grubase,
 			struct gru_context_configuration_handle *cch,
-			void __user *ubuf, int ctxnum, int dsrcnt)
+			void __user *ubuf, int ctxnum, int dsrcnt,
+			int flush_cbrs)
 {
 	void *cb, *cbe, *tfh, *gseg;
 	int i, scr;
@@ -55,6 +56,8 @@ static int gru_dump_context_data(void *g
 	tfh = grubase + GRU_TFH_BASE;
 
 	for_each_cbr_in_allocation_map(i, &cch->cbr_allocation_map, scr) {
+		if (flush_cbrs)
+			gru_flush_cache(cb);
 		if (gru_user_copy_handle(&ubuf, cb))
 			goto fail;
 		if (gru_user_copy_handle(&ubuf, tfh + i * GRU_HANDLE_STRIDE))
@@ -115,7 +118,7 @@ fail:
 
 static int gru_dump_context(struct gru_state *gru, int ctxnum,
 		void __user *ubuf, void __user *ubufend, char data_opt,
-		char lock_cch)
+		char lock_cch, char flush_cbrs)
 {
 	struct gru_dump_context_header hdr;
 	struct gru_dump_context_header __user *uhdr = ubuf;
@@ -159,8 +162,7 @@ static int gru_dump_context(struct gru_s
 			ret = -EFBIG;
 		else
 			ret = gru_dump_context_data(grubase, cch, ubuf, ctxnum,
-							dsrcnt);
-
+							dsrcnt, flush_cbrs);
 	}
 	if (cch_locked)
 		unlock_cch_handle(cch);
@@ -215,7 +217,8 @@ int gru_dump_chiplet_request(unsigned lo
 	for (ctxnum = 0; ctxnum < GRU_NUM_CCH; ctxnum++) {
 		if (req.ctxnum == ctxnum || req.ctxnum < 0) {
 			ret = gru_dump_context(gru, ctxnum, ubuf, ubufend,
-						req.data_opt, req.lock_cch);
+						req.data_opt, req.lock_cch,
+						req.flush_cbrs);
 			if (ret < 0)
 				goto fail;
 			ubuf += ret;
diff -puN drivers/misc/sgi-gru/grulib.h~gru-add-debug-option-for-cache-flushing drivers/misc/sgi-gru/grulib.h
--- a/drivers/misc/sgi-gru/grulib.h~gru-add-debug-option-for-cache-flushing
+++ a/drivers/misc/sgi-gru/grulib.h
@@ -125,6 +125,8 @@ struct gru_dump_chiplet_state_req {
 	int		ctxnum;
 	char		data_opt;
 	char		lock_cch;
+	char		flush_cbrs;
+	char		fill[10];
 	pid_t		pid;
 	void		*buf;
 	size_t		buflen;
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch


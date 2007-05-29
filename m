From: akpm@linux-foundation.org
Subject: - dave-broke-gfs2-26-nmwgit.patch removed from -mm tree
Date: Tue, 29 May 2007 11:54:04 -0700
Message-ID: <200705291854.l4TIs37X008500@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752977AbXE2Syf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:54:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: teigland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Dave broke gfs2-2.6-nmw.git
has been removed from the -mm tree.  Its filename was
     dave-broke-gfs2-26-nmwgit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dave broke gfs2-2.6-nmw.git
From: David Teigland <teigland@redhat.com>

Fix compilation that broke when replacing log_error with log_debug.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/lock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/dlm/lock.c~dave-broke-gfs2-26-nmwgit fs/dlm/lock.c
--- a/fs/dlm/lock.c~dave-broke-gfs2-26-nmwgit
+++ a/fs/dlm/lock.c
@@ -1098,8 +1098,8 @@ void dlm_scan_timeout(struct dlm_ls *ls)
 		}
 
 		if (do_cancel) {
-			log_debug("timeout cancel %x node %d %s", lkb->lkb_id,
-				  lkb->lkb_nodeid, r->res_name);
+			log_debug(r->res_ls, "timeout cancel %x node %d %s",
+				  lkb->lkb_id, lkb->lkb_nodeid, r->res_name);
 			lkb->lkb_flags &= ~DLM_IFL_WATCH_TIMEWARN;
 			lkb->lkb_flags |= DLM_IFL_TIMEOUT_CANCEL;
 			del_timeout(lkb);
_

Patches currently in -mm which might be from teigland@redhat.com are

git-gfs2-nmw.patch

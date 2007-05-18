From: akpm@linux-foundation.org
Subject: + dave-broke-gfs2-26-nmwgit.patch added to -mm tree
Date: Fri, 18 May 2007 14:52:49 -0700
Message-ID: <200705182152.l4ILqnoT024261@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44872 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbXERVyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 17:54:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: teigland@redhat.com


The patch titled
     Dave broke gfs2-2.6-nmw.git
has been added to the -mm tree.  Its filename is
     dave-broke-gfs2-26-nmwgit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
dave-broke-gfs2-26-nmwgit.patch

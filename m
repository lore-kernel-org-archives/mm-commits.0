From: akpm@linux-foundation.org
Subject: [merged] ocfs2-unlock-super-lock-if-lockres-refresh-failed.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:39:07 -0800
Message-ID: <20130222203907.B2E9D5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:46517 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3BVUjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:39:08 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so118732qah.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:39:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: unlock super lock if lockres refresh failed
has been removed from the -mm tree.  Its filename was
     ocfs2-unlock-super-lock-if-lockres-refresh-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: unlock super lock if lockres refresh failed

If lockres refresh failed, the super lock will never be released which
will cause some processes on other cluster nodes hung forever.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-unlock-super-lock-if-lockres-refresh-failed fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-unlock-super-lock-if-lockres-refresh-failed
+++ a/fs/ocfs2/dlmglue.c
@@ -2545,6 +2545,7 @@ int ocfs2_super_lock(struct ocfs2_super 
 	 * everything is up to the caller :) */
 	status = ocfs2_should_refresh_lock_res(lockres);
 	if (status < 0) {
+		ocfs2_cluster_unlock(osb, lockres, level);
 		mlog_errno(status);
 		goto bail;
 	}
@@ -2553,8 +2554,10 @@ int ocfs2_super_lock(struct ocfs2_super 
 
 		ocfs2_complete_lock_res_refresh(lockres, status);
 
-		if (status < 0)
+		if (status < 0) {
+			ocfs2_cluster_unlock(osb, lockres, level);
 			mlog_errno(status);
+		}
 		ocfs2_track_lock_refresh(lockres);
 	}
 bail:
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

origin.patch
linux-next.patch


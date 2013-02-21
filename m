From: akpm@linux-foundation.org
Subject: + ocfs2-unlock-super-lock-if-lockres-refresh-failed.patch added to -mm tree
Date: Thu, 21 Feb 2013 14:02:14 -0800
Message-ID: <20130221220214.B1E405A4253__11779.6751241714$1361484171$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:57289 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3BUWCS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 17:02:18 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so3419vea.0
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 14:02:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: junxiao.bi@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, stable@vger.kernel.org


The patch titled
     Subject: ocfs2: unlock super lock if lockres refresh failed
has been added to the -mm tree.  Its filename is
     ocfs2-unlock-super-lock-if-lockres-refresh-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
ocfs2-unlock-super-lock-if-lockres-refresh-failed.patch


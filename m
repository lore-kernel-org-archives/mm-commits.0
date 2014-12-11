From: akpm@linux-foundation.org
Subject: [merged] ocfs2-o2net-fix-connect-expired.patch removed from -mm
 tree
Date: Thu, 11 Dec 2014 10:55:18 -0800
Message-ID: <5489e896.WPPuIVXCyFVD2M1H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758399AbaLKSzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, srinivas.eeda@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2net: fix connect expired
has been removed from the -mm tree.  Its filename was
     ocfs2-o2net-fix-connect-expired.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: o2net: fix connect expired

Set nn_persistent_error to -ENOTCONN will stop reconnect since the
"stop" condition in o2net_start_connect() will be true.

stop = (nn->nn_sc ||
		(nn->nn_persistent_error &&
		(nn->nn_persistent_error != -ENOTCONN || timeout == 0)));

This will make connection never be established if the first connection
request is lost.

Set nn_persistent_error to 0 when connect expired to fix this.  With
this changes, dlm will not be waken up when connect expired, this is OK
since dlm depends on network, dlm can do nothing in this case if waken
up.  Let it wait there for network recover and connect built again to
continue.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-o2net-fix-connect-expired fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net-fix-connect-expired
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1736,7 +1736,7 @@ static void o2net_connect_expired(struct
 		     o2net_idle_timeout() / 1000,
 		     o2net_idle_timeout() % 1000);
 
-		o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
+		o2net_set_nn_state(nn, NULL, 0, 0);
 	}
 	spin_unlock(&nn->nn_lock);
 }
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

origin.patch
ocfs2-reflink-fix-slow-unlink-for-refcounted-file.patch
ocfs2-fix-journal-commit-deadlock.patch


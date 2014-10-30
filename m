From: akpm@linux-foundation.org
Subject: + ocfs2-o2net-fix-connect-expired.patch added to -mm tree
Date: Thu, 30 Oct 2014 15:33:06 -0700
Message-ID: <5452bca2.QUbObUm1FG5NqS6I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161035AbaJ3WdF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 18:33:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, srinivas.eeda@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2net: fix connect expired
has been added to the -mm tree.  Its filename is
     ocfs2-o2net-fix-connect-expired.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-o2net-fix-connect-expired.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-o2net-fix-connect-expired.patch

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
Subject: ocfs2: o2net: fix connect expired

Set nn_persistent_error to -ENOTCONN will stop reconnect since the "stop"
condition in o2net_start_connect() will be true.

stop = (nn->nn_sc ||
		(nn->nn_persistent_error &&
		(nn->nn_persistent_error != -ENOTCONN || timeout == 0)));

This will make connection never be established if the first connection
request is lost.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Srinivas Eeda <srinivas.eeda@oracle.com>
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

ocfs2-o2net-fix-connect-expired.patch
ocfs2-reflink-fix-slow-unlink-for-refcounted-file.patch
ocfs2-fix-journal-commit-deadlock.patch


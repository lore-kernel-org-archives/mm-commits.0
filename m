From: akpm@linux-foundation.org
Subject: + ocfs2-o2net-set-tcp-user-timeout-to-max-value.patch added to
 -mm tree
Date: Tue, 17 Jun 2014 15:43:33 -0700
Message-ID: <53a0c495.hMwJFGysn5dzPluc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965999AbaFQWne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 18:43:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com


The patch titled
     Subject: ocfs2: o2net: set tcp user timeout to max value
has been added to the -mm tree.  Its filename is
     ocfs2-o2net-set-tcp-user-timeout-to-max-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-o2net-set-tcp-user-timeout-to-max-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-o2net-set-tcp-user-timeout-to-max-value.patch

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
Subject: ocfs2: o2net: set tcp user timeout to max value

When tcp retransmit timeout(15mins), the connection will be closed. 
Pending messages may be lost during this time.  So we set tcp user timeout
to override the retransmit timeout to the max value.  This is OK for ocfs2
since we have disk heartbeat, if peer crash, the disk heartbeat will
timeout and it will be evicted, if disk heartbeat not timeout and
connection idle for a long time, then this means the cluster enters
split-brain state, since fence can't happen, we'd better keep the
connection and wait network recover.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   20 ++++++++++++++++++++
 fs/ocfs2/cluster/tcp.h |    1 +
 2 files changed, 21 insertions(+)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-o2net-set-tcp-user-timeout-to-max-value fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net-set-tcp-user-timeout-to-max-value
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1480,6 +1480,14 @@ static int o2net_set_nodelay(struct sock
 	return ret;
 }
 
+static int o2net_set_usertimeout(struct socket *sock)
+{
+	int user_timeout = O2NET_TCP_USER_TIMEOUT;
+
+	return kernel_setsockopt(sock, SOL_TCP, TCP_USER_TIMEOUT,
+				(char *)&user_timeout, sizeof(user_timeout));
+}
+
 static void o2net_initialize_handshake(void)
 {
 	o2net_hand->o2hb_heartbeat_timeout_ms = cpu_to_be32(
@@ -1663,6 +1671,12 @@ static void o2net_start_connect(struct w
 		goto out;
 	}
 
+	ret = o2net_set_usertimeout(sock);
+	if (ret) {
+		mlog(ML_ERROR, "set TCP_USER_TIMEOUT failed with %d\n", ret);
+		goto out;
+	}
+
 	o2net_register_callbacks(sc->sc_sock->sk, sc);
 
 	spin_lock(&nn->nn_lock);
@@ -1844,6 +1858,12 @@ static int o2net_accept_one(struct socke
 		goto out;
 	}
 
+	ret = o2net_set_usertimeout(new_sock);
+	if (ret) {
+		mlog(ML_ERROR, "set TCP_USER_TIMEOUT failed with %d\n", ret);
+		goto out;
+	}
+
 	slen = sizeof(sin);
 	ret = new_sock->ops->getname(new_sock, (struct sockaddr *) &sin,
 				       &slen, 1);
diff -puN fs/ocfs2/cluster/tcp.h~ocfs2-o2net-set-tcp-user-timeout-to-max-value fs/ocfs2/cluster/tcp.h
--- a/fs/ocfs2/cluster/tcp.h~ocfs2-o2net-set-tcp-user-timeout-to-max-value
+++ a/fs/ocfs2/cluster/tcp.h
@@ -63,6 +63,7 @@ typedef void (o2net_post_msg_handler_fun
 #define O2NET_KEEPALIVE_DELAY_MS_DEFAULT	2000
 #define O2NET_IDLE_TIMEOUT_MS_DEFAULT		30000
 
+#define O2NET_TCP_USER_TIMEOUT			0x7fffffff
 
 /* TODO: figure this out.... */
 static inline int o2net_link_down(int err, struct socket *sock)
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-o2net-dont-shutdown-connection-when-idle-timeout.patch
ocfs2-o2net-set-tcp-user-timeout-to-max-value.patch
ocfs2-quorum-add-a-log-for-node-not-fenced.patch


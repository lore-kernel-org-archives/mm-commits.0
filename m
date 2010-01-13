From: akpm@linux-foundation.org
Subject: + net-rds-remove-uses-of-nipquad-use-%pi4.patch added to -mm tree
Date: Wed, 13 Jan 2010 12:54:33 -0800
Message-ID: <201001132054.o0DKsXYZ027874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755503Ab0AMUyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 15:54:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, andy.grover@oracle.com


The patch titled
     net/rds: remove uses of NIPQUAD, use %pI4
has been added to the -mm tree.  Its filename is
     net-rds-remove-uses-of-nipquad-use-%pi4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/rds: remove uses of NIPQUAD, use %pI4
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Grover <andy.grover@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/rds/tcp_connect.c |    7 +++----
 net/rds/tcp_listen.c  |    6 +++---
 net/rds/tcp_send.c    |    4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff -puN net/rds/tcp_connect.c~net-rds-remove-uses-of-nipquad-use-%pi4 net/rds/tcp_connect.c
--- a/net/rds/tcp_connect.c~net-rds-remove-uses-of-nipquad-use-%pi4
+++ a/net/rds/tcp_connect.c
@@ -90,8 +90,8 @@ int rds_tcp_conn_connect(struct rds_conn
 
 	ret = sock->ops->bind(sock, (struct sockaddr *)&src, sizeof(src));
 	if (ret) {
-		rdsdebug("bind failed with %d at address %u.%u.%u.%u\n",
-		     ret, NIPQUAD(conn->c_laddr));
+		rdsdebug("bind failed with %d at address %pI4\n",
+			 ret, &conn->c_laddr);
 		goto out;
 	}
 
@@ -108,8 +108,7 @@ int rds_tcp_conn_connect(struct rds_conn
 				 O_NONBLOCK);
 	sock = NULL;
 
-	rdsdebug("connect to address %u.%u.%u.%u returned %d\n",
-		 NIPQUAD(conn->c_faddr), ret);
+	rdsdebug("connect to address %pI4 returned %d\n", &conn->c_faddr, ret);
 	if (ret == -EINPROGRESS)
 		ret = 0;
 
diff -puN net/rds/tcp_listen.c~net-rds-remove-uses-of-nipquad-use-%pi4 net/rds/tcp_listen.c
--- a/net/rds/tcp_listen.c~net-rds-remove-uses-of-nipquad-use-%pi4
+++ a/net/rds/tcp_listen.c
@@ -66,9 +66,9 @@ static int rds_tcp_accept_one(struct soc
 
 	inet = inet_sk(new_sock->sk);
 
-	rdsdebug("accepted tcp %u.%u.%u.%u:%u -> %u.%u.%u.%u:%u\n",
-		  NIPQUAD(inet->inet_saddr), ntohs(inet->inet_sport),
-		  NIPQUAD(inet->inet_daddr), ntohs(inet->inet_dport));
+	rdsdebug("accepted tcp %pI4:%u -> %pI4:%u\n",
+		 &inet->inet_saddr, ntohs(inet->inet_sport),
+		 &inet->inet_daddr, ntohs(inet->inet_dport));
 
 	conn = rds_conn_create(inet->inet_saddr, inet->inet_daddr,
 			       &rds_tcp_transport, GFP_KERNEL);
diff -puN net/rds/tcp_send.c~net-rds-remove-uses-of-nipquad-use-%pi4 net/rds/tcp_send.c
--- a/net/rds/tcp_send.c~net-rds-remove-uses-of-nipquad-use-%pi4
+++ a/net/rds/tcp_send.c
@@ -193,9 +193,9 @@ out:
 			rds_tcp_stats_inc(s_tcp_sndbuf_full);
 			ret = 0;
 		} else {
-			printk(KERN_WARNING "RDS/tcp: send to %u.%u.%u.%u "
+			printk(KERN_WARNING "RDS/tcp: send to %pI4 "
 			       "returned %d, disconnecting and reconnecting\n",
-			       NIPQUAD(conn->c_faddr), ret);
+			       &conn->c_faddr, ret);
 			rds_conn_drop(conn);
 		}
 	}
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-staging-pohmelfs-inodec-remove-uses-of-nipquad-use-%pi4.patch
net-rds-remove-uses-of-nipquad-use-%pi4.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch


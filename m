From: akpm@linux-foundation.org
Subject: - autofs4-check-kernel-communication-pipe-is-valid-for-write.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:29 -0700
Message-ID: <200807242329.m6ONTTFh011385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756770AbYGXX3d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: check kernel communication pipe is valid for write
has been removed from the -mm tree.  Its filename was
     autofs4-check-kernel-communication-pipe-is-valid-for-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: check kernel communication pipe is valid for write
From: Ian Kent <raven@themaw.net>

It is possible for an autofs mount to become catatonic (and for the daemon
communication pipe to become NULL) after a wait has been initiallized but
before the request has been sent to the daemon.  We need to check for this
before sending the request packet.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN fs/autofs4/waitq.c~autofs4-check-kernel-communication-pipe-is-valid-for-write fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-check-kernel-communication-pipe-is-valid-for-write
+++ a/fs/autofs4/waitq.c
@@ -99,6 +99,7 @@ static void autofs4_notify_daemon(struct
 		union autofs_packet_union v4_pkt;
 		union autofs_v5_packet_union v5_pkt;
 	} pkt;
+	struct file *pipe = NULL;
 	size_t pktsz;
 
 	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
@@ -164,8 +165,19 @@ static void autofs4_notify_daemon(struct
 		return;
 	}
 
-	if (autofs4_write(sbi->pipe, &pkt, pktsz))
-		autofs4_catatonic_mode(sbi);
+	/* Check if we have become catatonic */
+	mutex_lock(&sbi->wq_mutex);
+	if (!sbi->catatonic) {
+		pipe = sbi->pipe;
+		get_file(pipe);
+	}
+	mutex_unlock(&sbi->wq_mutex);
+
+	if (pipe) {
+		if (autofs4_write(pipe, &pkt, pktsz))
+			autofs4_catatonic_mode(sbi);
+		fput(pipe);
+	}
 }
 
 static int autofs4_getpath(struct autofs_sb_info *sbi,
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch


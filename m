From: akpm@linux-foundation.org
Subject: + autofs4-check-kernel-communication-pipe-is-valid-for-write.patch added to -mm tree
Date: Tue, 01 Jul 2008 11:03:57 -0700
Message-ID: <200807011803.m61I3vwo007321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbYGASEc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 14:04:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     autofs4: check kernel communication pipe is valid for write
has been added to the -mm tree.  Its filename is
     autofs4-check-kernel-communication-pipe-is-valid-for-write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

autofs4-dont-make-expiring-dentry-negative.patch
autofs4-dont-make-expiring-dentry-negative-fix.patch
autofs4-revert-redo-lookup-in-ttfd.patch
autofs4-use-look-aside-list-for-lookups.patch
autofs4-use-look-aside-list-for-lookups-autofs4-fix-symlink-name-allocation.patch
autofs4-dont-release-directory-mutex-if-called-in-oz_mode.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts.patch
autofs4-use-struct-qstr-in-waitqc.patch
autofs4-fix-waitq-locking.patch
autofs4-fix-pending-mount-race.patch
autofs4-check-kernel-communication-pipe-is-valid-for-write.patch


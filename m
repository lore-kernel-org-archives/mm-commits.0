From: akpm@linux-foundation.org
Subject: + autofs4-track-uid-and-gid-of-last-mount-requester.patch added to -mm tree
Date: Thu, 07 Aug 2008 14:11:11 -0700
Message-ID: <200808072111.m77LBBO8005578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbYHGVLm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 17:11:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     autofs4: track uid and gid of last mount requester
has been added to the -mm tree.  Its filename is
     autofs4-track-uid-and-gid-of-last-mount-requester.patch

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
Subject: autofs4: track uid and gid of last mount requester
From: Ian Kent <raven@themaw.net>

Track the uid and gid of the last process to request a mount for on an
autofs dentry.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    3 +++
 fs/autofs4/inode.c    |    2 ++
 fs/autofs4/waitq.c    |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

diff -puN fs/autofs4/autofs_i.h~autofs4-track-uid-and-gid-of-last-mount-requester fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-track-uid-and-gid-of-last-mount-requester
+++ a/fs/autofs4/autofs_i.h
@@ -63,6 +63,9 @@ struct autofs_info {
 	unsigned long last_used;
 	atomic_t count;
 
+	uid_t uid;
+	gid_t gid;
+
 	mode_t	mode;
 	size_t	size;
 
diff -puN fs/autofs4/inode.c~autofs4-track-uid-and-gid-of-last-mount-requester fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-track-uid-and-gid-of-last-mount-requester
+++ a/fs/autofs4/inode.c
@@ -53,6 +53,8 @@ struct autofs_info *autofs4_init_ino(str
 		atomic_set(&ino->count, 0);
 	}
 
+	ino->uid = 0;
+	ino->gid = 0;
 	ino->mode = mode;
 	ino->last_used = jiffies;
 
diff -puN fs/autofs4/waitq.c~autofs4-track-uid-and-gid-of-last-mount-requester fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-track-uid-and-gid-of-last-mount-requester
+++ a/fs/autofs4/waitq.c
@@ -457,6 +457,40 @@ int autofs4_wait(struct autofs_sb_info *
 
 	status = wq->status;
 
+	/*
+	 * For direct and offset mounts we need to track the requestrer
+	 * uid and gid in the dentry info struct. This is so it can be
+	 * supplied, on request, by the misc device ioctl interface.
+	 * This is needed during daemon resatart when reconnecting
+	 * to existing, active, autofs mounts. The uid and gid (and
+	 * related string values) may be used for macro substitution
+	 * in autofs mount maps.
+	 */
+	if (!status) {
+		struct autofs_info *ino;
+		struct dentry *de = NULL;
+
+		/* direct mount or browsable map */
+		ino = autofs4_dentry_ino(dentry);
+		if (!ino) {
+			/* If not lookup actual dentry used */
+			de = d_lookup(dentry->d_parent, &dentry->d_name);
+			if (de)
+				ino = autofs4_dentry_ino(de);
+		}
+
+		/* Set mount requester */
+		if (ino) {
+			spin_lock(&sbi->fs_lock);
+			ino->uid = wq->uid;
+			ino->gid = wq->gid;
+			spin_unlock(&sbi->fs_lock);
+		}
+
+		if (de)
+			dput(de);
+	}
+
 	/* Are we the last process to need status? */
 	mutex_lock(&sbi->wq_mutex);
 	if (!--wq->wait_ctr)
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-cleanup-autofs-mount-type-usage.patch
autofs4-track-uid-and-gid-of-last-mount-requester.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-devicer-node-ioctl-docoumentation.patch
autofs4-add-miscellaneous-device-for-ioctls.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch


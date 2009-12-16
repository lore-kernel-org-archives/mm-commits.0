From: akpm@linux-foundation.org
Subject: [merged] autofs4-use-helper-function-for-need-mount-check.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:33:44 -0800
Message-ID: <200912162033.nBGKXi4f012969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbZLPUeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:34:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, adilger@sun.com, hch@infradead.org, sage@newdream.net, viro@ZenIV.linux.org.uk, yehuda@newdream.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: use helper function for need mount check
has been removed from the -mm tree.  Its filename was
     autofs4-use-helper-function-for-need-mount-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: use helper function for need mount check
From: Ian Kent <raven@themaw.net>

Define simple helper function for checking if we need to trigger a mount.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Sage Weil <sage@newdream.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Yehuda Saheh <yehuda@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-use-helper-function-for-need-mount-check fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-use-helper-function-for-need-mount-check
+++ a/fs/autofs4/root.c
@@ -104,6 +104,14 @@ static void autofs4_del_active(struct de
 	return;
 }
 
+static unsigned int autofs4_need_mount(unsigned int flags)
+{
+	unsigned int res = 0;
+	if (flags & (TRIGGER_FLAGS | TRIGGER_INTENTS))
+		res = 1;
+	return res;
+}
+
 static int autofs4_dir_open(struct inode *inode, struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
@@ -168,7 +176,7 @@ static int try_to_fill_dentry(struct den
 		}
 	/* Trigger mount for path component or follow link */
 	} else if (dentry->d_flags & DCACHE_AUTOFS_PENDING ||
-			flags & (TRIGGER_FLAGS | TRIGGER_INTENTS) ||
+			autofs4_need_mount(flags) ||
 			current->link_count) {
 		DPRINTK("waiting for mount name=%.*s",
 			dentry->d_name.len, dentry->d_name.name);
@@ -234,7 +242,7 @@ static void *autofs4_follow_link(struct 
 	autofs4_expire_wait(dentry);
 
 	/* We trigger a mount for almost all flags */
-	lookup_type = nd->flags & (TRIGGER_FLAGS | TRIGGER_INTENTS);
+	lookup_type = autofs4_need_mount(nd->flags);
 	if (!(lookup_type || dentry->d_flags & DCACHE_AUTOFS_PENDING))
 		goto follow;
 
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-clean-up-real_lookup.patch


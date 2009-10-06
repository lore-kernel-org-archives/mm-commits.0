From: akpm@linux-foundation.org
Subject: + autofs4-use-helper-function-for-need-mount-check.patch added to -mm tree
Date: Tue, 06 Oct 2009 13:50:27 -0700
Message-ID: <200910062050.n96KoRw3009513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933338AbZJFUvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 16:51:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, adilger@sun.com, hch@infradead.org, sage@newdream.net, viro@ZenIV.linux.org.uk, yehuda@newdream.net


The patch titled
     autofs4: use helper function for need mount check
has been added to the -mm tree.  Its filename is
     autofs4-use-helper-function-for-need-mount-check.patch

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

vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-clean-up-real_lookup.patch
autofs4-use-helper-functions-for-active-list-handling.patch
autofs4-use-helper-functions-for-expiring-list.patch
autofs4-use-helper-function-for-need-mount-check.patch
autofs4-use-autofs_info-for-pending-flag.patch
autofs4-renamer-unhashed-to-active-in-autofs4_lookup.patch
autofs4-cleanup-active-and-expire-lookup.patch
autofs4-eliminate-d_unhashed-in-path-walk-checks.patch
autofs4-rename-dentry-to-active-in-autofs4_lookup_active.patch
autofs4-rename-dentry-to-expiring-in-autofs4_lookup_expiring.patch
autofs4-always-use-lookup-for-lookup.patch


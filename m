From: akpm@linux-foundation.org
Subject: [patch 099/126] autofs: fix AT_NO_AUTOMOUNT not being
 honored
Date: Fri, 08 Sep 2017 16:16:24 -0700
Message-ID: <20170908231624.pWjiP-3F4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53390 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757210AbdIHXQZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:16:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, mm-commits@vger.kernel.org, oholy@redhat.com, raven@themaw.net, torvalds@linux-foundation.org, walters@redhat.com

From: Ian Kent <raven@themaw.net>
Subject: autofs: fix AT_NO_AUTOMOUNT not being honored

The fstatat(2) and statx() calls can pass the flag AT_NO_AUTOMOUNT which
is meant to clear the LOOKUP_AUTOMOUNT flag and prevent triggering of an
automount by the call.  But this flag is unconditionally cleared for all
stat family system calls except statx().

stat family system calls have always triggered mount requests for the
negative dentry case in follow_automount() which is intended but prevents
the fstatat(2) and statx() AT_NO_AUTOMOUNT case from being handled.

In order to handle the AT_NO_AUTOMOUNT for both system calls the negative
dentry case in follow_automount() needs to be changed to return ENOENT
when the LOOKUP_AUTOMOUNT flag is clear (and the other required flags are
clear).

AFAICT this change doesn't have any noticable side effects and may, in
some use cases (although I didn't see it in testing) prevent unnecessary
callbacks to the automount daemon.

It's also possible that a stat family call has been made with a path that
is in the process of being mounted by some other process.  But stat family
calls should return the automount state of the path as it is "now" so it
shouldn't wait for mount completion.

This is the same semantic as the positive dentry case already handled.

Link: http://lkml.kernel.org/r/150216641255.11652.4204561328197919771.stgit@pluto.themaw.net
Fixes: deccf497d804a4c5fca ("Make stat/lstat/fstatat pass AT_NO_AUTOMOUNT to vfs_statx()")
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: David Howells <dhowells@redhat.com>
Cc: Colin Walters <walters@redhat.com>
Cc: Ondrej Holy <oholy@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c         |   15 ++++++++++++---
 include/linux/fs.h |    3 +--
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN fs/namei.c~autofs-fix-at_no_automount-not-being-honored fs/namei.c
--- a/fs/namei.c~autofs-fix-at_no_automount-not-being-honored
+++ a/fs/namei.c
@@ -1129,9 +1129,18 @@ static int follow_automount(struct path
 	 * of the daemon to instantiate them before they can be used.
 	 */
 	if (!(nd->flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY |
-			   LOOKUP_OPEN | LOOKUP_CREATE | LOOKUP_AUTOMOUNT)) &&
-	    path->dentry->d_inode)
-		return -EISDIR;
+			   LOOKUP_OPEN | LOOKUP_CREATE |
+			   LOOKUP_AUTOMOUNT))) {
+		/* Positive dentry that isn't meant to trigger an
+		 * automount, EISDIR will allow it to be used,
+		 * otherwise there's no mount here "now" so return
+		 * ENOENT.
+		 */
+		if (path->dentry->d_inode)
+			return -EISDIR;
+		else
+			return -ENOENT;
+	}
 
 	if (path->dentry->d_sb->s_user_ns != &init_user_ns)
 		return -EACCES;
diff -puN include/linux/fs.h~autofs-fix-at_no_automount-not-being-honored include/linux/fs.h
--- a/include/linux/fs.h~autofs-fix-at_no_automount-not-being-honored
+++ a/include/linux/fs.h
@@ -3043,8 +3043,7 @@ static inline int vfs_lstat(const char _
 static inline int vfs_fstatat(int dfd, const char __user *filename,
 			      struct kstat *stat, int flags)
 {
-	return vfs_statx(dfd, filename, flags | AT_NO_AUTOMOUNT,
-			 stat, STATX_BASIC_STATS);
+	return vfs_statx(dfd, filename, flags, stat, STATX_BASIC_STATS);
 }
 static inline int vfs_fstat(int fd, struct kstat *stat)
 {
_

From: akpm@linux-foundation.org
Subject: [patch 26/28] autofs: revert "autofs: fix AT_NO_AUTOMOUNT not
 being honored"
Date: Wed, 29 Nov 2017 16:11:26 -0800
Message-ID: <5a1f4cae.+W+0vzG/a+da8iQG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753424AbdK3AL2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:11:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, raven@themaw.net, dhowells@redhat.com, neilb@suse.com, oholy@redhat.com, stable@vger.kernel.org, viro@ZenIV.linux.org.uk, walters@redhat.com

From: Ian Kent <raven@themaw.net>
Subject: autofs: revert "autofs: fix AT_NO_AUTOMOUNT not being honored"

42f4614821 ("autofs: fix AT_NO_AUTOMOUNT not being honored") allowed the
fstatat(2) system call to properly honor the AT_NO_AUTOMOUNT flag but
introduced a semantic change.

In order to honor AT_NO_AUTOMOUNT a semantic change was made to the
negative dentry case for stat family system calls in follow_automount().

This changed the unconditional triggering of an automount in this case to
no longer be done and an error returned instead.

This has caused more problems than I expected so reverting the change is
needed.

In a discussion with Neil Brown it was concluded that the automount(8)
daemon can implement this change without kernel modifications.  So that
will be done instead and the autofs module documentation updated with a
description of the problem and what needs to be done by module users for
this specific case.

Link: http://lkml.kernel.org/r/151174730120.6162.3848002191530283984.stgit@pluto.themaw.net
Fixes: 42f4614821 ("autofs: fix AT_NO_AUTOMOUNT not being honored")
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Neil Brown <neilb@suse.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Colin Walters <walters@redhat.com>
Cc: Ondrej Holy <oholy@redhat.com>
Cc: <stable@vger.kernel.org>	[4.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c         |   15 +++------------
 include/linux/fs.h |    3 ++-
 2 files changed, 5 insertions(+), 13 deletions(-)

diff -puN fs/namei.c~autofs-revert-fix-at_no_automount-not-being-honored fs/namei.c
--- a/fs/namei.c~autofs-revert-fix-at_no_automount-not-being-honored
+++ a/fs/namei.c
@@ -1129,18 +1129,9 @@ static int follow_automount(struct path
 	 * of the daemon to instantiate them before they can be used.
 	 */
 	if (!(nd->flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY |
-			   LOOKUP_OPEN | LOOKUP_CREATE |
-			   LOOKUP_AUTOMOUNT))) {
-		/* Positive dentry that isn't meant to trigger an
-		 * automount, EISDIR will allow it to be used,
-		 * otherwise there's no mount here "now" so return
-		 * ENOENT.
-		 */
-		if (path->dentry->d_inode)
-			return -EISDIR;
-		else
-			return -ENOENT;
-	}
+			   LOOKUP_OPEN | LOOKUP_CREATE | LOOKUP_AUTOMOUNT)) &&
+	    path->dentry->d_inode)
+		return -EISDIR;
 
 	if (path->dentry->d_sb->s_user_ns != &init_user_ns)
 		return -EACCES;
diff -puN include/linux/fs.h~autofs-revert-fix-at_no_automount-not-being-honored include/linux/fs.h
--- a/include/linux/fs.h~autofs-revert-fix-at_no_automount-not-being-honored
+++ a/include/linux/fs.h
@@ -3088,7 +3088,8 @@ static inline int vfs_lstat(const char _
 static inline int vfs_fstatat(int dfd, const char __user *filename,
 			      struct kstat *stat, int flags)
 {
-	return vfs_statx(dfd, filename, flags, stat, STATX_BASIC_STATS);
+	return vfs_statx(dfd, filename, flags | AT_NO_AUTOMOUNT,
+			 stat, STATX_BASIC_STATS);
 }
 static inline int vfs_fstat(int fd, struct kstat *stat)
 {
_

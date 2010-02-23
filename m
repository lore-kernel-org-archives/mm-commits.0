From: akpm@linux-foundation.org
Subject: + fix-__d_path-for-lazy-unmounts.patch added to -mm tree
Date: Mon, 22 Feb 2010 16:10:57 -0800
Message-ID: <201002230010.o1N0Avf3032358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930Ab0BWALT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 19:11:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: john.johansen@canonical.com, agruen@suse.de, linuxram@us.ibm.com, mszeredi@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     vfs: fix __d_path for lazy unmounts
has been added to the -mm tree.  Its filename is
     fix-__d_path-for-lazy-unmounts.patch

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
Subject: vfs: fix __d_path for lazy unmounts
From: John Johansen <john.johansen@canonical.com>

When __d_path() hits a lazily unmounted mount point, it tries to prepend
the name of the lazily unmounted dentry to the path name.  It gets this
wrong, and also overwrites the slash that separates the name from the
following pathname component.  This patch fixes that; if a process was in
directory /foo/bar and /foo got lazily unmounted, the old result was
``foobar'' (note the missing slash), while the new result with this patch
is ``/foo/bar''.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff -puN fs/dcache.c~fix-__d_path-for-lazy-unmounts fs/dcache.c
--- a/fs/dcache.c~fix-__d_path-for-lazy-unmounts
+++ a/fs/dcache.c
@@ -1941,11 +1941,9 @@ char *__d_path(const struct path *path, 
 	retval = end-1;
 	*retval = '/';
 
-	for (;;) {
+	while(dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
 
-		if (dentry == root->dentry && vfsmnt == root->mnt)
-			break;
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
 			/* Global root? */
 			if (vfsmnt->mnt_parent == vfsmnt) {
@@ -1969,9 +1967,30 @@ out:
 	return retval;
 
 global_root:
-	retval += 1;	/* hit the slash */
+	/*
+	 * We went past the (vfsmount, dentry) we were looking for and have
+	 * either hit a root dentry, a lazily unmounted dentry, an
+	 * unconnected dentry, or the file is on a pseudo filesystem.
+	 */
+	if ((dentry->d_sb->s_flags & MS_NOUSER) ||
+	    (dentry->d_name.len = 1 && *dentry->d_name.name == '/')) {
+		/*
+		 * Historically, we also glue together the root dentry and
+		 * remaining name for pseudo filesystems like pipefs, which
+		 * have the MS_NOUSER flag set. This results in pathnames
+		 * like "pipe:[439336]".
+		 */
+		retval += 1;	/* overwrite the slash */
+		buflen++;
+	}
 	if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
 		goto Elong;
+
+	/* connect lazily unmounted mount point */
+	if (*retval != '/' && !(dentry->d_sb->s_flags & MS_NOUSER) &&
+	    prepend(&retval, &buflen, "/", 1) != 0)
+		goto Elong;
+
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
 	goto out;
_

Patches currently in -mm which might be from john.johansen@canonical.com are

linux-next.patch
fix-__d_path-for-lazy-unmounts.patch


From: akpm@linux-foundation.org
Subject: + vfs-fix-mount-bind.patch added to -mm tree
Date: Thu, 20 May 2010 21:03:06 -0400
Message-ID: <201005210404.o4L44WZE021862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739Ab0EUEFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 00:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, maciej.rutecki@gmail.com, rjw@sisk.pl, stable@kernel.org, torvalds@linux-foundation.orgviro@ZenIV.linux.org.uk, vonsch@gmail.com


The patch titled
     vfs: fix `mount --bind'
has been added to the -mm tree.  Its filename is
     vfs-fix-mount-bind.patch

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
Subject: vfs: fix `mount --bind'
From: Al Viro <viro@ZenIV.linux.org.uk>

We set the "it's dead, don't mount on it" flag _and_ do not remove it if
we turn the damn thing negative and leave it around.  And if it goes
positive afterwards, well...

Fortunately, there's only one place where that can needs to be caught:
only d_delete() can turn the sucker negative without immediately freeing
it; all other places that can lead to ->d_iput() call are followed by
unconditionally freeing struct dentry in question.  So the fix is obvious:

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16014

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: Adam Tkac <vonsch@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>		[2.6.34.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/dcache.c~vfs-fix-mount-bind fs/dcache.c
--- a/fs/dcache.c~vfs-fix-mount-bind
+++ a/fs/dcache.c
@@ -1526,6 +1526,7 @@ void d_delete(struct dentry * dentry)
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
 	if (atomic_read(&dentry->d_count) == 1) {
+		dentry->d_flags &= ~DCACHE_CANT_MOUNT;
 		dentry_iput(dentry);
 		fsnotify_nameremove(dentry, isdir);
 		return;
_

Patches currently in -mm which might be from viro@ZenIV.linux.org.uk are

origin.patch
vfs-fix-mount-bind.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch


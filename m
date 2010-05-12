From: akpm@linux-foundation.org
Subject: + fsnotify-initialize-mask-in-fsnotify_perm.patch added to -mm tree
Date: Wed, 12 May 2010 11:42:41 -0700
Message-ID: <201005121842.o4CIgfdl013411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755032Ab0ELSmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, akpm@linux-foundation.org


The patch titled
     fsnotify: initialize mask in fsnotify_perm
has been added to the -mm tree.  Its filename is
     fsnotify-initialize-mask-in-fsnotify_perm.patch

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
Subject: fsnotify: initialize mask in fsnotify_perm
From: Eric Paris <eparis@redhat.com>

akpm got a warning the fsnotify_mask could be used uninitialized in
fsnotify_perm().  It's not actually possible but his compiler complained
about it.  This patch just initializes it to 0 to shut up the compiler.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fsnotify.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/fsnotify.h~fsnotify-initialize-mask-in-fsnotify_perm include/linux/fsnotify.h
--- a/include/linux/fsnotify.h~fsnotify-initialize-mask-in-fsnotify_perm
+++ a/include/linux/fsnotify.h
@@ -39,16 +39,18 @@ static inline int fsnotify_perm(struct f
 {
 	struct path *path = &file->f_path;
 	struct inode *inode = path->dentry->d_inode;
-	__u32 fsnotify_mask;
+	__u32 fsnotify_mask = 0;
 
 	if (file->f_mode & FMODE_NONOTIFY)
 		return 0;
 	if (!(mask & (MAY_READ | MAY_OPEN)))
 		return 0;
-	if (mask & MAY_READ)
-		fsnotify_mask = FS_ACCESS_PERM;
 	if (mask & MAY_OPEN)
 		fsnotify_mask = FS_OPEN_PERM;
+	else if (mask & MAY_READ)
+		fsnotify_mask = FS_ACCESS_PERM;
+	else
+		BUG();
 
 	return fsnotify(inode, fsnotify_mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
 }
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
fsnotify-initialize-mask-in-fsnotify_perm.patch
include-linux-fsnotifyh-squash-warning.patch
vfs-o_-bit-numbers-uniqueness-check.patch
ext3-fixup-rb_root-initializations-to-use-rb_root.patch


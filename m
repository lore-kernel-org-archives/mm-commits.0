From: akpm@linux-foundation.org
Subject: + vfs-optimization-for-touch_atime.patch added to -mm tree
Date: Mon, 20 Jul 2009 23:25:09 -0700
Message-ID: <200907210625.n6L6P9cp002033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754958AbZGUGZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 02:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, haveblue@us.ibm.com, hch@infradead.org, vaurora@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: optimization for touch_atime()
has been added to the -mm tree.  Its filename is
     vfs-optimization-for-touch_atime.patch

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
Subject: vfs: optimization for touch_atime()
From: Andi Kleen <andi@firstfloor.org>

Some benchmark testing shows touch_atime to be high up in profile logs for
IO intensive workloads.  Most likely that's due to the lock in
mnt_want_write().  Unfortunately touch_atime first takes the lock, and
then does all the other tests that could avoid atime updates (like noatime
or relatime).

Do it the other way round -- first try to avoid the update and only then
if that didn't succeed take the lock.  That works because none of the
atime avoidance tests rely on locking.

This also eliminates a goto.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Valerie Aurora <vaurora@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/inode.c~vfs-optimization-for-touch_atime fs/inode.c
--- a/fs/inode.c~vfs-optimization-for-touch_atime
+++ a/fs/inode.c
@@ -1403,31 +1403,31 @@ void touch_atime(struct vfsmount *mnt, s
 	struct inode *inode = dentry->d_inode;
 	struct timespec now;
 
-	if (mnt_want_write(mnt))
-		return;
 	if (inode->i_flags & S_NOATIME)
-		goto out;
+		return;
 	if (IS_NOATIME(inode))
-		goto out;
+		return;
 	if ((inode->i_sb->s_flags & MS_NODIRATIME) && S_ISDIR(inode->i_mode))
-		goto out;
+		return;
 
 	if (mnt->mnt_flags & MNT_NOATIME)
-		goto out;
+		return;
 	if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
-		goto out;
+		return;
 
 	now = current_fs_time(inode->i_sb);
 
 	if (!relatime_need_update(mnt, inode, now))
-		goto out;
+		return;
 
 	if (timespec_equal(&inode->i_atime, &now))
-		goto out;
+		return;
+
+	if (mnt_want_write(mnt))
+		return;
 
 	inode->i_atime = now;
 	mark_inode_dirty_sync(inode);
-out:
 	mnt_drop_write(mnt);
 }
 EXPORT_SYMBOL(touch_atime);
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
x86-fix-x86-fix-pageattr-handling-for-lpage-percpu-allocator-and-re-enable-it.patch
vfs-optimization-for-touch_atime.patch
vfs-optimize-touch_time-too.patch
vfs-optimize-touch_time-too-fix.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
documentation-memorytxt-remove-some-very-outdated-recommendations.patch


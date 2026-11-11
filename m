Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794441170;
	b=XqFLGve45W0XTkwSgKNz+1krRI2EzbQunWfw/AC/l5ZGqTXFB5avCvsoarnCsuoJNDFX
	 t0EgGefziZy9JN5Yy7RqGzWLYClB3Oky7+WnHe8SBJmowxrZQVRggBvx30IpBzexUaSrp
	 omJARsmMc0tafTGWUmbyAay5AEC9Ab6O/KAs9djvbRVLK5LbrYMylwlzQG++aSx/JzXeE
	 3o6M0nuRCuGNfORNkXS4czhrjb77lRy7JNvqonKHFR1fEov+gdOsDMpgbiV2j1/Z1osXj
	 FG0GzySC/nvpY4StSd0ttj/N6KNzuW1B29E2YT6hLKUyqcagUYRs01X5jN0Xr8u3EfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794441170;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=uUJaboCjLIgNLDO5yD86KKaL/f6qCVWOJUbD/6NP4Vk=;
	b=Y6LcA92EDaTLIowUW8WBNRIeJ19+v3uMobEotFskLCHZxYj7rOj8AjNlSrt8SAmpIwe+
	 WLdLECbAmTwzM6CGx398jBzCt6WgYW4Z/wh40mPvxmDzEhQ2uGQB0NDBZ3D5WWKgGIDZH
	 24XuQRekiHHM6fI0AZZltAOybfUsa6yAr3LdPNFZ9C+5JAfzKNXXQOdmjtUXxKj8Sc/+R
	 GE35DJskS/2WGmIRD/hanEUI3Ds4y3/HHtWQfFaPgof75H/6NOPsX+UTlbaF1P70lS3bp
	 c3uFiIKz7fKbPK8wkqKPg/De0+XP2zy9eTPHo883uuwJepdKfMwKH4U9QqZ2n9s+j6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y43XyQyq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A624606A31C
	for <mm-commits@vger.kernel.org>; Wed, 11 Nov 2026 23:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y43XyQyq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E251F00A05;
	Wed, 11 Nov 2026 23:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794441170;
	bh=uUJaboCjLIgNLDO5yD86KKaL/f6qCVWOJUbD/6NP4Vk=;
	h=Date:To:From:Subject;
	b=Y43XyQyqIN1YDGAHTOzYra7349zxEFzeSsy+GEOx3Kj9+L5BbJ9XsoAIpe2E8pTD4
	 H5kYPQogjfXThjpLrG3ZU2tCcEJNv/AhqiDPNYOQWab4PFbMXkztvPRv2+G66oBuDg
	 PAflXngUMwazxwzHVB+xIDzvO/z8kZetioPRXtr8=
Date: Wed, 11 Nov 2026 15:52:49 -0800
To: mm-commits@vger.kernel.org,
	syzbot+c73ff6790f3d6c635abc@syzkaller.appspotmail.com,mark@fasheh.com,
	joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,
	a.p.zijlstra@chello.nl,847807867@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-lockdep-class-of-newly-created-directories.patch added to mm-nonmm-unstable branch
Message-Id: <20261111235249.D9E251F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: fix lockdep class of newly created directories
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-lockdep-class-of-newly-created-directories.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-lockdep-class-of-newly-created-directories.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shuai Liu <847807867@qq.com>
Subject: ocfs2: fix lockdep class of newly created directories
Date: Tue, 10 Nov 2026 09:45:06 +0800

Directories and regular files use different lockdep classes for i_rwsem
(i_mutex_dir_key vs i_mutex_key) so that lockdep can verify the documented
locking order "parent[2] -> child -> normal" without spurious class-level
cycles: e.g.  cross-directory rename takes I_MUTEX_CHILD on the source
directory followed by an unclassed I_MUTEX_NORMAL on the target inode,
while other paths take I_MUTEX_NORMAL on a file before touching a
child-class inode.

Since commit 14358e6ddaed ("lockdep: annotate dir vs file i_mutex"), this
split is applied in unlock_new_inode(), which relies on the inode being
created with I_NEW set.  ocfs2 creates inodes through new_inode() (no
I_NEW) and instantiates them with a plain d_instantiate(), so
lockdep_annotate_inode_mutex_key() never runs on this path.  Every
directory created after mount therefore keeps the plain i_mutex_key class
for its whole lifetime, breaking the dir/file class separation that the
VFS locking order relies on.

With such a directory the class-level chain

  i_mutex_key/I_MUTEX_NORMAL -> i_mutex_key/I_MUTEX_CHILD

recorded by the reflink path (ocfs2_vfs_reflink() locks the source inode,
then __ocfs2_reflink() takes I_MUTEX_CHILD on the orphan inode) collides
with the chain

  i_mutex_key/I_MUTEX_CHILD -> i_mutex_key

recorded by vfs_rename() when renaming a directory onto an existing
file, and lockdep reports a "possible deadlock in vfs_rename":

  syz-executor105/5623 is trying to acquire lock:
  ffff8880767009a0 (&sb->s_type->i_mutex_key#18){+.+.}-{4:4}, at: vfs_rename+0x6e3
  but task is already holding lock:
  ffff8880764ff9a0 (&sb->s_type->i_mutex_key#18/2){+.+.}-{4:4}, at: vfs_rename+0x64d

  Chain exists of:
    &sb->s_type->i_mutex_key#18 --> &oi->ip_alloc_sem --> &sb->s_type->i_mutex_key#18/2

Fix it by calling lockdep_annotate_inode_mutex_key() in
ocfs2_get_init_inode() right after the final mode is established, before
the inode can be found or locked by anyone else.  This is the same
treatment shmem got (commit b45d71fb89ab8adf, "mm: shmem.c: Correctly
annotate new inodes for lockdep"), following the hugetlbfs pattern of
annotating right after new inode creation.  Freshly created ocfs2
directories are now properly separated from files in lockdep and the
rename vs reflink cycle disappears.

The C reproducer from syzbot (mount ocfs2 image, OCFS2_IOC_REFLINK, mkdir
two directories, rename a directory onto the reflinked file) hits the
lockdep warning on every run without the fix and runs cleanly with it.

Link: https://lore.kernel.org/tencent_DEBEB3490E975A2C62C2D7DD573A9A254F05@qq.com
Fixes: 14358e6ddaed ("lockdep: annotate dir vs file i_mutex")
Signed-off-by: Shuai Liu <847807867@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+c73ff6790f3d6c635abc@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=c73ff6790f3d6c635abc
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

 fs/ocfs2/namei.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ocfs2/namei.c~ocfs2-fix-lockdep-class-of-newly-created-directories
+++ a/fs/ocfs2/namei.c
@@ -203,6 +203,13 @@ static struct inode *ocfs2_get_init_inod
 		set_nlink(inode, 2);
 	mode = mode_strip_sgid(&nop_mnt_idmap, dir, mode);
 	inode_init_owner(&nop_mnt_idmap, inode, dir, mode);
+	/*
+	 * This inode never goes through unlock_new_inode() (there is no
+	 * I_NEW state on this path), so the directory vs file lockdep
+	 * class split for i_rwsem has to be done here, before the inode
+	 * becomes visible to anybody else.
+	 */
+	lockdep_annotate_inode_mutex_key(inode);
 	status = dquot_initialize(inode);
 	if (status) {
 		iput(inode);
_

Patches currently in -mm which might be from 847807867@qq.com are

ocfs2-fix-lockdep-class-of-newly-created-directories.patch


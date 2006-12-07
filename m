From: akpm@osdl.org
Subject: - function-v9fs_get_idpool-returns-int-not-u32-as-called-twice.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:45 -0800
Message-ID: <200612072302.kB7N2jKi029889@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51915 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163728AbWLGXDf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikukkon@gmail.com, ericvh@gmail.com, lucho@ionkov.net, mikukkon@iki.fi, rminnich@lanl.gov, mm-commits@vger.kernel.org


The patch titled
     Function v9fs_get_idpool returns int, not u32 as called twice in fs/9p/vfs_inode.c
has been removed from the -mm tree.  Its filename was
     function-v9fs_get_idpool-returns-int-not-u32-as-called-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Function v9fs_get_idpool returns int, not u32 as called twice in fs/9p/vfs_inode.c
From: Mika Kukkonen <mikukkon@gmail.com>

Function v9fs_get_idpool returns int, not u32.  Actually it returns -1 on
errors, and these two callers check if the value is smaller than 0, which
was caught by gcc with extra warning flags.  Compile tested only but should
be OK, as the value computed in v9fs_get_idpool() is also int.

Signed-of-by: Mika Kukkonen <mikukkon@iki.fi>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@lanl.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/9p/vfs_inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/9p/vfs_inode.c~function-v9fs_get_idpool-returns-int-not-u32-as-called-twice fs/9p/vfs_inode.c
--- a/fs/9p/vfs_inode.c~function-v9fs_get_idpool-returns-int-not-u32-as-called-twice
+++ a/fs/9p/vfs_inode.c
@@ -256,7 +256,7 @@ static int
 v9fs_create(struct v9fs_session_info *v9ses, u32 pfid, char *name, u32 perm,
 	u8 mode, char *extension, u32 *fidp, struct v9fs_qid *qid, u32 *iounit)
 {
-	u32 fid;
+	int fid;
 	int err;
 	struct v9fs_fcall *fcall;
 
@@ -310,7 +310,7 @@ static struct v9fs_fid*
 v9fs_clone_walk(struct v9fs_session_info *v9ses, u32 fid, struct dentry *dentry)
 {
 	int err;
-	u32 nfid;
+	int nfid;
 	struct v9fs_fid *ret;
 	struct v9fs_fcall *fcall;
 
_

Patches currently in -mm which might be from mikukkon@gmail.com are

origin.patch


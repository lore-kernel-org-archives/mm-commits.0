From: akpm@linux-foundation.org
Subject: - fs-gfs2-test-for-is_err-rather-than-0.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:18:28 -0700
Message-ID: <200803312018.m2VKISkG024060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753831AbYCaUTd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:19:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fs/gfs2: test for IS_ERR rather than 0
has been removed from the -mm tree.  Its filename was
     fs-gfs2-test-for-is_err-rather-than-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/gfs2: test for IS_ERR rather than 0
From: Julia Lawall <julia@diku.dk>

The function gfs2_inode_lookup always returns either a valid pointer or a
value made with ERR_PTR, so its result should be tested with IS_ERR, not
with a test for 0.

The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

//<smpl>
@a@
expression E, E1;
statement S,S1;
position p;
@@

E = gfs2_inode_lookup(...)
... when != E = E1
if@p (E) S else S1

@n@
position a.p;
expression E,E1;
statement S,S1;
@@

E = NULL
... when != E = E1
if@p (E) S else S1

@depends on !n@
expression E;
statement S,S1;
position a.p;
@@

* if@p (E)
  S else S1
//</smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/ops_export.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/gfs2/ops_export.c~fs-gfs2-test-for-is_err-rather-than-0 fs/gfs2/ops_export.c
--- a/fs/gfs2/ops_export.c~fs-gfs2-test-for-is_err-rather-than-0
+++ a/fs/gfs2/ops_export.c
@@ -204,8 +204,6 @@ static struct dentry *gfs2_get_dentry(st
 	inode = gfs2_inode_lookup(sb, DT_UNKNOWN,
 					inum->no_addr,
 					0, 0);
-	if (!inode)
-		goto fail;
 	if (IS_ERR(inode)) {
 		error = PTR_ERR(inode);
 		goto fail;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
git-alsa-tiwai.patch
git-powerpc.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-gfs2-nmw.patch
git-infiniband.patch
git-udf.patch
git-net.patch
git-ocfs2.patch
fs-affs-filec-use-bug_on.patch
drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch


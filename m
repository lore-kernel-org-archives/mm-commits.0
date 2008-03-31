From: akpm@linux-foundation.org
Subject: - fs-ocfs2-aopsc-test-for-is_err-rather-than-0.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:18:57 -0700
Message-ID: <200803312018.m2VKIveg024096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754382AbYCaUTq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:19:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, kurt.hackel@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org


The patch titled
     fs/ocfs2/aops.c: test for IS_ERR rather than 0
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-aopsc-test-for-is_err-rather-than-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ocfs2/aops.c: test for IS_ERR rather than 0
From: Julia Lawall <julia@diku.dk>

The function ocfs2_start_trans always returns either a valid pointer or a
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

E = ocfs2_start_trans(...)
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
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/aops.c~fs-ocfs2-aopsc-test-for-is_err-rather-than-0 fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~fs-ocfs2-aopsc-test-for-is_err-rather-than-0
+++ a/fs/ocfs2/aops.c
@@ -467,11 +467,11 @@ handle_t *ocfs2_start_walk_page_trans(st
 							 unsigned to)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	handle_t *handle = NULL;
+	handle_t *handle;
 	int ret = 0;
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (!handle) {
+	if (IS_ERR(handle)) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out;
@@ -487,7 +487,7 @@ handle_t *ocfs2_start_walk_page_trans(st
 	}
 out:
 	if (ret) {
-		if (handle)
+		if (!IS_ERR(handle))
 			ocfs2_commit_trans(osb, handle);
 		handle = ERR_PTR(ret);
 	}
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


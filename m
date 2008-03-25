From: akpm@linux-foundation.org
Subject: + fs-ocfs2-aopsc-test-for-is_err-rather-than-0.patch added to -mm tree
Date: Tue, 25 Mar 2008 15:47:14 -0700
Message-ID: <200803252247.m2PMlESO017459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753447AbYCYWsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:48:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, kurt.hackel@oracle.com, mark@fasheh.com


The patch titled
     fs/ocfs2/aops.c: test for IS_ERR rather than 0
has been added to the -mm tree.  Its filename is
     fs-ocfs2-aopsc-test-for-is_err-rather-than-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-acpi-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
git-alsa-tiwai.patch
git-powerpc.patch
drivers-block-viodasdc-use-field_sizeof.patch
fs-gfs2-test-for-is_err-rather-than-0.patch
git-udf.patch
drivers-net-ixgb-ixgb_mainc-remove-unused-variable.patch
git-ocfs2.patch
fs-ocfs2-aopsc-test-for-is_err-rather-than-0.patch
fs-affs-filec-use-bug_on.patch
drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch


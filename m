From: akpm@linux-foundation.org
Subject: + fs-gfs2-test-for-is_err-rather-than-0.patch added to -mm tree
Date: Tue, 25 Mar 2008 15:45:04 -0700
Message-ID: <200803252245.m2PMj5pR017432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753960AbYCYWqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:46:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, swhiteho@redhat.com


The patch titled
     fs/gfs2: test for IS_ERR rather than 0
has been added to the -mm tree.  Its filename is
     fs-gfs2-test-for-is_err-rather-than-0.patch

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


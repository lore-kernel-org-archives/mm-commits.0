From: akpm@linux-foundation.org
Subject: - fs-reiserfs-superc-correct-use-of-and.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:57 -0800
Message-ID: <200803050745.m257jvep021631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764266AbYCEHqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:46:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, chris.mason@oracle.com, jack@ucw.cz, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     fs/reiserfs/super.c: correct use of ! and &
has been removed from the -mm tree.  Its filename was
     fs-reiserfs-superc-correct-use-of-and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/reiserfs/super.c: correct use of ! and &
From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

This is not tested and clearly changes the semantics, so it is only
something to consider.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/super.c~fs-reiserfs-superc-correct-use-of-and fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~fs-reiserfs-superc-correct-use-of-and
+++ a/fs/reiserfs/super.c
@@ -2031,7 +2031,7 @@ static int reiserfs_quota_on(struct supe
 		return -EXDEV;
 	}
 	/* We must not pack tails for quota files on reiserfs for quota IO to work */
-	if (!REISERFS_I(nd.path.dentry->d_inode)->i_flags & i_nopack_mask) {
+	if (!(REISERFS_I(nd.path.dentry->d_inode)->i_flags & i_nopack_mask)) {
 		reiserfs_warning(sb,
 				 "reiserfs: Quota file must have tail packing disabled.");
 		path_put(&nd.path);
_

Patches currently in -mm which might be from julia@diku.dk are

sound-use-bug_on.patch
git-powerpc.patch
git-dvb.patch
git-hid.patch
git-udf.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
git-ocfs2.patch
drivers-block-viodasdc-use-field_sizeof.patch
usb-use-div_round_up.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
drivers-acpi-asus_acpic-correct-use-of-and.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch


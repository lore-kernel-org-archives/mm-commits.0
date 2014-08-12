From: akpm@linux-foundation.org
Subject: [merged] fs-hpfs-dnodec-fix-suspect-code-indent.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:39:40 -0700
Message-ID: <53ea6d7c.fOUzquND5EAW8LQy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:63995 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbaHLTjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:41 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so1919956obc.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mikulas@artax.karlin.mff.cuni.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hpfs/dnode.c: fix suspect code indent
has been removed from the -mm tree.  Its filename was
     fs-hpfs-dnodec-fix-suspect-code-indent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/hpfs/dnode.c: fix suspect code indent

Fix 2 checkpatch warnings:
"WARNING: suspect code indent for conditional statements"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/dnode.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN fs/hpfs/dnode.c~fs-hpfs-dnodec-fix-suspect-code-indent fs/hpfs/dnode.c
--- a/fs/hpfs/dnode.c~fs-hpfs-dnodec-fix-suspect-code-indent
+++ a/fs/hpfs/dnode.c
@@ -545,12 +545,13 @@ static void delete_empty_dnode(struct in
 			struct dnode *d1;
 			struct quad_buffer_head qbh1;
 			if (hpfs_sb(i->i_sb)->sb_chk)
-			    if (up != i->i_ino) {
-				hpfs_error(i->i_sb,
-					"bad pointer to fnode, dnode %08x, pointing to %08x, should be %08lx",
-					dno, up, (unsigned long)i->i_ino);
-				return;
-			    }
+				if (up != i->i_ino) {
+					hpfs_error(i->i_sb,
+						   "bad pointer to fnode, dnode %08x, pointing to %08x, should be %08lx",
+						   dno, up,
+						   (unsigned long)i->i_ino);
+					return;
+				}
 			if ((d1 = hpfs_map_dnode(i->i_sb, down, &qbh1))) {
 				d1->up = cpu_to_le32(up);
 				d1->root_dnode = 1;
@@ -1061,8 +1062,8 @@ struct hpfs_dirent *map_fnode_dirent(str
 		hpfs_brelse4(qbh);
 		if (hpfs_sb(s)->sb_chk)
 			if (hpfs_stop_cycles(s, dno, &c1, &c2, "map_fnode_dirent #1")) {
-			kfree(name2);
-			return NULL;
+				kfree(name2);
+				return NULL;
 		}
 		goto go_down;
 	}
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch


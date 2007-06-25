From: akpm@linux-foundation.org
Subject: - ext4-lost-brelse-in-ext4_read_inode.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:21:28 -0700
Message-ID: <200706250921.l5P9LSLk031118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60852 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbXFYJZO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:25:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dev@openvz.org, tytso@mit.edu, vvs@sw.ru, mm-commits@vger.kernel.org


The patch titled
     ext4: lost brelse in ext4_read_inode()
has been removed from the -mm tree.  Its filename was
     ext4-lost-brelse-in-ext4_read_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: lost brelse in ext4_read_inode()
From: Kirill Korotaev <dev@openvz.org>

One of error path in ext4_read_inode() leaks bh since brelse is forgoten.

Signed-off-by: Kirill Korotaev <dev@openvz.org>
Acked-by: Vasily Averin <vvs@sw.ru>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ext4/inode.c~ext4-lost-brelse-in-ext4_read_inode fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-lost-brelse-in-ext4_read_inode
+++ a/fs/ext4/inode.c
@@ -2673,8 +2673,10 @@ void ext4_read_inode(struct inode * inod
 		 */
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
-		    EXT4_INODE_SIZE(inode->i_sb))
+		    EXT4_INODE_SIZE(inode->i_sb)) {
+			brelse (bh);
 			goto bad_inode;
+		}
 		if (ei->i_extra_isize == 0) {
 			/* The extra space is currently unused. Use it. */
 			ei->i_extra_isize = sizeof(struct ext4_inode) -
_

Patches currently in -mm which might be from dev@openvz.org are

i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch

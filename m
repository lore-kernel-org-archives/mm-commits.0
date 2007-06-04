From: akpm@linux-foundation.org
Subject: + ext3-lost-brelse-in-ext3_read_inode.patch added to -mm tree
Date: Mon, 04 Jun 2007 13:50:15 -0700
Message-ID: <200706042050.l54KoFar018690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755367AbXFDUvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:51:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dev@openvz.org, vvs@sw.ru


The patch titled
     ext3: lost brelse in ext3_read_inode()
has been added to the -mm tree.  Its filename is
     ext3-lost-brelse-in-ext3_read_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3: lost brelse in ext3_read_inode()
From:Kirill Korotaev <dev@openvz.org>

One of error path in ext3_read_inode() leaks bh since brelse is forgoten.

Signed-off-by: Kirill Korotaev <dev@openvz.org>
Acked-by: Vasily Averin <vvs@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ext3/inode.c~ext3-lost-brelse-in-ext3_read_inode fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-lost-brelse-in-ext3_read_inode
+++ a/fs/ext3/inode.c
@@ -2677,8 +2677,10 @@ void ext3_read_inode(struct inode * inod
 		 */
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT3_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
-		    EXT3_INODE_SIZE(inode->i_sb))
+		    EXT3_INODE_SIZE(inode->i_sb)) {
+			brelse (bh);
 			goto bad_inode;
+		}
 		if (ei->i_extra_isize == 0) {
 			/* The extra space is currently unused. Use it. */
 			ei->i_extra_isize = sizeof(struct ext3_inode) -
_

Patches currently in -mm which might be from dev@openvz.org are

ext3-lost-brelse-in-ext3_read_inode.patch
ext4-lost-brelse-in-ext4_read_inode.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
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
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch

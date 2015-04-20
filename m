From: akpm@linux-foundation.org
Subject: [merged] fs-affs-affsh-add-mount-option-manipulation-macros.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:08 -0700
Message-ID: <55355168.o7bq+oE7jbAM1n0M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbbDTTNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/affs.h: add mount option manipulation macros
has been removed from the -mm tree.  Its filename was
     fs-affs-affsh-add-mount-option-manipulation-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/affs.h: add mount option manipulation macros

Add clear/set/test affs mount option macros.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/affs/affs.h~fs-affs-affsh-add-mount-option-manipulation-macros fs/affs/affs.h
--- a/fs/affs/affs.h~fs-affs-affsh-add-mount-option-manipulation-macros
+++ a/fs/affs/affs.h
@@ -119,6 +119,10 @@ struct affs_sb_info {
 #define AFFS_MOUNT_SF_VERBOSE		0x0800 /* Talk about fs when mounting */
 #define AFFS_MOUNT_SF_NO_TRUNCATE	0x1000 /* Don't truncate filenames */
 
+#define affs_clear_opt(o, opt)    (o &= ~AFFS_MOUNT_##opt)
+#define affs_set_opt(o, opt)      (o |= AFFS_MOUNT_##opt)
+#define affs_test_opt(o, opt)     ((o) & AFFS_MOUNT_##opt)
+
 /* short cut to get to the affs specific sb data */
 static inline struct affs_sb_info *AFFS_SB(struct super_block *sb)
 {
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch


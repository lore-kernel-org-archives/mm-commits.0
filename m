From: akpm@linux-foundation.org
Subject: - ext4-error-proc-entry-creation-when-the-fs-ext4-is-not-correctly-created.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:37:43 -0700
Message-ID: <200807162137.m6GLbhoY014414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755528AbYGPVqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shen@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     ext4: error proc entry creation when the fs/ext4 is not correctly created
has been removed from the -mm tree.  Its filename was
     ext4-error-proc-entry-creation-when-the-fs-ext4-is-not-correctly-created.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: error proc entry creation when the fs/ext4 is not correctly created
From: Shen Feng <shen@cn.fujitsu.com>

When the directory fs/ext4 is not correctly created under proc, the entry
under this directory should not be created.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/mballoc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/ext4/mballoc.c~ext4-error-proc-entry-creation-when-the-fs-ext4-is-not-correctly-created fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~ext4-error-proc-entry-creation-when-the-fs-ext4-is-not-correctly-created
+++ a/fs/ext4/mballoc.c
@@ -2785,6 +2785,10 @@ static int ext4_mb_init_per_dev_proc(str
 	struct proc_dir_entry *proc;
 	char devname[64];
 
+	if (proc_root_ext4 == NULL) {
+		sbi->s_mb_proc = NULL;
+		return -EINVAL;
+	}
 	bdevname(sb->s_bdev, devname);
 	sbi->s_mb_proc = proc_mkdir(devname, proc_root_ext4);
 
_

Patches currently in -mm which might be from shen@cn.fujitsu.com are

origin.patch
ext2-remove-double-definitions-of-xattr-macros.patch
ext3-improve-some-code-in-rb-tree-part-of-dirc.patch
ext3-remove-double-definitions-of-xattr-macros.patch
reiserfs-remove-double-definitions-of-xattr-macros.patch


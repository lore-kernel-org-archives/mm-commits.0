From: akpm@linux-foundation.org
Subject: [merged] const-mark-remaining-export_operations-const.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:37:06 -0700
Message-ID: <200909222037.n8MKb678031180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659AbZIVUmA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     const: mark remaining export_operations const
has been removed from the -mm tree.  Its filename was
     const-mark-remaining-export_operations-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: const: mark remaining export_operations const
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/super.c  |    2 +-
 fs/nilfs2/super.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/jffs2/super.c~const-mark-remaining-export_operations-const fs/jffs2/super.c
--- a/fs/jffs2/super.c~const-mark-remaining-export_operations-const
+++ a/fs/jffs2/super.c
@@ -123,7 +123,7 @@ static struct dentry *jffs2_get_parent(s
 	return d_obtain_alias(jffs2_iget(child->d_inode->i_sb, pino));
 }
 
-static struct export_operations jffs2_export_ops = {
+static const struct export_operations jffs2_export_ops = {
 	.get_parent = jffs2_get_parent,
 	.fh_to_dentry = jffs2_fh_to_dentry,
 	.fh_to_parent = jffs2_fh_to_parent,
diff -puN fs/nilfs2/super.c~const-mark-remaining-export_operations-const fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~const-mark-remaining-export_operations-const
+++ a/fs/nilfs2/super.c
@@ -560,7 +560,7 @@ nilfs_fh_to_parent(struct super_block *s
 				    nilfs_nfs_get_inode);
 }
 
-static struct export_operations nilfs_export_ops = {
+static const struct export_operations nilfs_export_ops = {
 	.fh_to_dentry = nilfs_fh_to_dentry,
 	.fh_to_parent = nilfs_fh_to_parent,
 	.get_parent = nilfs_get_parent,
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
acpi-switch-proc-acpi-debug_layerdebug_level-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
cpqarray-switch-to-seq_file.patch
dac960-switch-to-seq_file.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
viafb-switch-to-seq_file.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch
gru-use-proc_create.patch


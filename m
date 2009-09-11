From: akpm@linux-foundation.org
Subject: + const-mark-remaining-export_operations-const.patch added to -mm tree
Date: Fri, 11 Sep 2009 13:27:18 -0700
Message-ID: <200909112027.n8BKRIDF018670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527AbZIKU1g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 16:27:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     const: mark remaining export_operations const
has been added to the -mm tree.  Its filename is
     const-mark-remaining-export_operations-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
acpi-switch-proc-acpi-debug_layerdebug_level-to-seq_file.patch
pcmcia-switch-proc-bus-pccard-drivers-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
kernel-profilec-switch-proc-irq-prof_cpu_mask-to-seq_file.patch
cpqarray-switch-to-seq_file.patch
dac960-switch-to-seq_file.patch
const-make-struct-super_block-dq_op-const.patch
const-make-struct-super_block-s_qcop-const.patch
const-mark-remaining-super_operations-const.patch
const-mark-remaining-export_operations-const.patch
const-mark-remaining-address_space_operations-const.patch
const-mark-remaining-inode_operations-as-const.patch
const-make-file_lock_operations-const.patch
const-make-lock_manager_operations-const.patch
const-make-block_device_operations-const.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
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


From: akpm@linux-foundation.org
Subject: - proc-more-debugging-for-already-registered-case.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:55:35 -0700
Message-ID: <200809182055.m8IKtZoG019108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352AbYIRUzi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:55:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: more debugging for "already registered" case
has been removed from the -mm tree.  Its filename was
     proc-more-debugging-for-already-registered-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: more debugging for "already registered" case
From: Alexey Dobriyan <adobriyan@gmail.com>

Print parent directory name as well.

The aim is to catch non-creation of parent directory when proc_mkdir will
return NULL and all subsequent registrations go directly in /proc instead
of intended directory.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/generic.c~proc-more-debugging-for-already-registered-case fs/proc/generic.c
--- a/fs/proc/generic.c~proc-more-debugging-for-already-registered-case
+++ a/fs/proc/generic.c
@@ -547,8 +547,8 @@ static int proc_register(struct proc_dir
 
 	for (tmp = dir->subdir; tmp; tmp = tmp->next)
 		if (strcmp(tmp->name, dp->name) == 0) {
-			printk(KERN_WARNING "proc_dir_entry '%s' already "
-					"registered\n", dp->name);
+			printk(KERN_WARNING "proc_dir_entry '%s'/'%s' already "
+					"registered\n", dir->name, dp->name);
 			dump_stack();
 			break;
 		}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
tags-skip-in-filenames.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
ext4-fix-11321-create-proc-ext4-stats-et-al-more-carefully.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
compat_binfmt_elf-definition-tweak.patch
proc-move-sysrq-trigger-out-of-fs-proc.patch
proc-fix-return-value-of-proc_reg_open-in-too-late-case.patch
proc-proc_sys_root-tweak.patch
proc-remove-dummy-vmcore_open.patch
proc-remove-unused-get_dma_list.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch


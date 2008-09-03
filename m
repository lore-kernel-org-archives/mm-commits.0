From: akpm@linux-foundation.org
Subject: + proc-remove-dummy-vmcore_open.patch added to -mm tree
Date: Tue, 02 Sep 2008 17:34:10 -0700
Message-ID: <200809030034.m830YAHp020857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473AbYICAeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 20:34:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     proc: remove dummy vmcore_open()
has been added to the -mm tree.  Its filename is
     proc-remove-dummy-vmcore_open.patch

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
Subject: proc: remove dummy vmcore_open()
From: Alexey Dobriyan <adobriyan@gmail.com>

Empty ->open is equvivalent to always succeeding ->open.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN fs/proc/vmcore.c~proc-remove-dummy-vmcore_open fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~proc-remove-dummy-vmcore_open
+++ a/fs/proc/vmcore.c
@@ -162,14 +162,8 @@ static ssize_t read_vmcore(struct file *
 	return acc;
 }
 
-static int open_vmcore(struct inode *inode, struct file *filp)
-{
-	return 0;
-}
-
 const struct file_operations proc_vmcore_operations = {
 	.read		= read_vmcore,
-	.open		= open_vmcore,
 };
 
 static struct vmcore* __init get_new_element(void)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
less-softirq-vectors.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
compat_binfmt_elf-definition-tweak.patch
proc-move-sysrq-trigger-out-of-fs-proc.patch
proc-fix-return-value-of-proc_reg_open-in-too-late-case.patch
proc-proc_sys_root-tweak.patch
proc-remove-dummy-vmcore_open.patch
proc-remove-unused-get_dma_list.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-autofs-autofs4-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch


From: akpm@linux-foundation.org
Subject: + proc-fix-return-value-of-proc_reg_open-in-too-late-case.patch added to -mm tree
Date: Tue, 02 Sep 2008 16:27:04 -0700
Message-ID: <200809022327.m82NR4LH018285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541AbYIBX1g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 19:27:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     proc: fix return value of proc_reg_open() in "too late" case
has been added to the -mm tree.  Its filename is
     proc-fix-return-value-of-proc_reg_open-in-too-late-case.patch

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
Subject: proc: fix return value of proc_reg_open() in "too late" case
From: Alexey Dobriyan <adobriyan@gmail.com>

If ->open() wasn't called, returning 0 is misleading and, theoretically,
oopsable:
1. remove_proc_entry clears ->proc_fops, drops lock,
2. ->open "succeeds",
3. ->release oopses, because it assumes ->open was called (single_release()).

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/inode.c~proc-fix-return-value-of-proc_reg_open-in-too-late-case fs/proc/inode.c
--- a/fs/proc/inode.c~proc-fix-return-value-of-proc_reg_open-in-too-late-case
+++ a/fs/proc/inode.c
@@ -350,7 +350,7 @@ static int proc_reg_open(struct inode *i
 	if (!pde->proc_fops) {
 		spin_unlock(&pde->pde_unload_lock);
 		kfree(pdeo);
-		return rv;
+		return -EINVAL;
 	}
 	pde->pde_users++;
 	open = pde->proc_fops->open;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
less-softirq-vectors.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
proc-move-sysrq-trigger-out-of-fs-proc.patch
proc-fix-return-value-of-proc_reg_open-in-too-late-case.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-autofs-autofs4-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch


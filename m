From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-proc-remove-priv-argument-from-is_stack-fix.patch removed from -mm tree
Date: Fri, 08 Sep 2017 16:00:33 -0700
Message-ID: <59b32111.TTCbEz15fYd6Yetz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49436 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757210AbdIHXAe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:00:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mhocko@kernel.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, proc: remove unused variable
has been removed from the -mm tree.  Its filename was
     fs-proc-remove-priv-argument-from-is_stack-fix.patch

This patch was dropped because it was folded into fs-proc-remove-priv-argument-from-is_stack.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: fs, proc: remove unused variable

The last cleanup can go a little further, as shown by this warning:

fs/proc/task_mmu.c: In function 'show_map_vma':
fs/proc/task_mmu.c:285:28: error: unused variable 'priv' [-Werror=unused-variable]

Link: http://lkml.kernel.org/r/20170801120150.1520051-1-arnd@arndb.de
Fixes: 14ccc3193225 ("fs, proc: remove priv argument from is_stack")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/proc/task_mmu.c~fs-proc-remove-priv-argument-from-is_stack-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-remove-priv-argument-from-is_stack-fix
+++ a/fs/proc/task_mmu.c
@@ -301,7 +301,6 @@ show_map_vma(struct seq_file *m, struct
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
-	struct proc_maps_private *priv = m->private;
 	vm_flags_t flags = vma->vm_flags;
 	unsigned long ino = 0;
 	unsigned long long pgoff = 0;
_

Patches currently in -mm which might be from arnd@arndb.de are

fs-proc-remove-priv-argument-from-is_stack.patch


From: akpm@linux-foundation.org
Subject: [merged] procfs-remove-unused-variable.patch removed from
 -mm tree
Date: Fri, 15 Sep 2017 10:51:16 -0700
Message-ID: <20170915175116.7nISZObwb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35380 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdIORvR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2017 13:51:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: remove unused variable
has been removed from the -mm tree.  Its filename was
     procfs-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: procfs: remove unused variable

In NOMMU configurations, we get a warning about a variable that has become
unused:

fs/proc/task_nommu.c: In function 'nommu_vma_show':
fs/proc/task_nommu.c:148:28: error: unused variable 'priv' [-Werror=unused-variable]

Link: http://lkml.kernel.org/r/20170911200231.3171415-1-arnd@arndb.de
Fixes: 1240ea0dc3bb ("fs, proc: remove priv argument from is_stack")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/proc/task_nommu.c~procfs-remove-unused-variable fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~procfs-remove-unused-variable
+++ a/fs/proc/task_nommu.c
@@ -145,7 +145,6 @@ static int nommu_vma_show(struct seq_fil
 			  int is_pid)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	struct proc_maps_private *priv = m->private;
 	unsigned long ino = 0;
 	struct file *file;
 	dev_t dev = 0;
_

Patches currently in -mm which might be from arnd@arndb.de are

iopoll-avoid-wint-in-bool-context-warning.patch


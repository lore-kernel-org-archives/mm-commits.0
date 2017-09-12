From: akpm@linux-foundation.org
Subject: + procfs-remove-unused-variable.patch added to -mm tree
Date: Tue, 12 Sep 2017 16:13:40 -0700
Message-ID: <59b86a24.aNtfShaLGgsr52qr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53068 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751529AbdILXNl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2017 19:13:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: remove unused variable
has been added to the -mm tree.  Its filename is
     procfs-remove-unused-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-remove-unused-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-remove-unused-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

procfs-remove-unused-variable.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch
iopoll-avoid-wint-in-bool-context-warning.patch


From: akpm@linux-foundation.org
Subject: [patch 3/9] procfs: remove unused variable
Date: Wed, 13 Sep 2017 16:28:17 -0700
Message-ID: <59b9bf11.4++OcvwWvNP1Y/g0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdIMX2S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2017 19:28:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de, mhocko@suse.com

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

From: akpm@linux-foundation.org
Subject: + shm-remove-unneeded-extern-for-function.patch added to -mm tree
Date: Wed, 18 Jun 2014 16:00:16 -0700
Message-ID: <53a21a00.ZDyoFKrusXApLhpR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbaFRXAR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 19:00:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, miltonm@bga.com, manfred@colorfullife.com, davidlohr@hp.com, anton@samba.org, millerjo@us.ibm.com


The patch titled
     Subject: shm: remove unneeded extern for function
has been added to the -mm tree.  Its filename is
     shm-remove-unneeded-extern-for-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shm-remove-unneeded-extern-for-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shm-remove-unneeded-extern-for-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jack Miller <millerjo@us.ibm.com>
Subject: shm: remove unneeded extern for function

A small cleanup while changing adjacent code.  Extern is not needed for
functions and only one declaration had it so remove it from the odd line.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Jack Miller <millerjo@us.ibm.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/shm.h~shm-remove-unneeded-extern-for-function include/linux/shm.h
--- a/include/linux/shm.h~shm-remove-unneeded-extern-for-function
+++ a/include/linux/shm.h
@@ -52,7 +52,7 @@ struct sysv_shm {
 
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr,
 	      unsigned long shmlba);
-extern int is_file_shm_hugepages(struct file *file);
+int is_file_shm_hugepages(struct file *file);
 void exit_shm(struct task_struct *task);
 #define shm_init_task(task) INIT_LIST_HEAD(&(task)->sysvshm.shm_clist)
 #else
_

Patches currently in -mm which might be from millerjo@us.ibm.com are

shm-make-exit_shm-work-proportional-to-task-activity.patch
shm-allow-exit_shm-in-parallel-if-only-marking-orphans.patch
shm-remove-unneeded-extern-for-function.patch


From: akpm@linux-foundation.org
Subject: [merged] shm-remove-unneeded-extern-for-function.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:41:34 -0700
Message-ID: <53ea6dee.6HZTaIRecfeeEv+S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f74.google.com ([209.85.192.74]:49560 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbaHLTlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:35 -0400
Received: by mail-qg0-f74.google.com with SMTP id z60so1312412qgd.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: millerjo@us.ibm.com, anton@samba.org, davidlohr@hp.com, manfred@colorfullife.com, miltonm@bga.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shm: remove unneeded extern for function
has been removed from the -mm tree.  Its filename was
     shm-remove-unneeded-extern-for-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch


From: akpm@linux-foundation.org
Subject: [merged] ipc-shm-is_file_shm_hugepages-can-be-boolean.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 15:28:33 -0800
Message-ID: <56a169a1.ctw3oRfRju3woKry%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbcAUX2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:28:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm.c: is_file_shm_hugepages() can be boolean
has been removed from the -mm tree.  Its filename was
     ipc-shm-is_file_shm_hugepages-can-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: ipc/shm.c: is_file_shm_hugepages() can be boolean

Make is_file_shm_hugepages() return bool to improve readability due to
this particular function only using either one or zero as its return
value.

No functional change.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shm.h |    6 +++---
 ipc/shm.c           |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/shm.h~ipc-shm-is_file_shm_hugepages-can-be-boolean include/linux/shm.h
--- a/include/linux/shm.h~ipc-shm-is_file_shm_hugepages-can-be-boolean
+++ a/include/linux/shm.h
@@ -52,7 +52,7 @@ struct sysv_shm {
 
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr,
 	      unsigned long shmlba);
-int is_file_shm_hugepages(struct file *file);
+bool is_file_shm_hugepages(struct file *file);
 void exit_shm(struct task_struct *task);
 #define shm_init_task(task) INIT_LIST_HEAD(&(task)->sysvshm.shm_clist)
 #else
@@ -66,9 +66,9 @@ static inline long do_shmat(int shmid, c
 {
 	return -ENOSYS;
 }
-static inline int is_file_shm_hugepages(struct file *file)
+static inline bool is_file_shm_hugepages(struct file *file)
 {
-	return 0;
+	return false;
 }
 static inline void exit_shm(struct task_struct *task)
 {
diff -puN ipc/shm.c~ipc-shm-is_file_shm_hugepages-can-be-boolean ipc/shm.c
--- a/ipc/shm.c~ipc-shm-is_file_shm_hugepages-can-be-boolean
+++ a/ipc/shm.c
@@ -459,7 +459,7 @@ static const struct file_operations shm_
 	.fallocate	= shm_fallocate,
 };
 
-int is_file_shm_hugepages(struct file *file)
+bool is_file_shm_hugepages(struct file *file)
 {
 	return file->f_op == &shm_file_operations_huge;
 }
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are



From: akpm@linux-foundation.org
Subject: + ipc-shm-is_file_shm_hugepages-can-be-boolean.patch added to -mm tree
Date: Tue, 17 Nov 2015 15:51:09 -0800
Message-ID: <564bbd6d.KjW6KMrzQUbLhDgP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbbKQXvJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 18:51:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm.c: is_file_shm_hugepages() can be boolean
has been added to the -mm tree.  Its filename is
     ipc-shm-is_file_shm_hugepages-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-shm-is_file_shm_hugepages-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-shm-is_file_shm_hugepages-can-be-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-statc-drop-the-last-new_valid_dev-check.patch
include-linux-kdev_th-remove-new_valid_dev.patch
ipc-shm-is_file_shm_hugepages-can-be-boolean.patch


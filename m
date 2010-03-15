From: akpm@linux-foundation.org
Subject: [merged] copy_signal-cleanup-kill-taskstats_tgid_init-and-acct_init_pacct.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:22 -0400
Message-ID: <201003150701.o2F71t3i016823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935850Ab0COHCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vfalico@redhat.com, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     copy_signal() cleanup: kill taskstats_tgid_init() and acct_init_pacct()
has been removed from the -mm tree.  Its filename was
     copy_signal-cleanup-kill-taskstats_tgid_init-and-acct_init_pacct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: copy_signal() cleanup: kill taskstats_tgid_init() and acct_init_pacct()
From: Veaceslav Falico <vfalico@redhat.com>

Kill unused functions taskstats_tgid_init() and acct_init_pacct() because
we don't use them anywhere after using kmem_cache_zalloc() in
copy_signal().

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/acct.h           |    2 --
 include/linux/taskstats_kern.h |    7 -------
 kernel/acct.c                  |   10 ----------
 3 files changed, 19 deletions(-)

diff -puN include/linux/acct.h~copy_signal-cleanup-kill-taskstats_tgid_init-and-acct_init_pacct include/linux/acct.h
--- a/include/linux/acct.h~copy_signal-cleanup-kill-taskstats_tgid_init-and-acct_init_pacct
+++ a/include/linux/acct.h
@@ -123,14 +123,12 @@ struct pacct_struct;
 struct pid_namespace;
 extern void acct_auto_close_mnt(struct vfsmount *m);
 extern void acct_auto_close(struct super_block *sb);
-extern void acct_init_pacct(struct pacct_struct *pacct);
 extern void acct_collect(long exitcode, int group_dead);
 extern void acct_process(void);
 extern void acct_exit_ns(struct pid_namespace *);
 #else
 #define acct_auto_close_mnt(x)	do { } while (0)
 #define acct_auto_close(x)	do { } while (0)
-#define acct_init_pacct(x)	do { } while (0)
 #define acct_collect(x,y)	do { } while (0)
 #define acct_process()		do { } while (0)
 #define acct_exit_ns(ns)	do { } while (0)
diff -puN include/linux/taskstats_kern.h~copy_signal-cleanup-kill-taskstats_tgid_init-and-acct_init_pacct include/linux/taskstats_kern.h
--- a/include/linux/taskstats_kern.h~copy_signal-cleanup-kill-taskstats_tgid_init-and-acct_init_pacct
+++ a/include/linux/taskstats_kern.h
@@ -14,11 +14,6 @@
 extern struct kmem_cache *taskstats_cache;
 extern struct mutex taskstats_exit_mutex;
 
-static inline void taskstats_tgid_init(struct signal_struct *sig)
-{
-	sig->stats = NULL;
-}
-
 static inline void taskstats_tgid_free(struct signal_struct *sig)
 {
 	if (sig->stats)
@@ -30,8 +25,6 @@ extern void taskstats_init_early(void);
 #else
 static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
 {}
-static inline void taskstats_tgid_init(struct signal_struct *sig)
-{}
 static inline void taskstats_tgid_free(struct signal_struct *sig)
 {}
 static inline void taskstats_init_early(void)
diff -puN kernel/acct.c~copy_signal-cleanup-kill-taskstats_tgid_init-and-acct_init_pacct kernel/acct.c
--- a/kernel/acct.c~copy_signal-cleanup-kill-taskstats_tgid_init-and-acct_init_pacct
+++ a/kernel/acct.c
@@ -588,16 +588,6 @@ out:
 }
 
 /**
- * acct_init_pacct - initialize a new pacct_struct
- * @pacct: per-process accounting info struct to initialize
- */
-void acct_init_pacct(struct pacct_struct *pacct)
-{
-	memset(pacct, 0, sizeof(struct pacct_struct));
-	pacct->ac_utime = pacct->ac_stime = cputime_zero;
-}

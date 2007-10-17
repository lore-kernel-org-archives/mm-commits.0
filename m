From: akpm@linux-foundation.org
Subject: + fix-build-breakage-if-sysfs.patch added to -mm tree
Date: Wed, 17 Oct 2007 14:46:46 -0700
Message-ID: <200710172146.l9HLkkVM009940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47942 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430AbXJQVrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 17:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhaval@linux.vnet.ibm.com, mingo@elte.hu, vatsa@linux.vnet.ibm.com


The patch titled
     sched: fix build breakage if !SYSFS
has been added to the -mm tree.  Its filename is
     fix-build-breakage-if-sysfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: fix build breakage if !SYSFS
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>

When CONFIG_SYSFS is not set, CONFIG_FAIR_USER_SCHED fails to build
with

kernel/built-in.o: In function `uids_kobject_init':
(.init.text+0x1488): undefined reference to `kernel_subsys'
kernel/built-in.o: In function `uids_kobject_init':
(.init.text+0x1490): undefined reference to `kernel_subsys'
kernel/built-in.o: In function `uids_kobject_init':
(.init.text+0x1480): undefined reference to `kernel_subsys'
kernel/built-in.o: In function `uids_kobject_init':
(.init.text+0x1494): undefined reference to `kernel_subsys'

This patch fixes this build error.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 ++
 kernel/user.c         |   23 +++++++++++++++--------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff -puN include/linux/sched.h~fix-build-breakage-if-sysfs include/linux/sched.h
--- a/include/linux/sched.h~fix-build-breakage-if-sysfs
+++ a/include/linux/sched.h
@@ -535,10 +535,12 @@ struct user_struct {
 
 #ifdef CONFIG_FAIR_USER_SCHED
 	struct task_group *tg;
+#ifdef CONFIG_SYSFS
 	struct kset kset;
 	struct subsys_attribute user_attr;
 	struct work_struct work;
 #endif
+#endif
 };
 
 #ifdef CONFIG_FAIR_USER_SCHED
diff -puN kernel/user.c~fix-build-breakage-if-sysfs kernel/user.c
--- a/kernel/user.c~fix-build-breakage-if-sysfs
+++ a/kernel/user.c
@@ -84,9 +84,6 @@ static struct user_struct *uid_hash_find
 
 #ifdef CONFIG_FAIR_USER_SCHED
 
-static struct kobject uids_kobject; /* represents /sys/kernel/uids directory */
-static DEFINE_MUTEX(uids_mutex);
-
 static void sched_destroy_user(struct user_struct *up)
 {
 	sched_destroy_group(up->tg);
@@ -108,6 +105,19 @@ static void sched_switch_user(struct tas
 	sched_move_task(p);
 }
 
+#else	/* CONFIG_FAIR_USER_SCHED */
+
+static void sched_destroy_user(struct user_struct *up) { }
+static int sched_create_user(struct user_struct *up) { return 0; }
+static void sched_switch_user(struct task_struct *p) { }
+
+#endif	/* CONFIG_FAIR_USER_SCHED */
+
+#if defined(CONFIG_FAIR_USER_SCHED) && defined(CONFIG_SYSFS)
+
+static struct kobject uids_kobject; /* represents /sys/kernel/uids directory */
+static DEFINE_MUTEX(uids_mutex);
+
 static inline void uids_mutex_lock(void)
 {
 	mutex_lock(&uids_mutex);
@@ -254,11 +264,8 @@ static inline void free_user(struct user
 	schedule_work(&up->work);
 }
 
-#else	/* CONFIG_FAIR_USER_SCHED */
+#else	/* CONFIG_FAIR_USER_SCHED && CONFIG_SYSFS */
 
-static void sched_destroy_user(struct user_struct *up) { }
-static int sched_create_user(struct user_struct *up) { return 0; }
-static void sched_switch_user(struct task_struct *p) { }
 static inline int user_kobject_create(struct user_struct *up) { return 0; }
 static inline void uids_mutex_lock(void) { }
 static inline void uids_mutex_unlock(void) { }
@@ -277,7 +284,7 @@ static inline void free_user(struct user
 	kmem_cache_free(uid_cachep, up);
 }
 
-#endif	/* CONFIG_FAIR_USER_SCHED */
+#endif
 
 /*
  * Locate the user_struct for the passed UID.  If found, take a ref on it.  The
_

Patches currently in -mm which might be from dhaval@linux.vnet.ibm.com are

origin.patch
fix-build-breakage-if-sysfs.patch
fix-build-breakage-if-sysfs-fix.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch

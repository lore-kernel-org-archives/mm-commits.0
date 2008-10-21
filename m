From: akpm@linux-foundation.org
Subject: + cgroups-tiny-cleanups.patch added to -mm tree
Date: Tue, 21 Oct 2008 12:13:32 -0700
Message-ID: <200810211913.m9LJDWDO031234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbYJUTOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 15:14:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroups: tiny cleanups
has been added to the -mm tree.  Its filename is
     cgroups-tiny-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: tiny cleanups
From: Li Zefan <lizf@cn.fujitsu.com>

- remove 'private' field from struct subsys
- remove cgroup_init_smp()
- remove unused 'i' in cgroup_tasks_start()

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    4 ----
 kernel/cgroup.c        |    1 -
 2 files changed, 5 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-tiny-cleanups include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-tiny-cleanups
+++ a/include/linux/cgroup.h
@@ -25,7 +25,6 @@ struct cgroup;
 
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
-extern void cgroup_init_smp(void);
 extern void cgroup_lock(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
@@ -348,8 +347,6 @@ struct cgroup_subsys {
 	struct cgroupfs_root *root;
 
 	struct list_head sibling;
-
-	void *private;
 };
 
 #define SUBSYS(_x) extern struct cgroup_subsys _x ## _subsys;
@@ -410,7 +407,6 @@ void cgroup_mm_owner_callbacks(struct ta
 
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
-static inline void cgroup_init_smp(void) {}
 static inline void cgroup_fork(struct task_struct *p) {}
 static inline void cgroup_fork_callbacks(struct task_struct *p) {}
 static inline void cgroup_post_fork(struct task_struct *p) {}
diff -puN kernel/cgroup.c~cgroups-tiny-cleanups kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-tiny-cleanups
+++ a/kernel/cgroup.c
@@ -2107,7 +2107,6 @@ static void *cgroup_tasks_start(struct s
 	down_read(&cgrp->pids_mutex);
 	if (pid) {
 		int end = cgrp->pids_length;
-		int i;
 		while (index < end) {
 			int mid = (index + end) / 2;
 			if (cgrp->tasks_pids[mid] == pid) {
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
cgroups-tiny-cleanups.patch


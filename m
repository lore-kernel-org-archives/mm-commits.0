From: akpm@linux-foundation.org
Subject: [merged] proc-spread-__ro_after_init.patch removed from
 -mm tree
Date: Wed, 07 Feb 2018 11:56:15 -0800
Message-ID: <20180207195615.CbfHOhisZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58280 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754337AbeBGT4Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:56:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc: use __ro_after_init
has been removed from the -mm tree.  Its filename was
     proc-spread-__ro_after_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/proc: use __ro_after_init

/proc/self inode numbers, value of proc_inode_cache and st_nlink of
/proc/$TGID are fixed constants.

Link: http://lkml.kernel.org/r/20180103184707.GA31849@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c        |    5 +++--
 fs/proc/inode.c       |    3 ++-
 fs/proc/self.c        |    3 ++-
 fs/proc/thread_self.c |    3 ++-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/proc/base.c~proc-spread-__ro_after_init fs/proc/base.c
--- a/fs/proc/base.c~proc-spread-__ro_after_init
+++ a/fs/proc/base.c
@@ -75,6 +75,7 @@
 #include <linux/ptrace.h>
 #include <linux/tracehook.h>
 #include <linux/printk.h>
+#include <linux/cache.h>
 #include <linux/cgroup.h>
 #include <linux/cpuset.h>
 #include <linux/audit.h>
@@ -112,8 +113,8 @@
  *	in /proc for a task before it execs a suid executable.
  */
 
-static u8 nlink_tid;
-static u8 nlink_tgid;
+static u8 nlink_tid __ro_after_init;
+static u8 nlink_tgid __ro_after_init;
 
 struct pid_entry {
 	const char *name;
diff -puN fs/proc/inode.c~proc-spread-__ro_after_init fs/proc/inode.c
--- a/fs/proc/inode.c~proc-spread-__ro_after_init
+++ a/fs/proc/inode.c
@@ -5,6 +5,7 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
 
+#include <linux/cache.h>
 #include <linux/time.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
@@ -52,7 +53,7 @@ static void proc_evict_inode(struct inod
 	}
 }
 
-static struct kmem_cache * proc_inode_cachep;
+static struct kmem_cache *proc_inode_cachep __ro_after_init;
 
 static struct inode *proc_alloc_inode(struct super_block *sb)
 {
diff -puN fs/proc/self.c~proc-spread-__ro_after_init fs/proc/self.c
--- a/fs/proc/self.c~proc-spread-__ro_after_init
+++ a/fs/proc/self.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/cache.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/pid_namespace.h>
@@ -30,7 +31,7 @@ static const struct inode_operations pro
 	.get_link	= proc_self_get_link,
 };
 
-static unsigned self_inum;
+static unsigned self_inum __ro_after_init;
 
 int proc_setup_self(struct super_block *s)
 {
diff -puN fs/proc/thread_self.c~proc-spread-__ro_after_init fs/proc/thread_self.c
--- a/fs/proc/thread_self.c~proc-spread-__ro_after_init
+++ a/fs/proc/thread_self.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/cache.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/pid_namespace.h>
@@ -30,7 +31,7 @@ static const struct inode_operations pro
 	.get_link	= proc_thread_self_get_link,
 };
 
-static unsigned thread_self_inum;
+static unsigned thread_self_inum __ro_after_init;
 
 int proc_setup_thread_self(struct super_block *s)
 {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

seq_file-delete-small-value-optimization.patch


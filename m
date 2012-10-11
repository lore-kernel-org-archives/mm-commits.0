From: akpm@linux-foundation.org
Subject: [merged] lglock-add-define_static_lglock.patch removed from -mm tree
Date: Thu, 11 Oct 2012 13:59:37 -0700
Message-ID: <20121011205937.A64EE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:54259 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab2JKU7i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 16:59:38 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so270416qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 13:59:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, ak@linux.intel.com, rusty@rustcorp.com.au, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lglock: add DEFINE_STATIC_LGLOCK()
has been removed from the -mm tree.  Its filename was
     lglock-add-define_static_lglock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: lglock: add DEFINE_STATIC_LGLOCK()

When the lglock doesn't need to be exported we can use
DEFINE_STATIC_LGLOCK().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c        |    2 +-
 include/linux/lglock.h |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/file_table.c~lglock-add-define_static_lglock fs/file_table.c
--- a/fs/file_table.c~lglock-add-define_static_lglock
+++ a/fs/file_table.c
@@ -36,7 +36,7 @@ struct files_stat_struct files_stat = {
 	.max_files = NR_FILE
 };
 
-DEFINE_LGLOCK(files_lglock);
+DEFINE_STATIC_LGLOCK(files_lglock);
 
 /* SLAB cache for file structures */
 static struct kmem_cache *filp_cachep __read_mostly;
diff -puN include/linux/lglock.h~lglock-add-define_static_lglock include/linux/lglock.h
--- a/include/linux/lglock.h~lglock-add-define_static_lglock
+++ a/include/linux/lglock.h
@@ -32,7 +32,8 @@
 #define br_write_lock(name)	lg_global_lock(name)
 #define br_write_unlock(name)	lg_global_unlock(name)
 
-#define DEFINE_BRLOCK(name)	DEFINE_LGLOCK(name)
+#define DEFINE_BRLOCK(name)		DEFINE_LGLOCK(name)
+#define DEFINE_STATIC_BRLOCK(name)	DEFINE_STATIC_LGLOCK(name)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define LOCKDEP_INIT_MAP lockdep_init_map
@@ -53,6 +54,11 @@ struct lglock {
 	= __ARCH_SPIN_LOCK_UNLOCKED;					\
 	struct lglock name = { .lock = &name ## _lock }
 
+#define DEFINE_STATIC_LGLOCK(name)					\
+	static DEFINE_PER_CPU(arch_spinlock_t, name ## _lock)		\
+	= __ARCH_SPIN_LOCK_UNLOCKED;					\
+	static struct lglock name = { .lock = &name ## _lock }
+
 void lg_lock_init(struct lglock *lg, char *name);
 void lg_local_lock(struct lglock *lg);
 void lg_local_unlock(struct lglock *lg);
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch


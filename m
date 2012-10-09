From: akpm@linux-foundation.org
Subject: + lglock-add-define_static_lglock.patch added to -mm tree
Date: Tue, 09 Oct 2012 14:49:54 -0700
Message-ID: <20121009214955.0643B1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:65406 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab2JIVt4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 17:49:56 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so700581qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 14:49:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, ak@linux.intel.com, rusty@rustcorp.com.au, viro@zeniv.linux.org.uk


The patch titled
     Subject: lglock: add DEFINE_STATIC_LGLOCK()
has been added to the -mm tree.  Its filename is
     lglock-add-define_static_lglock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
lglock-remove-unused-define_lglock_lockdep.patch
lglock-make-the-per_cpu-locks-static.patch
lglock-add-define_static_lglock.patch


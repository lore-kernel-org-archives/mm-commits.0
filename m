From: akpm@linux-foundation.org
Subject: [merged] consolidate-warn_once-static-variables.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:17 -0700
Message-ID: <20120326192817.6BCA5A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:39289 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab2CZT2S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:18 -0400
Received: by mail-wi0-f202.google.com with SMTP id hj13so233174wib.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@suse.com, jbeulich@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: consolidate WARN_...ONCE() static variables
has been removed from the -mm tree.  Its filename was
     consolidate-warn_once-static-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Jan Beulich" <JBeulich@suse.com>
Subject: consolidate WARN_...ONCE() static variables

Due to the alignment of following variables, these typically consume more
than just the single byte that 'bool' requires, and as there are a few
hundred instances, the cache pollution (not so much the waste of memory)
sums up.  Put these variables into their own section, outside of any half
way frequently used memory range.

Do the same also to the __warned variable of rcu_lockdep_assert(). 
(Don't, however, include the ones used by printk_once() and alike, as they
can potentially be hot.)

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h         |    6 +++---
 include/asm-generic/vmlinux.lds.h |    1 +
 include/linux/rcupdate.h          |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/bug.h~consolidate-warn_once-static-variables include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~consolidate-warn_once-static-variables
+++ a/include/asm-generic/bug.h
@@ -134,7 +134,7 @@ extern void warn_slowpath_null(const cha
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
-	static bool __warned;					\
+	static bool __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
@@ -144,7 +144,7 @@ extern void warn_slowpath_null(const cha
 })
 
 #define WARN_ONCE(condition, format...)	({			\
-	static bool __warned;					\
+	static bool __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
@@ -154,7 +154,7 @@ extern void warn_slowpath_null(const cha
 })
 
 #define WARN_TAINT_ONCE(condition, taint, format...)	({	\
-	static bool __warned;					\
+	static bool __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
diff -puN include/asm-generic/vmlinux.lds.h~consolidate-warn_once-static-variables include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~consolidate-warn_once-static-variables
+++ a/include/asm-generic/vmlinux.lds.h
@@ -167,6 +167,7 @@
 	CPU_KEEP(exit.data)						\
 	MEM_KEEP(init.data)						\
 	MEM_KEEP(exit.data)						\
+	*(.data.unlikely)						\
 	STRUCT_ALIGN();							\
 	*(__tracepoints)						\
 	/* implement dynamic printk debug */				\
diff -puN include/linux/rcupdate.h~consolidate-warn_once-static-variables include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~consolidate-warn_once-static-variables
+++ a/include/linux/rcupdate.h
@@ -418,7 +418,7 @@ extern int rcu_my_thread_group_empty(voi
  */
 #define rcu_lockdep_assert(c, s)					\
 	do {								\
-		static bool __warned;					\
+		static bool __section(.data.unlikely) __warned;		\
 		if (debug_lockdep_rcu_enabled() && !__warned && !(c)) {	\
 			__warned = true;				\
 			lockdep_rcu_suspicious(__FILE__, __LINE__, s);	\
_

Patches currently in -mm which might be from JBeulich@suse.com are

origin.patch
linux-next.patch


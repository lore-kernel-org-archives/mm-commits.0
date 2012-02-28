From: akpm@linux-foundation.org
Subject: + consolidate-warn_once-static-variables.patch added to -mm tree
Date: Mon, 27 Feb 2012 16:03:06 -0800
Message-ID: <20120228000306.B1D71A02DD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37523 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab2B1ADJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 19:03:09 -0500
Received: by eaaf13 with SMTP id f13so184152eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 16:03:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@suse.com, jbeulich@suse.com


The patch titled
     Subject: consolidate WARN_...ONCE() static variables
has been added to the -mm tree.  Its filename is
     consolidate-warn_once-static-variables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -419,7 +419,7 @@ extern int rcu_my_thread_group_empty(voi
  */
 #define rcu_lockdep_assert(c, s)					\
 	do {								\
-		static bool __warned;					\
+		static bool __section(.data.unlikely) __warned;		\
 		if (debug_lockdep_rcu_enabled() && !__warned && !(c)) {	\
 			__warned = true;				\
 			lockdep_rcu_suspicious(__FILE__, __LINE__, s);	\
_
Subject: Subject: consolidate WARN_...ONCE() static variables

Patches currently in -mm which might be from JBeulich@suse.com are

linux-next.patch
consolidate-warn_once-static-variables.patch


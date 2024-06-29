Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C4BBE47
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628248; cv=none; b=mRs9TOPGwPRtRe+LodL/zW/5zX7xAPAWdurfEdN5fnvy2nEe43G8NquP1fPcmLRHhq7cw9hoMpN2h+IZNeBppvm3Tag9UplA0Msb85JSYp0O1lPicRMD+PoGZiltE+Mp+332gTGRqw/ZL7D05V7i3TSnIze7WZ1hc8jrZJa0zZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628248; c=relaxed/simple;
	bh=grdow22WXlgfBBgeco2hdPdJq9dg3Odm+lkgO4S1Pj4=;
	h=Date:To:From:Subject:Message-Id; b=maKcrDN0g42tVDLQ0kDfrZI9/LZGEGeuJrt0Czlbz8PB/gdZUY//mtJHgX4JxHm3j6wRzp/+G149NhRunDaVFJbAkcaiGpcKaY/vDwVPR/Z1zqXe+tvTOhv5Rzk4iocc484Dd5+CGIKgRnG9tiiMaVVghYrXcu5+DQyywmzMNQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2XCs+Zzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2XCs+Zzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918ADC116B1;
	Sat, 29 Jun 2024 02:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628248;
	bh=grdow22WXlgfBBgeco2hdPdJq9dg3Odm+lkgO4S1Pj4=;
	h=Date:To:From:Subject:From;
	b=2XCs+Zzpb0t8RqUphGEM54C1AWA7IZJmDijLhZFPbJe5Zw1syzW187e9tCWFu2A5Q
	 LBEphsrDn4UKSQiGbJK6WhjFbRDFIJoPgo1gFRptadS7J9W+YFhvR0nim+Be4VtEq/
	 imm1dL3sdrh2etobfw2IwqOqvoKUd80Us5ThEIA4=
Date: Fri, 28 Jun 2024 19:30:48 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-allow-disabling-kmsan-checks-for-the-current-task.patch removed from -mm tree
Message-Id: <20240629023048.918ADC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: allow disabling KMSAN checks for the current task
has been removed from the -mm tree.  Its filename was
     kmsan-allow-disabling-kmsan-checks-for-the-current-task.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: allow disabling KMSAN checks for the current task
Date: Fri, 21 Jun 2024 13:34:55 +0200

Like for KASAN, it's useful to temporarily disable KMSAN checks around,
e.g., redzone accesses.  Introduce kmsan_disable_current() and
kmsan_enable_current(), which are similar to their KASAN counterparts.

Make them reentrant in order to handle memory allocations in interrupt
context.  Repurpose the allow_reporting field for this.

Link: https://lkml.kernel.org/r/20240621113706.315500-12-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kmsan.rst |   11 +++++++++--
 include/linux/kmsan.h             |   24 ++++++++++++++++++++++++
 include/linux/kmsan_types.h       |    2 +-
 mm/kmsan/core.c                   |    1 -
 mm/kmsan/hooks.c                  |   18 +++++++++++++++---
 mm/kmsan/report.c                 |    7 ++++---
 tools/objtool/check.c             |    2 ++
 7 files changed, 55 insertions(+), 10 deletions(-)

--- a/Documentation/dev-tools/kmsan.rst~kmsan-allow-disabling-kmsan-checks-for-the-current-task
+++ a/Documentation/dev-tools/kmsan.rst
@@ -110,6 +110,13 @@ in the Makefile. Think of this as applyi
 function in the file or directory. Most users won't need KMSAN_SANITIZE, unless
 their code gets broken by KMSAN (e.g. runs at early boot time).
 
+KMSAN checks can also be temporarily disabled for the current task using
+``kmsan_disable_current()`` and ``kmsan_enable_current()`` calls. Each
+``kmsan_enable_current()`` call must be preceded by a
+``kmsan_disable_current()`` call; these call pairs may be nested. One needs to
+be careful with these calls, keeping the regions short and preferring other
+ways to disable instrumentation, where possible.
+
 Support
 =======
 
@@ -338,11 +345,11 @@ Per-task KMSAN state
 ~~~~~~~~~~~~~~~~~~~~
 
 Every task_struct has an associated KMSAN task state that holds the KMSAN
-context (see above) and a per-task flag disallowing KMSAN reports::
+context (see above) and a per-task counter disallowing KMSAN reports::
 
   struct kmsan_context {
     ...
-    bool allow_reporting;
+    unsigned int depth;
     struct kmsan_context_state cstate;
     ...
   }
--- a/include/linux/kmsan.h~kmsan-allow-disabling-kmsan-checks-for-the-current-task
+++ a/include/linux/kmsan.h
@@ -239,6 +239,22 @@ void kmsan_unpoison_entry_regs(const str
  */
 void *kmsan_get_metadata(void *addr, bool is_origin);
 
+/**
+ * kmsan_enable_current(): Enable KMSAN for the current task.
+ *
+ * Each kmsan_enable_current() current call must be preceded by a
+ * kmsan_disable_current() call. These call pairs may be nested.
+ */
+void kmsan_enable_current(void);
+
+/**
+ * kmsan_disable_current(): Disable KMSAN for the current task.
+ *
+ * Each kmsan_disable_current() current call must be followed by a
+ * kmsan_enable_current() call. These call pairs may be nested.
+ */
+void kmsan_disable_current(void);
+
 #else
 
 static inline void kmsan_init_shadow(void)
@@ -338,6 +354,14 @@ static inline void kmsan_unpoison_entry_
 {
 }
 
+static inline void kmsan_enable_current(void)
+{
+}
+
+static inline void kmsan_disable_current(void)
+{
+}
+
 #endif
 
 #endif /* _LINUX_KMSAN_H */
--- a/include/linux/kmsan_types.h~kmsan-allow-disabling-kmsan-checks-for-the-current-task
+++ a/include/linux/kmsan_types.h
@@ -31,7 +31,7 @@ struct kmsan_context_state {
 struct kmsan_ctx {
 	struct kmsan_context_state cstate;
 	int kmsan_in_runtime;
-	bool allow_reporting;
+	unsigned int depth;
 };
 
 #endif /* _LINUX_KMSAN_TYPES_H */
--- a/mm/kmsan/core.c~kmsan-allow-disabling-kmsan-checks-for-the-current-task
+++ a/mm/kmsan/core.c
@@ -43,7 +43,6 @@ void kmsan_internal_task_create(struct t
 	struct thread_info *info = current_thread_info();
 
 	__memset(ctx, 0, sizeof(*ctx));
-	ctx->allow_reporting = true;
 	kmsan_internal_unpoison_memory(info, sizeof(*info), false);
 }
 
--- a/mm/kmsan/hooks.c~kmsan-allow-disabling-kmsan-checks-for-the-current-task
+++ a/mm/kmsan/hooks.c
@@ -39,12 +39,10 @@ void kmsan_task_create(struct task_struc
 
 void kmsan_task_exit(struct task_struct *task)
 {
-	struct kmsan_ctx *ctx = &task->kmsan_ctx;
-
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
 
-	ctx->allow_reporting = false;
+	kmsan_disable_current();
 }
 
 void kmsan_slab_alloc(struct kmem_cache *s, void *object, gfp_t flags)
@@ -424,3 +422,17 @@ void kmsan_check_memory(const void *addr
 					   REASON_ANY);
 }
 EXPORT_SYMBOL(kmsan_check_memory);
+
+void kmsan_enable_current(void)
+{
+	KMSAN_WARN_ON(current->kmsan_ctx.depth == 0);
+	current->kmsan_ctx.depth--;
+}
+EXPORT_SYMBOL(kmsan_enable_current);
+
+void kmsan_disable_current(void)
+{
+	current->kmsan_ctx.depth++;
+	KMSAN_WARN_ON(current->kmsan_ctx.depth == 0);
+}
+EXPORT_SYMBOL(kmsan_disable_current);
--- a/mm/kmsan/report.c~kmsan-allow-disabling-kmsan-checks-for-the-current-task
+++ a/mm/kmsan/report.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/console.h>
+#include <linux/kmsan.h>
 #include <linux/moduleparam.h>
 #include <linux/stackdepot.h>
 #include <linux/stacktrace.h>
@@ -158,12 +159,12 @@ void kmsan_report(depot_stack_handle_t o
 
 	if (!kmsan_enabled)
 		return;
-	if (!current->kmsan_ctx.allow_reporting)
+	if (current->kmsan_ctx.depth)
 		return;
 	if (!origin)
 		return;
 
-	current->kmsan_ctx.allow_reporting = false;
+	kmsan_disable_current();
 	ua_flags = user_access_save();
 	raw_spin_lock(&kmsan_report_lock);
 	pr_err("=====================================================\n");
@@ -216,5 +217,5 @@ void kmsan_report(depot_stack_handle_t o
 	if (panic_on_kmsan)
 		panic("kmsan.panic set ...\n");
 	user_access_restore(ua_flags);
-	current->kmsan_ctx.allow_reporting = true;
+	kmsan_enable_current();
 }
--- a/tools/objtool/check.c~kmsan-allow-disabling-kmsan-checks-for-the-current-task
+++ a/tools/objtool/check.c
@@ -1202,6 +1202,8 @@ static const char *uaccess_safe_builtin[
 	"__sanitizer_cov_trace_switch",
 	/* KMSAN */
 	"kmsan_copy_to_user",
+	"kmsan_disable_current",
+	"kmsan_enable_current",
 	"kmsan_report",
 	"kmsan_unpoison_entry_regs",
 	"kmsan_unpoison_memory",
_

Patches currently in -mm which might be from iii@linux.ibm.com are



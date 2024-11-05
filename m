Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B5F216A0B
	for <mm-commits@vger.kernel.org>; Tue,  5 Nov 2024 23:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730848634; cv=none; b=MryeOWQt9CmYxw2gMV2p9cnRlB5vahc8vt74F09v0DozOytHehvyZbJmCtH/p1IKalshsIaNyMl7WqCXNbVJLatq1kO1avemLFDoYaWH+XnaGNZqQMb5PXWycswiWvLfUE0fM9KzkuaJyTAg6SblCJW7+eVdzYj5WMmnRfSg1jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730848634; c=relaxed/simple;
	bh=ofjZVYR2CICYGn3GQb4yTI6hOUVc1E5AJ69NMT227Mg=;
	h=Date:To:From:Subject:Message-Id; b=UW5o22A7PYxECaERLK6yd9sn8qPylhmg+LLv1FZMmuHhRyYudBR1hdXRYVItUwTg1mPVlst+PmnnlzcCMz+w383n+r2Ea4yMg4FynBn4dvvxcimFRIAq9MLkdXD2ghnvBSYyglcvjHnORohhW1N49gANyCXnC8oKYsZDQD2Xp70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M4Tm5qFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M4Tm5qFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA7CC4CED1;
	Tue,  5 Nov 2024 23:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730848633;
	bh=ofjZVYR2CICYGn3GQb4yTI6hOUVc1E5AJ69NMT227Mg=;
	h=Date:To:From:Subject:From;
	b=M4Tm5qFFMhQplNM8JxFGAeicczqg1oZHNPkJuud7tyjrvscJVruSExrmYcWED/KOQ
	 YpB+6betekLWQ8NGA5Z8V0z8UvI3ErtGydd8xFBbfOBULsW5DhAbAZF8gzRxRNTHDf
	 qeSQKok64Ad3LEDXuoIpm6azr3JiwxGfrRdi/ykg=
Date: Tue, 05 Nov 2024 15:17:12 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,penguin-kernel@I-love.SAKURA.ne.jp,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,axelrasmussen@google.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap_lock-check-trace_mmap_lock_type_enabled-instead-of-regcount.patch added to mm-unstable branch
Message-Id: <20241105231713.4DA7CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mmap_lock: check trace_mmap_lock_$type_enabled() instead of regcount
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap_lock-check-trace_mmap_lock_type_enabled-instead-of-regcount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap_lock-check-trace_mmap_lock_type_enabled-instead-of-regcount.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: mmap_lock: check trace_mmap_lock_$type_enabled() instead of regcount
Date: Tue, 5 Nov 2024 12:34:57 +0100

Since 7d6be67cfdd4 ("mm: mmap_lock: replace get_memcg_path_buf() with
on-stack buffer") we use trace_mmap_lock_reg()/unreg() only to maintain an
atomic reg_refcount which is checked to avoid performing
get_mm_memcg_path() in case none of the tracepoints using it is enabled.

This can be achieved directly by putting all the work needed for the
tracepoint behind the trace_mmap_lock_##type##_enabled(), as suggested by
Documentation/trace/tracepoints.rst and with the following advantages:

- uses the tracepoint's static key instead of evaluating a branch

- the check tracepoint specific, not shared by all of them

- we can get rid of trace_mmap_lock_reg()/unreg() completely

Thus use the trace_..._enabled() check and remove unnecessary code.

Link: https://lkml.kernel.org/r/20241105113456.95066-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmap_lock.h |   14 ++--------
 mm/mmap_lock.c                   |   39 +++++------------------------
 2 files changed, 12 insertions(+), 41 deletions(-)

--- a/include/trace/events/mmap_lock.h~mm-mmap_lock-check-trace_mmap_lock_type_enabled-instead-of-regcount
+++ a/include/trace/events/mmap_lock.h
@@ -10,9 +10,6 @@
 
 struct mm_struct;
 
-extern int trace_mmap_lock_reg(void);
-extern void trace_mmap_lock_unreg(void);
-
 DECLARE_EVENT_CLASS(mmap_lock,
 
 	TP_PROTO(struct mm_struct *mm, const char *memcg_path, bool write),
@@ -40,16 +37,15 @@ DECLARE_EVENT_CLASS(mmap_lock,
 );
 
 #define DEFINE_MMAP_LOCK_EVENT(name)                                    \
-	DEFINE_EVENT_FN(mmap_lock, name,                                \
+	DEFINE_EVENT(mmap_lock, name,                                   \
 		TP_PROTO(struct mm_struct *mm, const char *memcg_path,  \
 			bool write),                                    \
-		TP_ARGS(mm, memcg_path, write),                         \
-		trace_mmap_lock_reg, trace_mmap_lock_unreg)
+		TP_ARGS(mm, memcg_path, write))
 
 DEFINE_MMAP_LOCK_EVENT(mmap_lock_start_locking);
 DEFINE_MMAP_LOCK_EVENT(mmap_lock_released);
 
-TRACE_EVENT_FN(mmap_lock_acquire_returned,
+TRACE_EVENT(mmap_lock_acquire_returned,
 
 	TP_PROTO(struct mm_struct *mm, const char *memcg_path, bool write,
 		bool success),
@@ -76,9 +72,7 @@ TRACE_EVENT_FN(mmap_lock_acquire_returne
 		__get_str(memcg_path),
 		__entry->write ? "true" : "false",
 		__entry->success ? "true" : "false"
-	),
-
-	trace_mmap_lock_reg, trace_mmap_lock_unreg
+	)
 );
 
 #endif /* _TRACE_MMAP_LOCK_H */
--- a/mm/mmap_lock.c~mm-mmap_lock-check-trace_mmap_lock_type_enabled-instead-of-regcount
+++ a/mm/mmap_lock.c
@@ -19,43 +19,23 @@ EXPORT_TRACEPOINT_SYMBOL(mmap_lock_relea
 
 #ifdef CONFIG_MEMCG
 
-static atomic_t reg_refcount;
-
 /*
  * Size of the buffer for memcg path names. Ignoring stack trace support,
  * trace_events_hist.c uses MAX_FILTER_STR_VAL for this, so we also use it.
  */
 #define MEMCG_PATH_BUF_SIZE MAX_FILTER_STR_VAL
 
-int trace_mmap_lock_reg(void)
-{
-	atomic_inc(&reg_refcount);
-	return 0;
-}
-
-void trace_mmap_lock_unreg(void)
-{
-	atomic_dec(&reg_refcount);
-}
-
-#define TRACE_MMAP_LOCK_EVENT(type, mm, ...)                    \
-	do {                                                    \
-		char buf[MEMCG_PATH_BUF_SIZE];                  \
-		get_mm_memcg_path(mm, buf, sizeof(buf));        \
-		trace_mmap_lock_##type(mm, buf, ##__VA_ARGS__); \
+#define TRACE_MMAP_LOCK_EVENT(type, mm, ...)				\
+	do {								\
+		if (trace_mmap_lock_##type##_enabled()) {		\
+			char buf[MEMCG_PATH_BUF_SIZE];                  \
+			get_mm_memcg_path(mm, buf, sizeof(buf));        \
+			trace_mmap_lock_##type(mm, buf, ##__VA_ARGS__); \
+		}							\
 	} while (0)
 
 #else /* !CONFIG_MEMCG */
 
-int trace_mmap_lock_reg(void)
-{
-	return 0;
-}
-
-void trace_mmap_lock_unreg(void)
-{
-}
-
 #define TRACE_MMAP_LOCK_EVENT(type, mm, ...)                                   \
 	trace_mmap_lock_##type(mm, "", ##__VA_ARGS__)
 
@@ -65,16 +45,13 @@ void trace_mmap_lock_unreg(void)
 #ifdef CONFIG_MEMCG
 /*
  * Write the given mm_struct's memcg path to a buffer. If the path cannot be
- * determined or the trace event is being unregistered, empty string is written.
+ * determined, empty string is written.
  */
 static void get_mm_memcg_path(struct mm_struct *mm, char *buf, size_t buflen)
 {
 	struct mem_cgroup *memcg;
 
 	buf[0] = '\0';
-	/* No need to get path if no trace event is registered. */
-	if (!atomic_read(&reg_refcount))
-		return;
 	memcg = get_mem_cgroup_from_mm(mm);
 	if (memcg == NULL)
 		return;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mmap_lock-check-trace_mmap_lock_type_enabled-instead-of-regcount.patch


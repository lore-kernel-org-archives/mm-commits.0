Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833809;
	b=brsT12QdJYLn6yALmS7HVeXfe4aI3LLdKzJRLaJ1QMoMTDMDNsD6b/XrTGBk/yN/xYix
	 qyOVrrvzsRf30l4y417mi37WaowQi56bcNmHz6Wb8UJunPKZlyp/PBhUGaZeFdv9XFl1K
	 IJst53XCZk4oR1FIzadsgEBl0WYVLxz+92KfQtSoVqItOMFpxoCBlIf0EQ+Kb2Cj4OwpA
	 2BT7XBms9Xp4FV3MZ6/8cH+bAmsOuXNRcPMnZIa80SKkJ5VKxXTpmnnEGv9TX+ZVXsVhb
	 21hKo/MIMoWjIu+hxuAjQjPMpArQlgYZSMuLsjeDntX6lvspu35Cy6OqPZWqM9y+UhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833809;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=jEPY5OiDunBHcOJw4QL+Q1L0E/4FpLdJ30LOxgjvEMs=;
	b=DJziw+nRHgHo0TuOIKBzCaYYkYueDL0tI4/FS33M8cFMgFBvBzG9WZkKiR3ASmw/5ces
	 STQsBbHtBYvRft0LpNxzxy5Z8VLdW6bqv7Fyn86G5QbgFSowwSXezZft+Jcq6C+N6rBBz
	 jBt7/uUHHorB/ruU+7vr3BQJBnFUw0HHA1EYp3s93r+uEy1WZLTN562tVktnJ1oQj9pjJ
	 vsz2tVw1o4ivUsJyousZp8CZBkZPUbbCdJgx3N53A868Y9S4GI0O5Aj5/t8rQn+wPjZpp
	 Da3Lkzw50+5Q3omIQc6UhaFMGasauoCGE+wyvjTb+ipnZmJgdO4dWr0ubnGbGBhvIsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ifiwat0q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B1E606A31B
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 23:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ifiwat0q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF921F000C1;
	Wed,  4 Nov 2026 23:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793833808;
	bh=jEPY5OiDunBHcOJw4QL+Q1L0E/4FpLdJ30LOxgjvEMs=;
	h=Date:To:From:Subject;
	b=Ifiwat0q6pIdOZgjm1ZqA7gw5ialcHsMKcdwk+RpQ7+X/nS1OUBuIp6Ik1ycwroQx
	 2mHDvQOtPvNd3yMShnzbE4Z5yMcbC1xB6R66V0ESnSjEzMFRe/iA1ZXXOEL6etTgoQ
	 b/hY0gV0L5HR3We3ix8Y2RB0238ptwy/PmU8H1jI=
Date: Wed, 04 Nov 2026 15:10:07 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,hao.ge@linux.dev,
	akpm@linux-foundation.org,abhishekbapat@google.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints.patch added to mm-new branch
Message-Id: <20261104231008.2AF921F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: alloc_tag: introduce IOCTLs to toggle allocation tracepoints
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Abhishek Bapat <abhishekbapat@google.com>
Subject: alloc_tag: introduce IOCTLs to toggle allocation tracepoints
Date: Wed, 04 Nov 2026 19:03:37 +0000

Introduce a new IOCTL (`ALLOCINFO_IOC_TOGGLE_TRACE`) to selectively
toggle tracing on allocation call sites. Userspace tools can use the
existing filtering mechanism to specify the set of tags to toggle
tracing for.

To facilitate low overhead execution for non-targeted call sites, add a
new `CODETAG_FLAG_TRACE_ON` flag to `struct codetag` to track per-site
activation. Protect these conditional branch evaluations using the global
`alloc_tag_trace_key` static branch and an inline static key check
pattern in the allocator hooks (`alloc_tag_add`, `alloc_tag_sub`, etc).
This ensures that the trace events are entirely skipped when no
allocation call sites are being actively traced, leaving only a NOP on
the allocation fast path.

Link: https://lore.kernel.org/37ae7dca766994d3872fcc65b623a80d5d506369.1793818636.git.abhishekbapat@google.com
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
---

 Documentation/mm/allocation-profiling.rst |   20 +++
 include/linux/alloc_tag.h                 |   47 +++++--
 include/linux/codetag.h                   |    5 
 include/uapi/linux/alloc_tag.h            |   13 ++
 mm/alloc_tag.c                            |  127 ++++++++++++++++++--
 5 files changed, 186 insertions(+), 26 deletions(-)

--- a/Documentation/mm/allocation-profiling.rst~alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints
+++ a/Documentation/mm/allocation-profiling.rst
@@ -149,6 +149,26 @@ expose the full call stack and the lifet
 - slab and percpu: the address of the object's `codetag_ref`
 - page allocator: the `struct page` pointer of the head page
 
+Events are only emitted for tags that have tracing turned on and while profiling
+is enabled. When no tag is traced, the hooks are behind a static branch.
+
+Enabling Tracing
+----------------
+
+Tracing is toggled on and off per tag with the `ALLOCINFO_IOC_TOGGLE_TRACE`
+ioctl on `/proc/allocinfo` (requires `CAP_SYS_ADMIN`, returns `-EPERM`
+otherwise). It takes the same filter as used by `ALLOCINFO_IOC_GET_AT`; an
+empty mask selects all tags. Size limits in the filter are checked once,
+against the tag's size at the time of the call. Tags already in the requested
+state are skipped and a -ENOENT is returned if no tag matched.
+
+Tracing is turned off for a module's tags when the module is unloaded.
+
+Memory allocated before a tag was enabled has no alloc event but will still
+produce a free event. Likewise, memory alive when tag is disabled will not
+produce a free event. Tools should expect unmatched frees after enabling and
+missing frees after disabling.
+
 Correlating the events
 ----------------------
 
--- a/include/linux/alloc_tag.h~alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints
+++ a/include/linux/alloc_tag.h
@@ -136,9 +136,36 @@ static inline bool mem_alloc_profiling_e
 				   &mem_alloc_profiling_key);
 }
 
-static inline bool alloc_tag_trace_enabled(void)
+static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
 {
-	return static_branch_unlikely(&alloc_tag_trace_key);
+	atomic_or(CODETAG_FLAG_INACCURATE, &tag->ct.flags);
+}
+
+static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
+{
+	return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_INACCURATE);
+}
+
+static inline void alloc_tag_set_traced(struct alloc_tag *tag)
+{
+	atomic_or(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
+}
+
+static inline void alloc_tag_clear_traced(struct alloc_tag *tag)
+{
+	atomic_andnot(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
+}
+
+static inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
+{
+	return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON);
+}
+
+static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
+{
+	if (static_branch_unlikely(&alloc_tag_trace_key))
+		return tag && alloc_tag_is_traced(tag);
+	return false;
 }
 
 void alloc_tag_trace_mem_alloc(const void *ptr, struct alloc_tag *tag,
@@ -151,7 +178,7 @@ void __alloc_tag_trace_hit(struct alloc_
 
 static __always_inline void alloc_tag_trace_hit(struct alloc_tag *tag)
 {
-	if (alloc_tag_trace_enabled())
+	if (alloc_tag_trace_enabled(tag))
 		__alloc_tag_trace_hit(tag);
 }
 
@@ -225,7 +252,7 @@ static inline void alloc_tag_add(union c
 	if (likely(alloc_tag_ref_set(ref, tag))) {
 		this_cpu_add(tag->counters->bytes, bytes);
 
-		if (alloc_tag_trace_enabled())
+		if (alloc_tag_trace_enabled(tag))
 			/* Trace successful allocs with their unique ptr */
 			alloc_tag_trace_mem_alloc(ptr, tag, bytes);
 	}
@@ -249,23 +276,13 @@ static inline void alloc_tag_sub(union c
 	this_cpu_sub(tag->counters->bytes, bytes);
 	this_cpu_dec(tag->counters->calls);
 
-	if (alloc_tag_trace_enabled())
+	if (alloc_tag_trace_enabled(tag))
 		/* Trace frees with their unique ptr */
 		alloc_tag_trace_mem_free(ptr, tag, bytes);
 
 	ref->ct = NULL;
 }
 
-static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
-{
-	tag->ct.flags |= CODETAG_FLAG_INACCURATE;
-}
-
-static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
-{
-	return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
-}
-
 #define alloc_tag_record(p)	((p) = current->alloc_tag)
 
 #else /* CONFIG_MEM_ALLOC_PROFILING */
--- a/include/linux/codetag.h~alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints
+++ a/include/linux/codetag.h
@@ -18,6 +18,7 @@ struct module;
 
 /* codetag flags */
 #define CODETAG_FLAG_INACCURATE	(1 << 0)
+#define CODETAG_FLAG_TRACE_ON	(1 << 1)
 
 /*
  * An instance of this structure is created in a special ELF section at every
@@ -25,7 +26,7 @@ struct module;
  * an array of these.
  */
 struct codetag {
-	unsigned int flags;
+	atomic_t flags;
 	unsigned int lineno;
 	const char *modname;
 	const char *function;
@@ -71,7 +72,7 @@ struct codetag_iterator {
 	.function	= __func__,			\
 	.filename	= __FILE__,			\
 	.lineno		= __LINE__,			\
-	.flags		= 0,				\
+	.flags		= ATOMIC_INIT(0),		\
 }
 
 void codetag_lock_module_list(struct codetag_type *cttype);
--- a/include/uapi/linux/alloc_tag.h~alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints
+++ a/include/uapi/linux/alloc_tag.h
@@ -85,9 +85,20 @@ struct allocinfo_get_at {
 	struct allocinfo_tag_data data;
 };
 
+struct allocinfo_toggle_traces {
+	/* inputs */
+	/*
+	 * Tags matching the filter are toggled; an empty mask selects all tags.
+	 * Size criteria are checked once, against the tag's size at call time.
+	 */
+	struct allocinfo_filter filter;
+	__u64 enable;
+};
+
 #define _ALLOCINFO_IOC_CONTENT_ID	0
 #define _ALLOCINFO_IOC_GET_AT		1
 #define _ALLOCINFO_IOC_GET_NEXT		2
+#define _ALLOCINFO_IOC_TOGGLE_TRACE	3
 
 #define ALLOCINFO_IOC_BASE		0xA6
 #define ALLOCINFO_IOC_CONTENT_ID	_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_CONTENT_ID,	\
@@ -96,5 +107,7 @@ struct allocinfo_get_at {
 					      struct allocinfo_get_at)
 #define ALLOCINFO_IOC_GET_NEXT		_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_NEXT,	\
 					     struct allocinfo_tag_data)
+#define ALLOCINFO_IOC_TOGGLE_TRACE	_IOW(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_TOGGLE_TRACE,	\
+					    struct allocinfo_toggle_traces)
 
 #endif /* _UAPI_ALLOC_TAG_H */
--- a/mm/alloc_tag.c~alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints
+++ a/mm/alloc_tag.c
@@ -60,6 +60,15 @@ DEFINE_STATIC_KEY_FALSE(mem_profiling_co
 DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
 EXPORT_SYMBOL(alloc_tag_trace_key);
 
+static atomic_t alloc_tag_trace_cnt = ATOMIC_INIT(0);
+
+/*
+ * As `codetag_lock_module_list` is a read lock, we need an additional mutex
+ * to protect against the race conditions involved in the alloc tag trace
+ * toggle path.
+ */
+static DEFINE_MUTEX(alloc_tag_trace_mutex);
+
 struct alloc_tag_kernel_section kernel_tags = { NULL, 0 };
 unsigned long alloc_tag_ref_mask;
 int alloc_tag_ref_offs;
@@ -296,7 +305,7 @@ static bool matches_filter(struct codeta
 		return false;
 
 	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
-		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
+		inaccurate = alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
 		if (inaccurate != !!(filter->inaccurate))
 			return false;
 	}
@@ -318,6 +327,23 @@ static bool matches_filter(struct codeta
 }
 
 /*
+ * Checks that a user supplied filter only uses known fields and that its size
+ * range, if any, is not inverted.
+ */
+static bool allocinfo_filter_valid(const struct allocinfo_filter *filter)
+{
+	if (filter->mask & ~ALLOCINFO_FILTER_MASKS)
+		return false;
+
+	if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
+	    (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
+	    filter->min_size > filter->max_size)
+		return false;
+
+	return true;
+}
+
+/*
  * Seeks the ioctl iterator to the specified 0-indexed tag position, reads its
  * profiling data and returns it to userspace.
  */
@@ -333,12 +359,7 @@ static int allocinfo_ioctl_get_at(struct
 	if (copy_from_user(&params, arg, sizeof(params)))
 		return -EFAULT;
 
-	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
-		return -EINVAL;
-
-	if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
-	    (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
-	    params.filter.min_size > params.filter.max_size)
+	if (!allocinfo_filter_valid(&params.filter))
 		return -EINVAL;
 
 	priv = m->private;
@@ -443,6 +464,74 @@ static int allocinfo_ioctl_get_next(stru
 	return ret;
 }
 
+static void alloc_tag_trace_toggle(struct alloc_tag *tag, bool enable)
+{
+	if (enable) {
+		if (alloc_tag_is_traced(tag))
+			return;
+
+		alloc_tag_set_traced(tag);
+		if (atomic_fetch_inc(&alloc_tag_trace_cnt) == 0)
+			static_branch_enable(&alloc_tag_trace_key);
+	} else {
+		if (!alloc_tag_is_traced(tag))
+			return;
+
+		alloc_tag_clear_traced(tag);
+		if (atomic_dec_and_test(&alloc_tag_trace_cnt))
+			static_branch_disable(&alloc_tag_trace_key);
+	}
+}
+
+/*
+ * Toggles tracing on every allocation tag that matches the user supplied
+ * filter. An empty filter mask selects all tags, same as for
+ * ALLOCINFO_IOC_GET_AT. Tags already in the requested state are not an error.
+ * Requires CAP_SYS_ADMIN.
+ */
+static int allocinfo_ioctl_toggle_trace(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_toggle_traces params;
+	struct codetag_iterator iter;
+	struct codetag *ct;
+	struct alloc_tag_counters counters;
+	bool fetched_counters;
+	int ret = 0;
+	int matches = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&params, arg, sizeof(params)))
+		return -EFAULT;
+
+	if (!allocinfo_filter_valid(&params.filter))
+		return -EINVAL;
+
+	codetag_lock_module_list(alloc_tag_cttype);
+
+	iter = codetag_get_ct_iter(alloc_tag_cttype);
+
+	mutex_lock(&alloc_tag_trace_mutex);
+	/* Toggle tracing on all codetags that match */
+	while ((ct = codetag_next_ct(&iter))) {
+		fetched_counters = false;
+		if (matches_filter(ct, &params.filter, &counters, &fetched_counters)) {
+			matches++;
+			alloc_tag_trace_toggle(ct_to_alloc_tag(ct), !!params.enable);
+		}
+	}
+	mutex_unlock(&alloc_tag_trace_mutex);
+
+	if (matches == 0)
+		/* Nothing matched the filter */
+		ret = -ENOENT;
+
+	codetag_unlock_module_list(alloc_tag_cttype);
+
+	return ret;
+}
+
 /*
  * Entry point ioctl function for /proc/allocinfo routing requests to fetch the
  * layout content ID, seek to a specific tag, or read sequential tags.
@@ -463,6 +552,9 @@ static long allocinfo_ioctl(struct file
 	case ALLOCINFO_IOC_GET_NEXT:
 		ret = allocinfo_ioctl_get_next(file->private_data, arg);
 		break;
+	case ALLOCINFO_IOC_TOGGLE_TRACE:
+		ret = allocinfo_ioctl_toggle_trace(file->private_data, arg);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
@@ -492,8 +584,6 @@ static const struct proc_ops allocinfo_p
 
 void __alloc_tag_trace_hit(struct alloc_tag *tag)
 {
-	if (unlikely(!tag))
-		return;
 	trace_alloc_tag_hit(tag);
 }
 EXPORT_SYMBOL(__alloc_tag_trace_hit);
@@ -1031,6 +1121,24 @@ static int load_module(struct module *mo
 	return 0;
 }
 
+static void unload_module(struct module *mod, struct codetag *start, struct codetag *stop)
+{
+	struct alloc_tag *start_tag = ct_to_alloc_tag(start);
+	struct alloc_tag *stop_tag = ct_to_alloc_tag(stop);
+	struct alloc_tag *tag;
+
+	/*
+	 * Turn tracing off for the tags of the module being unloaded. Without
+	 * this, `alloc_tag_trace_cnt` would never reach zero and tracing would
+	 * stay enabled forever.
+	 *
+	 * `alloc_tag_trace_mutex` is not needed here as this code path is
+	 * protected by a `down_write(&cttype->mod_lock)`.
+	 */
+	for (tag = start_tag; tag < stop_tag; tag++)
+		alloc_tag_trace_toggle(tag, false);
+}
+
 static void replace_module(struct module *mod, struct module *new_mod)
 {
 	MA_STATE(mas, &mod_area_mt, 0, module_tags.size);
@@ -1357,6 +1465,7 @@ static int __init alloc_tag_init(void)
 		.alloc_section_mem	= reserve_module_tags,
 		.free_section_mem	= release_module_tags,
 		.module_load		= load_module,
+		.module_unload		= unload_module,
 		.module_replaced	= replace_module,
 #endif
 	};
_

Patches currently in -mm which might be from abhishekbapat@google.com are

alloc_tag-add-trace-events-for-tracing-allocations.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints.patch
alloc_tag-add-a-flags-field-to-allocinfo_filter.patch
alloc_tag-extend-allocinfo_filter-to-support-tracing-queries.patch
alloc_tag-add-a-test-for-trace-state-toggle-and-filtering.patch


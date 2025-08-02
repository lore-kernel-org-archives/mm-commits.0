Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB67D24DCE3
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160871; cv=none; b=C2L9Jppo8v6fI/KasvYrZi6xO+IfW7jMuFl32LM/U0LNe0Idy6dzw/yzrf6dvk/1nMm6ViH57S1QpnteeoZ2rG7z5e+Fexpgy8ZTrNqHv6NMreus4nltHMd6thWpcakPemGC4dpkfZYBsk1dCJgLaLFjQd2g0WINL9bojfZPmmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160871; c=relaxed/simple;
	bh=Xba8x4+tuVHbTFtG4wCC6wa9Ep2MXml6F1eiPSwH3Os=;
	h=Date:To:From:Subject:Message-Id; b=NROCuweXjgpLUjgfkdcENo24eLwdBNKIkuTmwBs9wbGRe+O0X5B1gHLnvAsRVbGQTtIkIg1rpm46aJA86axFmwjj3noyuIHtG6UzoZwdfOxktuZefic0GSHaf+lqWzH+g9dswnFh3R+8HDzGfy9hqTzHrsd90su9LY+AairnQ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qaE+3foJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qaE+3foJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67ADC4CEEF;
	Sat,  2 Aug 2025 18:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160870;
	bh=Xba8x4+tuVHbTFtG4wCC6wa9Ep2MXml6F1eiPSwH3Os=;
	h=Date:To:From:Subject:From;
	b=qaE+3foJoR95xS3WG41lfr3Mk36Ew5SzsxejrCFdb57KTfv3qWuKlMPvrkQkeDsFi
	 LgRbxroQwjK5Cl3sEQX/YpHT0I1W9VBMGbVzvzpBPkapoa1zEto67r1gzUMy5Mxh3C
	 Mq8pVKr3JgTfjSDK95Tszfr9xb7O59pLGGM2n60A=
Date: Sat, 02 Aug 2025 11:54:30 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] execmem-rework-execmem_cache_free.patch removed from -mm tree
Message-Id: <20250802185430.A67ADC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: execmem: rework execmem_cache_free()
has been removed from the -mm tree.  Its filename was
     execmem-rework-execmem_cache_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: execmem: rework execmem_cache_free()
Date: Sun, 13 Jul 2025 10:17:25 +0300

Currently execmem_cache_free() ignores potential allocation failures that
may happen in execmem_cache_add().  Besides, it uses text poking to fill
the memory with trapping instructions before returning it to cache
although it would be more efficient to make that memory writable, update
it using memcpy and then restore ROX protection.

Rework execmem_cache_free() so that in case of an error it will defer
freeing of the memory to a delayed work.

With this the happy fast path will now change permissions to RW, fill the
memory with trapping instructions using memcpy, restore ROX permissions,
add the memory back to the free cache and clear the relevant entry in
busy_areas.

If any step in the fast path fails, the entry in busy_areas will be marked
as pending_free.  These entries will be handled by a delayed work and
freed asynchronously.

To make the fast path faster, use __GFP_NORETRY for memory allocations and
let asynchronous handler try harder with GFP_KERNEL.

Link: https://lkml.kernel.org/r/20250713071730.4117334-4-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c |  125 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 102 insertions(+), 23 deletions(-)

--- a/mm/execmem.c~execmem-rework-execmem_cache_free
+++ a/mm/execmem.c
@@ -93,8 +93,15 @@ struct execmem_cache {
 	struct mutex mutex;
 	struct maple_tree busy_areas;
 	struct maple_tree free_areas;
+	unsigned int pending_free_cnt;	/* protected by mutex */
 };
 
+/* delay to schedule asynchronous free if fast path free fails */
+#define FREE_DELAY	(msecs_to_jiffies(10))
+
+/* mark entries in busy_areas that should be freed asynchronously */
+#define PENDING_FREE_MASK	(1 << (PAGE_SHIFT - 1))
+
 static struct execmem_cache execmem_cache = {
 	.mutex = __MUTEX_INITIALIZER(execmem_cache.mutex),
 	.busy_areas = MTREE_INIT_EXT(busy_areas, MT_FLAGS_LOCK_EXTERN,
@@ -155,20 +162,17 @@ static void execmem_cache_clean(struct w
 
 static DECLARE_WORK(execmem_cache_clean_work, execmem_cache_clean);
 
-static int execmem_cache_add(void *ptr, size_t size)
+static int execmem_cache_add_locked(void *ptr, size_t size, gfp_t gfp_mask)
 {
 	struct maple_tree *free_areas = &execmem_cache.free_areas;
-	struct mutex *mutex = &execmem_cache.mutex;
 	unsigned long addr = (unsigned long)ptr;
 	MA_STATE(mas, free_areas, addr - 1, addr + 1);
 	unsigned long lower, upper;
 	void *area = NULL;
-	int err;
 
 	lower = addr;
 	upper = addr + size - 1;
 
-	mutex_lock(mutex);
 	area = mas_walk(&mas);
 	if (area && mas.last == addr - 1)
 		lower = mas.index;
@@ -178,12 +182,14 @@ static int execmem_cache_add(void *ptr,
 		upper = mas.last;
 
 	mas_set_range(&mas, lower, upper);
-	err = mas_store_gfp(&mas, (void *)lower, GFP_KERNEL);
-	mutex_unlock(mutex);
-	if (err)
-		return err;
+	return mas_store_gfp(&mas, (void *)lower, gfp_mask);
+}
 
-	return 0;
+static int execmem_cache_add(void *ptr, size_t size, gfp_t gfp_mask)
+{
+	guard(mutex)(&execmem_cache.mutex);
+
+	return execmem_cache_add_locked(ptr, size, gfp_mask);
 }
 
 static bool within_range(struct execmem_range *range, struct ma_state *mas,
@@ -278,7 +284,7 @@ static int execmem_cache_populate(struct
 	if (err)
 		goto err_free_mem;
 
-	err = execmem_cache_add(p, alloc_size);
+	err = execmem_cache_add(p, alloc_size, GFP_KERNEL);
 	if (err)
 		goto err_reset_direct_map;
 
@@ -307,29 +313,102 @@ static void *execmem_cache_alloc(struct
 	return __execmem_cache_alloc(range, size);
 }
 
+static inline bool is_pending_free(void *ptr)
+{
+	return ((unsigned long)ptr & PENDING_FREE_MASK);
+}
+
+static inline void *pending_free_set(void *ptr)
+{
+	return (void *)((unsigned long)ptr | PENDING_FREE_MASK);
+}
+
+static inline void *pending_free_clear(void *ptr)
+{
+	return (void *)((unsigned long)ptr & ~PENDING_FREE_MASK);
+}
+
+static int execmem_force_rw(void *ptr, size_t size);
+
+static int __execmem_cache_free(struct ma_state *mas, void *ptr, gfp_t gfp_mask)
+{
+	size_t size = mas_range_len(mas);
+	int err;
+
+	err = execmem_force_rw(ptr, size);
+	if (err)
+		return err;
+
+	execmem_fill_trapping_insns(ptr, size, /* writable = */ true);
+	execmem_restore_rox(ptr, size);
+
+	err = execmem_cache_add_locked(ptr, size, gfp_mask);
+	if (err)
+		return err;
+
+	mas_store_gfp(mas, NULL, gfp_mask);
+	return 0;
+}
+
+static void execmem_cache_free_slow(struct work_struct *work);
+static DECLARE_DELAYED_WORK(execmem_cache_free_work, execmem_cache_free_slow);
+
+static void execmem_cache_free_slow(struct work_struct *work)
+{
+	struct maple_tree *busy_areas = &execmem_cache.busy_areas;
+	MA_STATE(mas, busy_areas, 0, ULONG_MAX);
+	void *area;
+
+	guard(mutex)(&execmem_cache.mutex);
+
+	if (!execmem_cache.pending_free_cnt)
+		return;
+
+	mas_for_each(&mas, area, ULONG_MAX) {
+		if (!is_pending_free(area))
+			continue;
+
+		area = pending_free_clear(area);
+		if (__execmem_cache_free(&mas, area, GFP_KERNEL))
+			continue;
+
+		execmem_cache.pending_free_cnt--;
+	}
+
+	if (execmem_cache.pending_free_cnt)
+		schedule_delayed_work(&execmem_cache_free_work, FREE_DELAY);
+	else
+		schedule_work(&execmem_cache_clean_work);
+}
+
 static bool execmem_cache_free(void *ptr)
 {
 	struct maple_tree *busy_areas = &execmem_cache.busy_areas;
-	struct mutex *mutex = &execmem_cache.mutex;
 	unsigned long addr = (unsigned long)ptr;
 	MA_STATE(mas, busy_areas, addr, addr);
-	size_t size;
 	void *area;
+	int err;
+
+	guard(mutex)(&execmem_cache.mutex);
 
-	mutex_lock(mutex);
 	area = mas_walk(&mas);
-	if (!area) {
-		mutex_unlock(mutex);
+	if (!area)
 		return false;
-	}
-	size = mas_range_len(&mas);
 
-	mas_store_gfp(&mas, NULL, GFP_KERNEL);
-	mutex_unlock(mutex);
-
-	execmem_fill_trapping_insns(ptr, size, /* writable = */ false);
-
-	execmem_cache_add(ptr, size);
+	err = __execmem_cache_free(&mas, area, GFP_KERNEL | __GFP_NORETRY);
+	if (err) {
+		/*
+		 * mas points to exact slot we've got the area from, nothing
+		 * else can modify the tree because of the mutex, so there
+		 * won't be any allocations in mas_store_gfp() and it will just
+		 * change the pointer.
+		 */
+		area = pending_free_set(area);
+		mas_store_gfp(&mas, area, GFP_KERNEL);
+		execmem_cache.pending_free_cnt++;
+		schedule_delayed_work(&execmem_cache_free_work, FREE_DELAY);
+		return true;
+	}
 
 	schedule_work(&execmem_cache_clean_work);
 
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-add-test-for-kexec-handover.patch
kho-add-test-for-kexec-handover-fix.patch


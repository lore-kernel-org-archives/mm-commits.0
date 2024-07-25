Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EBE13B5A0
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 21:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721942105; cv=none; b=TW/+7Hk2Cm1J3zrP0+Non3HXi4js2JBxu7qaATOLLWI/owsepxd8b0pyovLb0qOTWJvjSO4oI4ewPHhbJtBAX4GcDTI1Ga+EkDlSIYeYNo/R/9qpGpAGlBNys8bHPslzOp8zBSAWIyOnR2yTX1MpGgtAwungP/q4lqfwW7EZqyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721942105; c=relaxed/simple;
	bh=v7SThllU6pcHamHvnaMv8QnSYN3kYr2Cn2c03CKP938=;
	h=Date:To:From:Subject:Message-Id; b=V/QhcO+a26xJ+MNO9sx8mzG7Ng/6Hpkm1s8lvDmJ77uLKAx9VZgMjMzHUMyFg4t5WSrYCnz1PCcFOln4U6RVPcuzD5rzZD05GMazLE2rd99MoA2x7sQBk9ke7Kn1KZ/aVXJEIgt3I22IKC0Rg0zP/wbmuT90PkUilwumM1JcOY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oVvwRnqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oVvwRnqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F27FC116B1;
	Thu, 25 Jul 2024 21:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721942105;
	bh=v7SThllU6pcHamHvnaMv8QnSYN3kYr2Cn2c03CKP938=;
	h=Date:To:From:Subject:From;
	b=oVvwRnqmhbji21MB7Q+hetOpH5kbjQg767xWI+GPoZQ9OL4gK53m0d+ij4ifeBpk/
	 qo16NdCO9c7fV8PD4RYqCURJ9LNPw6Tz4ztVlZJ0FYSJlbnFg81t7Vbep9M+3CZubI
	 uv12Ts6ZpRwfPA5S6SdYT6NvqA/6jKsOJDpQRzPc=
Date: Thu, 25 Jul 2024 14:15:04 -0700
To: mm-commits@vger.kernel.org,weiyongjun1@huawei.com,chenjun102@huawei.com,catalin.marinas@arm.com,aleksandr.mikhalitsyn@canonical.com,ptikhomirov@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmemleak-enable-tracking-for-percpu-pointers.patch added to mm-unstable branch
Message-Id: <20240725211505.2F27FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmemleak: enable tracking for percpu pointers
has been added to the -mm mm-unstable branch.  Its filename is
     kmemleak-enable-tracking-for-percpu-pointers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmemleak-enable-tracking-for-percpu-pointers.patch

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
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: kmemleak: enable tracking for percpu pointers
Date: Thu, 25 Jul 2024 12:12:15 +0800

Patch series "kmemleak: support for percpu memory leak detect'.

This is a rework of this series:
https://lore.kernel.org/lkml/20200921020007.35803-1-chenjun102@huawei.com/

Originally I was investigating a percpu leak on our customer nodes and
having this functionality was a huge help, which lead to this fix [1].

So probably it's a good idea to have it in mainstream too, especially as
after [2] it became much easier to implement (we already have a separate
tree for percpu pointers).

[1] commit 0af8c09c89681 ("netfilter: x_tables: fix percpu counter block leak on error path when creating new netns")
[2] commit 39042079a0c24 ("kmemleak: avoid RCU stalls when freeing metadata for per-CPU pointers")


This patch (of 2):

This basically does:

- Add min_percpu_addr and max_percpu_addr to filter out unrelated data
  similar to min_addr and max_addr;
- Set min_count for percpu pointers to 1 to start tracking them;
- Calculate checksum of percpu area as xor of crc32 for each cpu;
- Split pointer lookup code into separate helper and use it twice: once
  as if the pointer is a virtual pointer and once as if it's percpu.

Link: https://lkml.kernel.org/r/20240725041223.872472-1-ptikhomirov@virtuozzo.com
Link: https://lkml.kernel.org/r/20240725041223.872472-2-ptikhomirov@virtuozzo.com
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Chen Jun <chenjun102@huawei.com>
Cc: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |  153 +++++++++++++++++++++++++++++-------------------
 1 file changed, 94 insertions(+), 59 deletions(-)

--- a/mm/kmemleak.c~kmemleak-enable-tracking-for-percpu-pointers
+++ a/mm/kmemleak.c
@@ -224,6 +224,10 @@ static int kmemleak_error;
 static unsigned long min_addr = ULONG_MAX;
 static unsigned long max_addr;
 
+/* minimum and maximum address that may be valid per-CPU pointers */
+static unsigned long min_percpu_addr = ULONG_MAX;
+static unsigned long max_percpu_addr;
+
 static struct task_struct *scan_thread;
 /* used to avoid reporting of recently allocated objects */
 static unsigned long jiffies_min_age;
@@ -294,13 +298,20 @@ static void hex_dump_object(struct seq_f
 	const u8 *ptr = (const u8 *)object->pointer;
 	size_t len;
 
-	if (WARN_ON_ONCE(object->flags & (OBJECT_PHYS | OBJECT_PERCPU)))
+	if (WARN_ON_ONCE(object->flags & OBJECT_PHYS))
 		return;
 
+	if (object->flags & OBJECT_PERCPU)
+		ptr = (const u8 *)this_cpu_ptr((void __percpu *)object->pointer);
+
 	/* limit the number of lines to HEX_MAX_LINES */
 	len = min_t(size_t, object->size, HEX_MAX_LINES * HEX_ROW_SIZE);
 
-	warn_or_seq_printf(seq, "  hex dump (first %zu bytes):\n", len);
+	if (object->flags & OBJECT_PERCPU)
+		warn_or_seq_printf(seq, "  hex dump (first %zu bytes on cpu %d):\n",
+				   len, raw_smp_processor_id());
+	else
+		warn_or_seq_printf(seq, "  hex dump (first %zu bytes):\n", len);
 	kasan_disable_current();
 	warn_or_seq_hex_dump(seq, DUMP_PREFIX_NONE, HEX_ROW_SIZE,
 			     HEX_GROUP_SIZE, kasan_reset_tag((void *)ptr), len, HEX_ASCII);
@@ -695,10 +706,14 @@ static int __link_object(struct kmemleak
 
 	untagged_ptr = (unsigned long)kasan_reset_tag((void *)ptr);
 	/*
-	 * Only update min_addr and max_addr with object
-	 * storing virtual address.
+	 * Only update min_addr and max_addr with object storing virtual
+	 * address. And update min_percpu_addr max_percpu_addr for per-CPU
+	 * objects.
 	 */
-	if (!(objflags & (OBJECT_PHYS | OBJECT_PERCPU))) {
+	if (objflags & OBJECT_PERCPU) {
+		min_percpu_addr = min(min_percpu_addr, untagged_ptr);
+		max_percpu_addr = max(max_percpu_addr, untagged_ptr + size);
+	} else if (!(objflags & OBJECT_PHYS)) {
 		min_addr = min(min_addr, untagged_ptr);
 		max_addr = max(max_addr, untagged_ptr + size);
 	}
@@ -1055,12 +1070,8 @@ void __ref kmemleak_alloc_percpu(const v
 {
 	pr_debug("%s(0x%px, %zu)\n", __func__, ptr, size);
 
-	/*
-	 * Percpu allocations are only scanned and not reported as leaks
-	 * (min_count is set to 0).
-	 */
 	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
-		create_object_percpu((unsigned long)ptr, size, 0, gfp);
+		create_object_percpu((unsigned long)ptr, size, 1, gfp);
 }
 EXPORT_SYMBOL_GPL(kmemleak_alloc_percpu);
 
@@ -1304,12 +1315,23 @@ static bool update_checksum(struct kmeml
 {
 	u32 old_csum = object->checksum;
 
-	if (WARN_ON_ONCE(object->flags & (OBJECT_PHYS | OBJECT_PERCPU)))
+	if (WARN_ON_ONCE(object->flags & OBJECT_PHYS))
 		return false;
 
 	kasan_disable_current();
 	kcsan_disable_current();
-	object->checksum = crc32(0, kasan_reset_tag((void *)object->pointer), object->size);
+	if (object->flags & OBJECT_PERCPU) {
+		unsigned int cpu;
+
+		object->checksum = 0;
+		for_each_possible_cpu(cpu) {
+			void *ptr = per_cpu_ptr((void __percpu *)object->pointer, cpu);
+
+			object->checksum ^= crc32(0, kasan_reset_tag((void *)ptr), object->size);
+		}
+	} else {
+		object->checksum = crc32(0, kasan_reset_tag((void *)object->pointer), object->size);
+	}
 	kasan_enable_current();
 	kcsan_enable_current();
 
@@ -1361,6 +1383,64 @@ static int scan_should_stop(void)
 	return 0;
 }
 
+static void scan_pointer(struct kmemleak_object *scanned,
+			 unsigned long pointer, unsigned int objflags)
+{
+	struct kmemleak_object *object;
+	unsigned long untagged_ptr;
+	unsigned long excess_ref;
+
+	untagged_ptr = (unsigned long)kasan_reset_tag((void *)pointer);
+	if (objflags & OBJECT_PERCPU) {
+		if (untagged_ptr < min_percpu_addr || untagged_ptr >= max_percpu_addr)
+			return;
+	} else {
+		if (untagged_ptr < min_addr || untagged_ptr >= max_addr)
+			return;
+	}
+
+	/*
+	 * No need for get_object() here since we hold kmemleak_lock.
+	 * object->use_count cannot be dropped to 0 while the object
+	 * is still present in object_tree_root and object_list
+	 * (with updates protected by kmemleak_lock).
+	 */
+	object = __lookup_object(pointer, 1, objflags);
+	if (!object)
+		return;
+	if (object == scanned)
+		/* self referenced, ignore */
+		return;
+
+	/*
+	 * Avoid the lockdep recursive warning on object->lock being
+	 * previously acquired in scan_object(). These locks are
+	 * enclosed by scan_mutex.
+	 */
+	raw_spin_lock_nested(&object->lock, SINGLE_DEPTH_NESTING);
+	/* only pass surplus references (object already gray) */
+	if (color_gray(object)) {
+		excess_ref = object->excess_ref;
+		/* no need for update_refs() if object already gray */
+	} else {
+		excess_ref = 0;
+		update_refs(object);
+	}
+	raw_spin_unlock(&object->lock);
+
+	if (excess_ref) {
+		object = lookup_object(excess_ref, 0);
+		if (!object)
+			return;
+		if (object == scanned)
+			/* circular reference, ignore */
+			return;
+		raw_spin_lock_nested(&object->lock, SINGLE_DEPTH_NESTING);
+		update_refs(object);
+		raw_spin_unlock(&object->lock);
+	}
+}
+
 /*
  * Scan a memory block (exclusive range) for valid pointers and add those
  * found to the gray list.
@@ -1372,13 +1452,10 @@ static void scan_block(void *_start, voi
 	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
 	unsigned long *end = _end - (BYTES_PER_POINTER - 1);
 	unsigned long flags;
-	unsigned long untagged_ptr;
 
 	raw_spin_lock_irqsave(&kmemleak_lock, flags);
 	for (ptr = start; ptr < end; ptr++) {
-		struct kmemleak_object *object;
 		unsigned long pointer;
-		unsigned long excess_ref;
 
 		if (scan_should_stop())
 			break;
@@ -1387,50 +1464,8 @@ static void scan_block(void *_start, voi
 		pointer = *(unsigned long *)kasan_reset_tag((void *)ptr);
 		kasan_enable_current();
 
-		untagged_ptr = (unsigned long)kasan_reset_tag((void *)pointer);
-		if (untagged_ptr < min_addr || untagged_ptr >= max_addr)
-			continue;
-
-		/*
-		 * No need for get_object() here since we hold kmemleak_lock.
-		 * object->use_count cannot be dropped to 0 while the object
-		 * is still present in object_tree_root and object_list
-		 * (with updates protected by kmemleak_lock).
-		 */
-		object = lookup_object(pointer, 1);
-		if (!object)
-			continue;
-		if (object == scanned)
-			/* self referenced, ignore */
-			continue;
-
-		/*
-		 * Avoid the lockdep recursive warning on object->lock being
-		 * previously acquired in scan_object(). These locks are
-		 * enclosed by scan_mutex.
-		 */
-		raw_spin_lock_nested(&object->lock, SINGLE_DEPTH_NESTING);
-		/* only pass surplus references (object already gray) */
-		if (color_gray(object)) {
-			excess_ref = object->excess_ref;
-			/* no need for update_refs() if object already gray */
-		} else {
-			excess_ref = 0;
-			update_refs(object);
-		}
-		raw_spin_unlock(&object->lock);
-
-		if (excess_ref) {
-			object = lookup_object(excess_ref, 0);
-			if (!object)
-				continue;
-			if (object == scanned)
-				/* circular reference, ignore */
-				continue;
-			raw_spin_lock_nested(&object->lock, SINGLE_DEPTH_NESTING);
-			update_refs(object);
-			raw_spin_unlock(&object->lock);
-		}
+		scan_pointer(scanned, pointer, 0);
+		scan_pointer(scanned, pointer, OBJECT_PERCPU);
 	}
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
 }
_

Patches currently in -mm which might be from ptikhomirov@virtuozzo.com are

kmemleak-enable-tracking-for-percpu-pointers.patch
kmemleak-test-add-percpu-leak.patch


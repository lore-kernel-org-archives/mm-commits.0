Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4991CC77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbjDRXe3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjDRXeD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7294900E
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A3C4615E4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EBAC433D2;
        Tue, 18 Apr 2023 23:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860840;
        bh=zXB7fA+ibgZ38o0b8GBWpYjmvBMwNBIQ9LiXhat2kJI=;
        h=Date:To:From:Subject:From;
        b=axAqKsmDarcpwmeUTxyYdjatzts3Rm1qzCMQ3kjj98+S8bmSiFM0Sp4ctp1DWyc0r
         9Y5o3vmH6mG3btuF5cug3RYhFU7nNyRjRFL/Nly8QowE1lE2v4BvYwiXCiX0FDmi7A
         1qFCLYhkEhRg5OaH3STReFFbGsD5J5aF5UPkNin8=
Date:   Tue, 18 Apr 2023 16:33:59 -0700
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free.patch removed from -mm tree
Message-Id: <20230418233400.82EBAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kfence: improve the performance of __kfence_alloc() and __kfence_free()
has been removed from the -mm tree.  Its filename was
     mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: mm: kfence: improve the performance of __kfence_alloc() and __kfence_free()
Date: Mon, 3 Apr 2023 20:27:38 +0800

In __kfence_alloc() and __kfence_free(), we will set and check canary. 
Assuming that the size of the object is close to 0, nearly 4k memory
accesses are required because setting and checking canary is executed byte
by byte.

canary is now defined like this:
KFENCE_CANARY_PATTERN(addr) ((u8)0xaa ^ (u8)((unsigned long)(addr) & 0x7))

Observe that canary is only related to the lower three bits of the
address, so every 8 bytes of canary are the same.  We can access 8-byte
canary each time instead of byte-by-byte, thereby optimizing nearly 4k
memory accesses to 4k/8 times.

Use the bcc tool funclatency to measure the latency of __kfence_alloc()
and __kfence_free(), the numbers (deleted the distribution of latency) is
posted below.  Though different object sizes will have an impact on the
measurement, we ignore it for now and assume the average object size is
roughly equal.

Before patching:
__kfence_alloc:
avg = 5055 nsecs, total: 5515252 nsecs, count: 1091
__kfence_free:
avg = 5319 nsecs, total: 9735130 nsecs, count: 1830

After patching:
__kfence_alloc:
avg = 3597 nsecs, total: 6428491 nsecs, count: 1787
__kfence_free:
avg = 3046 nsecs, total: 3415390 nsecs, count: 1121

The numbers indicate that there is ~30% - ~40% performance improvement.

Link: https://lkml.kernel.org/r/20230403122738.6006-1-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c   |   70 ++++++++++++++++++++++++++++++-------------
 mm/kfence/kfence.h |   10 +++++-
 mm/kfence/report.c |    2 -
 3 files changed, 59 insertions(+), 23 deletions(-)

--- a/mm/kfence/core.c~mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free
+++ a/mm/kfence/core.c
@@ -297,20 +297,13 @@ metadata_update_state(struct kfence_meta
 	WRITE_ONCE(meta->state, next);
 }
 
-/* Write canary byte to @addr. */
-static inline bool set_canary_byte(u8 *addr)
-{
-	*addr = KFENCE_CANARY_PATTERN(addr);
-	return true;
-}
-
 /* Check canary byte at @addr. */
 static inline bool check_canary_byte(u8 *addr)
 {
 	struct kfence_metadata *meta;
 	unsigned long flags;
 
-	if (likely(*addr == KFENCE_CANARY_PATTERN(addr)))
+	if (likely(*addr == KFENCE_CANARY_PATTERN_U8(addr)))
 		return true;
 
 	atomic_long_inc(&counters[KFENCE_COUNTER_BUGS]);
@@ -323,15 +316,31 @@ static inline bool check_canary_byte(u8
 	return false;
 }
 
-/* __always_inline this to ensure we won't do an indirect call to fn. */
-static __always_inline void for_each_canary(const struct kfence_metadata *meta, bool (*fn)(u8 *))
+static inline void set_canary(const struct kfence_metadata *meta)
 {
 	const unsigned long pageaddr = ALIGN_DOWN(meta->addr, PAGE_SIZE);
-	unsigned long addr;
+	unsigned long addr = pageaddr;
+
+	/*
+	 * The canary may be written to part of the object memory, but it does
+	 * not affect it. The user should initialize the object before using it.
+	 */
+	for (; addr < meta->addr; addr += sizeof(u64))
+		*((u64 *)addr) = KFENCE_CANARY_PATTERN_U64;
+
+	addr = ALIGN_DOWN(meta->addr + meta->size, sizeof(u64));
+	for (; addr - pageaddr < PAGE_SIZE; addr += sizeof(u64))
+		*((u64 *)addr) = KFENCE_CANARY_PATTERN_U64;
+}
+
+static inline void check_canary(const struct kfence_metadata *meta)
+{
+	const unsigned long pageaddr = ALIGN_DOWN(meta->addr, PAGE_SIZE);
+	unsigned long addr = pageaddr;
 
 	/*
-	 * We'll iterate over each canary byte per-side until fn() returns
-	 * false. However, we'll still iterate over the canary bytes to the
+	 * We'll iterate over each canary byte per-side until a corrupted byte
+	 * is found. However, we'll still iterate over the canary bytes to the
 	 * right of the object even if there was an error in the canary bytes to
 	 * the left of the object. Specifically, if check_canary_byte()
 	 * generates an error, showing both sides might give more clues as to
@@ -339,16 +348,35 @@ static __always_inline void for_each_can
 	 */
 
 	/* Apply to left of object. */
-	for (addr = pageaddr; addr < meta->addr; addr++) {
-		if (!fn((u8 *)addr))
+	for (; meta->addr - addr >= sizeof(u64); addr += sizeof(u64)) {
+		if (unlikely(*((u64 *)addr) != KFENCE_CANARY_PATTERN_U64))
 			break;
 	}
 
-	/* Apply to right of object. */
-	for (addr = meta->addr + meta->size; addr < pageaddr + PAGE_SIZE; addr++) {
-		if (!fn((u8 *)addr))
+	/*
+	 * If the canary is corrupted in a certain 64 bytes, or the canary
+	 * memory cannot be completely covered by multiple consecutive 64 bytes,
+	 * it needs to be checked one by one.
+	 */
+	for (; addr < meta->addr; addr++) {
+		if (unlikely(!check_canary_byte((u8 *)addr)))
 			break;
 	}
+
+	/* Apply to right of object. */
+	for (addr = meta->addr + meta->size; addr % sizeof(u64) != 0; addr++) {
+		if (unlikely(!check_canary_byte((u8 *)addr)))
+			return;
+	}
+	for (; addr - pageaddr < PAGE_SIZE; addr += sizeof(u64)) {
+		if (unlikely(*((u64 *)addr) != KFENCE_CANARY_PATTERN_U64)) {
+
+			for (; addr - pageaddr < PAGE_SIZE; addr++) {
+				if (!check_canary_byte((u8 *)addr))
+					return;
+			}
+		}
+	}
 }
 
 static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t gfp,
@@ -434,7 +462,7 @@ static void *kfence_guarded_alloc(struct
 #endif
 
 	/* Memory initialization. */
-	for_each_canary(meta, set_canary_byte);
+	set_canary(meta);
 
 	/*
 	 * We check slab_want_init_on_alloc() ourselves, rather than letting
@@ -495,7 +523,7 @@ static void kfence_guarded_free(void *ad
 	alloc_covered_add(meta->alloc_stack_hash, -1);
 
 	/* Check canary bytes for memory corruption. */
-	for_each_canary(meta, check_canary_byte);
+	check_canary(meta);
 
 	/*
 	 * Clear memory if init-on-free is set. While we protect the page, the
@@ -751,7 +779,7 @@ static void kfence_check_all_canary(void
 		struct kfence_metadata *meta = &kfence_metadata[i];
 
 		if (meta->state == KFENCE_OBJECT_ALLOCATED)
-			for_each_canary(meta, check_canary_byte);
+			check_canary(meta);
 	}
 }
 
--- a/mm/kfence/kfence.h~mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free
+++ a/mm/kfence/kfence.h
@@ -21,7 +21,15 @@
  * lower 3 bits of the address, to detect memory corruptions with higher
  * probability, where similar constants are used.
  */
-#define KFENCE_CANARY_PATTERN(addr) ((u8)0xaa ^ (u8)((unsigned long)(addr) & 0x7))
+#define KFENCE_CANARY_PATTERN_U8(addr) ((u8)0xaa ^ (u8)((unsigned long)(addr) & 0x7))
+
+/*
+ * Define a continuous 8-byte canary starting from a multiple of 8. The canary
+ * of each byte is only related to the lowest three bits of its address, so the
+ * canary of every 8 bytes is the same. 64-bit memory can be filled and checked
+ * at a time instead of byte by byte to improve performance.
+ */
+#define KFENCE_CANARY_PATTERN_U64 ((u64)0xaaaaaaaaaaaaaaaa ^ (u64)(0x0706050403020100))
 
 /* Maximum stack depth for reports. */
 #define KFENCE_STACK_DEPTH 64
--- a/mm/kfence/report.c~mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free
+++ a/mm/kfence/report.c
@@ -168,7 +168,7 @@ static void print_diff_canary(unsigned l
 
 	pr_cont("[");
 	for (cur = (const u8 *)address; cur < end; cur++) {
-		if (*cur == KFENCE_CANARY_PATTERN(cur))
+		if (*cur == KFENCE_CANARY_PATTERN_U8(cur))
 			pr_cont(" .");
 		else if (no_hash_pointers)
 			pr_cont(" 0x%02x", *cur);
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-simplify-mas_wr_node_walk.patch
maple_tree-use-correct-variable-type-in-sizeof.patch
maple_tree-add-a-test-case-to-check-maple_alloc.patch


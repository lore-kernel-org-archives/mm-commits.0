Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAAEFCA0ED0
	for <mm-commits@archiver.kernel.org>; Mon, 11 Sep 2023 22:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235862AbjIKWVm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243959AbjIKSdd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 14:33:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C39B1A2
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 11:33:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C32C433C8;
        Mon, 11 Sep 2023 18:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694457208;
        bh=lGWw0PzFYqIwY5Nd1nzbTgwmWhvTri7Vukxwh/54lOc=;
        h=Date:To:From:Subject:From;
        b=zW3xKUo0t+OZhbgykTDkAmjcO5Ewy0veDXak/MYlKkqk8D0upxjZUkoRm2MB6VdU3
         uNr20HqSXDuen9wM7J8fOkXlEBxgxcb25/vv/0Pkvw41n7966pp6lv01qI6Q68Nk9N
         Zzv2ROV7S0gch7/t+hYLpsK5bzUXMOh8Y0u+rWv0=
Date:   Mon, 11 Sep 2023 11:33:27 -0700
To:     mm-commits@vger.kernel.org, elver@google.com, dvyukov@google.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-simplify-kmsan_internal_memmove_metadata.patch added to mm-unstable branch
Message-Id: <20230911183328.04C32C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmsan: simplify kmsan_internal_memmove_metadata()
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-simplify-kmsan_internal_memmove_metadata.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-simplify-kmsan_internal_memmove_metadata.patch

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
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: simplify kmsan_internal_memmove_metadata()
Date: Mon, 11 Sep 2023 16:56:59 +0200

kmsan_internal_memmove_metadata() is the function that implements copying
metadata every time memcpy()/memmove() is called.  Because shadow memory
stores 1 byte per each byte of kernel memory, copying the shadow is
trivial and can be done by a single memmove() call.

Origins, on the other hand, are stored as 4-byte values corresponding to
every aligned 4 bytes of kernel memory.  Therefore, if either the source
or the destination of kmsan_internal_memmove_metadata() is unaligned, the
number of origin slots corresponding to the source or destination may
differ:

  1) memcpy(0xffff888080a00000, 0xffff888080900000, 4)
     copies 1 origin slot into 1 origin slot:

     src (0xffff888080900000): xxxx
     src origins:              o111
     dst (0xffff888080a00000): xxxx
     dst origins:              o111

  2) memcpy(0xffff888080a00001, 0xffff888080900000, 4)
     copies 1 origin slot into 2 origin slots:

     src (0xffff888080900000): xxxx
     src origins:              o111
     dst (0xffff888080a00000): .xxx x...
     dst origins:              o111 o111

  3) memcpy(0xffff888080a00000, 0xffff888080900001, 4)
     copies 2 origin slots into 1 origin slot:

     src (0xffff888080900000): .xxx x...
     src origins:              o111 o222
     dst (0xffff888080a00000): xxxx
     dst origins:              o111
                           (or o222)

Previously, kmsan_internal_memmove_metadata() tried to solve this problem
by copying min(src_slots, dst_slots) as is and cloning the missing slot on
one of the ends, if needed.

This was error-prone even in the simple cases where 4 bytes were copied,
and did not account for situations where the total number of nonzero
origin slots could have increased by more than one after copying:

  memcpy(0xffff888080a00000, 0xffff888080900002, 8)

  src (0xffff888080900002): ..xx .... xx..
  src origins:              o111 0000 o222
  dst (0xffff888080a00000): xx.. ..xx
                            o111 0000
                        (or 0000 o222)

The new implementation simply copies the shadow byte by byte, and updates
the corresponding origin slot, if the shadow byte is nonzero.  This
approach can handle complex cases with mixed initialized and uninitialized
bytes.  Similarly to KMSAN inline instrumentation, latter writes to bytes
sharing the same origin slots take precedence.

Link: https://lkml.kernel.org/r/20230911145702.2663753-1-glider@google.com
Fixes: f80be4571b19 ("kmsan: add KMSAN runtime core")
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c |  127 +++++++++++-----------------------------------
 1 file changed, 31 insertions(+), 96 deletions(-)

--- a/mm/kmsan/core.c~kmsan-simplify-kmsan_internal_memmove_metadata
+++ a/mm/kmsan/core.c
@@ -83,131 +83,66 @@ depot_stack_handle_t kmsan_save_stack_wi
 /* Copy the metadata following the memmove() behavior. */
 void kmsan_internal_memmove_metadata(void *dst, void *src, size_t n)
 {
+	depot_stack_handle_t prev_old_origin = 0, prev_new_origin = 0;
+	int i, iter, step, src_off, dst_off, oiter_src, oiter_dst;
 	depot_stack_handle_t old_origin = 0, new_origin = 0;
-	int src_slots, dst_slots, i, iter, step, skip_bits;
 	depot_stack_handle_t *origin_src, *origin_dst;
-	void *shadow_src, *shadow_dst;
-	u32 *align_shadow_src, shadow;
+	u8 *shadow_src, *shadow_dst;
+	u32 *align_shadow_dst;
 	bool backwards;
 
 	shadow_dst = kmsan_get_metadata(dst, KMSAN_META_SHADOW);
 	if (!shadow_dst)
 		return;
 	KMSAN_WARN_ON(!kmsan_metadata_is_contiguous(dst, n));
+	align_shadow_dst =
+		(u32 *)ALIGN_DOWN((u64)shadow_dst, KMSAN_ORIGIN_SIZE);
 
 	shadow_src = kmsan_get_metadata(src, KMSAN_META_SHADOW);
 	if (!shadow_src) {
-		/*
-		 * @src is untracked: zero out destination shadow, ignore the
-		 * origins, we're done.
-		 */
-		__memset(shadow_dst, 0, n);
+		/* @src is untracked: mark @dst as initialized. */
+		kmsan_internal_unpoison_memory(dst, n, /*checked*/ false);
 		return;
 	}
 	KMSAN_WARN_ON(!kmsan_metadata_is_contiguous(src, n));
 
-	__memmove(shadow_dst, shadow_src, n);
-
 	origin_dst = kmsan_get_metadata(dst, KMSAN_META_ORIGIN);
 	origin_src = kmsan_get_metadata(src, KMSAN_META_ORIGIN);
 	KMSAN_WARN_ON(!origin_dst || !origin_src);
-	src_slots = (ALIGN((u64)src + n, KMSAN_ORIGIN_SIZE) -
-		     ALIGN_DOWN((u64)src, KMSAN_ORIGIN_SIZE)) /
-		    KMSAN_ORIGIN_SIZE;
-	dst_slots = (ALIGN((u64)dst + n, KMSAN_ORIGIN_SIZE) -
-		     ALIGN_DOWN((u64)dst, KMSAN_ORIGIN_SIZE)) /
-		    KMSAN_ORIGIN_SIZE;
-	KMSAN_WARN_ON((src_slots < 1) || (dst_slots < 1));
-	KMSAN_WARN_ON((src_slots - dst_slots > 1) ||
-		      (dst_slots - src_slots < -1));
 
 	backwards = dst > src;
-	i = backwards ? min(src_slots, dst_slots) - 1 : 0;
-	iter = backwards ? -1 : 1;
-
-	align_shadow_src =
-		(u32 *)ALIGN_DOWN((u64)shadow_src, KMSAN_ORIGIN_SIZE);
-	for (step = 0; step < min(src_slots, dst_slots); step++, i += iter) {
-		KMSAN_WARN_ON(i < 0);
-		shadow = align_shadow_src[i];
-		if (i == 0) {
-			/*
-			 * If @src isn't aligned on KMSAN_ORIGIN_SIZE, don't
-			 * look at the first @src % KMSAN_ORIGIN_SIZE bytes
-			 * of the first shadow slot.
-			 */
-			skip_bits = ((u64)src % KMSAN_ORIGIN_SIZE) * 8;
-			shadow = (shadow >> skip_bits) << skip_bits;
+	step = backwards ? -1 : 1;
+	iter = backwards ? n - 1 : 0;
+	src_off = (u64)src % KMSAN_ORIGIN_SIZE;
+	dst_off = (u64)dst % KMSAN_ORIGIN_SIZE;
+
+	/* Copy shadow bytes one by one, updating the origins if necessary. */
+	for (i = 0; i < n; i++, iter += step) {
+		oiter_src = (iter + src_off) / KMSAN_ORIGIN_SIZE;
+		oiter_dst = (iter + dst_off) / KMSAN_ORIGIN_SIZE;
+		if (!shadow_src[iter]) {
+			shadow_dst[iter] = 0;
+			if (!align_shadow_dst[oiter_dst])
+				origin_dst[oiter_dst] = 0;
+			continue;
 		}
-		if (i == src_slots - 1) {
-			/*
-			 * If @src + n isn't aligned on
-			 * KMSAN_ORIGIN_SIZE, don't look at the last
-			 * (@src + n) % KMSAN_ORIGIN_SIZE bytes of the
-			 * last shadow slot.
-			 */
-			skip_bits = (((u64)src + n) % KMSAN_ORIGIN_SIZE) * 8;
-			shadow = (shadow << skip_bits) >> skip_bits;
-		}
-		/*
-		 * Overwrite the origin only if the corresponding
-		 * shadow is nonempty.
-		 */
-		if (origin_src[i] && (origin_src[i] != old_origin) && shadow) {
-			old_origin = origin_src[i];
-			new_origin = kmsan_internal_chain_origin(old_origin);
+		shadow_dst[iter] = shadow_src[iter];
+		old_origin = origin_src[oiter_src];
+		if (old_origin == prev_old_origin)
+			new_origin = prev_new_origin;
+		else {
 			/*
 			 * kmsan_internal_chain_origin() may return
 			 * NULL, but we don't want to lose the previous
 			 * origin value.
 			 */
+			new_origin = kmsan_internal_chain_origin(old_origin);
 			if (!new_origin)
 				new_origin = old_origin;
 		}
-		if (shadow)
-			origin_dst[i] = new_origin;
-		else
-			origin_dst[i] = 0;
-	}
-	/*
-	 * If dst_slots is greater than src_slots (i.e.
-	 * dst_slots == src_slots + 1), there is an extra origin slot at the
-	 * beginning or end of the destination buffer, for which we take the
-	 * origin from the previous slot.
-	 * This is only done if the part of the source shadow corresponding to
-	 * slot is non-zero.
-	 *
-	 * E.g. if we copy 8 aligned bytes that are marked as uninitialized
-	 * and have origins o111 and o222, to an unaligned buffer with offset 1,
-	 * these two origins are copied to three origin slots, so one of then
-	 * needs to be duplicated, depending on the copy direction (@backwards)
-	 *
-	 *   src shadow: |uuuu|uuuu|....|
-	 *   src origin: |o111|o222|....|
-	 *
-	 * backwards = 0:
-	 *   dst shadow: |.uuu|uuuu|u...|
-	 *   dst origin: |....|o111|o222| - fill the empty slot with o111
-	 * backwards = 1:
-	 *   dst shadow: |.uuu|uuuu|u...|
-	 *   dst origin: |o111|o222|....| - fill the empty slot with o222
-	 */
-	if (src_slots < dst_slots) {
-		if (backwards) {
-			shadow = align_shadow_src[src_slots - 1];
-			skip_bits = (((u64)dst + n) % KMSAN_ORIGIN_SIZE) * 8;
-			shadow = (shadow << skip_bits) >> skip_bits;
-			if (shadow)
-				/* src_slots > 0, therefore dst_slots is at least 2 */
-				origin_dst[dst_slots - 1] =
-					origin_dst[dst_slots - 2];
-		} else {
-			shadow = align_shadow_src[0];
-			skip_bits = ((u64)dst % KMSAN_ORIGIN_SIZE) * 8;
-			shadow = (shadow >> skip_bits) << skip_bits;
-			if (shadow)
-				origin_dst[0] = origin_dst[1];
-		}
+		origin_dst[oiter_dst] = new_origin;
+		prev_new_origin = new_origin;
+		prev_old_origin = old_origin;
 	}
 }
 
_

Patches currently in -mm which might be from glider@google.com are

kmsan-simplify-kmsan_internal_memmove_metadata.patch
kmsan-prevent-optimizations-in-memcpy-tests.patch
kmsan-merge-test_memcpy_aligned_to_unaligned2-together.patch
kmsan-introduce-test_memcpy_initialized_gap.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6ED4502F
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 04:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761451248; cv=none; b=G8KXffWbYbnsL2yC+5SDeZ5nGimfywnGCQPCQf4qxpTyMPxVAAp3A1uXrnpzIlfx/hVPDE0AQ9JaEdnu8KmItqrY9T5nD0f1qecSBYDpXl8ZSO3af9NWQZuYUKXc4bTJEgNK0xpjj85fJU6HA+sGOZQrwblq7eHn0M1nk3U5F5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761451248; c=relaxed/simple;
	bh=I/nlVRl59D1bIGup/Vvn7RFaLM+iP9v2JQRpQcjEXs4=;
	h=Date:To:From:Subject:Message-Id; b=PO9fGdSGNFmlOy3ApcwZmGeLFm7YAlctmpO+7wBtUO0GzLRnuiPg/anWPnweYB/GxnpFjanwOthWi9m26dm+c+q5GvmaxgDZxco1J6GTTHnfG67sLB4E2u8yRrgmV/JUIhNCjO8qTeZiiVOWAeLjWSVMJn1lmWmlY3fW8/2rtn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qsMHYniS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qsMHYniS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8ABC4CEE7;
	Sun, 26 Oct 2025 04:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761451248;
	bh=I/nlVRl59D1bIGup/Vvn7RFaLM+iP9v2JQRpQcjEXs4=;
	h=Date:To:From:Subject:From;
	b=qsMHYniS0lNIetVqV0ZEsnzQREhne5+7kxx3fTYO38M//SlRTm+IuDQlHJQNkrwk0
	 e/podojMqsmIlNyX5N6uo738Ej10ESUjn3yYn2KVGZmPPG2BZPgmiqX1Wm71K5yEsI
	 2RBvosZIbTaA6HoXNQT+GDAs3kT91hVdSIXG95tk=
Date: Sat, 25 Oct 2025 21:00:47 -0700
To: mm-commits@vger.kernel.org,hch@infradead.org,linux@treblig.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-xxhash-remove-more-unused-xxh-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20251026040048.3A8ABC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/xxhash: remove more unused xxh functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-xxhash-remove-more-unused-xxh-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-xxhash-remove-more-unused-xxh-functions.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: lib/xxhash: remove more unused xxh functions
Date: Fri, 24 Oct 2025 21:51:20 +0100

xxh32_reset() and xxh32_copy_state() are unused, and with those gone, the
xxh32_state struct is also unused.

xxh64_copy_state() is also unused.

Remove them all.

(Also fixes a comment above the xxh64_state that referred to it as
xxh32_state).

Link: https://lkml.kernel.org/r/20251024205120.454508-1-linux@treblig.org
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xxhash.h |   46 ---------------------------------------
 lib/xxhash.c           |   29 ------------------------
 2 files changed, 1 insertion(+), 74 deletions(-)

--- a/include/linux/xxhash.h~lib-xxhash-remove-more-unused-xxh-functions
+++ a/include/linux/xxhash.h
@@ -141,21 +141,7 @@ static inline unsigned long xxhash(const
  */
 
 /**
- * struct xxh32_state - private xxh32 state, do not use members directly
- */
-struct xxh32_state {
-	uint32_t total_len_32;
-	uint32_t large_len;
-	uint32_t v1;
-	uint32_t v2;
-	uint32_t v3;
-	uint32_t v4;
-	uint32_t mem32[4];
-	uint32_t memsize;
-};
-
-/**
- * struct xxh32_state - private xxh64 state, do not use members directly
+ * struct xxh64_state - private xxh64 state, do not use members directly
  */
 struct xxh64_state {
 	uint64_t total_len;
@@ -168,16 +154,6 @@ struct xxh64_state {
 };
 
 /**
- * xxh32_reset() - reset the xxh32 state to start a new hashing operation
- *
- * @state: The xxh32 state to reset.
- * @seed:  Initialize the hash state with this seed.
- *
- * Call this function on any xxh32_state to prepare for a new hashing operation.
- */
-void xxh32_reset(struct xxh32_state *state, uint32_t seed);
-
-/**
  * xxh64_reset() - reset the xxh64 state to start a new hashing operation
  *
  * @state: The xxh64 state to reset.
@@ -210,24 +186,4 @@ int xxh64_update(struct xxh64_state *sta
  */
 uint64_t xxh64_digest(const struct xxh64_state *state);
 
-/*-**************************
- * Utils
- ***************************/
-
-/**
- * xxh32_copy_state() - copy the source state into the destination state
- *
- * @src: The source xxh32 state.
- * @dst: The destination xxh32 state.
- */
-void xxh32_copy_state(struct xxh32_state *dst, const struct xxh32_state *src);
-
-/**
- * xxh64_copy_state() - copy the source state into the destination state
- *
- * @src: The source xxh64 state.
- * @dst: The destination xxh64 state.
- */
-void xxh64_copy_state(struct xxh64_state *dst, const struct xxh64_state *src);
-
 #endif /* XXHASH_H */
--- a/lib/xxhash.c~lib-xxhash-remove-more-unused-xxh-functions
+++ a/lib/xxhash.c
@@ -73,21 +73,6 @@ static const uint64_t PRIME64_3 =  16095
 static const uint64_t PRIME64_4 =  9650029242287828579ULL;
 static const uint64_t PRIME64_5 =  2870177450012600261ULL;
 
-/*-**************************
- *  Utils
- ***************************/
-void xxh32_copy_state(struct xxh32_state *dst, const struct xxh32_state *src)
-{
-	memcpy(dst, src, sizeof(*dst));
-}
-EXPORT_SYMBOL(xxh32_copy_state);
-
-void xxh64_copy_state(struct xxh64_state *dst, const struct xxh64_state *src)
-{
-	memcpy(dst, src, sizeof(*dst));
-}
-EXPORT_SYMBOL(xxh64_copy_state);
-
 /*-***************************
  * Simple Hash Functions
  ****************************/
@@ -239,20 +224,6 @@ EXPORT_SYMBOL(xxh64);
 /*-**************************************************
  * Advanced Hash Functions
  ***************************************************/
-void xxh32_reset(struct xxh32_state *statePtr, const uint32_t seed)
-{
-	/* use a local state for memcpy() to avoid strict-aliasing warnings */
-	struct xxh32_state state;
-
-	memset(&state, 0, sizeof(state));
-	state.v1 = seed + PRIME32_1 + PRIME32_2;
-	state.v2 = seed + PRIME32_2;
-	state.v3 = seed + 0;
-	state.v4 = seed - PRIME32_1;
-	memcpy(statePtr, &state, sizeof(state));
-}
-EXPORT_SYMBOL(xxh32_reset);
-
 void xxh64_reset(struct xxh64_state *statePtr, const uint64_t seed)
 {
 	/* use a local state for memcpy() to avoid strict-aliasing warnings */
_

Patches currently in -mm which might be from linux@treblig.org are

lib-xxhash-remove-more-unused-xxh-functions.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CD82ECD11
	for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2025 21:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752702700; cv=none; b=FTIYCVDTgXB9bvYYbt8RxrUhEsRc2lxCnyE8+8zXGwxkMWjdE26ThCMy7Gajfn4YERFoE73TFwRHKaPzUZYy5FnQMtj3RMCqipzYPOuRhJv1v5CoVPQ1z/s8XmDakqTxoa3tLD7aRe6IeiEtibg7Hl6x4XG3j9N1BIm8AtRj2rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752702700; c=relaxed/simple;
	bh=l3rjtk7X43z/hDEysIgfSNjHC2RGBVtlPiAKSmSFuRA=;
	h=Date:To:From:Subject:Message-Id; b=jnw2aRtNFDgJumOp6UvkYSBBFtH6Bj+5uQerPqrak+JMOms2MH9cnWsOtyDBj67wTxZXyo0+OSCXLTc0w41iSaq5473ToG4ILAbjWflGAPS688vaZsWHBnIHJFvsMg4DNP1fdSYBrsij88EQoWL36eCb6EwZkSwO1SO/nTbdg4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YmTMRPUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YmTMRPUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901B6C4CEE7;
	Wed, 16 Jul 2025 21:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752702697;
	bh=l3rjtk7X43z/hDEysIgfSNjHC2RGBVtlPiAKSmSFuRA=;
	h=Date:To:From:Subject:From;
	b=YmTMRPUtpTWmKbWUdISleJxb7iEseU0vBOhxtTgIgFYY+NmnELjqs1Yk4081itbAB
	 0xdaF42vTmg3YfRLSFCgcmZ8sYmuRebN4uraJPSoQ/IXMThjIbI97tQdnVh1qIenAX
	 lq7Z0udvByR92btPP6NwjA3A74zadjK+dIkE6Zic=
Date: Wed, 16 Jul 2025 14:51:36 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,hch@lst.de,linux@treblig.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-xxhash-remove-unused-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20250716215137.901B6C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/xxhash: remove unused functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-xxhash-remove-unused-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-xxhash-remove-unused-functions.patch

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
Subject: lib/xxhash: remove unused functions
Date: Wed, 16 Jul 2025 14:32:45 +0100

xxh32_digest() and xxh32_update() were added in 2017 in the original
xxhash commit, but have remained unused.

Remove them.

Link: https://lkml.kernel.org/r/20250716133245.243363-1-linux@treblig.org
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dave Gilbert <linux@treblig.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xxhash.h |   26 ---------
 lib/xxhash.c           |  107 ---------------------------------------
 2 files changed, 133 deletions(-)

--- a/include/linux/xxhash.h~lib-xxhash-remove-unused-functions
+++ a/include/linux/xxhash.h
@@ -178,32 +178,6 @@ struct xxh64_state {
 void xxh32_reset(struct xxh32_state *state, uint32_t seed);
 
 /**
- * xxh32_update() - hash the data given and update the xxh32 state
- *
- * @state:  The xxh32 state to update.
- * @input:  The data to hash.
- * @length: The length of the data to hash.
- *
- * After calling xxh32_reset() call xxh32_update() as many times as necessary.
- *
- * Return:  Zero on success, otherwise an error code.
- */
-int xxh32_update(struct xxh32_state *state, const void *input, size_t length);
-
-/**
- * xxh32_digest() - produce the current xxh32 hash
- *
- * @state: Produce the current xxh32 hash of this state.
- *
- * A hash value can be produced at any time. It is still possible to continue
- * inserting input into the hash state after a call to xxh32_digest(), and
- * generate new hashes later on, by calling xxh32_digest() again.
- *
- * Return: The xxh32 hash stored in the state.
- */
-uint32_t xxh32_digest(const struct xxh32_state *state);
-
-/**
  * xxh64_reset() - reset the xxh64 state to start a new hashing operation
  *
  * @state: The xxh64 state to reset.
--- a/lib/xxhash.c~lib-xxhash-remove-unused-functions
+++ a/lib/xxhash.c
@@ -267,113 +267,6 @@ void xxh64_reset(struct xxh64_state *sta
 }
 EXPORT_SYMBOL(xxh64_reset);
 
-int xxh32_update(struct xxh32_state *state, const void *input, const size_t len)
-{
-	const uint8_t *p = (const uint8_t *)input;
-	const uint8_t *const b_end = p + len;
-
-	if (input == NULL)
-		return -EINVAL;
-
-	state->total_len_32 += (uint32_t)len;
-	state->large_len |= (len >= 16) | (state->total_len_32 >= 16);
-
-	if (state->memsize + len < 16) { /* fill in tmp buffer */
-		memcpy((uint8_t *)(state->mem32) + state->memsize, input, len);
-		state->memsize += (uint32_t)len;
-		return 0;
-	}
-
-	if (state->memsize) { /* some data left from previous update */
-		const uint32_t *p32 = state->mem32;
-
-		memcpy((uint8_t *)(state->mem32) + state->memsize, input,
-			16 - state->memsize);
-
-		state->v1 = xxh32_round(state->v1, get_unaligned_le32(p32));
-		p32++;
-		state->v2 = xxh32_round(state->v2, get_unaligned_le32(p32));
-		p32++;
-		state->v3 = xxh32_round(state->v3, get_unaligned_le32(p32));
-		p32++;
-		state->v4 = xxh32_round(state->v4, get_unaligned_le32(p32));
-		p32++;
-
-		p += 16-state->memsize;
-		state->memsize = 0;
-	}
-
-	if (p <= b_end - 16) {
-		const uint8_t *const limit = b_end - 16;
-		uint32_t v1 = state->v1;
-		uint32_t v2 = state->v2;
-		uint32_t v3 = state->v3;
-		uint32_t v4 = state->v4;
-
-		do {
-			v1 = xxh32_round(v1, get_unaligned_le32(p));
-			p += 4;
-			v2 = xxh32_round(v2, get_unaligned_le32(p));
-			p += 4;
-			v3 = xxh32_round(v3, get_unaligned_le32(p));
-			p += 4;
-			v4 = xxh32_round(v4, get_unaligned_le32(p));
-			p += 4;
-		} while (p <= limit);
-
-		state->v1 = v1;
-		state->v2 = v2;
-		state->v3 = v3;
-		state->v4 = v4;
-	}
-
-	if (p < b_end) {
-		memcpy(state->mem32, p, (size_t)(b_end-p));
-		state->memsize = (uint32_t)(b_end-p);
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(xxh32_update);
-
-uint32_t xxh32_digest(const struct xxh32_state *state)
-{
-	const uint8_t *p = (const uint8_t *)state->mem32;
-	const uint8_t *const b_end = (const uint8_t *)(state->mem32) +
-		state->memsize;
-	uint32_t h32;
-
-	if (state->large_len) {
-		h32 = xxh_rotl32(state->v1, 1) + xxh_rotl32(state->v2, 7) +
-			xxh_rotl32(state->v3, 12) + xxh_rotl32(state->v4, 18);
-	} else {
-		h32 = state->v3 /* == seed */ + PRIME32_5;
-	}
-
-	h32 += state->total_len_32;
-
-	while (p + 4 <= b_end) {
-		h32 += get_unaligned_le32(p) * PRIME32_3;
-		h32 = xxh_rotl32(h32, 17) * PRIME32_4;
-		p += 4;
-	}
-
-	while (p < b_end) {
-		h32 += (*p) * PRIME32_5;
-		h32 = xxh_rotl32(h32, 11) * PRIME32_1;
-		p++;
-	}
-
-	h32 ^= h32 >> 15;
-	h32 *= PRIME32_2;
-	h32 ^= h32 >> 13;
-	h32 *= PRIME32_3;
-	h32 ^= h32 >> 16;
-
-	return h32;
-}
-EXPORT_SYMBOL(xxh32_digest);
-
 int xxh64_update(struct xxh64_state *state, const void *input, const size_t len)
 {
 	const uint8_t *p = (const uint8_t *)input;
_

Patches currently in -mm which might be from linux@treblig.org are

lib-xxhash-remove-unused-functions.patch
lib-xxhash-comment-out-unused-functions.patch


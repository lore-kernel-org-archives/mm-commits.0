Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8760436A03F
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 22:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660960; cv=none; b=fyZIsqWXtWnzBOi7AY+NFTIa4fsp91MevYVQDro/U2Q7lVAtqGYI299ZNDI0HgMsswYwnNArniYg6Z7fGUxgPTHdUCud3OHtG9+GaA+G2ZVFLF0gtNSrS4hfI9iKA2toCfmShlHEVMev01WJUhblp5YO8+8eq+2tZN9K96E8Hno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660960; c=relaxed/simple;
	bh=cOykXQfyKq5rDV/sNXTfZ/k8kvfp/edOWgj1AWmin7g=;
	h=Date:To:From:Subject:Message-Id; b=eo9RjjQlGm9cp4m/np1v4RTkcyY+/qLC1e6/sjeIRLnANaCs/nbyPuXRhnbVO9KSbET4XQRLmHfzqWT/xlavLSD1GUsO9ix22R34TbHXZ76HxFHPEQB/QIccHqTsq9T/z/aNEJVcvX3F5mNZgyQx6Re7x5DV/1pVfY4NAviVdu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tjTzjaRx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tjTzjaRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342551F000E9;
	Thu, 13 Aug 2026 22:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660959;
	bh=yGosHoxV4hqo0AM2XBzQK1DuD2cmj8FeyWYvMMzEW04=;
	h=Date:To:From:Subject;
	b=tjTzjaRxyidRJZb4RfITNW5seRRKcVQhW7r0F1tcYRZIommIeeUDuOZQVhcSMWpnH
	 etD8Bqcyn65kPRWQvbzw2+GOg2eT06bbWY37u99zgNZHNrDjnFMD5bbdJomIF4m6Fb
	 j2nFoqiQFmjSzkfC8eVG9/iyb1XyGnguiZxNKg4I=
Date: Thu, 13 Aug 2026 15:42:38 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@linux.dev,nathan@kernel.org,david.laight.linux@gmail.com,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-xz-use-size_t-instead-of-uint32_t-in-a-few-places.patch removed from -mm tree
Message-Id: <20260813224239.342551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/xz: use size_t instead of uint32_t in a few places
has been removed from the -mm tree.  Its filename was
     lib-xz-use-size_t-instead-of-uint32_t-in-a-few-places.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: lib/xz: use size_t instead of uint32_t in a few places
Date: Sun, 14 Jun 2026 19:05:17 +0300

Reduce the number of uint32_t <-> size_t conversions a little. 
Eliminating such conversions entirely would require changing almost all
uint32_t to size_t, which would look confusing and increase the sizes of
the structs even more.  Going the other way, converting everything to
uint32_t, isn't possible because the input and output buffers use size_t
in struct xz_buf.

Now both arguments to min() have the same type.  This is required to for
compatibility with PowerPC boot code[1] whose min() is strict like
include/linux/minmax.h was before the commit d03eba99f5bf ("minmax: allow
min()/max()/clamp() if the arguments have the same signedness.").

Swap the order of the "state" and "len" in struct lzma_dec to avoid
padding in the middle of the struct when size_t is 64 bits.  The
reordering doesn't change the size of the struct; the padding just appears
at the end instead.

dict_flush() used to truncate size_t to uint32_t when returning.  This
wasn't a bug; the value is always small enough.

Link: https://lore.kernel.org/20260614160521.924710-1-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/lkml/20260610232323.GA1071374@ax162/ [1]
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/xz_dec_lzma2.c |   40 ++++++++++++++++++++--------------------
 lib/xz/xz_lzma2.h     |    2 +-
 2 files changed, 21 insertions(+), 21 deletions(-)

--- a/lib/xz/xz_dec_lzma2.c~lib-xz-use-size_t-instead-of-uint32_t-in-a-few-places
+++ a/lib/xz/xz_dec_lzma2.c
@@ -135,14 +135,16 @@ struct lzma_dec {
 	uint32_t rep2;
 	uint32_t rep3;
 
-	/* Types of the most recently seen LZMA symbols */
-	enum lzma_state state;
-
 	/*
 	 * Length of a match. This is updated so that dict_repeat can
-	 * be called again to finish repeating the whole match.
+	 * be called again to finish repeating the whole match. This is
+	 * size_t because a pointer to this is passed to dict_repeat,
+	 * and there it's nicer to have size_t instead of uint32_t.
 	 */
-	uint32_t len;
+	size_t len;
+
+	/* Types of the most recently seen LZMA symbols */
+	enum lzma_state state;
 
 	/*
 	 * LZMA properties or related bit masks (number of literal
@@ -228,13 +230,13 @@ struct lzma2_dec {
 	enum lzma2_seq next_sequence;
 
 	/* Uncompressed size of LZMA chunk (2 MiB at maximum) */
-	uint32_t uncompressed;
+	size_t uncompressed;
 
 	/*
 	 * Compressed size of LZMA chunk or compressed/uncompressed
 	 * size of uncompressed chunk (64 KiB at maximum)
 	 */
-	uint32_t compressed;
+	size_t compressed;
 
 	/*
 	 * True if dictionary reset is needed. This is false before
@@ -273,7 +275,7 @@ struct xz_dec_lzma2 {
 	 * decoder calls. See lzma2_lzma() for details.
 	 */
 	struct {
-		uint32_t size;
+		size_t size;
 		uint8_t buf[3 * LZMA_IN_REQUIRED];
 	} temp;
 };
@@ -320,7 +322,7 @@ static inline bool dict_has_space(const
  * still empty. This special case is needed for single-call decoding to
  * avoid writing a '\0' to the end of the destination buffer.
  */
-static inline uint32_t dict_get(const struct dictionary *dict, uint32_t dist)
+static inline uint32_t dict_get(const struct dictionary *dict, size_t dist)
 {
 	size_t offset = dict->pos - dist - 1;
 
@@ -346,10 +348,10 @@ static inline void dict_put(struct dicti
  * invalid, false is returned. On success, true is returned and *len is
  * updated to indicate how many bytes were left to be repeated.
  */
-static bool dict_repeat(struct dictionary *dict, uint32_t *len, uint32_t dist)
+static bool dict_repeat(struct dictionary *dict, size_t *len, size_t dist)
 {
 	size_t back;
-	uint32_t left;
+	size_t left;
 
 	if (dist >= dict->full || dist >= dict->size)
 		return false;
@@ -375,7 +377,7 @@ static bool dict_repeat(struct dictionar
 
 /* Copy uncompressed data as is from input to dictionary and output buffers. */
 static void dict_uncompressed(struct dictionary *dict, struct xz_buf *b,
-			      uint32_t *left)
+			      size_t *left)
 {
 	size_t copy_size;
 
@@ -433,7 +435,7 @@ static void dict_uncompressed(struct dic
  * enough space in b->out. This is guaranteed because caller uses dict_limit()
  * before decoding data into the dictionary.
  */
-static uint32_t dict_flush(struct dictionary *dict, struct xz_buf *b)
+static size_t dict_flush(struct dictionary *dict, struct xz_buf *b)
 {
 	size_t copy_size = dict->pos - dict->start;
 
@@ -878,7 +880,7 @@ static bool lzma_props(struct xz_dec_lzm
 static bool lzma2_lzma(struct xz_dec_lzma2 *s, struct xz_buf *b)
 {
 	size_t in_avail;
-	uint32_t tmp;
+	size_t tmp;
 
 	in_avail = b->in_size - b->in_pos;
 	if (s->temp.size > 0 || s->lzma2.compressed == 0) {
@@ -1046,25 +1048,23 @@ enum xz_ret xz_dec_lzma2_run(struct xz_d
 
 		case SEQ_UNCOMPRESSED_1:
 			s->lzma2.uncompressed
-					+= (uint32_t)b->in[b->in_pos++] << 8;
+					+= (size_t)b->in[b->in_pos++] << 8;
 			s->lzma2.sequence = SEQ_UNCOMPRESSED_2;
 			break;
 
 		case SEQ_UNCOMPRESSED_2:
 			s->lzma2.uncompressed
-					+= (uint32_t)b->in[b->in_pos++] + 1;
+					+= (size_t)b->in[b->in_pos++] + 1;
 			s->lzma2.sequence = SEQ_COMPRESSED_0;
 			break;
 
 		case SEQ_COMPRESSED_0:
-			s->lzma2.compressed
-					= (uint32_t)b->in[b->in_pos++] << 8;
+			s->lzma2.compressed = (size_t)b->in[b->in_pos++] << 8;
 			s->lzma2.sequence = SEQ_COMPRESSED_1;
 			break;
 
 		case SEQ_COMPRESSED_1:
-			s->lzma2.compressed
-					+= (uint32_t)b->in[b->in_pos++] + 1;
+			s->lzma2.compressed += (size_t)b->in[b->in_pos++] + 1;
 			s->lzma2.sequence = s->lzma2.next_sequence;
 			break;
 
--- a/lib/xz/xz_lzma2.h~lib-xz-use-size_t-instead-of-uint32_t-in-a-few-places
+++ a/lib/xz/xz_lzma2.h
@@ -143,7 +143,7 @@ static inline bool lzma_state_is_literal
  * Get the index of the appropriate probability array for decoding
  * the distance slot.
  */
-static inline uint32_t lzma_get_dist_state(uint32_t len)
+static inline size_t lzma_get_dist_state(size_t len)
 {
 	return len < DIST_STATES + MATCH_LEN_MIN
 			? len - MATCH_LEN_MIN : DIST_STATES - 1;
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are



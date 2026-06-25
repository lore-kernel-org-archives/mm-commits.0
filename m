Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B97B1F1513
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 23:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782429523; cv=none; b=aRUzucpAqUeBXV8RTRJqBCut3hoE0T2+e2rVHz6A5EoXScFWoImursvq15GNaAiXo2ZMjTtFkjapYg9ZlZMQEAdYMM6/T2FXmcuqbFc9SGcXakcSHN3p40J9PK5mwra8a5J0zRXRLlsjlmt0wFUa5/JAy3pbpYsj2NHGd2sPg3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782429523; c=relaxed/simple;
	bh=yL2A2Vu1sTm5FaLBGM52z4mQwG2afpoVBoiEHhXGLjg=;
	h=Date:To:From:Subject:Message-Id; b=kGWhD0cg8amDwyxjtXRkJDShXM0novELhnBC/Rv8ybzCUP7HdXpJE4+DKQuHoV8Z7F/LetBXlWYgECQK1nOQVY6A4funmJr55wzstQ3pfv68BDA0eBiUb9jKvvo+DAMCyjhe9lWNcP8Ak4wJKVkD1zdWgtEwo7mC54nL9z5VIL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R5aT1bsq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R5aT1bsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB421F000E9;
	Thu, 25 Jun 2026 23:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782429521;
	bh=CMS3dlHk7AS5z47TQMz9oeOqpltVFpizJPCfQuqYCtQ=;
	h=Date:To:From:Subject;
	b=R5aT1bsq5QVuEd9aaynp5bAlkrZLiZNdKStMp7tF2x9xvYY4JDAJqS+0mm3TK//OF
	 rKh0NiNDhIOPXb5697pcgZnJ477bFTaUZlMkfet7do6Ol4fz+KciC0ZBgVXJccXFdQ
	 +6uEyI5gRBhwx1PFVsQCcBz30nNaWtcgxtMNg6fo=
Date: Thu, 25 Jun 2026 16:18:41 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@linux.dev,nathan@kernel.org,david.laight.linux@gmail.com,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-xz-use-size_t-instead-of-uint32_t-in-a-few-places.patch added to mm-nonmm-unstable branch
Message-Id: <20260625231841.BCB421F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/xz: use size_t instead of uint32_t in a few places
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-xz-use-size_t-instead-of-uint32_t-in-a-few-places.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-xz-use-size_t-instead-of-uint32_t-in-a-few-places.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

lib-xz-use-size_t-instead-of-uint32_t-in-a-few-places.patch
lib-xz-fix-comments.patch


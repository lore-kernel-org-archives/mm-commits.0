Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916792472A2
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 02:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785810952; cv=none; b=mxGK74PETtHbJibOTYttlY3sNN1fyTravbzQYrpZ5E6YDLxXpIWcrxfjaavj61t9jcuXOtgpVOgld7pnYgDj5eOiWOjCspvYfGnu+M8Ik4oEJKTpJDKznQxoZ8OyxUB8G9YI89umJCJ6nQKYg3n6JgkUBnNGSgIvkHyhvJFQ5Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785810952; c=relaxed/simple;
	bh=Rw6wVuZp9UFjCuGn+II8oF/nnTOCjurvI1CV7uPm1cE=;
	h=Date:To:From:Subject:Message-Id; b=BfPaS5vQpTP1Yh0KPsvBl7ZVg8YCX3wg/9RNwPKYcIhfEF7AsIpIkaAQEjTxdniCpHA8Jso2YgKa5u0nX28aOzvVdvb9BlEoTNcZgxYC/yTkR+OgoMyBqu5qLH8F+nQAQGH+kDJdK3+kMMKDpSpkcPvtYRNm3Fvz5+PMgPhBHJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UpyWvtT+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UpyWvtT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17891F000E9;
	Tue,  4 Aug 2026 02:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785810951;
	bh=Vy0z/CGa7P2MuqLC8nQUP9QYVYaa9ts1wzmxw3znzRQ=;
	h=Date:To:From:Subject;
	b=UpyWvtT+h6JAdvdqMwOeNF4s4TzVs2xpFPKcgkUgEROZ+UV4AAdKaLLAgDbv68DYx
	 7f/YX2gfd2pwgFDhW//yoZgQPpQdnqymbPeVBFMlpMAKqwhajrZsS1wJGojLSLrw1j
	 kLEJdPVB/xIkSe/amjejJ/3JJ/JpLfDWIheAmbGY=
Date: Mon, 03 Aug 2026 19:35:50 -0700
To: mm-commits@vger.kernel.org,lasse.collin@tukaani.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-xz-replace-min_t-with-min.patch removed from -mm tree
Message-Id: <20260804023550.F17891F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/xz: replace min_t with min
has been removed from the -mm tree.  Its filename was
     lib-xz-replace-min_t-with-min.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: lib/xz: replace min_t with min
Date: Tue, 9 Jun 2026 18:00:28 +0300

Use the simpler min() macro since the values are unsigned and compatible.

Link: https://lore.kernel.org/20260609150030.634570-1-lasse.collin@tukaani.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/xz_dec_bcj.c    |    2 +-
 lib/xz/xz_dec_lzma2.c  |   11 +++++------
 lib/xz/xz_dec_stream.c |    4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

--- a/lib/xz/xz_dec_bcj.c~lib-xz-replace-min_t-with-min
+++ a/lib/xz/xz_dec_bcj.c
@@ -466,7 +466,7 @@ static void bcj_flush(struct xz_dec_bcj
 {
 	size_t copy_size;
 
-	copy_size = min_t(size_t, s->temp.filtered, b->out_size - b->out_pos);
+	copy_size = min(s->temp.filtered, b->out_size - b->out_pos);
 	memcpy(b->out + b->out_pos, s->temp.buf, copy_size);
 	b->out_pos += copy_size;
 
--- a/lib/xz/xz_dec_lzma2.c~lib-xz-replace-min_t-with-min
+++ a/lib/xz/xz_dec_lzma2.c
@@ -354,7 +354,7 @@ static bool dict_repeat(struct dictionar
 	if (dist >= dict->full || dist >= dict->size)
 		return false;
 
-	left = min_t(size_t, dict->limit - dict->pos, *len);
+	left = min(dict->limit - dict->pos, *len);
 	*len -= left;
 
 	back = dict->pos - dist - 1;
@@ -1098,9 +1098,8 @@ enum xz_ret xz_dec_lzma2_run(struct xz_d
 			 * the output buffer yet, we may run this loop
 			 * multiple times without changing s->lzma2.sequence.
 			 */
-			dict_limit(&s->dict, min_t(size_t,
-					b->out_size - b->out_pos,
-					s->lzma2.uncompressed));
+			dict_limit(&s->dict, min(b->out_size - b->out_pos,
+						 s->lzma2.uncompressed));
 			if (!lzma2_lzma(s, b))
 				return XZ_DATA_ERROR;
 
@@ -1260,8 +1259,8 @@ enum xz_ret xz_dec_microlzma_run(struct
 		s->dict.end = b->out_size - b->out_pos;
 
 	while (true) {
-		dict_limit(&s->dict, min_t(size_t, b->out_size - b->out_pos,
-					   s->lzma2.uncompressed));
+		dict_limit(&s->dict, min(b->out_size - b->out_pos,
+					 s->lzma2.uncompressed));
 
 		if (!lzma2_lzma(s, b))
 			return XZ_DATA_ERROR;
--- a/lib/xz/xz_dec_stream.c~lib-xz-replace-min_t-with-min
+++ a/lib/xz/xz_dec_stream.c
@@ -155,8 +155,8 @@ static const uint8_t check_sizes[16] = {
  */
 static bool fill_temp(struct xz_dec *s, struct xz_buf *b)
 {
-	size_t copy_size = min_t(size_t,
-			b->in_size - b->in_pos, s->temp.size - s->temp.pos);
+	size_t copy_size = min(b->in_size - b->in_pos,
+			       s->temp.size - s->temp.pos);
 
 	memcpy(s->temp.buf + s->temp.pos, b->in + b->in_pos, copy_size);
 	b->in_pos += copy_size;
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are



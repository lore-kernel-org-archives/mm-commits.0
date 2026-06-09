Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4B03E450E
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 19:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781034635; cv=none; b=cg4fNZD7r4iF+1Gh6dmXCsGo/Sb73tz4XvEuH3ftTgqAccpwHC6vFccvniBXTKEJsAZqixQazXnQbHcWuEFOE1aSBlqJbXzbeffDW8JkvOUw7pBoVdmnl1V1h1A5VSLY51bu4hwn42RF3TvX90fZ0OKNe872bJ8AHDw9eBPNC7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781034635; c=relaxed/simple;
	bh=dVcHj/+x+sImnaamBHX1P3DOoXlUsJ4vyFyP4Kd2hvI=;
	h=Date:To:From:Subject:Message-Id; b=OFStr/UADSkgZ5F4zea9H8FqkmYfldjfh3SyrnF7At/JTVbQUZ7xfJ0GqebL/kUjLehqaEKCA7g8WBf1zgZQ3ukJWwR1r9TBeZeKAQAlHFAdxTuK53lN84stU33l/fd03up9MNnCgMdUt3VuU5noJ/ejDshX19wj7Q5z6nbFQG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S82Lniu+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S82Lniu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9531F00893;
	Tue,  9 Jun 2026 19:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781034631;
	bh=NrYnYPAED8RQ77I4ZP/e+ziR3ZrjhfYT1aUHrLN93M8=;
	h=Date:To:From:Subject;
	b=S82Lniu+uELI7MdwEz+AKlQfUtgxITbkwo3s94djkwYGwZOGpt54qXav89p8coYaG
	 cc6kyr2aJjpRRe9GKCHi0gik7c52FnOxDtieZ0WvcZHojPxqwfAJ+qDzNxlpzqrQ2Z
	 llRJVZb8ahg5VlBaKNt9MHzaCu4IFsP7DQW+kvew=
Date: Tue, 09 Jun 2026 12:50:30 -0700
To: mm-commits@vger.kernel.org,lasse.collin@tukaani.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-xz-replace-min_t-with-min.patch added to mm-nonmm-unstable branch
Message-Id: <20260609195031.1F9531F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/xz: replace min_t with min
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-xz-replace-min_t-with-min.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-xz-replace-min_t-with-min.patch

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

lib-xz-replace-min_t-with-min.patch


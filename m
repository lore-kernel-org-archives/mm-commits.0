Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946B61F1513
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 23:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782429525; cv=none; b=E+GE72cxLtdg5lnv9iWJNkBpZ91WxFyY6XX41UzafA5M4uZcs3mIMy9CW8SH0rDByL1w20HVzUMHH6Fy9TNdSn86/81MtFN263WxpWwo+bPTndNe7ulvwHN20YUA938X4nvrSmdPdCyUe8Fv4NYMP9WPDY4jh9vJvBvgYV8cgwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782429525; c=relaxed/simple;
	bh=4hXhHgYmB/ZzAe3CQNgI0YHkAPboPcO8/TczHDj6JR8=;
	h=Date:To:From:Subject:Message-Id; b=YvDF/YwLl3l3HfPf4gq7yyGG+P748Tbnwt96BUPMc80GaSjFKnJGTmsR2ydd/8mSZJXhaMX16Q/NK51aDg/7uWKrLGjZ+bu5g93FoIk7waQibnVEqMQdYQ3AiQsZK6BDQf3sUQU9yNLtzid8H7odHl8tf1erxzmcJ11pvkzCZZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fi+IIYbE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fi+IIYbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D24B1F000E9;
	Thu, 25 Jun 2026 23:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782429524;
	bh=hPridJL/EqvhqFaJyefZlE8oZ7A6e9LFMttB4JFm5uQ=;
	h=Date:To:From:Subject;
	b=Fi+IIYbERZSNv9m8CH0r5C4hLguSJNedbiSjdZsV9yVia48pKROCvectvZLLNZfZc
	 4+NtEuD3IJBuhDlfLO8ImVfeMcHBBO9vkc3b12wRv/kme28Gr0VeE2FXFfkgw3zdP8
	 j1WIG7FfPbif67pUeeHLGg+qjIIQO3pcTYS4u+BY=
Date: Thu, 25 Jun 2026 16:18:43 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@linux.dev,nathan@kernel.org,david.laight.linux@gmail.com,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-xz-fix-comments.patch added to mm-nonmm-unstable branch
Message-Id: <20260625231844.2D24B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/xz: fix comments
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-xz-fix-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-xz-fix-comments.patch

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
Subject: lib/xz: fix comments
Date: Sun, 14 Jun 2026 19:05:18 +0300

Link: https://lore.kernel.org/20260614160521.924710-2-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/xz_dec_lzma2.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/lib/xz/xz_dec_lzma2.c~lib-xz-fix-comments
+++ a/lib/xz/xz_dec_lzma2.c
@@ -271,7 +271,7 @@ struct xz_dec_lzma2 {
 	struct lzma_dec lzma;
 
 	/*
-	 * Temporary buffer which holds small number of input bytes between
+	 * Temporary buffer which holds a small number of input bytes between
 	 * decoder calls. See lzma2_lzma() for details.
 	 */
 	struct {
@@ -757,8 +757,8 @@ static bool lzma_main(struct xz_dec_lzma
 	uint32_t pos_state;
 
 	/*
-	 * If the dictionary was reached during the previous call, try to
-	 * finish the possibly pending repeat in the dictionary.
+	 * If the dictionary write limit was reached during the previous call,
+	 * try to finish the possibly pending repeat in the dictionary.
 	 */
 	if (dict_has_space(&s->dict) && s->lzma.len > 0)
 		dict_repeat(&s->dict, &s->lzma.len, s->lzma.rep0);
@@ -978,7 +978,7 @@ enum xz_ret xz_dec_lzma2_run(struct xz_d
 			 *          an uncompressed chunk
 			 *   0x02   Uncompressed chunk (no dictionary reset)
 			 *
-			 * Highest three bits (s->control & 0xE0):
+			 * Highest three bits (tmp & 0xE0):
 			 *   0xE0   Dictionary reset, new properties and state
 			 *          reset, followed by LZMA compressed chunk
 			 *   0xC0   New properties and state reset, followed
@@ -990,7 +990,7 @@ enum xz_ret xz_dec_lzma2_run(struct xz_d
 			 *   0x80   LZMA chunk (no dictionary or state reset)
 			 *
 			 * For LZMA compressed chunks, the lowest five bits
-			 * (s->control & 1F) are the highest bits of the
+			 * (tmp & 1F) are the highest bits of the
 			 * uncompressed size (bits 16-20).
 			 *
 			 * A new LZMA2 stream must begin with a dictionary
@@ -1091,7 +1091,7 @@ enum xz_ret xz_dec_lzma2_run(struct xz_d
 		case SEQ_LZMA_RUN:
 			/*
 			 * Set dictionary limit to indicate how much we want
-			 * to be encoded at maximum. Decode new data into the
+			 * to be decoded at maximum. Decode new data into the
 			 * dictionary. Flush the new data from dictionary to
 			 * b->out. Check if we finished decoding this chunk.
 			 * In case the dictionary got full but we didn't fill
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

lib-xz-use-size_t-instead-of-uint32_t-in-a-few-places.patch
lib-xz-fix-comments.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99BD3C0630
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 22:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660961; cv=none; b=NR+FW1/InTx2SbP/nlX8oNl5c8woBKvcXux1SPPcLZQ5K30vX+2S+goSomnG86aVd/W87SCa9VNUO6XfyQIZmNLnLN58zI2xbO90LQGmzfE/G8KgHTYtnt8xWEXHyip3NY0C+g8OevPyUS0wek2itvOc2D+Xj05KwdKptQ2jdj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660961; c=relaxed/simple;
	bh=Ti2nyZkznzvRbGR8WsI+nGQ4c2sHV7zUCtFiXQYQirQ=;
	h=Date:To:From:Subject:Message-Id; b=WX4rVEG4D+aTpGaWg8sQ2i3pAvxh3pmq9lPBmfVmh8aLQHC7gHVVV5mPOQ50Q7aBqYRB2/pAwTS15TsZMR2W2QcpqKCoOr2zANH8i/yT4RzRD7OO5YsbXQfy9Cdf3wHqrPLjpykzm02Y1XbwtkC72VgA/8EbaEV8bz+9jrNpCUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AR3IArUs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AR3IArUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E7D1F00A3A;
	Thu, 13 Aug 2026 22:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660960;
	bh=MNXZTh91T0CBI0GITGBTz5GMkvtjcEFvM1uTjQwPCao=;
	h=Date:To:From:Subject;
	b=AR3IArUsWfi7NKso5wKhFNmko0LBjtIUALeBmZWsqrhCwAlcUWMtWyyUwTndLkHdp
	 PYElSO5eJWF5VX2HZRF50RNUIxK4pZDnxWrsNfH38243OwUAcPto7jNpwV+092KdYS
	 15pEn5aIozOg2dSs1q/cZ35CuZ5Su7SLvAkWeV/Q=
Date: Thu, 13 Aug 2026 15:42:39 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@linux.dev,nathan@kernel.org,david.laight.linux@gmail.com,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-xz-fix-comments.patch removed from -mm tree
Message-Id: <20260813224240.60E7D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/xz: fix comments
has been removed from the -mm tree.  Its filename was
     lib-xz-fix-comments.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



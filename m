Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538FF3587DE
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338711; cv=none; b=E0GLbJapTvIEgqbN/IE+IHfWVbZmszMu2R77GgTwXHXkj15i5RoflRBQnuY3Hw3JXtvyC0Di7yJBWv1l9dtjQ/1dUfIbvtDH3HtjgFvbBodGcGo7Z0NydwqPL7WV4GwS6X9aTCI3s8G5M6/VGqnc4W57TRNJh5WxpYF5K3ccMKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338711; c=relaxed/simple;
	bh=mj3DqqtREx4bTsNQgPlvAue7G+lI89hn2rijAm/jHH4=;
	h=Date:To:From:Subject:Message-Id; b=WPjp+SkHWb7PcfAT2Tt+Ne9Xs/SVChnT/GxjUM/EJQhGAk0VlImzbuXz+NDVSKqkFyYWYiA9mRsldBM2ZIXmyhBSLHsban3lCZnKNTQQGfGFHvLhzsVN1IFWSX0x0QRB515FBXsunk7hCOgxSAvRWd6ut2tG7mLDzqs5xZGgeuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2U7HbKVE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2U7HbKVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277AB1F0089B;
	Wed,  7 Oct 2026 02:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338710;
	bh=Bbhh7d7AHUzr3Bl65N8UVJzVSl7c2oA2r09qlmvWthY=;
	h=Date:To:From:Subject;
	b=2U7HbKVEYqby+FtAgC8kx69kGXPN1SBfTTBjfEODAT+1lqOYdgOc1kc2JqDTRzKru
	 xk1eBvmCXfJSw2km8XAwZ1e61i6z/EE6eoEC7UP7CvWiy4WV8htTItfec/49cwXZlh
	 buS7U79pEZ0NMHHwgzzu5Hq117QdsW/s75MNT3xA=
Date: Tue, 06 Oct 2026 19:05:09 -0700
To: mm-commits@vger.kernel.org,vega@nebusec.ai,kyungsik.lee@lge.com,zhilinz@nebusec.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-validate-in-memory-lz4-chunk-length.patch removed from -mm tree
Message-Id: <20261007020510.277AB1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: validate in-memory LZ4 chunk length
has been removed from the -mm tree.  Its filename was
     lib-validate-in-memory-lz4-chunk-length.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhiling Zou <zhilinz@nebusec.ai>
Subject: lib: validate in-memory LZ4 chunk length
Date: Sat, 12 Sep 2026 21:32:17 +0800

We found and validated an issue in lib/decompress_unlz4.c.  The bug is
reachable by a root user through kexec_file_load() with a crafted external
initrd.

unlz4() reads the compressed chunk length from an in-memory initrd and
passes it to LZ4_decompress_safe().  It only checks the chunk length
against the allocation size when the input is filled by a callback.

Reject an in-memory chunk that extends past the remaining input before
calling the LZ4 decoder.  This prevents malformed initrds from making
the decoder read past the mapped archive.

Link: https://lore.kernel.org/59c6555c27aa7ba18ee227f9f02c78d15a37605f.1789219453.git.zhilinz@nebusec.ai
Fixes: e76e1fdfa8f8 ("lib: add support for LZ4-compressed kernel")
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: VEGA <vega@nebusec.ai>
Assisted-by: LLM
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
---

 lib/decompress_unlz4.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/lib/decompress_unlz4.c~lib-validate-in-memory-lz4-chunk-length
+++ a/lib/decompress_unlz4.c
@@ -139,6 +139,10 @@ STATIC inline int INIT unlz4(u8 *input,
 		if (!fill) {
 			inp += 4;
 			size -= 4;
+			if (chunksize > size) {
+				error("data corrupted");
+				goto exit_2;
+			}
 		} else {
 			if (chunksize > LZ4_compressBound(uncomp_chunksize)) {
 				error("chunk length is longer than allocated");
_

Patches currently in -mm which might be from zhilinz@nebusec.ai are



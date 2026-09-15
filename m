Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E293F1ACE
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 04:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789447576; cv=none; b=UG8L0/lABSAcHkpiNZdb2N3xeUZ7zZ7TjYdwVHz7AAgtZ2ADzUTw0PDez7cf7zo+vMavqX30wY/xMKG7Z/r+W1IB7HgKsWwQV9U3EP8/zECtS2M2iWl1/9hyqcSkZprDM01w8OZOXJbZ8SCPcX240OKU3nHEaM12n41ZdgVYuF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789447576; c=relaxed/simple;
	bh=UxfYJHjsycL+3JmZ0rGCCIN7QIN2OnVHs+7I4ygGTrQ=;
	h=Date:To:From:Subject:Message-Id; b=oLzHRkHlmoaKtqoz7O2ALJ1MlJ1WXW99Ap7sdC3yhD7SOYOB71DkrualnuCmJ66MaVOy+xRcikCmsZrkvHp/psCUn1VYDqZy8k1rrqCSc/qy+rXNuIHkdUx0U3JQw2QAKdaD6I5shw5YxEcJfAbDz/NL0F9yJFIYBoJAFXLTIrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j4fUcUd6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j4fUcUd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9081F000FF;
	Tue, 15 Sep 2026 04:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789447569;
	bh=lkpxBlX6jO5Na83S83CQHPQDO8zcyTBX/wIQzA4GqUY=;
	h=Date:To:From:Subject;
	b=j4fUcUd6ftaJOIITmDE2hvXT3brsJuDiWhdmkJIfvPljgeo6U227vfA3hs/zNSYVF
	 gC9zypabVepa4uaTPuwcq7u5z596MkuM30L3Zo00wKK+IT57rrul/yoeHyIg/jCfLH
	 cn+ynpDyEItoMnUkNL0zwr62FXF8gJcV4y+D8w7c=
Date: Mon, 14 Sep 2026 21:46:08 -0700
To: mm-commits@vger.kernel.org,vega@nebusec.ai,kyungsik.lee@lge.com,zhilinz@nebusec.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-validate-in-memory-lz4-chunk-length.patch added to mm-nonmm-unstable branch
Message-Id: <20260915044609.2B9081F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: validate in-memory LZ4 chunk length
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-validate-in-memory-lz4-chunk-length.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-validate-in-memory-lz4-chunk-length.patch

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
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Reported-by: VEGA <vega@nebusec.ai>
Assisted-by: LLM
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

lib-validate-in-memory-lz4-chunk-length.patch


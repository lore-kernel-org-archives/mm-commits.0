Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74FB26A1B9
	for <mm-commits@vger.kernel.org>; Wed, 20 Aug 2025 22:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755729972; cv=none; b=p6AGfoR8+v+aF+kh3JH5gp+gOWZV6ptoMrYzMYrT5IKaFbmak6MSbP1tRxMu1TRoDDODpKfA+DctI8Z872uMYf+8jBU7NjDXNsj8BXeL3X5KuILc4ApGM7+EMLLeW3bOIjOB6RzZrnwG//e9EduMblqpUYXLtiRtuiwhkbV7VkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755729972; c=relaxed/simple;
	bh=QFsKOhaXvqRgthXeffgdmSr4At7a/xabDS1XKgkrj8c=;
	h=Date:To:From:Subject:Message-Id; b=HGqQA2XiveF0QWz2GGuKH2l9pSkcy7nzK5qaKp+17PBVxF5588nnygAAZM/Gw19W2G/vgHto6PwGNUgJrqIbvyxZccRuvCE4r6Jfbke0efyK1eG6Me5LBNg/al/z3tdmTX/d5tPzfMyqZUgqGYUEGM9zRqIACMWROmsaHiPGin4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CDrF7K7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CDrF7K7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4990DC4CEE7;
	Wed, 20 Aug 2025 22:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755729971;
	bh=QFsKOhaXvqRgthXeffgdmSr4At7a/xabDS1XKgkrj8c=;
	h=Date:To:From:Subject:From;
	b=CDrF7K7cRAyCfiLnhdMw++ZqprOfjtJ8Zbi8upHk8CQROVHufKw7bfa/9YUVHQFN+
	 vpeNDxhOIZPNZERgvSN9faUr0P82DHu5Xn7gvcqSMaenRSvRBzYDIur1av/AZXfV34
	 jcvy9iUT+Sbn63Ooc0V4SQfiqEKUNqplTprTUKq4=
Date: Wed, 20 Aug 2025 15:46:10 -0700
To: mm-commits@vger.kernel.org,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-reduce-the-size-of-the-compression-buffer-to-a-single-page.patch added to mm-new branch
Message-Id: <20250820224611.4990DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: reduce the size of the compression buffer to a single page
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-reduce-the-size-of-the-compression-buffer-to-a-single-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-reduce-the-size-of-the-compression-buffer-to-a-single-page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm/zswap: reduce the size of the compression buffer to a single page
Date: Wed, 20 Aug 2025 11:15:47 -0700

Reduce the compression buffer size from 2 * PAGE_SIZE to only one page, as
the compression output (in the success case) should not exceed the length
of the input.

In the past, Chengming tried to reduce the compression buffer size, but
ran into issues with the LZO algorithm (see [2]).  Herbert Xu reported
that the issue has been fixed (see [3]).  Now we should have the guarantee
that compressors' output should not exceed one page in the success case,
and the algorithm will just report failure otherwise.

With this patch, we save one page per cpu (per compression algorithm).

Link: https://lkml.kernel.org/r/20250820181547.3794167-1-nphamcs@gmail.com
Link: https://lore.kernel.org/linux-mm/20231213-zswap-dstmem-v4-1-f228b059dd89@bytedance.com/ [1]
Link: https://lore.kernel.org/lkml/0000000000000b05cd060d6b5511@google.com/ [2]
Link: https://lore.kernel.org/linux-mm/aKUmyl5gUFCdXGn-@gondor.apana.org.au/ [3]
Co-developed-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/zswap.c~mm-zswap-reduce-the-size-of-the-compression-buffer-to-a-single-page
+++ a/mm/zswap.c
@@ -833,7 +833,7 @@ static int zswap_cpu_comp_prepare(unsign
 	u8 *buffer = NULL;
 	int ret;
 
-	buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
+	buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
 	if (!buffer) {
 		ret = -ENOMEM;
 		goto fail;
@@ -960,12 +960,7 @@ static bool zswap_compress(struct page *
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
 
-	/*
-	 * We need PAGE_SIZE * 2 here since there maybe over-compression case,
-	 * and hardware-accelerators may won't check the dst buffer size, so
-	 * giving the dst buffer with enough length to avoid buffer overflow.
-	 */
-	sg_init_one(&output, dst, PAGE_SIZE * 2);
+	sg_init_one(&output, dst, PAGE_SIZE);
 	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
 
 	/*
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-zswap-reduce-the-size-of-the-compression-buffer-to-a-single-page.patch


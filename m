Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793736383;
	b=w72ZZoyxPW2ujP65Tolo+082qsYqILCbqWt5EnTbgrxfTobUu5riXgcZ43iKf4gLsc8d
	 nw5FHAlGiwXDT8PyHWlKBOSgqsshCUqDit8fd9JZF20CSDzmoGOoOWAac5hkKVsHNiaWj
	 DYAD6ybsQULdUnk7I6vyXRc+gO/oJyTyV6Mjw6BVlQIpxK7dQn9rlkst1eqrOWQfP5FkX
	 BCdJIf0/t+dCANRtHHpRpJ02qxvG1UhH80X8l/bIabzCtwthbEFBUe9fQ2HgsvWJMgre7
	 gjnhh+QDbljSNqdtXqRP6CCn4YxZeAC+Xq1YR0J+LDoadAX125E91JlGIBeGEEZUEFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793736383;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=yoA1XuDqufQKzAwZva16pLc+dFhnD4m+8ZfN6xl5jZ0=;
	b=1Y9owiEYpmYPsun2N6drKuGaXmNEW55ohqWTm4IXDoEpOP4cN+FG2oUV/tghVqjFv70H
	 Wbg/LrWFWDv+3zOkAJFTh03KfOxqPqESaN5RsGa0ftzJIWUfqEnWEQDnr3FqEo6r1EtNn
	 JW3oqHzllFm4BCmTacnRZ9xJwsVvUFNuGpm2FQQnrlpjXptrFQdGDRUVz8f7SauTiXpjN
	 hE1a4+VN9DcFIzmVk90Y09cfcUo1cH8DaG7inSLMKp19KriFAnp1IzNyzWt7fdbLmTDiD
	 QsVbTiGLmNxhhKplZijgt0todWx6HN7HlQn1910wdpiTH4dOs7tEaOyy4BkGiaGBRAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QWgOT92P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A339606D818;
	Tue,  3 Nov 2026 20:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QWgOT92P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354CD1F000C1;
	Tue,  3 Nov 2026 20:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793736377;
	bh=yoA1XuDqufQKzAwZva16pLc+dFhnD4m+8ZfN6xl5jZ0=;
	h=Date:To:From:Subject;
	b=QWgOT92P9bSA716kSfj6HkCj21BmfrzqysEBfvk9E3CDp0vkOnSqwSwHv+ktRROZC
	 imOOua0Am3USNi6tj6mhm9XiA6l1DRMOsSbBya9KpG+Hq0NnHfTHlgo6Ohp8OE1NvL
	 zyoO8G5IYbZg2Mu2aFRoyJXHYY8lk3S7gPif+b9w=
Date: Tue, 03 Nov 2026 12:06:16 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,
	shr@devkernel.io,jack@suse.cz,akpm@linux-foundation.org,
	dennylin0707@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-writeback-avoid-overflow-when-reporting-bdi-byte-limits.patch added to mm-new branch
Message-Id: <20261103200617.354CD1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page-writeback: avoid overflow when reporting BDI byte limits
has been added to the -mm mm-new branch.  Its filename is
     mm-page-writeback-avoid-overflow-when-reporting-bdi-byte-limits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-writeback-avoid-overflow-when-reporting-bdi-byte-limits.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Hungyu Lin <dennylin0707@gmail.com>
Subject: mm/page-writeback: avoid overflow when reporting BDI byte limits
Date: Tue,  3 Nov 2026 19:36:26 +0000

bdi_get_bytes() multiplies unsigned long operands before assigning the
result to u64.  On 32-bit kernels, the intermediate product wraps and
min_bytes and max_bytes report incorrect limits.  For example, with
vm.dirty_bytes set to 104857600 and max_ratio set to 100, max_bytes
reports 268 instead of 104857600.

Convert the page count to bytes in u64 and use mul_u64_u32_div() to avoid
overflow in the subsequent multiplication.  This also handles large dirty
limits on systems with larger pages.  Combining the two divisions keeps
the existing rounding behavior.

Link: https://lore.kernel.org/20261103193627.71959-1-dennylin0707@gmail.com
Fixes: 00df7d51263b ("mm: add bdi_get_max_bytes() function")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: <stable@vger.kernel.org>
---

 mm/page-writeback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-page-writeback-avoid-overflow-when-reporting-bdi-byte-limits
+++ a/mm/page-writeback.c
@@ -665,7 +665,8 @@ static u64 bdi_get_bytes(unsigned int ra
 	u64 bytes;
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
-	bytes = (dirty_thresh * PAGE_SIZE * ratio) / BDI_RATIO_SCALE / 100;
+	bytes = mul_u64_u32_div((u64)dirty_thresh << PAGE_SHIFT, ratio,
+				100 * BDI_RATIO_SCALE);
 
 	return bytes;
 }
_

Patches currently in -mm which might be from dennylin0707@gmail.com are

mm-page-writeback-avoid-overflow-when-reporting-bdi-byte-limits.patch
delayacct-preserve-delay-extrema-when-aggregating-taskstats.patch
shmem-clamp-negative-used-block-samples-in-statfs.patch


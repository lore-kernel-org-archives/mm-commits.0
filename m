Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794261569;
	b=Ku7kb7jkTkn2oZVGU5ajHkOGlGLm7s1p72ptuEAfpY1ZxKEHn21OF44Yru30irvO7uwg
	 91cgCPwwpzNZPgtEcs281p84bowy/9Oe6+pGv2CT3dpMKFNdlVSSms2+UvUSpuEhJqsoc
	 TNwlfx8ER7ox4yapTtlvnDhkzfVtMZrN5wqzdflCdBqSpqA0xoiOuc5vEViUF2brlUbGq
	 UnOan0Q1rZNGI6/pXnMAJMQTgDa3dnrtjjYj55FoNqns4G9t/n8Vojfp3N+1awJtIpW7v
	 72gq0lyRJ70yzQo3JtDfg35rbyQI3Dt4yfIkNpi+kl6oFBSM6Iijapy+/rhRFaLrfIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794261569;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=UKAuiKlsQCTr62mhFm86uuFWVmLUYnV1BgOFVOD+TK0=;
	b=3c7pjWlTEu2UVA01NUY+7XRAdPGCH4q8hjwAMIeU91XHSlbV3V2wLsA03/VjpOapz+c7
	 hi7H7E+80Aa0dgnbcIgJh2m+Mw2fEMDGzId/o8bjaUTH2dUlMHz7Fp8TpkcM3aLyvQn//
	 r6KyDn47ak51VmeCWQLuxgiByo1HuqD8bgFpboEehr1VFTjhdwfjjU8y2L+emmsDZBJ1l
	 DR81HG/xFmtH5uYp5EqeyhsxGPeo3WTafKIrqvZf/V8LKFd90XYaZKjCRzTQbZXyJylwj
	 SEiaf6dayNeuuw//j21AQcSWNHrsxoJP9hGGm6cLZTqo1lhFXDrPsmpKUAJsKNNvi0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XyMc5+oB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F25606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 21:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XyMc5+oB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC601F0089F;
	Mon,  9 Nov 2026 21:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794261568;
	bh=UKAuiKlsQCTr62mhFm86uuFWVmLUYnV1BgOFVOD+TK0=;
	h=Date:To:From:Subject;
	b=XyMc5+oBhovidD4E4bYeU1AunHlbFdrhWmOqJY9u2KoGqgaqy5tV2BEuih8ru/peo
	 qh2dxB3EtaCs8GPUVRBet1ZfJOkLaXs9CuP/f/SVSakIjLKnFQR8efCvM+59rUAL6A
	 xAeHaVF5fN8JojgDVirAsKvmB+YU8x3bRsXuUqCs=
Date: Mon, 09 Nov 2026 13:59:27 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tytso@mit.edu,
	lczerner@redhat.com,jack@suse.cz,hughd@google.com,dennylin0707@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-skip-empty-finite-ranges-in-truncate_pagecache_range.patch added to mm-new branch
Message-Id: <20261109215928.3FC601F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: skip empty finite ranges in truncate_pagecache_range
has been added to the -mm mm-new branch.  Its filename is
     mm-skip-empty-finite-ranges-in-truncate_pagecache_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-skip-empty-finite-ranges-in-truncate_pagecache_range.patch

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
Subject: mm: skip empty finite ranges in truncate_pagecache_range
Date: Wed,  4 Nov 2026 18:27:00 +0000

For a finite range ending before the first page boundary,
truncate_pagecache_range() calculates unmap_end as -1.  The unsigned
comparison then treats the empty full-page interval as nonempty.

For example, lstart == 0 and lend == 0 cause unmap_mapping_range() to be
called with a zero length, meaning unmap to EOF.  Punching one byte at
offset zero in a mapped FUSE file can therefore remove mappings outside
the hole, causing unnecessary page-table work and subsequent faults.

Set unmap_end to zero for these small finite ranges so that the existing
unsigned comparison skips the empty interval.  Explicitly handle lend ==
-1 and lend == LLONG_MAX with LLONG_MAX, preserving EOF handling and
avoiding wrapping in the endpoint calculation at the largest inclusive
end.

Link: https://lore.kernel.org/20261104182700.88789-1-dennylin0707@gmail.com
Link: https://lore.kernel.org/r/20261027211505.22044-1-dennylin0707@gmail.com
Fixes: 5a7203947a1d ("mm: teach truncate_inode_pages_range() to handle non page aligned ranges")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Hugh Dickins <hughd@google.com>
---

 mm/truncate.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/truncate.c~mm-skip-empty-finite-ranges-in-truncate_pagecache_range
+++ a/mm/truncate.c
@@ -954,7 +954,15 @@ void truncate_pagecache_range(struct ino
 {
 	struct address_space *mapping = inode->i_mapping;
 	loff_t unmap_start = round_up(lstart, PAGE_SIZE);
-	loff_t unmap_end = round_down(1 + lend, PAGE_SIZE) - 1;
+	loff_t unmap_end;
+
+	if (lend == -1 || lend == LLONG_MAX)
+		unmap_end = LLONG_MAX;
+	else if (lend < PAGE_SIZE - 1)
+		unmap_end = 0;
+	else
+		unmap_end = round_down(1 + lend, PAGE_SIZE) - 1;
+
 	/*
 	 * This rounding is currently just for example: unmap_mapping_range
 	 * expands its hole outwards, whereas we want it to contract the hole
_

Patches currently in -mm which might be from dennylin0707@gmail.com are

mm-page-writeback-avoid-overflow-when-reporting-bdi-byte-limits.patch
mm-skip-empty-finite-ranges-in-truncate_pagecache_range.patch
delayacct-preserve-delay-extrema-when-aggregating-taskstats.patch
shmem-clamp-negative-used-block-samples-in-statfs.patch


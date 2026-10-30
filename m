Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793323816;
	b=GyAtLo5xlywDkJRGGh3Co4y7zvEXFcHbOLVsXsiGfLq6EgWq7K+yZrYe/iUFPiGnIDAq
	 KA95H9qvf0mA00oSiQBqAAbmhI8FEdZ952zd9pu5iCD13RWCgfTb/+jhITVz6e32DVnFm
	 4o3pXSQr4QnI5zbVU59OmykMFfCLU23vz9E/9h3BA6u0KAPQSwkTT9u71Qeu2OmHoJBS0
	 +o9bZ1SyiTdbVft1GGJXS0L/jc6TmY0lUm4yChLfl4mCMSv7SSmY6IZbEpSmXnNgkvbMN
	 hAjsXz0S4e9Ztm3nE+irvUYfZH5b7X8jw8mEDFGFPkjFQ8R5eNuylURvWufmdkJtjbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793323816;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=fOzG0Gx5lIDqsEgop89wticUfUqDKoUbmn/vy9euBMs=;
	b=zWkAri7TpGgX0trLuICkW0qZcxnMq2FDqt8KnpVP7+lZAFuWmuXIsfRnGrltfccTIZdH
	 IJ2e5ynZsFxRpOsXNmQbxxD4NXnhKM5V8k1VVS7eifLzTvleZX4byimRc3F08mIXov04q
	 sUyFkeSccK/A0leoZkDuaR7WA7cFkAhGdbQX5KVq3pykN/CpS2SGKZkRcxmZmEgNJk4rG
	 u4zzQlRK4WXm6Kw9eu/3BhAsFst9F24QUm8zJQO4ZjTT0oOE3XwKP1N1uB5637QAywvNb
	 IKDjL9+KTD6ibVT8ZZcU6Yy0yh3Ep9Ss1wXAA2vOFIjvPqCzIb/DUKhf5iYrZD8TgSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tionEUjv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE31606A31C;
	Fri, 30 Oct 2026 01:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tionEUjv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345DF1F000C1;
	Fri, 30 Oct 2026 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793323816;
	bh=fOzG0Gx5lIDqsEgop89wticUfUqDKoUbmn/vy9euBMs=;
	h=Date:To:From:Subject;
	b=tionEUjvoiulsjLFQlSkQkabNLYRu8FlCdwDEOX2ijhwmYY1sq7GdgrubpIrWmm3+
	 2pKrg6mFDsq5hv+H4rZ1fyv7wPapxxvAn+TZrFLg2x13I6DPXJ8mfR0awjFQDiXfZF
	 xnEyotg1/VOJaaUXTPOdFM1TGyk6z2QLt0UCQmTU=
Date: Thu, 29 Oct 2026 18:30:15 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pjw@kernel.org,
	muchun.song@linux.dev,glider@google.com,elver@google.com,dvyukov@google.com,
	aou@eecs.berkeley.edu,alex@ghiti.fr,liuyun01@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfence-clear-the-pool-pointer-before-freeing-pages.patch added to mm-new branch
Message-Id: <20261030013016.345DF1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: kfence: clear the pool pointer before freeing pages
has been added to the -mm mm-new branch.  Its filename is
     kfence-clear-the-pool-pointer-before-freeing-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfence-clear-the-pool-pointer-before-freeing-pages.patch

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
From: Jackie Liu <liuyun01@kylinos.cn>
Subject: kfence: clear the pool pointer before freeing pages
Date: Thu, 29 Oct 2026 10:57:42 +0800

Late initialization frees a failed pool before clearing __kfence_pool.
Slab allocations can reuse those pages in between and be mistaken for
KFENCE objects by is_kfence_address(), even though KFENCE is not enabled.

Clear __kfence_pool before freeing the pages, and use the saved address
for cleanup.

Link: https://lore.kernel.org/2fab8aaa82ab2004e706fd7ec8dac20427976457.1793242457.git.liuyun01@kylinos.cn
Fixes: b33f778bba5e ("kfence: alloc kfence_pool after system startup")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: AlexandreGhiti <alex@ghiti.fr>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/kfence/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kfence/core.c~kfence-clear-the-pool-pointer-before-freeing-pages
+++ a/mm/kfence/core.c
@@ -1052,16 +1052,17 @@ static int kfence_init_late(void)
 	free_contig_range(page_to_pfn(virt_to_page((void *)kfence_metadata_init)),
 			  nr_pages_meta);
 free_pool:
+	WRITE_ONCE(__kfence_pool, NULL);
 	free_contig_range(page_to_pfn(virt_to_page((void *)addr)),
 			  free_size / PAGE_SIZE);
 #else
 	free_pages_exact((void *)kfence_metadata_init, KFENCE_METADATA_SIZE);
 free_pool:
+	WRITE_ONCE(__kfence_pool, NULL);
 	free_pages_exact((void *)addr, free_size);
 #endif
 
 	kfence_metadata_init = NULL;
-	__kfence_pool = NULL;
 	return err;
 }
 
_

Patches currently in -mm which might be from liuyun01@kylinos.cn are

kfence-fix-pool-cleanup-on-metadata-allocation-failure.patch
kfence-clear-the-pool-pointer-before-freeing-pages.patch
riscv-keep-booting-if-kfence-pool-reservation-fails.patch


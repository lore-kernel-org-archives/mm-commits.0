Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388F1C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011129; cv=none; b=iWfMEswYkl1ga0NO+SD6JjwKGnUz4uiV3MSvhuG/Yn1Yu04xmfmhzWYsk9Ak3n2kAvdGlaXF0Dgmoyx6x5S+BLmz4i0nzsHRWsR0XK6zaHyCgpcAzS0Ycaoj5cgJypiBGD9X8DJPHpzK04QcYTXAp29KaYg0w9KdEsTLiJmMUSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011129; c=relaxed/simple;
	bh=t+IK6zJipKmUuzmXcYIsCxHKBfe0Kx8xJqqkpMAmdFU=;
	h=Date:To:From:Subject:Message-Id; b=tcxBcHt4kqur02I+XxQtSvmAJbj8ASi945hnWndR8XhhsDXTSU/q0u1bRenseuckWI28lZ1Psxp3+ZQU8ySlB37IbDOeOnDKCx6+5MsAeJB1AEHHJyWl7bv7uUSQucgO626eaYl7BNSo5A6yLMCUyqN+pqNJ14JxU9lBm2xqWZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Loz5VWyu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Loz5VWyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBCFC4CEE4;
	Mon, 12 May 2025 00:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011129;
	bh=t+IK6zJipKmUuzmXcYIsCxHKBfe0Kx8xJqqkpMAmdFU=;
	h=Date:To:From:Subject:From;
	b=Loz5VWyuCVYpxSAVP6DTp0d4AmVqkYhssWXwy7j5Ji+nQzwe9E6teHeOANUfqxZTO
	 ZSvl08+wr7nLuV36Pf+BvDRCYnkMcQG5/4ctpSQS/8At9EEZ64UVvGVYHBa0hhPqlW
	 Amf+cCO7UZX15V8s2P7mvXarGaLScy2X9f5HNRNw=
Date: Sun, 11 May 2025 17:52:08 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,hch@infradead.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmalloc-use-atomic_long_add_return_relaxed.patch removed from -mm tree
Message-Id: <20250512005209.0FBCFC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: use atomic_long_add_return_relaxed()
has been removed from the -mm tree.  Its filename was
     vmalloc-use-atomic_long_add_return_relaxed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: vmalloc: use atomic_long_add_return_relaxed()
Date: Tue, 15 Apr 2025 13:26:46 +0200

Switch from the atomic_long_add_return() to its relaxed version.

We do not need a full memory barrier or any memory ordering during
increasing the "vmap_lazy_nr" variable.  What we only need is to do it
atomically.  This is what atomic_long_add_return_relaxed() guarantees.

AARCH64:

<snip>
Default:
    40ec:       d34cfe94        lsr     x20, x20, #12
    40f0:       14000044        b       4200 <free_vmap_area_noflush+0x19c>
    40f4:       94000000        bl      0 <__sanitizer_cov_trace_pc>
    40f8:       90000000        adrp    x0, 0 <__traceiter_alloc_vmap_area>
    40fc:       91000000        add     x0, x0, #0x0
    4100:       f8f40016        ldaddal x20, x22, [x0]
    4104:       8b160296        add     x22, x20, x22

Relaxed:
    40ec:       d34cfe94        lsr     x20, x20, #12
    40f0:       14000044        b       4200 <free_vmap_area_noflush+0x19c>
    40f4:       94000000        bl      0 <__sanitizer_cov_trace_pc>
    40f8:       90000000        adrp    x0, 0 <__traceiter_alloc_vmap_area>
    40fc:       91000000        add     x0, x0, #0x0
    4100:       f8340016        ldadd   x20, x22, [x0]
    4104:       8b160296        add     x22, x20, x22
<snip>

Link: https://lkml.kernel.org/r/20250415112646.113091-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Christop Hellwig <hch@infradead.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~vmalloc-use-atomic_long_add_return_relaxed
+++ a/mm/vmalloc.c
@@ -2370,7 +2370,7 @@ static void free_vmap_area_noflush(struc
 	if (WARN_ON_ONCE(!list_empty(&va->list)))
 		return;
 
-	nr_lazy = atomic_long_add_return(va_size(va) >> PAGE_SHIFT,
+	nr_lazy = atomic_long_add_return_relaxed(va_size(va) >> PAGE_SHIFT,
 					 &vmap_lazy_nr);
 
 	/*
_

Patches currently in -mm which might be from urezki@gmail.com are

maintainers-add-myself-as-vmalloc-co-maintainer.patch


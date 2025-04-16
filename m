Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83A5221D9E
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 01:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744766861; cv=none; b=f5mnhB0q412o/c7s0TP38TMhIo4G0VP8RzZYrfcbLwCfiGRnoIws+gzwIG7cPJja9oR4rWVhCzcbjxn20YiR9D0kfM653d274FS7VFd014hv79TqHYZvVkXaqlUwcEz6s9iaCHd97slmRbcIhaUUyNo/iw1XT8wF/K34gE9afB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744766861; c=relaxed/simple;
	bh=eax85cIXRU4+0KXaI1n1wRz5B2riykDTT24VQf+WAHQ=;
	h=Date:To:From:Subject:Message-Id; b=dDqd2p6RP673JN27ecwLuE0TSK66jegVpRtMqI4pStcVLvXE5fZo3cRsu5dZBYoBIQGK+vG7Ro4jaZWGH21e7PlK3Z0lQzbNBPodEFU8+MqGg58CCxBV+Ik2eHQ475lcRcASKW2xyplmtqAmM3MIkorDuEztPmNg4+T/Holj1nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XO4E70K1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XO4E70K1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546E3C4CEE7;
	Wed, 16 Apr 2025 01:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744766859;
	bh=eax85cIXRU4+0KXaI1n1wRz5B2riykDTT24VQf+WAHQ=;
	h=Date:To:From:Subject:From;
	b=XO4E70K1i/P+Klz5HBbh9Pi1h+ojI+ZLapNGXIXbBZxqPKUddOZGoM0RuCgkRPS0R
	 ZDiPqnwcoTu+OmTgwsf+vqcIGzfOlBSM3jgwR4QQ5CB5/sDkL9i2RrKCNEYEmc+6gI
	 bunB48TiYibzdMsC29q0WoTLfPTEEv2IWKnhVOAk=
Date: Tue, 15 Apr 2025 18:27:38 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,hch@infradead.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-use-atomic_long_add_return_relaxed.patch added to mm-unstable branch
Message-Id: <20250416012739.546E3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc: use atomic_long_add_return_relaxed()
has been added to the -mm mm-unstable branch.  Its filename is
     vmalloc-use-atomic_long_add_return_relaxed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-use-atomic_long_add_return_relaxed.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

vmalloc-add-for_each_vmap_node-helper.patch
vmalloc-switch-to-for_each_vmap_node-helper.patch
vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch
vmalloc-use-atomic_long_add_return_relaxed.patch


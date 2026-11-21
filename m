Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795296045;
	b=f8Lqz+nFGAiSSp63n0Gp6+S7aMKSVmiiBjz31bhr8PgGX0tgVQIbX7MyyV86zbevQNRM
	 hGmlJQEWVyBbi3hdxqKYzMnqlU9JM5JcmVLOnhFQfEzoqcgIYVRCU0U11r+VuFDO0Bcje
	 iQuZdpx2OpWdLO0NqEEzs1Oh2sB88IBxocNgkIx0o8kkAbfbeRLUP1HVZrePjCjhs56BY
	 rmqlRJxNA5Ki3ac/CC9vZjNUpiL1FzPa5Pvgc4IKUmt7DpWiXsFRovQMV3HHLvPdqyiHu
	 afvYYMKBZe6O2eRy+W5MxixxPYjEgVHVTJ5i0XDQvqUS9vWesizFehJs8BIJmnz0WOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795296045;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=nwojgbpgAHEx4sz1PpvJBqSuIXptQbNeBW/bR5c00dQ=;
	b=0X25jslBG1dcU3nN5YIGPxxRCgjGTm4JRt0C8biQ7F3eZq/TJ845g+nWGY+q2tTN8J7U
	 ufCDUqGxiZzOrKGC3Ae/s+kL2C+8qoN+8Hv015s7Z66KV9xxt7mtDw9FPG9W6gdk65lsS
	 9Mo/C13UwY2YrJQnYhq7/X28nf6j34aUQZwsOaqAvHmSOriBVJVu8JTx1dhqoleqSC/wR
	 r3ugPBb8VOIlFw5OMqbSLfBGYxHLlgRGLUBTXK00bEkQGOJ7TkHwhCCUOwDTYbcLQdzEa
	 w7tFXxtRPkKHbFvzVHQJtwTWL4QkcInBx1z1NyHxljL8kBEF4nK3IRcU/lZuO/vyR3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZNhpsuk0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF93606A333
	for <mm-commits@vger.kernel.org>; Sat, 21 Nov 2026 21:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZNhpsuk0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E331F000C4;
	Sat, 21 Nov 2026 21:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795296044;
	bh=nwojgbpgAHEx4sz1PpvJBqSuIXptQbNeBW/bR5c00dQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=ZNhpsuk0NdB7e3DEiA0w4ixA1gAyLzQCeNkE6AeJ8YgvKXctVNVsZf1daZU4wYEhy
	 oWUyTT6xlqqpRi+hgklq0Zb+Z65m796IVengQ589daA7apJFYiemmt4yzxnNd+05UK
	 i3JmEuXNf0uRQapfKOISyNnrOI6MbfTWLH7GapWQ=
Date: Sat, 21 Nov 2026 13:20:44 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,azpijr@gmail.com,
	liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261029-vmalloc_remap-v2-1-c4705cbf26c2@linux.dev>
References: <20261029-vmalloc_remap-v2-1-c4705cbf26c2@linux.dev>
Subject: + mm-vmalloc-drop-vm_dma_coherent-from-remap_vmalloc_range_partial.patch added to mm-unstable branch
Message-Id: <20261121212044.A1E331F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vmalloc: drop VM_DMA_COHERENT from remap_vmalloc_range_partial
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-drop-vm_dma_coherent-from-remap_vmalloc_range_partial.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-drop-vm_dma_coherent-from-remap_vmalloc_range_partial.patch

This patch will later appear in the mm-unstable branch at
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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/vmalloc: drop VM_DMA_COHERENT from remap_vmalloc_range_partial
Date: Thu, 29 Oct 2026 17:19:07 +0800

Patch series "mm/vmalloc: harden remap_vmalloc_range_partial against NULL
pages", v2.

remap_vmalloc_range_partial() passes vmalloc_to_page()'s result to
vm_insert_page() unchecked, oopsing via page_folio() if the page is
NULL. The NULL case never happens today because VM_USERMAP areas keep
every page mapped, but that assumption is nowhere checked.

Patch 1 drops VM_DMA_COHERENT from the allow-list -- a dead entry (no
caller maps a DMA-coherent area through this path).

Patch 2 fails the mapping with -EINVAL instead of oopsing if
vmalloc_to_page() ever returns NULL, with a WARN to mark the broken
invariant.

Patch 1 is a behavior change (no in-tree caller affected)
Patch 2 only changes a failure path that cannot be reached today.
The two are independent.


This patch (of 2):

No caller maps a VM_DMA_COHERENT area through this path: such areas
come from dma_alloc_coherent() internals and are freed via vunmap(),
never through remap_vmalloc_range[_partial](); all 13 callers pass
vmalloc_user()/vmalloc()-backed addresses.

The flag was added in commit fe9041c245196 ("vmalloc: lift the arm
flag for coherent mappings to common code") as a mechanical
translation of ARM's VM_ARM_DMA_CONSISTENT.

Drop it so DMA-coherent areas can never enter the path.

Link: https://lore.kernel.org/20261029-vmalloc_remap-v2-0-c4705cbf26c2@linux.dev
Link: https://patch.msgid.link/20261029-vmalloc_remap-v2-1-c4705cbf26c2@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-drop-vm_dma_coherent-from-remap_vmalloc_range_partial
+++ a/mm/vmalloc.c
@@ -5052,7 +5052,7 @@ int remap_vmalloc_range_partial(struct v
 	if (!area)
 		return -EINVAL;
 
-	if (!(area->flags & (VM_USERMAP | VM_DMA_COHERENT)))
+	if (!(area->flags & VM_USERMAP))
 		return -EINVAL;
 
 	if (check_add_overflow(size, off, &end_index) ||
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-drop-vm_dma_coherent-from-remap_vmalloc_range_partial.patch
mm-vmalloc-reject-null-pages-in-remap_vmalloc_range_partial.patch


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832298;
	b=U/RVdSdaGb6wjKi481ODg6CZgnQbDqTYBVcfQ4OGtqzpGp+taj+AtO59EJ/t+i9prgUT
	 t13Qrh+xH0uF6PzcjXhi85XThe32wdkM0fXFYxBOdHWzqnmaN6+f7bQV5zvTjVAf3/6yD
	 VFqjh7K3oREIAjwEHCDt561ZCYSMuFN1TcXXUhLkDfcdT76PKPOLY/PdX1g7BQyNDj/K8
	 Z+EJsystVefb5EmKU3aSU1bBjD+htSTF3f5Or1+0dHDyfo1wqyd6hGfVMJFaJv2DtjDDk
	 i33reGrHKznPnNNDh4Hn4dfgNhjPzobhDeAVutnWWueZB/QVLOeQSX8ZeKON/D24ctQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832298;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gHUODhHMUrvv7YC6dpfcY7DX79JIJzOfQLQLBJ0VnPI=;
	b=yyS1nhEAcffF0pGhpxeuJmB9h4d2iWSrobwZREUr1rsW8nKEudqjxc1wEtMNthb5JObV
	 UWJRWJnzy0meRlWW7r1BqmiNehVlsaVO+c1jkQXR5sPOc4JiG+tV8TcFcNJYr6Mabxrsn
	 ZBSZwUEZM2KDhfgGB9/b7Hk0zYvNbn2IZPis82e7rdsYy2OEngzq7jhkr70BeCX1oyQO7
	 6jU7tsrnKW5IR0gNl+lzx+EO4B93kcDf59R7Ai25Btw9YvqmaGZMq2wwtU18BIao3RFcr
	 14pzwBFqiJ7W/Nkccjz5FOVi/8maOif+C8E50uWfg9wlk/ckSGoKT0INDzy8w+n2Ozw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="s4tNxiz/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4121A606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=s4tNxiz/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3AF1F01829;
	Sat, 24 Oct 2026 08:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832298;
	bh=gHUODhHMUrvv7YC6dpfcY7DX79JIJzOfQLQLBJ0VnPI=;
	h=Date:To:From:Subject;
	b=s4tNxiz/7/AfjV2SZfEgGEFHdeTVrja5IkH/rxyiHh52ocmqVfmt+GqRmTLF5fj9M
	 4Bw9caycSu99rFVHRRkvKmOKOChsNxogG1rTl2OXYx4NGAb5HFx8O9lq6/USoJSzrx
	 rj9S53cXZbIbvhgwiNNlyZrZFFtaHeGsED7MWckI=
Date: Sat, 24 Oct 2026 01:58:17 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch removed from -mm tree
Message-Id: <20261024085818.0C3AF1F01829@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vmalloc: fix vmalloc_dump_obj address alignment for last-page lookups
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/vmalloc: fix vmalloc_dump_obj address alignment for last-page lookups
Date: Mon, 28 Sep 2026 16:15:54 +0800

Patch series "mm/vmalloc: fix vmalloc_dump_obj VA lookup", v4.

vmalloc_dump_obj() has two bugs that cause it to miss vmalloc
allocations.

  1. PAGE_ALIGN() rounds up, pushing last-page addresses to va_end
     and outside the VA lookup range.

  2. The function searches only one vmap node, but allocations
     larger than 64 KiB may span multiple vmap zones whose VA
     is stored in a different node's rb-tree.

Patch 1 fixes the alignment, patch 2 fixes the cross-zone search.


This patch (of 2):

vmalloc_dump_obj() uses PAGE_ALIGN() to normalize the input address before
looking it up in the per-node busy tree.  PAGE_ALIGN() rounds up, which
can push an address in the last page of a vmalloc allocation to va_end --
outside the [va_start, va_end) range that __find_vmap_area() searches. 
This causes the lookup to miss the VA and return false, degrading
diagnostic output in OOM dumps and KASAN reports to the less informative
"vmalloc memory" fallback.

The upward alignment can also change the addr_to_node() mapping when the
page boundary crosses a vmap zone boundary, causing the search to hit the
wrong node entirely.

Use PAGE_ALIGN_DOWN() instead, which rounds down to the page containing
the address.  This keeps the address within the VA range and preserves the
correct node mapping.

Link: https://lore.kernel.org/20260928-vmalloc_dump_obj-v4-0-6f288a431edc@linux.dev
Link: https://lore.kernel.org/20260928-vmalloc_dump_obj-v4-1-6f288a431edc@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups
+++ a/mm/vmalloc.c
@@ -5268,7 +5268,7 @@ bool vmalloc_dump_obj(void *object)
 	unsigned long addr;
 	unsigned long nr_pages;
 
-	addr = PAGE_ALIGN((unsigned long) object);
+	addr = PAGE_ALIGN_DOWN((unsigned long) object);
 	vn = addr_to_node(addr);
 
 	if (!spin_trylock(&vn->busy.lock))
_

Patches currently in -mm which might be from liuye@kylinos.cn are



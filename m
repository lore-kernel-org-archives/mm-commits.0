Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832528;
	b=yjjlzEf+9p6d3/8bQ5lWdQd68sxR344+TfwYCyFL5tqEKxo0InuAs+XEs1MrwSZcpgOy
	 dTfj7Wx5myD+yHKxxmn7Yqu3Qfj2zElEyopJbQ7a18BzMdUoQgLkdSVgFYWrwFrD4wKg9
	 hE+xRqGf9hxFrkot51wb82qmZG5toG10kz0xrUMC4AULuB+vffrFPjunhYNANpOTbaum/
	 QGdjNP933awAJPBx9swKtuNBtKhkaDm9+5gtUMJKXaBKUEYUe/W6KLAWWUTCzIrwW8YTt
	 WRsXeLIizq3JoIhgQJLVz5meKM9WFYwW7HuNTJ1DkLXyg6fQR4yGUX6PKwulb5fomkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832528;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+yP9e7uy5/SdPubk91QSz+jWN02J3B8aeVuwZgWUyD0=;
	b=UVC7fxNmBDTT8PMjP98AdDd3Lf2qA/g8gSbDVxIMKr2OrInDJZ8n/0NmNKsYfUt2mgDZ
	 9QDcUYWulOmr6IHrc7UFcjdLsRa5KRNdcMSzBaRyoMZfSAOgxqnLmJT7wiOjhapFeKEsf
	 d3dxywL3/j+lGJczfZidtmtmXwOCbqgfE4HTOJ8MOfbHzdktgSkKqZd3qz5q99Z8Vrcll
	 CdQMFvvcK0WmFFvQ7jSj+nBssRD26pxwZ7M9ta09uZIOZvhgm7D3F3tqPrQlzAOFsGxDk
	 AyX9i8cHtr3m2QM3/V4wKgkggJvkgBIwCuWlvEVQTsO9gI/+f1jhyvrm4MwWFMLtxpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=M1DxmmEa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8041E606A31D
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=M1DxmmEa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADB61F01825;
	Sat, 24 Oct 2026 09:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832528;
	bh=+yP9e7uy5/SdPubk91QSz+jWN02J3B8aeVuwZgWUyD0=;
	h=Date:To:From:Subject;
	b=M1DxmmEaSENonl27HEJJER7g6WdVRJfVTA4R/x9zTBue1cTW9joxd5zMvNzJEOQ09
	 kK/1nOlv+2ylxddLuNNPBDMHUo3tWu2hegMjhaeMIGmGmjagRINhkQpZbJZ3NAyVP1
	 Uf6KTErukOP1vYVQv+TokM2gEWaGPJ/i5DbOW+gg=
Date: Sat, 24 Oct 2026 02:02:07 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,rppt@kernel.org,ritesh.list@gmail.com,joao.m.martins@oracle.com,dave.jiang@intel.com,alison.schofield@intel.com,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-warn-on-unaligned-compound-zone-device-ranges.patch removed from -mm tree
Message-Id: <20261024090208.4ADB61F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: warn on unaligned compound zone device ranges
has been removed from the -mm tree.  Its filename was
     mm-warn-on-unaligned-compound-zone-device-ranges.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: warn on unaligned compound zone device ranges
Date: Fri, 16 Oct 2026 21:13:34 +0800

A compound page of order N must start at a PFN aligned to 2^N pages. 
Therefore, a range used to initialize compound pages must start on a
compound-page boundary and contain an integral number of compound pages.

Two recent Device DAX bugs were caused by ranges that violated this
invariant, but neither was detected by memmap_init_zone_device().

Warn if the adjusted zone-device range violates this invariant so future
violations are reported when the compound pages are initialized.

Link: https://lore.kernel.org/20261016131334.3419393-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/r/20261016053944.2579541-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/r/20261016054914.2601510-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---

 mm/mm_init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mm_init.c~mm-warn-on-unaligned-compound-zone-device-ranges
+++ a/mm/mm_init.c
@@ -1142,6 +1142,8 @@ void __ref memmap_init_zone_device(struc
 	if (!nr_pages)
 		return;
 
+	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));
+
 	/*
 	 * Seed the reusable head-page template from the first real struct
 	 * page. The normal page-init and refcount helpers must operate on
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch


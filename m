Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEAD173
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754159956; cv=none; b=LqmUFT+CVQarY0N0n+3mgDykLNuipuEtvgJZf3rupGQ+s585imzIYrNtlEHGozqCZfb1F1eMUGwIZoCufi8hZvpIHdHIIDpuCqi0RwBQl90Yuxa1fwaE85lEvRnH2ebkg3ha9MIpXquwooEDDsAVH7fEvPZ3XD8tAa5cAJDHelQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754159956; c=relaxed/simple;
	bh=l9suHuXX+UlYbm8vMGCXTSH/rO4Ul+Das2n5Cw4rTFQ=;
	h=Date:To:From:Subject:Message-Id; b=GypcgN/xeouZZPv5cnX1XYOGDCeq4jXVrIgYbepSwIDNsN9LRsU60/MWTVvWatciuANrQBWfw9YhnjkOsYBQyE8gSNSABW5R5AZ+ONiLZ8M8o4k6GyeFP8CR/Wi9vZkKfRZZcNsZWis1E/4u2qKsv5RkmOZJ55dys18JmSbMbEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kAfvz/SB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kAfvz/SB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B39C4CEEF;
	Sat,  2 Aug 2025 18:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754159955;
	bh=l9suHuXX+UlYbm8vMGCXTSH/rO4Ul+Das2n5Cw4rTFQ=;
	h=Date:To:From:Subject:From;
	b=kAfvz/SBq6NXt3uUEzn24UoDBUxnzriqyxrDRw/iCy2yBtRgLf8jBbe+sOdcViIQz
	 hkvpkgUL8j4xrxOjiN+JDnzLeeF/K5UUZaxcOLg3utFNfI5XA5akW19/5mBQYXRT6Z
	 3DlZFo55rMwz/wTdUj2tSZ2aPeHhMkS05SDrDbp8=
Date: Sat, 02 Aug 2025 11:39:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-correct-type-for-vmalloc-vm_flags-fields-fix.patch removed from -mm tree
Message-Id: <20250802183915.98B39C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fixup very disguised vmalloc flags parameter
has been removed from the -mm tree.  Its filename was
     mm-correct-type-for-vmalloc-vm_flags-fields-fix.patch

This patch was dropped because it was folded into mm-correct-type-for-vmalloc-vm_flags-fields.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: fixup very disguised vmalloc flags parameter
Date: Tue, 29 Jul 2025 13:48:50 +0100

The declare_vma() function in arm64 arch code liberally mixes the concepts
of VMAs and near-identically named vmalloc data structures, so I
accidentally changed the 'vm_flags' field' that is assigned to a 'vma'
thinking it was... the vm_flags field of a vma, which it turns out, it
isn't.

Revert the type from vm_flags_t to unsigned long.

Given vm_flags_t == unsigned long, there is no change in any behaviour
before or after this patch, but in future this will matter.

Link: https://lkml.kernel.org/r/e74dd8de-7e60-47ab-8a45-2c851f3c5d26@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/mm/mmu.c~mm-correct-type-for-vmalloc-vm_flags-fields-fix
+++ a/arch/arm64/mm/mmu.c
@@ -721,7 +721,7 @@ void mark_rodata_ro(void)
 
 static void __init declare_vma(struct vm_struct *vma,
 			       void *va_start, void *va_end,
-			       vm_flags_t vm_flags)
+			       unsigned long vm_flags)
 {
 	phys_addr_t pa_start = __pa_symbol(va_start);
 	unsigned long size = va_end - va_start;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch
mm-correct-type-for-vmalloc-vm_flags-fields.patch


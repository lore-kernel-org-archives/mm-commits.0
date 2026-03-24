Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1E1370D63
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388636; cv=none; b=Kxm1tVTCmTwn8uXPLZB8Zit+b0ijag/l04u5rF2XDDvOHx22dv3XdfJSz/75vKUrYAnJqQ6j+TlAuWW4+5QdmnN/MjYWK97J/Ms+UC/XQ7M8e9oZ0b+60DE31KKZJA2n7KtAqzuNxHIxZFT8p8ZHAFmgvByvEly4rXnBihwr+Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388636; c=relaxed/simple;
	bh=OKBY4XgmpK5B4dF1Aj81nryLGF28XnNoJWFW9zTJ87Y=;
	h=Date:To:From:Subject:Message-Id; b=ff6rkl3UGSSoCo7Bs8iIhF1UHNvW8uITxjT2H1bM1pcnY0TOVpQ9YtNGjOVrR6ZOVVOg59Dv1cPnD9g9sPAcemzehPZuRmx9zkJ1/vWc9NZg6WuOb2WGxIH6abl4uwRNZUGlvXUn9Dr0yRq72QbuNoxVtqrXKM3UYdZRbEeIYfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fwweT6oy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fwweT6oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A10C19424;
	Tue, 24 Mar 2026 21:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388636;
	bh=OKBY4XgmpK5B4dF1Aj81nryLGF28XnNoJWFW9zTJ87Y=;
	h=Date:To:From:Subject:From;
	b=fwweT6oy61jwzhBsRYUJoeWhEaTdgEOo7dWCfv4mJMHQJ4qb/B6BgVbchoAvscTjj
	 W5f7LZh86d0brwAQpV1let7nC1H4FQ+1uh0YUKaDAW83hRakrgupDY5WVDdggHVDsd
	 0ISy3+O04PyvhC9Jxm3OCKlpQWaoI/Kqw3EUf/KI=
Date: Tue, 24 Mar 2026 14:43:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] loongarch-mm-align-vmemmap-to-maximal-folio-size.patch removed from -mm tree
Message-Id: <20260324214356.07A10C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: LoongArch/mm: align vmemmap to maximal folio size
has been removed from the -mm tree.  Its filename was
     loongarch-mm-align-vmemmap-to-maximal-folio-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: LoongArch/mm: align vmemmap to maximal folio size
Date: Fri, 27 Feb 2026 19:42:44 +0000

The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
struct pages of the head page to be naturally aligned with regard to the
folio size.

Align vmemmap to MAX_FOLIO_VMEMMAP_ALIGN.

Link: https://lkml.kernel.org/r/20260227194302.274384-7-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Hildenbrand (arm) <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/pgtable.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/pgtable.h~loongarch-mm-align-vmemmap-to-maximal-folio-size
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -104,7 +104,8 @@ struct vm_area_struct;
 	 min(PTRS_PER_PGD * PTRS_PER_PUD * PTRS_PER_PMD * PTRS_PER_PTE * PAGE_SIZE, (1UL << cpu_vabits) / 2) - PMD_SIZE - VMEMMAP_SIZE - KFENCE_AREA_SIZE)
 #endif
 
-#define vmemmap		((struct page *)((VMALLOC_END + PMD_SIZE) & PMD_MASK))
+#define VMEMMAP_ALIGN	max(PMD_SIZE, MAX_FOLIO_VMEMMAP_ALIGN)
+#define vmemmap		((struct page *)(ALIGN(VMALLOC_END, VMEMMAP_ALIGN)))
 #define VMEMMAP_END	((unsigned long)vmemmap + VMEMMAP_SIZE - 1)
 
 #define KFENCE_AREA_START	(VMEMMAP_END + 1)
_

Patches currently in -mm which might be from kas@kernel.org are



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832341;
	b=R/LGm/UrhNnEd86xxwZA/A0qp3tKJdP+HBO69JFnj8RuvMCFEzo5Ogz/MdAAltESmM8g
	 Hs5CZjvBmrMnh0ZFzCxoI4Xmww9opAQ/5J9ziAEMKN3/1IzIQEMljLc7Uc7kQxtNRy3+G
	 MNiHZZ62GUhCYjjnm9IfxrP3KpEmP4esz/neIOpV7pXkMixnJisIHlwrorottfTRYv3an
	 sUJvijrZNUAmrmLBsA1dg1kqL16mCvaICr1/Y5DZmVSc9sJojYzagrR0+R/uUB9iEfKot
	 7zBc88Cz0dxelV2S9lG7CyLR3L5PHlrGix6jUoADeOLUq3/mCbYvFajw1x6jRxHFYJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832341;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nhx1r2ebJL4hQTAtA6lCeoIQdnFKHy/Vbh3N+LuSmK8=;
	b=QjCApgOoojSc8UHyNFyZW49kLJ2SDTsPNYo4GMZcNn/AUFN8wD6uCykn43bMOctaBh92
	 jjYxvLoQ1lAw84x6plQ8zAmmX6HvPRiKjarhZhmjus+f2rk8C/hv3z5UkDMsUrJ2k7SOD
	 RCrU/7aYjwePIHrmBKpNh6zoSgDXEFMffxVG3spekCOu68FLOnDSq0E++W3ForxVWCMDI
	 YoyiHaFuQtJhE+uGSs+k6WIvuSedmn8/QrqwQQQ7X/2GntB1FdyD1tb2BD3fq6Q75dJQt
	 aAaccF7fDF2i48SM6pUu8mvP+U+36rRMIJQvxpvFpBXhY7dpptiA2iQD1m+C8oHvLtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WLWUVQQa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1CA606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WLWUVQQa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617221F01828;
	Sat, 24 Oct 2026 08:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832341;
	bh=nhx1r2ebJL4hQTAtA6lCeoIQdnFKHy/Vbh3N+LuSmK8=;
	h=Date:To:From:Subject;
	b=WLWUVQQaTzeP80RXnP8jUq6Ou1DKB7gRt1Mvxb78cgIeQsxwDZihXfz/CQcktgFz6
	 wMPcCD1ajFXqkq0lweBJzAGpPa1YCNSAm/rqBnOejVw3hM5G1SB5Xrz7H35JipWMv1
	 SPXMjBA77Ro5sWgDMByHQ540XOWErLwV+5XKivoU=
Date: Sat, 24 Oct 2026 01:59:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kbingham@kernel.org,kasong@tencent.com,jan.kiszka@siemens.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-remove-pfn_in_present_section.patch removed from -mm tree
Message-Id: <20261024085901.617221F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/sparse: remove pfn_in_present_section()
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-pfn_in_present_section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: remove pfn_in_present_section()
Date: Mon, 21 Sep 2026 21:58:59 +0200

Unused, let's remove it.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-7-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
---

 include/linux/mmzone.h |   10 ----------
 1 file changed, 10 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-remove-pfn_in_present_section
+++ a/include/linux/mmzone.h
@@ -2300,13 +2300,6 @@ static inline unsigned long next_valid_p
 
 #endif
 
-static inline int pfn_in_present_section(unsigned long pfn)
-{
-	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
-		return 0;
-	return present_section(__pfn_to_section(pfn));
-}
-
 static inline unsigned long next_present_section_nr(unsigned long section_nr)
 {
 	while (++section_nr <= __highest_used_section_nr) {
@@ -2336,9 +2329,6 @@ static inline unsigned long next_present
 #else
 #define pfn_to_nid(pfn)		(0)
 #endif
-
-#else
-#define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
 /*
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch


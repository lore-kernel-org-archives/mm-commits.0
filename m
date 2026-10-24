Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832339;
	b=pZjlvvIWDJ0wmhe91n+17yqp+rXJ4SLv63Mz93ZiZKjWRGYzmbNL8qYlvzy5T6WinVW5
	 e3zzgeTFSBqB10l3hm3A/S/xb/2mTpD0U9+Gk4zqETbwjRX/RA+/56Y9vTHZhP2NQ5pP9
	 hzXkovi7jdGsADItgXZ5memc0nycQUarCXZJ7YNUJJ3RE0ptXdgcs4gzpcIhYdEWnHnmD
	 DMX6lyNSFK6FVKqgfQbjRbUzOPdBx88G+4SZ/ZhQD9hUbMRsHLaIC1ESypySR8H5bBKTW
	 lpXhuDZ1160gSTvZ7UejIog+oA1BsVV6DqkUV1udlKvvi1Yoe3B5G55IeGHFrgW8WFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832339;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ZZruYvcJiAyQ8zD0Wfuw/fznz7LtKIw8ApsoqnoFb6U=;
	b=mkU29Cb2nlxlFNafIDYTpjLVud+/E+3IZevnr1B9x12VntHSMamBYc0ztqx40MKtNTwr
	 ZYJ3T2XsFQVlyp1Y2fMB1ivfwFRrw+XSlJw4GUJSRfP/onqepyVLuelRuWgNWG5PEz2GX
	 6HSArqn3I0r6iRJI8diRIk4V1XF55+o3uLdyxhYf5hXfVX/gZoIG8Rblr5qO4MW00KPhW
	 o+de9Q9XPuWISOCjrixQm/bjKinaPcjPhO2zKJja3yruo1yDZ/o6p5MzUKWdcGT4Scis/
	 xkn6z+UkUNhJLP64u6fnD2u5nUHFrTe8U0/pcFgVD7X/JYCYu3FK5t0Q131P/Q2yEjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oq0XQm2t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E578606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oq0XQm2t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538B91F01828;
	Sat, 24 Oct 2026 08:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832339;
	bh=ZZruYvcJiAyQ8zD0Wfuw/fznz7LtKIw8ApsoqnoFb6U=;
	h=Date:To:From:Subject;
	b=oq0XQm2tflSKNg89dCQBRHOcIRjBGxGfrwhG5LNrjDRxxQ9IrWBMbLUHkKkynxqJ6
	 tgujIv1tqdmBsji0MCSz1uKW7bJorx/jhNCP3S57xxHuTRGPMNnbK88CN6i/gB4jde
	 Md92hOn+dqQTELGo38PJJAtPg0d+ob3fAI1R6i+w=
Date: Sat, 24 Oct 2026 01:58:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kbingham@kernel.org,kasong@tencent.com,jan.kiszka@siemens.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-cleanup-sparse_init_one_section.patch removed from -mm tree
Message-Id: <20261024085859.538B91F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/sparse: cleanup sparse_init_one_section()
has been removed from the -mm tree.  Its filename was
     mm-sparse-cleanup-sparse_init_one_section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: cleanup sparse_init_one_section()
Date: Mon, 21 Sep 2026 21:58:57 +0200

Let's avoid the "pnum" terminology.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-5-54d81d65e125@kernel.org
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

 mm/sparse.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/sparse.h~mm-sparse-cleanup-sparse_init_one_section
+++ a/mm/sparse.h
@@ -20,7 +20,7 @@ void sparse_sections_init(void);
 int sparse_index_init(unsigned long section_nr, int nid);
 
 static inline void sparse_init_one_section(struct mem_section *ms,
-		unsigned long pnum, struct page *mem_map,
+		unsigned long section_nr, struct page *mem_map,
 		struct mem_section_usage *usage, unsigned long flags)
 {
 	unsigned long coded_mem_map;
@@ -32,7 +32,7 @@ static inline void sparse_init_one_secti
 	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
 	 * from the page pointer to obtain the PFN.
 	 */
-	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
+	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(section_nr));
 	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch


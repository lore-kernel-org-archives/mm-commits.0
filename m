Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C5A280331
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 03:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297394; cv=none; b=s2WmMNNXmDsXaidNoZ5Cz3T1pAvdbV4Aw160B9ZTG1WoRnpluPDPgHji/drd9ZtP8Ija15JmbNng9LAaDqSpepxP+uzbu+IWNffr8qhKPXuYQnX8DXUyAdAfrx07UEzKx5tQDXEs7Y4IOGV7yHiLmfHesPNbflpJEzzszIo5anM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297394; c=relaxed/simple;
	bh=dTBrO9b1T4LQUZFYQiBPdU65rza7N+Emxw4NQIdxvME=;
	h=Date:To:From:Subject:Message-Id; b=GjuKIV1l0gC0f6H+77vsxvVaOQaKG/VgloAeSjoL7bnFz7I4g4g9DOG/MNL0AMHcLyWJN3KLV5Vpo3lcndPrLoWOKhC7V53PECb7GUmjcxgoSOa0rRq0/Dsl04cA4xg8srPG9+U5A3byBKesn6adEsb3Bo9JboGujwIlCOHQ+YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vpda5U+a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vpda5U+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2261F000E9;
	Wed, 29 Jul 2026 03:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785297393;
	bh=FtPxY5fKSIoEyS7hBwPdh9fkktRIVt7i2yT/4iGRNvU=;
	h=Date:To:From:Subject;
	b=vpda5U+aot8jeF2IaXuVO+Voa+kDM5JOrxL+d3JEIacZ60bvg6/uYlfxvF4B2A3m8
	 w2GaYe6U64mqIRY11ttG03WEulZ7yIXkSS4Fbvfp7DO37ZAEj8crk3lT+m8Rsrb+wI
	 is36jTjIfvn4x2UqsekcHAmnVQ9riJjnxZ7Z405A=
Date: Tue, 28 Jul 2026 20:56:33 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch removed from -mm tree
Message-Id: <20260729035633.6B2261F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch

This patch was dropped because it was folded into mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer.patch

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix
Date: Wed, 8 Jul 2026 16:33:08 +0800

v11:
According to the comments of David, simplify page_to_nid() to pass
&(PF_POISONED_CHECK(page)->flags) directly.

v10:
According to the comments of David, drop the redundant CONFIG_NUMA split
in page_to_nid()/folio_nid() and remove the SECTIONS_WIDTH != 0 guard
around ASSERT_EXCLUSIVE_BITS() in memdesc_section().

Link: https://lore.kernel.org/20260708083308.747930-1-hui.zhu@linux.dev
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

--- a/include/linux/mm.h~mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix
+++ a/include/linux/mm.h
@@ -2303,29 +2303,15 @@ static inline int memdesc_nid(const memd
 #endif
 #endif
 
-#ifdef CONFIG_NUMA
 static inline int page_to_nid(const struct page *page)
 {
-	const struct page *p = PF_POISONED_CHECK(page);
-
-	return memdesc_nid(&p->flags);
+	return memdesc_nid(&(PF_POISONED_CHECK(page)->flags));
 }
 
 static inline int folio_nid(const struct folio *folio)
 {
 	return memdesc_nid(&folio->flags);
 }
-#else
-static inline int page_to_nid(const struct page *page)
-{
-	return 0;
-}
-
-static inline int folio_nid(const struct folio *folio)
-{
-	return 0;
-}
-#endif
 
 #ifdef CONFIG_NUMA_BALANCING
 /* page access time bits needs to hold at least 4 seconds */
@@ -2566,9 +2552,7 @@ static inline void set_page_section(stru
 
 static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 {
-#if SECTIONS_WIDTH != 0
 	ASSERT_EXCLUSIVE_BITS(mdf->f, SECTIONS_MASK << SECTIONS_PGSHIFT);
-#endif
 	return (mdf->f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #else /* !SECTION_IN_PAGE_FLAGS */
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer.patch


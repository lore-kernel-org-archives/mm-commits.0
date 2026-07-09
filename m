Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F28F2F49FD
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 03:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783568961; cv=none; b=SeIocei9ZQOm3F+6dgpXLbGSbrB6h0CWNj2r1Ipqrc6y491hK7QbMQVtx81LkfY5sxb4t+VPo+IP3vBk1m4xxS8yRDyxUohKuWACU3PKNXIb6Rm2NTbSHX/7Pikyu6R3Qc8yXz2icPRD6nUJBc1uRb1fVoqN6axuyeyyX2uK2Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783568961; c=relaxed/simple;
	bh=Y94nlElIb+bH7uweo8HyqfoNbNENAlrRTQ28aWwgpZA=;
	h=Date:To:From:Subject:Message-Id; b=Z/0smbXJD5YeawsgCQvDbkf8171Fd526VLcv/Td5srov6RCDROonWWFFMYbgT9TI7rxNxtOZVfoY4GWQG7chZjda9bab03IyNJBtbEjirHQdAmysQkDt+Fj0cssbWn49pMy2d21+2H4PZ+PEIutt7iH2yXdCu2S9itE5CgvlvKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t0g/XWvZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t0g/XWvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9751F000E9;
	Thu,  9 Jul 2026 03:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783568960;
	bh=33q7Rul/e5DB5+EATBXV+W0LKyHDdLzpRgNB5bi/D8o=;
	h=Date:To:From:Subject;
	b=t0g/XWvZ4m5AB5vtOcdhWtMy3dAXnP4obGSm7/dr4qcNcy8lVXTIQzSRQ8gS1X+gV
	 yN0Twa0BSOBZmo6xO/wEjfsITao2B6FN5KQO9JhVuPPe43e79OwLlqZ1dvcWPB32nr
	 xUKT0ZpheDNfW4w3DsU3wKu0J7MmIsPBv69NHwBg=
Date: Wed, 08 Jul 2026 20:49:19 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch added to mm-unstable branch
Message-Id: <20260709034920.0B9751F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch

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
mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch


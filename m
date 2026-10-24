Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832540;
	b=d+et/KjNYijWdL/tSPUHtb8j5GiW7pJum8FD6RNUVyHeFwNdjYjUYnp2+UVRkPUw/d03
	 VvC0XMX+EmyC+Fdd0SqWPPPOJ0eAiMr0N6kG3sxeQS1k//EzZ6zCLv9DL19UREfbNbNJa
	 9sJ95neDeFH7UXj4eFo+EdeOx8RGHii26oQED/FRPk34WW7ca4Lmoi3U/2P68TNsLSm2S
	 OVyNKhxR0XUGQiXBfXtK4N8M7GR2T6bqVxLZlALjE3eqELyweBYVQaV+4zwZG6KmLye7J
	 aHLpRad/JVIq2q92j+zGVyH6JVEsdHTU5g7RjwRAh3ZA4c3Jcc5BYlS0lH5ADwhphIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832540;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nTfx94I1o9vkdnJ7Y3U90PChafj4BQd0BrAfcL5K4xI=;
	b=0xG94t/W7+ZsQ9OUvlb8O6ruvOe++IyHfLJ8gVb9bqJzFnwJ42J2pjANHR96cc5JY4BO
	 krz+uCJqRnih1TQX+VX/K6zVMJwTzxF5Y8q3IcPPy2FI2ApOgnnOSEFkEE/2YxjnzniWI
	 y26EXa1MieJIy/g8JfNBgrq7SddM45tRFlsc5eowEK6txOQVRk6ykVRWSB2Q6OoObS/eN
	 z7QuWugpDV+wa3lKutzjHRpDoxBpOrUV50dqSnBhKKujZiynABlwTTiRzqcrbTkmIAAq8
	 /JrBbOdCS8J6zIjpYixlZcm0vaKLgAOd3dpV9Tca6Tyk5sjH2gKBWugxww+yjPLCnjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ySMdYjsr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAFF606A31F;
	Sat, 24 Oct 2026 09:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ySMdYjsr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE8E1F01825;
	Sat, 24 Oct 2026 09:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832540;
	bh=nTfx94I1o9vkdnJ7Y3U90PChafj4BQd0BrAfcL5K4xI=;
	h=Date:To:From:Subject;
	b=ySMdYjsrLrW6p83xrwxREJmVeMXr2m+3oIQ9qO/pAGvVLTvz3ly5+XA8PJP+tAYsE
	 MZNfEnwa+6S/qvQ6sDncmogtcsV8fuMYkhpRKkBIntwmvU8mYLBiyCamp5XwMoRsgu
	 FQPAUUEY7/ms0LoERgIoCUoVUZTJFuGRFFRPtJbs=
Date: Sat, 24 Oct 2026 02:02:19 -0700
To: mm-commits@vger.kernel.org,wangruikang@iscas.ac.cn,tongtiangen@huawei.com,stable@vger.kernel.org,paul.walmsley@sifive.com,pasha.tatashin@soleen.com,palmer@dabbelt.com,guoyaxing@bosc.ac.cn,david@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,cuiyunhui@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-mm-exclude-invalid-thp-pmds-from-page-table-check.patch removed from -mm tree
Message-Id: <20261024090219.DCE8E1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: riscv: mm: exclude invalid THP PMDs from page table check
has been removed from the -mm tree.  Its filename was
     riscv-mm-exclude-invalid-thp-pmds-from-page-table-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yunhui Cui <cuiyunhui@bytedance.com>
Subject: riscv: mm: exclude invalid THP PMDs from page table check
Date: Sat, 23 May 2026 12:20:52 +0800

RISC-V THP splitting uses a temporary invalid PMD state where
pmd_mkinvalid() clears _PAGE_PRESENT and _PAGE_PROT_NONE but leaves
_PAGE_LEAF set so the MM code can still recognize the PMD as a THP split
in-progress entry.

That temporary state no longer describes a user-accessible mapping, but
page_table_check currently treats it as one because the RISC-V PMD
user-accessibility test only checks whether the PMD is a leaf and has user
permissions.

As a result, when a PMD-sized anonymous THP is split during a COW fault,
page_table_check can account the invalid intermediate PMD as a live PMD
mapping, and then account the replacement PTE mappings again when the
split installs the PTE table.  This leaves stale PMD accounting behind and
later triggers page_table_check failures such as a non-zero anon_map_count
when the folio is freed.

Fix this by tightening pmd_user_accessible_page() so PMD page-table-check
accounting only considers leaf PMDs that still carry either _PAGE_PRESENT
or _PAGE_PROT_NONE.  This preserves the THP split semantics required by
the MM code while preventing page_table_check from treating invalid split
PMDs as live user mappings.

With CONFIG_PAGE_TABLE_CHECK=y and CONFIG_PAGE_TABLE_CHECK_ENFORCED=y,
tools/testing/selftests/mm/cow completes successfully on RISC-V after this
change.

Link: https://lore.kernel.org/20260523042052.35476-1-cuiyunhui@bytedance.com
Fixes: 3fee229a8eb9 ("riscv/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK")
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: tongtiangen <tongtiangen@huawei.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: Yaxing Guo <guoyaxing@bosc.ac.cn>
Cc: <stable@vger.kernel.org>
---

 arch/riscv/include/asm/pgtable.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/riscv/include/asm/pgtable.h~riscv-mm-exclude-invalid-thp-pmds-from-page-table-check
+++ a/arch/riscv/include/asm/pgtable.h
@@ -989,7 +989,14 @@ static inline bool pte_user_accessible_p
 
 static inline bool pmd_user_accessible_page(struct mm_struct *mm, unsigned long addr, pmd_t pmd)
 {
-	return pmd_leaf(pmd) && pmd_user(pmd);
+	/*
+	 * page_table_check() must ignore THP split invalidation entries created by
+	 * pmd_mkinvalid(). These retain _PAGE_LEAF so pmd_present()/pmd_leaf() stay
+	 * true during the split, but they no longer describe a user-accessible
+	 * mapping once both _PAGE_PRESENT and _PAGE_PROT_NONE are cleared.
+	 */
+	return (pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE)) &&
+		(pmd_val(pmd) & _PAGE_LEAF) && pmd_user(pmd);
 }
 
 static inline bool pud_user_accessible_page(struct mm_struct *mm, unsigned long addr, pud_t pud)
_

Patches currently in -mm which might be from cuiyunhui@bytedance.com are



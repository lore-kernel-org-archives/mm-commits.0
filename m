Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6D746434
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247700; cv=none; b=ADSaGLmvtzm8EZNyWxUtD/ATTtiqVtI2xV12kU1n/zw9X6HFgUauDsMMEOrpLbNfkaE2Y6NeQ0o9ICrOvAIOS3ADRAg0DKvzu/L2DoirPEvSOa1ykVxMpwqZxc5tcd3Hi6JUU62DlF0BUKBqtlHPUi/jIDSDT0jG2KAiRGiOoLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247700; c=relaxed/simple;
	bh=j/a8qXfl1USQeHbURDTD29vYEGq7+sQCNgK48hgA5KM=;
	h=Date:To:From:Subject:Message-Id; b=KOewH19hE3VE8H9gs7giDX8c7Yz7qLMLJ7H/x0SiVVsBTRHuAFmdBXMZlwwodCoUo11c6/YeMAH4h61sras/7jkFUw5CG0+RczZ7DvJX8nzNVH82APTtNTKwvUc6MHQ0njtO3GxPW4JwVr/ThCGLKj8i50Mgmr3+1WfxwwmHwLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AP6e4k16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AP6e4k16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC266C4CEC2;
	Mon,  2 Sep 2024 03:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247700;
	bh=j/a8qXfl1USQeHbURDTD29vYEGq7+sQCNgK48hgA5KM=;
	h=Date:To:From:Subject:From;
	b=AP6e4k16/CK7CvkX3vxJsYQpOR5gzzxBZPMBInSz6PlDF56Wledw2rstbKH4NVPzd
	 Stl/aLT88f6pDkp2vbRnV0Yar/YN98/KZBSqeFiiwwAMsLIXgTIrCHXDqqP0eC+LuE
	 NwUS6TvBYuA90sObNUQRlPhcqiXKXfAGfS4/7EGA=
Date: Sun, 01 Sep 2024 20:28:19 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,tglx@linutronix.de,rppt@kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,linux@armlinux.org.uk,jgross@suse.com,hpa@zytor.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,brauner@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch removed from -mm tree
Message-Id: <20240902032819.EC266C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/8xx: document and enforce that split PT locks are not used
has been removed from the -mm tree.  Its filename was
     powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: powerpc/8xx: document and enforce that split PT locks are not used
Date: Fri, 26 Jul 2024 17:07:28 +0200

Right now, we cannot have split PT locks because 8xx does not support SMP.

But for the sake of documentation *why* 8xx is fine regarding what we
documented in huge_pte_lockptr(), let's just add code to enforce it at the
same time as documenting it.

This should also make everybody who wants to copy from the 8xx approach of
supporting such unusual ways of mapping hugetlb folios aware that it gets
tricky once multiple page tables are involved.

Link: https://lkml.kernel.org/r/20240726150728.3159964-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/pgtable.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/powerpc/mm/pgtable.c~powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used
+++ a/arch/powerpc/mm/pgtable.c
@@ -297,6 +297,12 @@ int huge_ptep_set_access_flags(struct vm
 }
 
 #if defined(CONFIG_PPC_8xx)
+
+#if defined(CONFIG_SPLIT_PTE_PTLOCKS) || defined(CONFIG_SPLIT_PMD_PTLOCKS)
+/* We need the same lock to protect the PMD table and the two PTE tables. */
+#error "8M hugetlb folios are incompatible with split page table locks"
+#endif
+
 static void __set_huge_pte_at(pmd_t *pmd, pte_t *ptep, pte_basic_t val)
 {
 	pte_basic_t *entry = (pte_basic_t *)ptep;
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch


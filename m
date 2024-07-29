Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EF523CE
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 00:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722214337; cv=none; b=c/u5CIKazIl5POhP5LBO3D0BJwc+2pWwKsQrtbTaDAf+2oaZuOUzUhELio5myrmq8gl9qdX3oIVK9L+Jy2Ll0FukcZ4a1hR6PX3uIr20nbBOtcoD/hMZpdlxfzIUbT3jELpb0t5XS0S43XVLE4kRwe6tvuAxoiNx/OC1hof6Kd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722214337; c=relaxed/simple;
	bh=ByL6Nut4YDVu+NY3xaeAzAhCGF5xYtkYR0JBz1wIAho=;
	h=Date:To:From:Subject:Message-Id; b=ZZlx4Wr5yuUdUXR/9rrxwGfDNA0NOPJM6DUEk1+Z68yLA4oGvn55HI2s+6YUQ8J7t5+5aK5ZfZnVk4OXrRqZYym2rnRlUbphf32LlGFtzR6oUFvAPdMTSnEU4G+SQwswxwBiQqSFmOQs5zCEjSMj0OK0SYKtw7StDIJG6NylGhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SeuqxPJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SeuqxPJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794A0C116B1;
	Mon, 29 Jul 2024 00:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722214336;
	bh=ByL6Nut4YDVu+NY3xaeAzAhCGF5xYtkYR0JBz1wIAho=;
	h=Date:To:From:Subject:From;
	b=SeuqxPJ//IwgnXgKnVWGh+p5OLkpQ2HP744s3zXDw7xcGKGMgma7XJwPPUnhayBRL
	 xWi8Ld3LuLePaGSIuYRPhNaZ1GJT3i+lmjITnPeEb6hfLDvF3NSlcQ4HiR9l1ZkUf8
	 kpn+EqytE6pa4SabcxR0onNxFDILTisiLiESrjP4=
Date: Sun, 28 Jul 2024 17:52:15 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,tglx@linutronix.de,rppt@kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,linux@armlinux.org.uk,jgross@suse.com,hpa@zytor.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,brauner@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch added to mm-unstable branch
Message-Id: <20240729005216.794A0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/8xx: document and enforce that split PT locks are not used
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-let-pte_lockptr-consume-a-pte_t-pointer.patch
mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch
mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C097493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nf8x9FdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D81C433C9;
	Mon, 11 Dec 2023 01:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257838;
	bh=pPXkHUTdfJ4lzT9yqOxfHzv4Ol+RbJjhogQbqAbR90s=;
	h=Date:To:From:Subject:From;
	b=nf8x9FdNyecBNnNs15TLurofik6SN7X932MxuY34Xbt6rWymg0ktISUy2WkrB6Vq+
	 pulO1svreJ07BFEvtNBCIkKUg93cdJ+5h5jNt2vOzEwKYPMJUEPfW2J8qVP8ODYWKG
	 bkAumdbIy+fHCQ304aplH9v4lhoB0gUZDbeWOGYg=
Date: Sun, 10 Dec 2023 17:23:57 -0800
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,arnd@arndb.de,sfr@canb.auug.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] powerpc-pmd_move_must_withdraw-is-only-needed-for-config_transparent_hugepage.patch removed from -mm tree
Message-Id: <20231211012358.51D81C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc: pmd_move_must_withdraw() is only needed for CONFIG_TRANSPARENT_HUGEPAGE
has been removed from the -mm tree.  Its filename was
     powerpc-pmd_move_must_withdraw-is-only-needed-for-config_transparent_hugepage.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: powerpc: pmd_move_must_withdraw() is only needed for CONFIG_TRANSPARENT_HUGEPAGE
Date: Mon, 27 Nov 2023 13:08:57 +1100

This is required for the later patch "Makefile.extrawarn: turn on
missing-prototypes globally".

Link: https://lkml.kernel.org/r/20231127132809.45c2b398@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/pgtable.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/mm/book3s64/pgtable.c~powerpc-pmd_move_must_withdraw-is-only-needed-for-config_transparent_hugepage
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -542,6 +542,7 @@ void ptep_modify_prot_commit(struct vm_a
 	set_pte_at(vma->vm_mm, addr, ptep, pte);
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * For hash translation mode, we use the deposited table to store hash slot
  * information and they are stored at PTRS_PER_PMD offset from related pmd
@@ -563,6 +564,7 @@ int pmd_move_must_withdraw(struct spinlo
 
 	return true;
 }
+#endif
 
 /*
  * Does the CPU support tlbie?
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7396B175BD
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759120; cv=none; b=IeiDtx5lWq+SdhHcomT1XMS95I95VzKqffpBNlmBQTizpNhOMCtnMrrhyBJeIchc0Pt1oKz3auCWtKwUwogFXyIRDNXHMSwqQGf7C0bd9c+P8Dw2BqL9zyYUBFNLQf8Rf5kzNFHwJDR0rjHwWtyIXXKPOngtltA5oJQJ7nHqyT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759120; c=relaxed/simple;
	bh=efcNgQwA3hIZPMzZ7VyIBs7haKVACfxuWWm5rQGEpOs=;
	h=Date:To:From:Subject:Message-Id; b=Oe41+TlHHiQcdRHG0eish591L2aVxYA136ndqFFojj09R1K8VjU2u/PPnGE3sNE2Chnzz6mbQncCooOkqsZlHvgAg7kk5LyjCf5JoK1DpIspyehsDrJs6NwYqXqrt696TCXtTJ8nbUuZ56E9p+E5MxAHOO0CwJwvKy7WFzFV9CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AATmUCxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AATmUCxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AC4C43390;
	Wed,  6 Mar 2024 21:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759120;
	bh=efcNgQwA3hIZPMzZ7VyIBs7haKVACfxuWWm5rQGEpOs=;
	h=Date:To:From:Subject:From;
	b=AATmUCxF9w3+CAEPv1WMm9JluCNiYP34f/TE6nSaF1yHp7y0KpbhSOJ73Epur7H6b
	 dEjr/RKeXfK6QIH8ESpq1PeJ/FqrJDvPKivMRDdunkXAno//qYdl3T+ODZAEpYOFqS
	 cbsEUws4wUItuV13v6Ey5FPVyKPtOWGbnJsxD0Pw=
Date: Wed, 06 Mar 2024 13:05:19 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,jgg@nvidia.com,glider@google.com,dvyukov@google.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@kernel.org,andreyknvl@gmail.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-x86-replace-pgd_large-with-pgd_leaf.patch removed from -mm tree
Message-Id: <20240306210519.F0AC4C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/x86: replace pgd_large() with pgd_leaf()
has been removed from the -mm tree.  Its filename was
     mm-x86-replace-pgd_large-with-pgd_leaf.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/x86: replace pgd_large() with pgd_leaf()
Date: Tue, 5 Mar 2024 12:37:44 +0800

pgd_leaf() is a global API while pgd_large() is not.  Always use the
global pgd_leaf(), then drop pgd_large().

Link: https://lkml.kernel.org/r/20240305043750.93762-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    4 ++--
 arch/x86/mm/pti.c              |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-x86-replace-pgd_large-with-pgd_leaf
+++ a/arch/x86/include/asm/pgtable.h
@@ -1418,8 +1418,8 @@ static inline bool pgdp_maps_userspace(v
 	return (((ptr & ~PAGE_MASK) / sizeof(pgd_t)) < PGD_KERNEL_START);
 }
 
-#define pgd_leaf	pgd_large
-static inline int pgd_large(pgd_t pgd) { return 0; }
+#define pgd_leaf	pgd_leaf
+static inline int pgd_leaf(pgd_t pgd) { return 0; }
 
 #ifdef CONFIG_PAGE_TABLE_ISOLATION
 /*
--- a/arch/x86/mm/pti.c~mm-x86-replace-pgd_large-with-pgd_leaf
+++ a/arch/x86/mm/pti.c
@@ -185,7 +185,7 @@ static p4d_t *pti_user_pagetable_walk_p4
 
 		set_pgd(pgd, __pgd(_KERNPG_TABLE | __pa(new_p4d_page)));
 	}
-	BUILD_BUG_ON(pgd_large(*pgd) != 0);
+	BUILD_BUG_ON(pgd_leaf(*pgd) != 0);
 
 	return p4d_offset(pgd, address);
 }
_

Patches currently in -mm which might be from peterx@redhat.com are



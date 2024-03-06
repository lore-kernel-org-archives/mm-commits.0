Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47949175BD
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759121; cv=none; b=gJ+0ouwzjMUlalZ1yK8o+A5SGlgnbx0upUZ7CVya0TEHs2xiRBIWwU2be9XM1y6+KPUfDowxJs49v11Tuje55aQswkQVs/SYTpl5t+/QLh6sE1kTqKrApnPDoKMaGwc3ykl+Dx3vwnR2sANHLqy/ynAmV5/NsQaAyBnEiMLvVXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759121; c=relaxed/simple;
	bh=oVabUEsT5zWdgWib2BKTBauSDw9+QFCUZr3gzQmC8JY=;
	h=Date:To:From:Subject:Message-Id; b=LWm+Tb4IABbj62LAJ+WvK1DHHPI9hjIfN73FD7QM8hGxO3nQBttfY938gwxDpZWZuF85XsJygIl8kHTPbrGozw+eN3eKCQhORUoZHdtuh4c6i8w0hbkH+qhctzO8+BWPK6mtBw0fq2ARAQ7xdxV7urPWE6tGaUAHyjhResbWfjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G63rwPdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G63rwPdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B7AC433F1;
	Wed,  6 Mar 2024 21:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759121;
	bh=oVabUEsT5zWdgWib2BKTBauSDw9+QFCUZr3gzQmC8JY=;
	h=Date:To:From:Subject:From;
	b=G63rwPdvXZSzHdgXnr1R4TN/WqP0zSN7Emu9wkcawZlvI1kjDQZ7kmbjvDVmUzVZT
	 1kjAv7cvpItMlAOqqV8M2y6WiS6QcZ1mkiPzNUGiTFyyDYNkbYwFmpqsZT9B+K7ITB
	 lt/52wPTVXOgC9jHfOOzSdJGtV1lkNp2Nrr4CvJo=
Date: Wed, 06 Mar 2024 13:05:20 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,jgg@nvidia.com,glider@google.com,dvyukov@google.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@kernel.org,andreyknvl@gmail.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-x86-drop-two-unnecessary-pud_leaf-definitions.patch removed from -mm tree
Message-Id: <20240306210521.17B7AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/x86: drop two unnecessary pud_leaf() definitions
has been removed from the -mm tree.  Its filename was
     mm-x86-drop-two-unnecessary-pud_leaf-definitions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/x86: drop two unnecessary pud_leaf() definitions
Date: Tue, 5 Mar 2024 12:37:45 +0800

pud_leaf() has a fallback macro defined in include/linux/pgtable.h
already.  Drop the extra two for x86.

Link: https://lkml.kernel.org/r/20240305043750.93762-6-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
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

 arch/x86/include/asm/pgtable.h      |    1 -
 include/asm-generic/pgtable-nopmd.h |    1 -
 2 files changed, 2 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-x86-drop-two-unnecessary-pud_leaf-definitions
+++ a/arch/x86/include/asm/pgtable.h
@@ -1097,7 +1097,6 @@ static inline int pud_bad(pud_t pud)
 	return (pud_flags(pud) & ~(_KERNPG_TABLE | _PAGE_USER)) != 0;
 }
 #else
-#define pud_leaf	pud_large
 static inline int pud_large(pud_t pud)
 {
 	return 0;
--- a/include/asm-generic/pgtable-nopmd.h~mm-x86-drop-two-unnecessary-pud_leaf-definitions
+++ a/include/asm-generic/pgtable-nopmd.h
@@ -31,7 +31,6 @@ static inline int pud_none(pud_t pud)		{
 static inline int pud_bad(pud_t pud)		{ return 0; }
 static inline int pud_present(pud_t pud)	{ return 1; }
 static inline int pud_user(pud_t pud)		{ return 0; }
-static inline int pud_leaf(pud_t pud)		{ return 0; }
 static inline void pud_clear(pud_t *pud)	{ }
 #define pmd_ERROR(pmd)				(pud_ERROR((pmd).pud))
 
_

Patches currently in -mm which might be from peterx@redhat.com are



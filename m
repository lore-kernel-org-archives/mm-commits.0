Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3DB179BC
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 17:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709661036; cv=none; b=VTWkoXlzucgLOZxq1+a0vl3sfrifie8n0jG6/WILc5QBnXdTKYgG03OVMmdOHjHLhZ51LjewfbQrjNmLnDZkvMi9IjGY4UN/ClCuOrR3FJKjqR5TG5P2vVs6hfIBXqpf5QEPJXkR0NBXWMl+vkVXdoFU5Hz11a0qDcNR1GQ6Dow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709661036; c=relaxed/simple;
	bh=FuCRnipWkDGN0c98q3Q6o/rroF4AaWiosLQmaKA0w94=;
	h=Date:To:From:Subject:Message-Id; b=lEWJTQhXGyqC91BOIZiPjEhzZt8HasHrqeDwyilsZ8M9EiKhPmcwaIB3lohv4o3AmZAVEnA7ZUEPEr4LJTOgXOVpMriYwD/uu+2Jrod6Smx9vyfzUcxXOKdvgKpC6MRDPCuEwUh4d8rtM3Zu3LJ6CXIoOzYx2vLKBSbXRW8XLMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vaifpjfv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vaifpjfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6CBC433F1;
	Tue,  5 Mar 2024 17:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709661036;
	bh=FuCRnipWkDGN0c98q3Q6o/rroF4AaWiosLQmaKA0w94=;
	h=Date:To:From:Subject:From;
	b=VaifpjfvJOg6okO+EllvvvopZOxyzLKxrlM27g7lz0wir4l/fDcnzo2VZDcc12Ums
	 OzKgRy56AcZIy0faDOO24rR+1ZrB/M8dRLbv0axyx+yW3bs0447ewBn2tTOf/dHUM/
	 /zeKrEZFMTFHVQhkkf2u9t2aWA2R8c+bsAbsLy1I=
Date: Tue, 05 Mar 2024 09:50:35 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,jgg@nvidia.com,glider@google.com,dvyukov@google.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@kernel.org,andreyknvl@gmail.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-drop-two-unnecessary-pud_leaf-definitions.patch added to mm-unstable branch
Message-Id: <20240305175036.5D6CBC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/x86: drop two unnecessary pud_leaf() definitions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-x86-drop-two-unnecessary-pud_leaf-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-x86-drop-two-unnecessary-pud_leaf-definitions.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/x86: drop two unnecessary pud_leaf() definitions
Date: Tue, 5 Mar 2024 12:37:45 +0800

pud_leaf() has a fallback macro defined in include/linux/pgtable.h
already.  Drop the extra two for x86.

Link: https://lkml.kernel.org/r/20240305043750.93762-6-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
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

mm-ppc-define-pxd_large-with-pxd_leaf.patch
mm-ppc-replace-pxd_is_leaf-with-pxd_leaf.patch
mm-x86-replace-p4d_large-with-p4d_leaf.patch
mm-x86-replace-pgd_large-with-pgd_leaf.patch
mm-x86-drop-two-unnecessary-pud_leaf-definitions.patch
mm-kasan-use-pxd_leaf-in-shadow_mapped.patch
mm-treewide-replace-pmd_large-with-pmd_leaf.patch
mm-treewide-replace-pud_large-with-pud_leaf.patch
mm-treewide-drop-pxd_large.patch
mm-treewide-align-up-pxd_leaf-retval-across-archs.patch


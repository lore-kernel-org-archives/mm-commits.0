Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BBB1BF53
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 18:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723574862; cv=none; b=YjFSTWzb/2buyul1uUaAxfj64TO2g06A62V0lMYTIKGONpsGu4cTypLYLJBzjzxmBcp0UqLXlRgEk3FAYYaT2TgzG+iXNVT7bEHRQtJvljsxzWDUY780CA6P734rEf2Lymq0kcqZ339lCpLFJmroSAQ0rIz/WIaFx1t2RueLG/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723574862; c=relaxed/simple;
	bh=G9B70scp3XtbJ9Fx3TP1Cx9SZydLeJS2TZ7D+dyqZPQ=;
	h=Date:To:From:Subject:Message-Id; b=s5G/xqp0+CY8Dy+0DBuG1DNmcaAC5r+NBVf60quV+wZY21eYjMW0mblGnQorr8c8nbK6hT6/7fKDWQE1NK2F1Tp7RP8sfCgQ0fe3ud36VCdSnbZuTmKALqY9VoS1HQZ2JMmzuutjm6nQFoMiasoU9DEzGenGFxdYCMtudaLQgws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oy1bCC9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oy1bCC9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6CFC32782;
	Tue, 13 Aug 2024 18:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723574861;
	bh=G9B70scp3XtbJ9Fx3TP1Cx9SZydLeJS2TZ7D+dyqZPQ=;
	h=Date:To:From:Subject:From;
	b=oy1bCC9CHsjbPbR6YKXriUo7gEjmerPq/Wl/PToO7XknuEoM2SV9Lwm72gN0s2bjC
	 3H2E6vQ8dAiovUOPPB50wdDgLZSPPN8/ZZ4P/HKzVA0z3FxGcYhXRITFJ6pFU9xc+a
	 mgBX2+16Gvx14/EUB3bcKCbB0mtMa2vgwAM0knds=
Date: Tue, 13 Aug 2024 11:47:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,seanjc@google.com,rientjes@google.com,riel@surriel.com,rick.p.edgecombe@intel.com,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,hughd@google.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-make-pud_leaf-only-care-about-pse-bit.patch added to mm-unstable branch
Message-Id: <20240813184741.CC6CFC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/x86: make pud_leaf() only care about PSE bit
has been added to the -mm mm-unstable branch.  Its filename is
     mm-x86-make-pud_leaf-only-care-about-pse-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-x86-make-pud_leaf-only-care-about-pse-bit.patch

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
Subject: mm/x86: make pud_leaf() only care about PSE bit
Date: Mon, 12 Aug 2024 14:12:22 -0400

When working on mprotect() on 1G dax entries, I hit an zap bad pud error
when zapping a huge pud that is with PROT_NONE permission.

Here the problem is x86's pud_leaf() requires both PRESENT and PSE bits
set to report a pud entry as a leaf, but that doesn't look right, as it's
not following the pXd_leaf() definition that we stick with so far, where
PROT_NONE entries should be reported as leaves.

To fix it, change x86's pud_leaf() implementation to only check against
PSE bit to report a leaf, irrelevant of whether PRESENT bit is set.

Link: https://lkml.kernel.org/r/20240812181225.1360970-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-x86-make-pud_leaf-only-care-about-pse-bit
+++ a/arch/x86/include/asm/pgtable.h
@@ -1078,8 +1078,7 @@ static inline pmd_t *pud_pgtable(pud_t p
 #define pud_leaf pud_leaf
 static inline bool pud_leaf(pud_t pud)
 {
-	return (pud_val(pud) & (_PAGE_PSE | _PAGE_PRESENT)) ==
-		(_PAGE_PSE | _PAGE_PRESENT);
+	return pud_val(pud) & _PAGE_PSE;
 }
 
 static inline int pud_bad(pud_t pud)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-dax-dump-start-address-in-fault-handler.patch
mm-mprotect-push-mmu-notifier-to-puds.patch
mm-powerpc-add-missing-pud-helpers.patch
mm-x86-make-pud_leaf-only-care-about-pse-bit.patch
mm-x86-implement-arch_check_zapped_pud.patch
mm-x86-add-missing-pud-helpers.patch
mm-mprotect-fix-dax-pud-handlings.patch


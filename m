Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B994149DE4
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 21:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723066018; cv=none; b=IB0j6uXnBUtKFt0+HuceKa7Y1UITfp08EnU5D7+1q8ZtyiJEyKINsjpnTrvgx/23XHG5ef/JALVRes5PRhU8ye054FZuj4bTc4viHWQwMnjgh873jtBwJ01C9kcUl5SvxaGpR964Pu72S96Eesyff9/NsxW1vGQdkKJmJUFYPOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723066018; c=relaxed/simple;
	bh=/FbmIYTSthy2eS0NpkSmHVNZUBwtZ3yRZOVDw0xn/6c=;
	h=Date:To:From:Subject:Message-Id; b=c6bGDq+uKwEJHX8Ilxgjmyh51nL5SaYar+CkJ+OmLOlJqpXvw3wpNjRpFMQcwEl3miztoGSxren1kReFr8MYrvT+07t224E2C7Lm5PbdFZoAwBQ7+19photqeqIVdSKzKxvxjY/zjnwoqDZGv6froVd1LlNMpX2cSsR2sV5Aznk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DKlSr5wU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DKlSr5wU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D69C32781;
	Wed,  7 Aug 2024 21:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723066018;
	bh=/FbmIYTSthy2eS0NpkSmHVNZUBwtZ3yRZOVDw0xn/6c=;
	h=Date:To:From:Subject:From;
	b=DKlSr5wU1ebCWJMbT1pH8N7bWDqQdIf15mLTzlpOhM4JWUL7cjgnFEb+AF21rjwIY
	 2IKxsNS3o6i0IMVOker4Iaa3SutwCk5iCZ/ogeYuroWacMrIStCFfANsKYgZLdr2Hd
	 VryozYvo7Uqku0Snh56ubAL+ZvD9qEGeGrQcgvtM=
Date: Wed, 07 Aug 2024 14:26:57 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,seanjc@google.com,rientjes@google.com,riel@surriel.com,rick.p.edgecombe@intel.com,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mgorman@techsingularity.net,kirill@shutemov.name,jthoughton@google.com,hughd@google.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-make-pud_leaf-only-care-about-pse-bit.patch added to mm-unstable branch
Message-Id: <20240807212657.D5D69C32781@smtp.kernel.org>
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
Date: Wed, 7 Aug 2024 15:48:08 -0400

An entry should be reported as PUD leaf even if it's PROT_NONE, in which
case PRESENT bit isn't there. I hit bad pud without this when testing dax
1G on zapping a PROT_NONE PUD.

Link: https://lkml.kernel.org/r/20240807194812.819412-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
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
mm-x86-arch_check_zapped_pud.patch
mm-x86-add-missing-pud-helpers.patch
mm-mprotect-fix-dax-pud-handlings.patch


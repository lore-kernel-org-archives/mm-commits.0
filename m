Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9019815A8
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 02:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723516068; cv=none; b=X8cQMOtNOKUcHjcniYBSoJqoWWc1tBfqcA/9M+nkQ49PoK+kqDy49flXUkK7YraZg2lShY3vKNIgv/VV0CvV89qXx/W96Od0RoNBbCWYUPY5zSLkKaP1R0/IqKZ68VXQr/oz5kEU65Jqzs4sG3ZaxT6KQoUhyEXv4/OSdxmSelU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723516068; c=relaxed/simple;
	bh=mEXXgh6orI7pa2w6R/Q9pLnHIbrNrMJv2ZV7dtZpsGg=;
	h=Date:To:From:Subject:Message-Id; b=VcRfOSTdvNFkIfx5ql69ZFGQVp9TxjLsKH8YKnN5n/QyXZ+q9+B3zvooIMNhWreeoNitKGjT6PUesSqkAERN5n4mysVgY9/wAK/6K0uVbFdWK60X4M+/9qPc+MCxIyVELMWFrn36JJedrteJdZC4BQmL2yu0J5L4gqluJ5KoL+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SzRIg+r2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SzRIg+r2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA91C4AF0E;
	Tue, 13 Aug 2024 02:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723516068;
	bh=mEXXgh6orI7pa2w6R/Q9pLnHIbrNrMJv2ZV7dtZpsGg=;
	h=Date:To:From:Subject:From;
	b=SzRIg+r2o8t1C2Wwh9DP3gOl0h/ix8Lkax/+DcAC4GBPMgJuMg82lC9NM/9wpWd0/
	 AQDc0zsJLOpcRQQzJBQ2DE1pyKhGRbbCmXL0H4xOPUEw48pQWWL3CRnbqnkz48vyqu
	 YOMx58RBFud1sWOZLVYOsB3XNpjZtQuY/v4sDt4k=
Date: Mon, 12 Aug 2024 19:27:47 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,seanjc@google.com,rientjes@google.com,riel@surriel.com,rick.p.edgecombe@intel.com,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mgorman@techsingularity.net,kirill@shutemov.name,jthoughton@google.com,hughd@google.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-x86-make-pud_leaf-only-care-about-pse-bit.patch removed from -mm tree
Message-Id: <20240813022748.5CA91C4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/x86: make pud_leaf() only care about PSE bit
has been removed from the -mm tree.  Its filename was
     mm-x86-make-pud_leaf-only-care-about-pse-bit.patch

This patch was dropped because an updated version will be issued

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

mm-x86-arch_check_zapped_pud.patch
mm-x86-add-missing-pud-helpers.patch
mm-mprotect-fix-dax-pud-handlings.patch


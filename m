Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38B364A8F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247798; cv=none; b=ARDNP11pM9rPOL4gKQivjIogxKfbyDTNMzjU5qFYiVweA+0iAiJOUIJjBAgomsuwkqGB4oZcrWiAC1+59zvs4usGFkznUZzGqbsxYunPy9DtvH57RqsAPJ0C6EJikhMJymqH8Yv6yNV3KUT8s2bVIdUmpOf7y/XMtkaamecUWJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247798; c=relaxed/simple;
	bh=mpKK4wcK+qvxK8oGYdgHe+MEORqAQHH36UwN6aStm1k=;
	h=Date:To:From:Subject:Message-Id; b=cAh76oFKhG57PYTdZBcx2q9IaPaLAcMIvvUBiFCfsT2TOleegvYPQuL49z7+70o76pha4PNHE6x/yYK/qRCfjHMdqhC+igtLhUwO8S/KOuGkHY8fLfwkB9B6cxRIdhTURP3H73KbTWkPnxlKsWzmYbCd9TJh+VsILPL4ECcqK3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M+UM6loa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M+UM6loa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8917AC4CEC2;
	Mon,  2 Sep 2024 03:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247797;
	bh=mpKK4wcK+qvxK8oGYdgHe+MEORqAQHH36UwN6aStm1k=;
	h=Date:To:From:Subject:From;
	b=M+UM6loa5klUKusCbCzsSig+A9wz8CRAhKp9oAlwbvD16GfBAFvyTm3Tj5L/gVmrF
	 3iC+vmk1u9FS/V+Jz42bj2apms2aAghKfMCFf4bMlnDLNPluJ6a+DAIrzvA/spyMEz
	 aLV0KT38I30sJEZwW5fPNLL5z1Gtpc3WsfrV4+a8=
Date: Sun, 01 Sep 2024 20:29:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,seanjc@google.com,rientjes@google.com,riel@surriel.com,rick.p.edgecombe@intel.com,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,hughd@google.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-x86-make-pud_leaf-only-care-about-pse-bit.patch removed from -mm tree
Message-Id: <20240902032957.8917AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/x86: make pud_leaf() only care about PSE bit
has been removed from the -mm tree.  Its filename was
     mm-x86-make-pud_leaf-only-care-about-pse-bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-introduce-arch_supports_huge_pfnmap-and-special-bits-to-pmd-pud.patch
mm-drop-is_huge_zero_pud.patch
mm-mark-special-bits-for-huge-pfn-mappings-when-inject.patch
mm-allow-thp-orders-for-pfnmaps.patch
mm-gup-detect-huge-pfnmap-entries-in-gup-fast.patch
mm-pagewalk-check-pfnmap-for-folio_walk_start.patch
mm-pagewalk-check-pfnmap-for-folio_walk_start-fix.patch
mm-fork-accept-huge-pfnmap-entries.patch
mm-always-define-pxx_pgprot.patch
mm-new-follow_pfnmap-api.patch
kvm-use-follow_pfnmap-api.patch
s390-pci_mmio-use-follow_pfnmap-api.patch
mm-x86-pat-use-the-new-follow_pfnmap-api.patch
vfio-use-the-new-follow_pfnmap-api.patch
acrn-use-the-new-follow_pfnmap-api.patch
mm-access_process_vm-use-the-new-follow_pfnmap-api.patch
mm-remove-follow_pte.patch
mm-x86-support-large-pfn-mappings.patch
mm-arm64-support-large-pfn-mappings.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ACB14A4C7
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560467; cv=none; b=nx3IMHXbvx4f5DSXpj1ovAcm+soinMBGIZtRRoqIXpjFVomnaOXkyjV6ejJSW0nMSFKKQLPaboCcmWy802NU05GwHLWQN0RxFb28XRWBUGbtkxeO7Tgmj2pqK41wKOcHQsQWZvSzI7uTVy85VY8uSRi0A1d6ETW4A77UuZ4o9NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560467; c=relaxed/simple;
	bh=xqpPE995/KqLP3HYxsfUjOOnMYPaKB2tK6ZAGsqFEkg=;
	h=Date:To:From:Subject:Message-Id; b=q5tzS41p3nKpbI4bv808vKoGRhxbnuZGXpOsQG8uimHFP/R9ZTWQUWBk9cNr/1IYFmvX9YAmbvdyx7+tY0R1VaaaXLqkUpZj6bimCN1TAH6bSD+cMZYlnbI3TMfyrBAsQNhr6LpjDMC70EACIaHt5GA4yD0uN9tqxwfnch0t4fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ke5e3VDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ke5e3VDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD075C4CEC6;
	Tue, 17 Sep 2024 08:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560467;
	bh=xqpPE995/KqLP3HYxsfUjOOnMYPaKB2tK6ZAGsqFEkg=;
	h=Date:To:From:Subject:From;
	b=ke5e3VDsNcuocXYwdGPgbVn9/Chj1y1j6eRDrML3dhRmRIwnviNSLHHr1CneJ+RlD
	 VgVh5D7Bdb+ZVyL2bFHgsZGtuhXmheg1X+t22QDxRyal9E1DRe4y91ZqzINKQViyVI
	 FmhfOPRUUccibl6d/PKcxwvfz+7uCSB7SW5GNcHY=
Date: Tue, 17 Sep 2024 01:07:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-detect-huge-pfnmap-entries-in-gup-fast.patch removed from -mm tree
Message-Id: <20240917080746.CD075C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: detect huge pfnmap entries in gup-fast
has been removed from the -mm tree.  Its filename was
     mm-gup-detect-huge-pfnmap-entries-in-gup-fast.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: detect huge pfnmap entries in gup-fast
Date: Mon, 26 Aug 2024 16:43:39 -0400

Since gup-fast doesn't have the vma reference, teach it to detect such huge
pfnmaps by checking the special bit for pmd/pud too, just like ptes.

Link: https://lkml.kernel.org/r/20240826204353.2228736-6-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/gup.c~mm-gup-detect-huge-pfnmap-entries-in-gup-fast
+++ a/mm/gup.c
@@ -3038,6 +3038,9 @@ static int gup_fast_pmd_leaf(pmd_t orig,
 	if (!pmd_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
 
+	if (pmd_special(orig))
+		return 0;
+
 	if (pmd_devmap(orig)) {
 		if (unlikely(flags & FOLL_LONGTERM))
 			return 0;
@@ -3082,6 +3085,9 @@ static int gup_fast_pud_leaf(pud_t orig,
 	if (!pud_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
 
+	if (pud_special(orig))
+		return 0;
+
 	if (pud_devmap(orig)) {
 		if (unlikely(flags & FOLL_LONGTERM))
 			return 0;
_

Patches currently in -mm which might be from peterx@redhat.com are



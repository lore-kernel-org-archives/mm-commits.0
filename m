Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE73845024
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 20:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716929441; cv=none; b=pAx+aZhkknwLlF/vec8RaTX5M0qg3womD6WF0BPRpo2TlwqZ1k4uuI2TFXJXzBGB4/w2yHpJic31J9lfdyV0QsIYYXfbVY64Jzp8g1yRokGfDvEpmqP8I05GSyWNTRTCPKtqhgX7ertNE7p52aTFGwsg2ed2hkqEg5MxvxIKi4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716929441; c=relaxed/simple;
	bh=yvelUc4ktMRaYFlLivXqpHy/h2iTpK3xuS6Zpssq3qM=;
	h=Date:To:From:Subject:Message-Id; b=LKNjeSGupm/dgFL6QYo1KVGCgIBNe4QPOsa5yeTF0mLgWSOdjr4wGNE7VOYz/i84YeIily+a7g2geoBgoJc4JUHr1EdDLQaSM2Cs0/08LRoCoZVQ7HkrRLnDkjp3vCKkm3G4OA+MIm4pBon7fRNi2x8UZi7JEwnK4DknZ6I2z8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wHa3YlV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wHa3YlV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D405C3277B;
	Tue, 28 May 2024 20:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716929441;
	bh=yvelUc4ktMRaYFlLivXqpHy/h2iTpK3xuS6Zpssq3qM=;
	h=Date:To:From:Subject:From;
	b=wHa3YlV99sEDvFS+nWaILx7DeCBqkRw1JakRjKskpWNUSIqdxsoeuiy3lEU1oNZAf
	 Tn06h1PBwvkTnmHgZSjp+LdN4dSckDZxEH4avulnYEDawZ25bK/BWdI+RXhAfclbgX
	 YoxUl9OM5FqH7ivZllCN3uoui5XVgL9v2SlZLo8Y=
Date: Tue, 28 May 2024 13:50:40 -0700
To: mm-commits@vger.kernel.org,jgg@nvidia.com,david@redhat.com,christophe.leroy@csgroup.eu,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-leftover-comment-references-to-pxx_huge.patch added to mm-unstable branch
Message-Id: <20240528205041.1D405C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: drop leftover comment references to pxx_huge()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-drop-leftover-comment-references-to-pxx_huge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-leftover-comment-references-to-pxx_huge.patch

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
Subject: mm: drop leftover comment references to pxx_huge()
Date: Mon, 27 May 2024 11:48:55 -0400

pxx_huge() has been removed in recent commit 9636f055dae1 ("mm/treewide:
remove pXd_huge()"), however there are still three comments referencing
the API that got overlooked.  Remove them.

Link: https://lkml.kernel.org/r/20240527154855.528816-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/arch_pgtable_helpers.rst |    4 ----
 arch/x86/mm/pat/set_memory.c              |    4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c~mm-drop-leftover-comment-references-to-pxx_huge
+++ a/arch/x86/mm/pat/set_memory.c
@@ -1120,8 +1120,8 @@ __split_large_page(struct cpa_data *cpa,
 		lpinc = PMD_SIZE;
 		/*
 		 * Clear the PSE flags if the PRESENT flag is not set
-		 * otherwise pmd_present/pmd_huge will return true
-		 * even on a non present pmd.
+		 * otherwise pmd_present() will return true even on a non
+		 * present pmd.
 		 */
 		if (!(pgprot_val(ref_prot) & _PAGE_PRESENT))
 			pgprot_val(ref_prot) &= ~_PAGE_PSE;
--- a/Documentation/mm/arch_pgtable_helpers.rst~mm-drop-leftover-comment-references-to-pxx_huge
+++ a/Documentation/mm/arch_pgtable_helpers.rst
@@ -90,8 +90,6 @@ PMD Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pmd_leaf                  | Tests a leaf mapped PMD                          |
 +---------------------------+--------------------------------------------------+
-| pmd_huge                  | Tests a HugeTLB mapped PMD                       |
-+---------------------------+--------------------------------------------------+
 | pmd_trans_huge            | Tests a Transparent Huge Page (THP) at PMD       |
 +---------------------------+--------------------------------------------------+
 | pmd_present               | Tests whether pmd_page() points to valid memory  |
@@ -169,8 +167,6 @@ PUD Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pud_leaf                  | Tests a leaf mapped PUD                          |
 +---------------------------+--------------------------------------------------+
-| pud_huge                  | Tests a HugeTLB mapped PUD                       |
-+---------------------------+--------------------------------------------------+
 | pud_trans_huge            | Tests a Transparent Huge Page (THP) at PUD       |
 +---------------------------+--------------------------------------------------+
 | pud_present               | Tests a valid mapped PUD                         |
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-debug_vm_pgtable-drop-random_orvalue-trick.patch
mm-drop-leftover-comment-references-to-pxx_huge.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489D149635
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291621; cv=none; b=NwX4Kw+5b41kq9DOkza/vfd+uhAamXE8hhXjF1cw6p+z5q+M+x0VkdqtnkSgPEaF/TipfIxH2Ga97Be1LHz5eJt3ZXEoqFDSMYiu/pCydb3tgXA4Llc/gsYyMqvYzIIZIk3Of4z9TmMTnKl1s4s7HyF4ixibcR3j3XAoCdV1dNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291621; c=relaxed/simple;
	bh=orRcHFqmoPb5wxmA3cK4+tu8Uy/ypXfWRSriE4BP81M=;
	h=Date:To:From:Subject:Message-Id; b=kAD1owXP7CDxYE3vwNUWA7pYvOc81y7w8HYMRKf3+wdhteoMDQC5ivhJmCDT+iQEavsZTBjw503L6Q++oh7NDv9UFW5qEMZ97Rbjav0CB03jf5ePZBCL0UQmVaKm1AZa7X/1PKL7sS7WxWPtiCF8oeVzf++gDPZr0vcHN3HyTXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ainf3gTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ainf3gTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E17DC32782;
	Tue, 25 Jun 2024 05:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291621;
	bh=orRcHFqmoPb5wxmA3cK4+tu8Uy/ypXfWRSriE4BP81M=;
	h=Date:To:From:Subject:From;
	b=Ainf3gTo7hLpNdjK8cL1z4yLljW7mybevUCy/H7f+bcJsN8xmPBXocL2E8wpZu6j8
	 tWGlO4GxtHnXjH2s/wy9P9Y95gn+7Xu1rfo2SNRae90pXaZ7fr3/zhMdqJuUtXy4KC
	 ohAKVOMHcAX8mec4ZUR5yyhp9KwFV/7PZnLf+ll4=
Date: Mon, 24 Jun 2024 22:00:20 -0700
To: mm-commits@vger.kernel.org,jgg@nvidia.com,david@redhat.com,christophe.leroy@csgroup.eu,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-drop-leftover-comment-references-to-pxx_huge.patch removed from -mm tree
Message-Id: <20240625050021.1E17DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: drop leftover comment references to pxx_huge()
has been removed from the -mm tree.  Its filename was
     mm-drop-leftover-comment-references-to-pxx_huge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



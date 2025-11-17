Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7131AF0BB
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343078; cv=none; b=ECaFYsS5Pbe2uXCl9QBf9M2DWKj25Eh2612uw7lWggG5aCUq1+TNDB5kAk/hMwMnTq8VBu2IETd+MPjlz0HowqsIaqlGZui+rXlCGqUi06AZ9G1oIzECmlYTMCZJs7Di5E4zIqgRw5pSikrYLn5fCVN5Mfscbe2H+090XzPKjGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343078; c=relaxed/simple;
	bh=Y9VDwQMIhwY5pB8AuslZ4ROy+wY75ph0zUu5hpEnOdg=;
	h=Date:To:From:Subject:Message-Id; b=L+IKF3HjoHE3TW7iyEti7BSSIN6cfHR5JCO9AzQakmmeB4ucZ7XahGVNTO2ptySXwBRhwkVSeTX44iN8pqaX8lDyM8pm7gfNrVlWg5/Omblrg0r5JaiIakvVNwtwmntln30+t4oxQODXTYmcMk5jhW7GTkHtid5U7qmVZZ0cXDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dQMfbaSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dQMfbaSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AA0C19421;
	Mon, 17 Nov 2025 01:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343077;
	bh=Y9VDwQMIhwY5pB8AuslZ4ROy+wY75ph0zUu5hpEnOdg=;
	h=Date:To:From:Subject:From;
	b=dQMfbaSy19lpVEDNKOtvsaJnSzerSQJNmKMOFVosV2iwMtWqln0K1ek/Xn33UAth5
	 kReuAAROkUY2T+o3TNvCG1htXtxIvP9rIHKNxGfF/JwCwz4sOwcu1N+psjYTKQ0QE4
	 0B3ojsLtB1ROL1CNtVtUAA9StcRzMyf8fUFptOhc=
Date: Sun, 16 Nov 2025 17:31:17 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ptdump-replace-read_once-with-standard-page-table-accessors.patch removed from -mm tree
Message-Id: <20251117013117.A5AA0C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ptdump: replace READ_ONCE() with standard page table accessors
has been removed from the -mm tree.  Its filename was
     mm-ptdump-replace-read_once-with-standard-page-table-accessors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/ptdump: replace READ_ONCE() with standard page table accessors
Date: Wed, 1 Oct 2025 05:25:02 +0100

Replace READ_ONCE() with standard page table accessors i.e pxdp_get()
which anyways default into READ_ONCE() in cases where platform does not
override.  Also convert ptep_get_lockless() into ptep_get() as well.

Link: https://lkml.kernel.org/r/20251001042502.1400726-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ptdump.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/ptdump.c~mm-ptdump-replace-read_once-with-standard-page-table-accessors
+++ a/mm/ptdump.c
@@ -31,7 +31,7 @@ static int ptdump_pgd_entry(pgd_t *pgd,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pgd_t val = READ_ONCE(*pgd);
+	pgd_t val = pgdp_get(pgd);
 
 #if CONFIG_PGTABLE_LEVELS > 4 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -54,7 +54,7 @@ static int ptdump_p4d_entry(p4d_t *p4d,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	p4d_t val = READ_ONCE(*p4d);
+	p4d_t val = p4dp_get(p4d);
 
 #if CONFIG_PGTABLE_LEVELS > 3 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -77,7 +77,7 @@ static int ptdump_pud_entry(pud_t *pud,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pud_t val = READ_ONCE(*pud);
+	pud_t val = pudp_get(pud);
 
 #if CONFIG_PGTABLE_LEVELS > 2 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -100,7 +100,7 @@ static int ptdump_pmd_entry(pmd_t *pmd,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pmd_t val = READ_ONCE(*pmd);
+	pmd_t val = pmdp_get(pmd);
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 	if (pmd_page(val) == virt_to_page(lm_alias(kasan_early_shadow_pte)))
@@ -121,7 +121,7 @@ static int ptdump_pte_entry(pte_t *pte,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pte_t val = ptep_get_lockless(pte);
+	pte_t val = ptep_get(pte);
 
 	if (st->effective_prot_pte)
 		st->effective_prot_pte(st, val);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are



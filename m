Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA2BC148
	for <mm-commits@vger.kernel.org>; Wed,  1 Oct 2025 20:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352199; cv=none; b=DEfTHn36a8EBp5L7S9xlzn5eyTaTQVUordZF5tLCqNMDToZEa1EOO7pb4Q0nvPnp5NbHYXlTHfBxvIwxM8P5JkK3J8STP9vSrllr73FNCEcIIeqTovHkAzsw1oqBKUT0LtGPpjByDzbhy9EBLhjlqSRPv4IFdbPJFBL+qcqUeMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352199; c=relaxed/simple;
	bh=yyllv02kci1xgI3bAT8VYL6z8Vs9/s7dJBNBUy4WQ6A=;
	h=Date:To:From:Subject:Message-Id; b=oD2L7aAsXdO6wvXowpWRUQaEplwhQUYkFpe4Hntay8kvKWTjFn/EQyFNT0ewkHFFXMs2hQ0w0qx+AW7iQ1QxLrBuV2TniBxpgpzbKTButz/TfKSofL/QpK6AN0E0r+Aj9TVTfs6od6bEmZJt6fgS0Q5P4tmyzj1K0IwXXuuJiS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AyRyS/AJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AyRyS/AJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663AFC4CEF1;
	Wed,  1 Oct 2025 20:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759352199;
	bh=yyllv02kci1xgI3bAT8VYL6z8Vs9/s7dJBNBUy4WQ6A=;
	h=Date:To:From:Subject:From;
	b=AyRyS/AJ2+M+FPRk+Gu/FsN7M/0ckMV+aLfPwRbE4aUDJSXjRhlzDbkeWwEIukph/
	 D0Ub/RFpIOvVKvJAW7eWNGEw7Du/YO+bplY0db7DeIYqDy3E7sfbIlbnVzUelK7J3n
	 l9eFER5FpFIB7OsSCRjvNxQAOs1F9tnHpJL37JoE=
Date: Wed, 01 Oct 2025 13:56:38 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ptdump-replace-read_once-with-standard-page-table-accessors.patch added to mm-new branch
Message-Id: <20251001205639.663AFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ptdump: replace READ_ONCE() with standard page table accessors
has been added to the -mm mm-new branch.  Its filename is
     mm-ptdump-replace-read_once-with-standard-page-table-accessors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ptdump-replace-read_once-with-standard-page-table-accessors.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

documentation-mm-drop-pxx_mkdevmap-descriptions-from-page-table-helpers.patch
mm-thp-drop-follow_devmap_pmd-default-stub.patch
mm-ptdump-replace-read_once-with-standard-page-table-accessors.patch


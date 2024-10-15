Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308841CACDB
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 22:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729031400; cv=none; b=aDTE0aI8CERt9T0gTzGHnqxpVLsrKcl8x1WlpFT/BsO9Fpn9mJG08JRa96jB2lYfWYg1f90KSKXTIxLdt4/z7p8WNN31vtZ/g2TZSd/LbpX95X4VR5IrfX2Du2Bh43q3olylFI3GZgqxqlCA5kNk/V8uFC2Bi9IovZJrwCgWF3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729031400; c=relaxed/simple;
	bh=8g246/LtFT9bmRVsAnE53e4Ev9G5laTR3RePuS3iLV0=;
	h=Date:To:From:Subject:Message-Id; b=ZD2SD5uknbqQcLIV446dqe3BJt97CHIoExbZl0R2jdf1Od7luGgQm9Kg6q2CbUDov8k+zacPvijH3L3BzWJVyZfgylD0w6PaX1PMo5N/rKO6biW3EY+Pl7wcup2guaV5Fer0xxAe/BeKK63TV8RNLK069DydxEhM4OPSuQQOjnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rdrjCuzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rdrjCuzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47DDC4CEC6;
	Tue, 15 Oct 2024 22:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729031398;
	bh=8g246/LtFT9bmRVsAnE53e4Ev9G5laTR3RePuS3iLV0=;
	h=Date:To:From:Subject:From;
	b=rdrjCuzwFCV25i28LigGGT3nG29nCAOxt4JwudpFzOOiHnQYV/uS3g2kUnTOybeRJ
	 633ROFAuXGC21rLdCn+1/D2ufwIWVEnkPc/akAUYExbfePTkJHx82cFHFYY1DO46qK
	 YOJ/ku1b4pYDuWm/TnJ4MYH7jGUoQC6SMRLmm7Zo=
Date: Tue, 15 Oct 2024 15:29:58 -0700
To: mm-commits@vger.kernel.org,jannh@google.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-fix-usage-of-pmd_leaf-pud_leaf-without-present-check.patch added to mm-hotfixes-unstable branch
Message-Id: <20241015222958.A47DDC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/pagewalk: fix usage of pmd_leaf()/pud_leaf() without present check
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-pagewalk-fix-usage-of-pmd_leaf-pud_leaf-without-present-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-fix-usage-of-pmd_leaf-pud_leaf-without-present-check.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: mm/pagewalk: fix usage of pmd_leaf()/pud_leaf() without present check
Date: Tue, 15 Oct 2024 13:12:36 +0200

pmd_leaf()/pud_leaf() only implies a pmd_present()/pud_present() check on
some architectures.  We really should check for
pmd_present()/pud_present() first.

This should explain the report we got on ppc64 (which has
CONFIG_PGTABLE_HAS_HUGE_LEAVES set in the config) that triggered:
	VM_WARN_ON_ONCE(pmd_leaf(pmdp_get_lockless(pmdp)));

Likely we had a PMD migration entry for which pmd_leaf() did not trigger. 
We raced with restoring the PMD migration entry, and suddenly saw a
pmd_leaf().  In this case, pte_offset_map_lock() saved us from more
trouble, because it rechecks the PMD value, but we would not have
processed the migration entry -- which is not too bad because the only
user of FW_MIGRATION is KSM for unsharing, and KSM only applies to small
folios.

Further, we shouldn't re-read the PMD/PUD value for our warning, the
primary purpose of the VM_WARN_ON_ONCE() is to find spurious use of
pmd_leaf()/pud_leaf() without CONFIG_PGTABLE_HAS_HUGE_LEAVES.

As a side note, we are currently not implementing FW_MIGRATION support for
PUD migration entries, which likely should exist due to hugetlb.  Add a
TODO so this won't fall through the cracks if more FW_MIGRATION users get
added.

Link: https://lkml.kernel.org/r/20241015111236.1290921-1-david@redhat.com
Fixes: aa39ca6940f1 ("mm/pagewalk: introduce folio_walk_start() + folio_walk_end()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+7d917f67c05066cec295@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/670d3248.050a0220.3e960.0064.GAE@google.com
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/pagewalk.c~mm-pagewalk-fix-usage-of-pmd_leaf-pud_leaf-without-present-check
+++ a/mm/pagewalk.c
@@ -744,7 +744,8 @@ struct folio *folio_walk_start(struct fo
 	pud = pudp_get(pudp);
 	if (pud_none(pud))
 		goto not_found;
-	if (IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) && pud_leaf(pud)) {
+	if (IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) &&
+	    (!pud_present(pud) || pud_leaf(pud))) {
 		ptl = pud_lock(vma->vm_mm, pudp);
 		pud = pudp_get(pudp);
 
@@ -753,6 +754,10 @@ struct folio *folio_walk_start(struct fo
 		fw->pudp = pudp;
 		fw->pud = pud;
 
+		/*
+		 * TODO: FW_MIGRATION support for PUD migration entries
+		 * once there are relevant users.
+		 */
 		if (!pud_present(pud) || pud_devmap(pud) || pud_special(pud)) {
 			spin_unlock(ptl);
 			goto not_found;
@@ -769,12 +774,13 @@ struct folio *folio_walk_start(struct fo
 	}
 
 pmd_table:
-	VM_WARN_ON_ONCE(pud_leaf(*pudp));
+	VM_WARN_ON_ONCE(!pud_present(pud) || pud_leaf(pud));
 	pmdp = pmd_offset(pudp, addr);
 	pmd = pmdp_get_lockless(pmdp);
 	if (pmd_none(pmd))
 		goto not_found;
-	if (IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) && pmd_leaf(pmd)) {
+	if (IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) &&
+	    (!pmd_present(pmd) || pmd_leaf(pmd))) {
 		ptl = pmd_lock(vma->vm_mm, pmdp);
 		pmd = pmdp_get(pmdp);
 
@@ -786,7 +792,7 @@ pmd_table:
 		if (pmd_none(pmd)) {
 			spin_unlock(ptl);
 			goto not_found;
-		} else if (!pmd_leaf(pmd)) {
+		} else if (pmd_present(pmd) && !pmd_leaf(pmd)) {
 			spin_unlock(ptl);
 			goto pte_table;
 		} else if (pmd_present(pmd)) {
@@ -812,7 +818,7 @@ pmd_table:
 	}
 
 pte_table:
-	VM_WARN_ON_ONCE(pmd_leaf(pmdp_get_lockless(pmdp)));
+	VM_WARN_ON_ONCE(!pmd_present(pmd) || pmd_leaf(pmd));
 	ptep = pte_offset_map_lock(vma->vm_mm, pmdp, addr, &ptl);
 	if (!ptep)
 		goto not_found;
_

Patches currently in -mm which might be from david@redhat.com are

mm-dont-install-pmd-mappings-when-thps-are-disabled-by-the-hw-process-vma.patch
mm-pagewalk-fix-usage-of-pmd_leaf-pud_leaf-without-present-check.patch
selftests-mm-hugetlb_fault_after_madv-use-default-hguetlb-page-size.patch
selftests-mm-hugetlb_fault_after_madv-improve-test-output.patch


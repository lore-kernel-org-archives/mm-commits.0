Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AD516D9DA;
	Fri,  5 Jul 2024 20:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720210602; cv=none; b=HUny037ORabHeLqpEN8Wt+xvbaJS8qOAUN4plbVqmKH0SDdPAcNiTNpUq8MC6wSPhBqi4kvAoFIyi3w3xoyIvmSqEmTWNLWWse+KzRLynUsjZcLylBwXri6O/jSPt3BMBOrJBRm5VIzt6PYyq+je0UKboePeACaDynWPEnzASdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720210602; c=relaxed/simple;
	bh=vxU5bg73SsUV18VpdboyVZYvGd/c7bv6DQyD6cML8Ek=;
	h=Date:To:From:Subject:Message-Id; b=FDQf6q444EICf1IDxwKXTMWbeJIQvlofBohqnz8cuY9M3TKHQEly8Vmp6J+lU1S4n2Gdzr6m8kzjmGWWCbvfjbuMImhycd4hLOlShqbPkYBk+p/S3IA6q9u7jhcIRo9qIQN+JzM0JWdWoJykka9bN0vGExrUMmR1Xtilyb675HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XszsHP4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XszsHP4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBDCC4AF0D;
	Fri,  5 Jul 2024 20:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720210602;
	bh=vxU5bg73SsUV18VpdboyVZYvGd/c7bv6DQyD6cML8Ek=;
	h=Date:To:From:Subject:From;
	b=XszsHP4nZnJmSS3QRRZ9bxlqcC9UakJ1UVXmqTmISDBn/AgaYcCjbHMCoA9PukFdt
	 aIew2rd1MZNMv77ijWg6uAqIKqUjBLEVh5V/tJlOHW/sQNNoqMD3E/Z5SQ8S0xh5ad
	 qeGTE01gFWXzS+v+AnLR5B6S3bSNoJA7CsILTtEo=
Date: Fri, 05 Jul 2024 13:16:41 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shy828301@gmail.com,ioworker0@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-khugepaged-activation-policy-v3.patch added to mm-unstable branch
Message-Id: <20240705201641.DBBDCC4AF0D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-fix-khugepaged-activation-policy-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-khugepaged-activation-policy-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-khugepaged-activation-policy-v3.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm-fix-khugepaged-activation-policy-v3
Date: Fri, 5 Jul 2024 11:28:48 +0100

- Make hugepage_pmd_enabled() out-of-line static in khugepaged.c (per Andrew)
- Refactor hugepage_pmd_enabled() for better readability (per Andrew)

Link: https://lkml.kernel.org/r/20240705102849.2479686-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
Closes: https://lore.kernel.org/linux-mm/7a0bbe69-1e3d-4263-b206-da007791a5c4@redhat.com/
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   13 -------------
 mm/khugepaged.c         |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 13 deletions(-)

--- a/include/linux/huge_mm.h~mm-fix-khugepaged-activation-policy-v3
+++ a/include/linux/huge_mm.h
@@ -128,19 +128,6 @@ static inline bool hugepage_global_alway
 			(1<<TRANSPARENT_HUGEPAGE_FLAG);
 }
 
-static inline bool hugepage_pmd_enabled(void)
-{
-	/*
-	 * We cover both the anon and the file-backed case here; file-backed
-	 * hugepages, when configured in, are determined by the global control.
-	 * Anon pmd-sized hugepages are determined by the pmd-size control.
-	 */
-	return (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && hugepage_global_enabled()) ||
-	       test_bit(PMD_ORDER, &huge_anon_orders_always) ||
-	       test_bit(PMD_ORDER, &huge_anon_orders_madvise) ||
-	       (test_bit(PMD_ORDER, &huge_anon_orders_inherit) && hugepage_global_enabled());
-}
-
 static inline int highest_order(unsigned long orders)
 {
 	return fls_long(orders) - 1;
--- a/mm/khugepaged.c~mm-fix-khugepaged-activation-policy-v3
+++ a/mm/khugepaged.c
@@ -413,6 +413,26 @@ static inline int hpage_collapse_test_ex
 	       test_bit(MMF_DISABLE_THP, &mm->flags);
 }
 
+static bool hugepage_pmd_enabled(void)
+{
+	/*
+	 * We cover both the anon and the file-backed case here; file-backed
+	 * hugepages, when configured in, are determined by the global control.
+	 * Anon pmd-sized hugepages are determined by the pmd-size control.
+	 */
+	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
+	    hugepage_global_enabled())
+		return true;
+	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
+		return true;
+	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
+		return true;
+	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
+	    hugepage_global_enabled())
+		return true;
+	return false;
+}
+
 void __khugepaged_enter(struct mm_struct *mm)
 {
 	struct khugepaged_mm_slot *mm_slot;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-fix-khugepaged-activation-policy.patch
mm-fix-khugepaged-activation-policy-v3.patch


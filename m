Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE671A7048
	for <mm-commits@vger.kernel.org>; Tue, 10 Sep 2024 18:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725993967; cv=none; b=U4njE4nN3WVJBYD7CMJeu62QYUT00sl1JUEEJqysq3+pJte5mHAAv0c2SH8wRREVaSd05anBRPPI4CP9uunZTL1LRD8/bVDprEku0dcomMK8R0iM6PME/ntEh+sRCwoiYs2XXG9BhMyyqAm7YbnqqE0+jXYUE1Dkz/UpqyWHsB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725993967; c=relaxed/simple;
	bh=X/ol8fWygI7vn9b0a1H5Ve5KzVwHN+G2tEVPwHQRPWM=;
	h=Date:To:From:Subject:Message-Id; b=QvIklwRrlTj+CS+EEYZXvH/yzhpHXMmpRA+IEALW0F/rSb+zAh8jhDBjhSZDnJi/g4sSSZqelaqvglvMqMgrk8h04qmIkj3Nh/IGk5YAS+eIoEu5ZscHWMREkscCDSqSjqXs9YLIfkCynRV3Lh6S1fovec1fV8dqKT25T1n7iM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vZ7G7Op2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vZ7G7Op2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2116C4CEC4;
	Tue, 10 Sep 2024 18:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725993966;
	bh=X/ol8fWygI7vn9b0a1H5Ve5KzVwHN+G2tEVPwHQRPWM=;
	h=Date:To:From:Subject:From;
	b=vZ7G7Op24TNCfmLluASmhkcMjAtVxQJIiNWBDJzp1fXwre46JyqY6OVDKmUxewcfX
	 81UQnf/DOBb+USSi0jXKqP0fUIeJwr3E/kAtJL7pUtEcMZehv6FDFwSNr99O3EjrjK
	 e4EMEiVOw3rEqRUFuoOTS13QTxHnO1zZ4l/bHENs=
Date: Tue, 10 Sep 2024 11:46:06 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,david@redhat.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-unused-set_pte_safe.patch added to mm-unstable branch
Message-Id: <20240910184606.C2116C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: drop unused set_pte_safe()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-drop-unused-set_pte_safe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-unused-set_pte_safe.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: drop unused set_pte_safe()
Date: Tue, 10 Sep 2024 15:40:26 +0530

All set_pte_safe() usage have been dropped after the commit eccd906484d1
("x86/mm: Do not use set_{pud, pmd}_safe() when splitting a large page")
This just drops now unused helper set_pte_safe().

Besides this macro was buggy due to doing direct dereferencing of the pte,
and if it were to be kept, it should have been updated to use a single
call to ptep_get().

Link: https://lkml.kernel.org/r/20240910101026.428808-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/pgtable.h~mm-drop-unused-set_pte_safe
+++ a/include/linux/pgtable.h
@@ -1064,12 +1064,6 @@ static inline int pgd_same(pgd_t pgd_a,
  * same value. Otherwise, use the typical "set" helpers and flush the
  * TLB.
  */
-#define set_pte_safe(ptep, pte) \
-({ \
-	WARN_ON_ONCE(pte_present(*ptep) && !pte_same(*ptep, pte)); \
-	set_pte(ptep, pte); \
-})
-
 #define set_pmd_safe(pmdp, pmd) \
 ({ \
 	WARN_ON_ONCE(pmd_present(*pmdp) && !pmd_same(*pmdp, pmd)); \
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-use-pxdp_get-for-accessing-page-table-entries.patch
mm-drop-unused-set_pte_safe.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7043620CCFB
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 23:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746747171; cv=none; b=jgOF6F/ZWWHMlehpeQbOZc5WxR8Leiet1DXtY6qaBxQ0W2fUCZgwodPd/UHnxG2xscARpczU2SFP4B/dXAJUn+vttIhAmhJOdI/tYNyil6gtGyWhvNj3qojJNrcC8iN8u104dRxeS/L7t/yhw8DM7S3GJLaUvq4LcDsdCHkC1EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746747171; c=relaxed/simple;
	bh=zl8+zdAPtRHO+7j45vtM/KvGa1ePsAk+oJx0lRhFkEM=;
	h=Date:To:From:Subject:Message-Id; b=ESxrPReeQmtnrU8BC9f2S1E0IicJuSSpEWVAR0TzCXdU82X7ibQsWvd2FdDKuc9241o9QeG73trT6WCOa4mKxOY8YFEFGqpeEPhRb7OSN5vwEalYeZ/cHPmLNM/88k21gfZzcYm8hyEyyI3t2S+0aRzzIzxd+rpXRPdNfauko9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kSbhGSvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kSbhGSvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2661C4CEE7;
	Thu,  8 May 2025 23:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746747170;
	bh=zl8+zdAPtRHO+7j45vtM/KvGa1ePsAk+oJx0lRhFkEM=;
	h=Date:To:From:Subject:From;
	b=kSbhGSvp2o4wlMyoECtmf1hUd9tfFbB1fa2bs9amtvQBvy0SJci2Bl+DA3K0AeFAp
	 Hiv/HTn+/Av3Qcq3tTODE1rr37yRrRUjK1CUXzUJqcidpqiAoA+dq+Pn3Kv0flAsX0
	 DcuOJQgl3tcdkR6GBQuha5Aqr3jfFZ3ZbejiGVAw=
Date: Thu, 08 May 2025 16:32:50 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,willy@infradead.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,Ignacio.MorenoGonzalez@kuka.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-make-madv_nohugepage-a-no-op-if-thp.patch added to mm-new branch
Message-Id: <20250508233250.B2661C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-make-madv_nohugepage-a-no-op-if-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-make-madv_nohugepage-a-no-op-if-thp.patch

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
From: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Subject: mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
Date: Thu, 08 May 2025 12:20:27 +0200

VM_NOHUGEPAGE is a no-op if CONFIG_TRANSPARENT_HUGEPAGE is disabled.  So
it makes no sense to return an error when calling madvise() with
MADV_NOHUGEPAGE in that case.

Link: https://lkml.kernel.org/r/20250508-madvise-nohugepage-noop-without-thp-v1-1-e7ceffb197f3@kuka.com
Signed-off-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/huge_mm.h~mm-madvise-make-madv_nohugepage-a-no-op-if-thp
+++ a/include/linux/huge_mm.h
@@ -506,6 +506,8 @@ bool unmap_huge_pmd_locked(struct vm_are
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#include <uapi/asm/mman.h>
+
 static inline bool folio_test_pmd_mappable(struct folio *folio)
 {
 	return false;
@@ -595,6 +597,9 @@ static inline bool unmap_huge_pmd_locked
 static inline int hugepage_madvise(struct vm_area_struct *vma,
 				   unsigned long *vm_flags, int advice)
 {
+	/* On a !THP kernel, MADV_NOHUGEPAGE is a no-op, but MADV_NOHUGEPAGE is not supported */
+	if (advice == MADV_NOHUGEPAGE)
+		return 0;
 	return -EINVAL;
 }
 
_

Patches currently in -mm which might be from Ignacio.MorenoGonzalez@kuka.com are

mm-mmap-map-map_stack-to-vm_nohugepage-only-if-thp-is-enabled.patch
mm-madvise-make-madv_nohugepage-a-no-op-if-thp.patch


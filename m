Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2F1450FE
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 23:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771630247; cv=none; b=mcoc/FJiZ31T5AC1CYaPHs011/HYI+sikqae6FiSue6wBVW72IdEroQRUt2Sp4kH95x0oYirOjVXocSl9SU+XAMV6pZksrIeN6xzu+vD2iigsiUwe4VfNWEVtNd4KoyanGevfX5PpEruWGKSn7HV3kNv/fBpZ6oPk1n1HW/NBaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771630247; c=relaxed/simple;
	bh=dVHRAdsJevHH8jXElzU1PMV1wBucW7stys7dHrn86sM=;
	h=Date:To:From:Subject:Message-Id; b=OX9OGcpEfUmuacZgTL56tDW4H7bkBOk3ijmxUlN/y5tTlP2mpu8YGz/J+RoxQ5zjd89kECnN3QcN+Ru2IFutF8TrK7H13OSHoNeudVThNWZR0P3kIEmgHwVDIWotSCe5a3O7g3DJ+RAfk47ffF75iCNXFEzTGejZgxEyHYLJQXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2L9OX13+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2L9OX13+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DE4C116C6;
	Fri, 20 Feb 2026 23:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771630246;
	bh=dVHRAdsJevHH8jXElzU1PMV1wBucW7stys7dHrn86sM=;
	h=Date:To:From:Subject:From;
	b=2L9OX13+UZuQafNVqlZExmk637VmV+6GlmDKjpCWo3BxDbHZM9pW+AtBywIi5EB/0
	 U5PcZwu/J7vRi7KICJsQd2QVHAUL9Ssr8XuvixicDh3ZWY+wlNs1UqyAwVPCa0zRC0
	 OjulsUNO7uKOzywEP01NQkVRq9Lqs68uKbaxrCHA=
Date: Fri, 20 Feb 2026 15:30:46 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,david@kernel.org,baolin.wang@linux.alibaba.com,qin.yuA@h3c.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_idlec-remove-redundant-mmu-notifier-in-aging-code.patch added to mm-new branch
Message-Id: <20260220233046.A1DE4C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_idle.c: remove redundant mmu notifier in aging code
has been added to the -mm mm-new branch.  Its filename is
     mm-page_idlec-remove-redundant-mmu-notifier-in-aging-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_idlec-remove-redundant-mmu-notifier-in-aging-code.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: qinyu <qin.yuA@h3c.com>
Subject: mm/page_idle.c: remove redundant mmu notifier in aging code
Date: Tue, 3 Feb 2026 18:26:49 +0800

Now we have mmu_notifier_clear_young immediately follows
pmdp_clear_young_notify which internally calls mmu_notifier_clear_young,
this is redundant.  change it with non-notify variant and keep consistent
with ptep aging code.

Link: https://lkml.kernel.org/r/20260203102649.2486836-1-qin.yuA@h3c.com
Signed-off-by: qinyu <qin.yuA@h3c.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_idle.c~mm-page_idlec-remove-redundant-mmu-notifier-in-aging-code
+++ a/mm/page_idle.c
@@ -74,7 +74,7 @@ static bool page_idle_clear_pte_refs_one
 			pmd_t pmdval = pmdp_get(pvmw.pmd);
 
 			if (likely(pmd_present(pmdval)))
-				referenced |= pmdp_clear_young_notify(vma, addr, pvmw.pmd);
+				referenced |= pmdp_test_and_clear_young(vma, addr, pvmw.pmd);
 			referenced |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PMD_SIZE);
 		} else {
 			/* unexpected pmd-mapped page? */
_

Patches currently in -mm which might be from qin.yuA@h3c.com are

mm-damon-remove-redudnant-mmu-notifier-call-in-pmdp-mkold.patch
mm-page_idlec-remove-redundant-mmu-notifier-in-aging-code.patch


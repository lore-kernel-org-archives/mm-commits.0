Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317DE17BCC
	for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2024 20:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712866679; cv=none; b=X1DaW/dqGnqEwgd0zKHZPG/GSJ8G+uIS3aK/sSfEu1nHEm6YxyqIs1cVEO7gyZD/bf309zX0qCdgs+ystIZhwF7yB/OgA88g5rZR1vG8BRJKEQ6QHAhnBZ+FT4vkeXYwyS3Qp6AcC/Oq2X3vBUdHPQWAoc8L20RxBmKf9gBVQZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712866679; c=relaxed/simple;
	bh=JxZXPTuMpajKYs/ASuBf6OXx0Kx0KdAuy+HaCK7h8Cg=;
	h=Date:To:From:Subject:Message-Id; b=p6gzTRj9TR9YR3GAnk631kade1N7W2vRjaXqKsZlQNegpzIvWihsjl37cGIJX8NC+BYKg+VGBJZ815wbQu0edO5CGsB3L+iwAKLYbO+xzw8AxVKV0M+Q4OBcFH7MGf0ll6Ar5AQFdgCYA75k+fTRsu7nswD1KNJPtb4c/yFuhL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ur7+AMIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ur7+AMIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6ECC072AA;
	Thu, 11 Apr 2024 20:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712866678;
	bh=JxZXPTuMpajKYs/ASuBf6OXx0Kx0KdAuy+HaCK7h8Cg=;
	h=Date:To:From:Subject:From;
	b=ur7+AMIHkluLQ461EVlFqCGjzoVC9B80H5lM6x0qX5fDlNpm4OuRLuEwKMJztf996
	 qdeVwCNrq9M7tgLKxHID5Ix5kgo5bwZAlII15+93G8MjI55FFhlRWX5dm8LTi0YuBu
	 cpYIjsLGUtvuglcmYXbgL3PKwmljSxpfRbYFl8Ww=
Date: Thu, 11 Apr 2024 13:17:58 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20240411201758.AC6ECC072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes
Date: Thu Apr 11 01:17:26 PM PDT 2024

ERROR: code indent should use tabs where possible
#86: FILE: arch/arm/mm/fault.c:368:
+        code = SEGV_MAPERR;$

WARNING: please, no spaces at the start of a line
#86: FILE: arch/arm/mm/fault.c:368:
+        code = SEGV_MAPERR;$

total: 1 errors, 1 warnings, 68 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/fault.c~arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes
+++ a/arch/arm/mm/fault.c
@@ -365,7 +365,7 @@ done:
 	if (likely(!(fault & VM_FAULT_ERROR)))
 		return 0;
 
-        code = SEGV_MAPERR;
+	code = SEGV_MAPERR;
 bad_area:
 	/*
 	 * If we are in kernel mode at this point, we
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DA82904
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956116; cv=none; b=jvsF0ylLybrLCcFgoASmP0uTOhtH1rFxYikJJYxo6hmQ7wKfX+yDFmXH2sMQLIMkPQNQ6bCJuRCAit3/QSRAtEDIkhOYxsWRqPuI89TIbBRJ1l+HWh8Zqh7K3p30FyjUkltKkUCJwMlA7tPQ5ZT5/KHw5hRJfzmorI6DrMFco8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956116; c=relaxed/simple;
	bh=28LzEeJAn7+uhxRvUvKMAXr16C523J+o7HgzvVpCl3Q=;
	h=Date:To:From:Subject:Message-Id; b=k3XfoYQfbECq6oFXd9YNGFwh8QGALm3rx74a9Gid7RYFKPv4tXSiENok+Nqe57Ibvr6wVFj5k1oR9wYZ0xXPb9iaFqdMWor+aWhpcLjeDbcHNFlnD8ZS35IA9KXzPsvjwRIFU3Kkh/yMGF48KyX5vdhd/PXCKD9/4z3e/mLnXBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T9PJCKJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T9PJCKJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAEFC113CC;
	Mon,  6 May 2024 00:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956116;
	bh=28LzEeJAn7+uhxRvUvKMAXr16C523J+o7HgzvVpCl3Q=;
	h=Date:To:From:Subject:From;
	b=T9PJCKJGGBomTkcSzlqL+qmuU+MwymCi0POskG/EevTM8asj/f1B+BNdH0AXiw5JB
	 RzRnx+Tjo0ZpJMf52IBHTZIF4gPdm7B9BD1Jd+cz6d7rcJlO1+zER5I2vQEwFMz42b
	 jkof6ZX2mStb4EwmxD/rNWBVMGV5tUBi793B1kBU=
Date: Sun, 05 May 2024 17:41:55 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20240506004156.5FAEFC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch

This patch was dropped because it was folded into arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch

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

arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
doc-split-bufferrst-out-of-api-summaryrst-fix-fix.patch
mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix.patch
kernel-watchdog_perfc-tidy-up-kerneldoc.patch


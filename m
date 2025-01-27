Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3059753BE;
	Mon, 27 Jan 2025 20:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738008767; cv=none; b=bk+P+9t0luMKxbEImMuxOV0ZAeMHGaDs7HYXiQ/mgTq0WOoRHBiNUjMEKXMtW8u+aKPjSo+n12cu5h3e1V7plTwD2TnRq/7ks0mYcGO9GVtOBz6zf6kcpIit2MYL5nwE3cJe3svYvaSv6bOEBScZQkrBYPGQzYoCjL0lcDZMBh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738008767; c=relaxed/simple;
	bh=ANGdde/Hv2M0TtIwyNt5kIfxVRZHhl3haC8txVOb4Gs=;
	h=Date:To:From:Subject:Message-Id; b=uW7oEm7XYwZWpIWCXjQcMFEPQZQlEZ2dUAuDJZrB0vOMtW1zqay6gvogYWrwSeyrv+RllyCPV7Lm1x4+UltM8rzlgTeG+lJPUIywUc4bDPrkgQoivLEb/foPIoX+h12yOS7zqZESSukvQeboOQjI8/yCmnjzSu4OxT2bkExuPZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AbNShHDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AbNShHDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904EAC4CED2;
	Mon, 27 Jan 2025 20:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738008766;
	bh=ANGdde/Hv2M0TtIwyNt5kIfxVRZHhl3haC8txVOb4Gs=;
	h=Date:To:From:Subject:From;
	b=AbNShHDlOgIrtFkqtGXuqZRPt7P80mGX5/+nvZY2cZZ/jJ2VTWDwYq/mqI5MGRQt6
	 6OLUF3nxXSTxnUrl8VzyXXzkSGadSrKuJUH8/oxfwGaD2kPOm+1bPMAtAR0/EHk06F
	 uzRD1UMqs1x0o6n21I63mPjeDYyoCndTZaLikopc=
Date: Mon, 27 Jan 2025 12:12:45 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,patrick.wang.shcn@gmail.com,matttbe@kernel.org,kuba@kernel.org,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-fix-upper-boundary-check-for-physical-address-objects.patch added to mm-hotfixes-unstable branch
Message-Id: <20250127201246.904EAC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmemleak: fix upper boundary check for physical address objects
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kmemleak-fix-upper-boundary-check-for-physical-address-objects.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-fix-upper-boundary-check-for-physical-address-objects.patch

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
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: kmemleak: fix upper boundary check for physical address objects
Date: Mon, 27 Jan 2025 18:42:33 +0000

Memblock allocations are registered by kmemleak separately, based on their
physical address.  During the scanning stage, it checks whether an object
is within the min_low_pfn and max_low_pfn boundaries and ignores it
otherwise.

With the recent addition of __percpu pointer leak detection (commit
6c99d4eb7c5e ("kmemleak: enable tracking for percpu pointers")), kmemleak
started reporting leaks in setup_zone_pageset() and
setup_per_cpu_pageset().  These were caused by the node_data[0] object
(initialised in alloc_node_data()) ending on the PFN_PHYS(max_low_pfn)
boundary.  The non-strict upper boundary check introduced by commit
84c326299191 ("mm: kmemleak: check physical address when scan") causes the
pg_data_t object to be ignored (not scanned) and the __percpu pointers it
contains to be reported as leaks.

Make the max_low_pfn upper boundary check strict when deciding whether to
ignore a physical address object and not scan it.

Link: https://lkml.kernel.org/r/20250127184233.2974311-1-catalin.marinas@arm.com
Fixes: 84c326299191 ("mm: kmemleak: check physical address when scan")
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: Patrick Wang <patrick.wang.shcn@gmail.com>
Cc: <stable@vger.kernel.org>	[6.0.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-fix-upper-boundary-check-for-physical-address-objects
+++ a/mm/kmemleak.c
@@ -1689,7 +1689,7 @@ static void kmemleak_scan(void)
 			unsigned long phys = object->pointer;
 
 			if (PHYS_PFN(phys) < min_low_pfn ||
-			    PHYS_PFN(phys + object->size) >= max_low_pfn)
+			    PHYS_PFN(phys + object->size) > max_low_pfn)
 				__paint_it(object, KMEMLEAK_BLACK);
 		}
 
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-kmemleak-fix-upper-boundary-check-for-physical-address-objects.patch


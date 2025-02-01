Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635C1153565;
	Sat,  1 Feb 2025 11:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410847; cv=none; b=YPGjz729HlKg0fWZaGexs/TT/B604DibkSEtXSUSSVC2hr4cSE9vWfsURJdYJHeaJeWUsIe2wjp1VBD6BwRtf4KzEvGUv8kgNkUrTxZfNlvKJcBSUQN+ov6bwjV3husXzQtlgxV5kR23ZABCcyMvGAkgnj1Ja12xyq4uPkgDJNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410847; c=relaxed/simple;
	bh=Ow77vYOMhXg4eXD8x5P+Ct2kmrxc7uX5svMd3Lkx0lw=;
	h=Date:To:From:Subject:Message-Id; b=bpyzASTbiiAp9ptaFfXpAbZYsGXzA5NP/FYcFomEXEl6pVHE/YgOoRqJmeOUyM2z6l4rUWHDVPOQ9Q5ul+I8PwKSLj0X8nuuW+Wxn6MT9fBJVAAx01mVwxzZbXAfT8I/TP679w8vW1Tg0vAwOMNN0hh1aagO61gwsCn78FPcUn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QgjQNuQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QgjQNuQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35512C4CED3;
	Sat,  1 Feb 2025 11:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410847;
	bh=Ow77vYOMhXg4eXD8x5P+Ct2kmrxc7uX5svMd3Lkx0lw=;
	h=Date:To:From:Subject:From;
	b=QgjQNuQ8NkEDkv9JMwCIMTXBoW0IFeU+hnRb32myaoG3bQ6Mk8pfBP98oUdOaU0tK
	 ptUPB9S1XGZkYOuYvGTLXGd4iZxaBFEJCWoSzVeqQPMT5uRCrUKHOw7Yz4ySJkbBW1
	 UjkxiCN+lNtIrJKI/F3DHIMt+9kfYf4MWyC76a+M=
Date: Sat, 01 Feb 2025 03:54:06 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,patrick.wang.shcn@gmail.com,matttbe@kernel.org,kuba@kernel.org,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kmemleak-fix-upper-boundary-check-for-physical-address-objects.patch removed from -mm tree
Message-Id: <20250201115407.35512C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmemleak: fix upper boundary check for physical address objects
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-fix-upper-boundary-check-for-physical-address-objects.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



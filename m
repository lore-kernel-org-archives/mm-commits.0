Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79A72AF0A
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 21:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749072436; cv=none; b=ScAsFFvuC6h1f7oHbiYiIvFJneY6X0tyvDA1YiKYNo008/UbG0NCZnjfIS6BMMHz8NbE6hJxX4y4iYpbVUI732B2gvm9gkXblM1ISeVOoil+fiwJdCrzdjEUNMmP8wkg411Hjsp5bKzITjF1r8aXE5gSquZfE4rpJgqeD56O2+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749072436; c=relaxed/simple;
	bh=+iSZABeykocVDdp3nRbRVR4a3vERya/ormVpXCabdJQ=;
	h=Date:To:From:Subject:Message-Id; b=R6dvBeH20utKPCjdO5zpfzp6EYYPNHByo5xQ4AchLz8GzFSQaUcn8u5CZGxkq6PKuzkV5y2YY0HuUKSTsrIHzL2v1v5kZQbHWtX4fy9fKEkudGswD15epRVnEPC+nO/Pvp2e78rY0PfXLmcFEAqiXSiby5p6oYcGpovzEytwPE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e208rByp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e208rByp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB50C4CEE4;
	Wed,  4 Jun 2025 21:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749072436;
	bh=+iSZABeykocVDdp3nRbRVR4a3vERya/ormVpXCabdJQ=;
	h=Date:To:From:Subject:From;
	b=e208rBypy1kGM56TxHeAnD5Iunix2/xnLGJFj7/GEglycXzi10AHRMmc5rPhN2Cqu
	 ipkms0ukIlvr5hwBsaQu1zKU9gR/jMLHuk3KAQfAfdS0OwKn7bSZtlR84+mqYu4iFf
	 PYIfPzzcSfZY2BFOswedVoMnBL6Pp2ZjdjeJRyDc=
Date: Wed, 04 Jun 2025 14:27:15 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rename-config_page_block_order-to-config_page_block_order_ceil-fix.patch removed from -mm tree
Message-Id: <20250604212716.1FB50C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Date: Wed, 4 Jun 2025 09:27:03 -0400
has been removed from the -mm tree.  Its filename was
     mm-rename-config_page_block_order-to-config_page_block_order_ceil-fix.patch

This patch was dropped because it was folded into mm-rename-config_page_block_order-to-config_page_block_order_ceil.patch

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Date: Wed, 4 Jun 2025 09:27:03 -0400
Subject: fixup: rename the missed PAGE_BLOCK_ORDER to PAGE_BLOCK_ORDER_CEIL

set_pageblock_order(): use PAGE_BLOCK_ORDER_CEIL

Link: https://lkml.kernel.org/r/EF1B1979-4D72-472D-8655-6B21AD26AA58@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506042058.XgvABCE0-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-rename-config_page_block_order-to-config_page_block_order_ceil-fix
+++ a/mm/mm_init.c
@@ -1509,7 +1509,7 @@ static inline void setup_usemap(struct z
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
 void __init set_pageblock_order(void)
 {
-	unsigned int order = PAGE_BLOCK_ORDER;
+	unsigned int order = PAGE_BLOCK_ORDER_CEIL;
 
 	/* Check that pageblock_nr_pages has not already been setup */
 	if (pageblock_order)
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-rename-config_page_block_order-to-config_page_block_order_ceil.patch


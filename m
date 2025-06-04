Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE701A7262
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 19:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749064616; cv=none; b=r/8AkzkhMiXVQaBCt10Cmf9mgyof1GTO9G4vF1gPqFW6GkAMsRD8vyL3qiA2jijjk/GTbBRcKZAc5EJqbwgJb1LcBe1al5puOw5SBQzO3ZKCq6vDzPIzxNxCD0s+e6kS6XiC7J8I73/EWRCDEsDo/dZhc0y/bfIMqYbfOCidKfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749064616; c=relaxed/simple;
	bh=HYx7rDCONWZ9vcJFtBES4ddFEX8rYe76xcVREl1AEuA=;
	h=Date:To:From:Subject:Message-Id; b=t6DCx+fH291BYLxZ2GPN06COhH7lxs2C+JHKB2guxvsHj/JYHntH4sbN8NxAZldpudZAaFpkCC45qpIfdxoUHW4FEXXjUDqQnsGUCoCD/vX7jg+05cgf/d+KhZ1iQoedLOrNOmwR9M7kb8NMa4IIIhobQsTx05vB3g1D/eDER2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fFaJNSzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fFaJNSzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957DAC4CEF0;
	Wed,  4 Jun 2025 19:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749064615;
	bh=HYx7rDCONWZ9vcJFtBES4ddFEX8rYe76xcVREl1AEuA=;
	h=Date:To:From:Subject:From;
	b=fFaJNSzJ5Ti+uoLbetMU1+nslGvCSL8FDrJedZdPN8ctkxHO6XPBIURtH3MeVOXkc
	 a1OmswUkfgFicHgBMyIu4Vws2GS2gqYQx9NehHyFZIGBpDTcXcAKRNhxsEoPACWFgY
	 lzNZdAi6CkD06bwXwokN2cgnAx+Sgu6Dfis0trEw=
Date: Wed, 04 Jun 2025 12:16:55 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-config_page_block_order-to-config_page_block_order_ceil-fix.patch added to mm-new branch
Message-Id: <20250604191655.957DAC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Date: Wed, 4 Jun 2025 09:27:03 -0400
has been added to the -mm mm-new branch.  Its filename is
     mm-rename-config_page_block_order-to-config_page_block_order_ceil-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-config_page_block_order-to-config_page_block_order_ceil-fix.patch

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
mm-rename-config_page_block_order-to-config_page_block_order_ceil-fix.patch


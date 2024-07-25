Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D249D11711
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 21:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721944659; cv=none; b=HKa8AdpH3Rg0uYjjlZaERN8yzYLLVWGACFwa3qKw9+7a/wuyetktOaPgDTwB44JT+Mu6qOsyxvd/3hAe8DZBCQ6QfcVRmgaVXRsYV4wfsO2nKPRVZFf4Nlf8YOjT4B2gLqP+zMmrVbiEHwLeZi2XqFD6G/94J9FtBV6EmbwyqlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721944659; c=relaxed/simple;
	bh=jGA01GZ8MZGaI5pMkQnlQ3aYpb2chPa6QJceZ00O2hQ=;
	h=Date:To:From:Subject:Message-Id; b=BIyzlNrAnr+P0+90F63NgqRZRngm8C5rZWp74Y8N5sqJL5SvtIxFu49qwozwgZU20grSJGFbn6yKLmTKr+Oh93udQqNfq1Qs22D55ZAt2mzPqMeIE3UAHTWXbGwWbgbhAuJbvCSN75y5RpQn/T9cgpTuU8VKcT9PddBPsREW45s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UlW++ui6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UlW++ui6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E1CC116B1;
	Thu, 25 Jul 2024 21:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721944658;
	bh=jGA01GZ8MZGaI5pMkQnlQ3aYpb2chPa6QJceZ00O2hQ=;
	h=Date:To:From:Subject:From;
	b=UlW++ui6NLzksV6sHmXCIFWjvrbkj0B74P+oxqEdEj15OuR71sxxqY/ANXeU/8wDr
	 rJdFIaNvEo7w+zyNYuBE8438NPbxwjGFQlmij4Z4o9XnF8+rS8TxEjJfRWlABvuuT1
	 QR8jobeTg3JN90i1UnPPl81E9s/AOv2yO2VBADM8=
Date: Thu, 25 Jul 2024 14:57:37 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,jdike@linux.intel.com,david@redhat.com,blaisorblade@yahoo.it,agk@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] um-mm-remove-redundant-assignment-of-max_low_pfn.patch removed from -mm tree
Message-Id: <20240725215738.74E1CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: um/mm: remove redundant assignment of max_low_pfn
has been removed from the -mm tree.  Its filename was
     um-mm-remove-redundant-assignment-of-max_low_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: um/mm: remove redundant assignment of max_low_pfn
Date: Sat, 15 Jun 2024 03:41:50 +0000

Current calculation of max_low_pfn is introduced in commit af84eab20891
("[PATCH] uml: fix LVM crash").  It is intended to set max_low_pfn to the
same value as max_pfn.

But I am not sure why the max_pfn is set to totalram_pages, which
represents the number of usable pages in system instead of an absolute
page frame number.  (The change history stops there.)

While we have already calculate it in setup_physmem(), so not necessary to
do it again.

Also this would help changing totalram_pages accounting, since we plan to
move the accounting into __free_pages_core().  With this change,
totalram_pages may not represent the total usable pages at this point,
since some pages would be deferred initialized.

Link: https://lkml.kernel.org/r/20240615034150.2958-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/mem.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/um/kernel/mem.c~um-mm-remove-redundant-assignment-of-max_low_pfn
+++ a/arch/um/kernel/mem.c
@@ -73,7 +73,6 @@ void __init mem_init(void)
 
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
-	max_low_pfn = totalram_pages();
 	max_pfn = max_low_pfn;
 	kmalloc_ok = 1;
 }
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are



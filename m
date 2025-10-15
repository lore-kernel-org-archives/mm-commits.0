Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE9744C63
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 00:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760486598; cv=none; b=fWxbT100Aaj2Sgg+5wKCYMmie7Rs0LbQGLaevy9oNe3HfePM7QkGh3N9R1TrIx2/22skUPod9hLIRnJplPIw8oCUFZq1M3tFO1YcB4LZbZoa5yEBzmYiMYtHU18pKKNh2mGjU/GkZpqU5J3Punnxijx1i2cOGe7kg/lmIQFRzOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760486598; c=relaxed/simple;
	bh=KFVwp9+JVuhFMG3ym/cJ0ZCyrhNeG50QyTn963Jcz/8=;
	h=Date:To:From:Subject:Message-Id; b=Bnq8D2iTGEQSbFoTEfX/61CHBIWQSj+Mgor9Ht/Dz7fBJVt3KhkOMqWu1mTvnwHjq9iWgnZSA9uhbFQwmwhOJjbdNIkBEg0+xNlFHs3S76qI1c15kaiFqkJyprxMUb38oKssS1LlopDe1qNk0ahUG55PK4Ju+D+b7S5hTL+OPrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HLjhCAvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HLjhCAvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FC4C4CEE7;
	Wed, 15 Oct 2025 00:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760486598;
	bh=KFVwp9+JVuhFMG3ym/cJ0ZCyrhNeG50QyTn963Jcz/8=;
	h=Date:To:From:Subject:From;
	b=HLjhCAvyTWwPVWTSJ8AmvARdjSGpYrsmEeUXlGPGwe08uzxrxuXlrq6caWqsUIZUs
	 /5J2esAvcoJAqlMlvuDmrJiQebCAS48KUTf93asTs85aK993spunfmw1xoN9By3YaM
	 TDixjncTPTchSXtdf8hLWSS+9HaSNSbHFGtpAJb4=
Date: Tue, 14 Oct 2025 17:03:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-remove-redundant-split_order-=-new_order-check-in-uniform_split.patch added to mm-new branch
Message-Id: <20251015000318.04FC4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: Remove redundant split_order != new_order check in uniform_split
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-remove-redundant-split_order-=-new_order-check-in-uniform_split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-remove-redundant-split_order-=-new_order-check-in-uniform_split.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: Remove redundant split_order != new_order check in uniform_split
Date: Tue, 14 Oct 2025 13:46:06 +0000

The uniform splitting logic is designed so that the @split_order variable
starts at the target @new_order and subsequently decreases with each
iteration.

Given that both @split_order and @new_order are integers and the splitting
process only ever targets the @new_order for a uniform split, the
condition where split_order != new_order will not logically occur within
the expected execution path.

Removes the check for this non-existent case, simplifying the code.

Link: https://lkml.kernel.org/r/20251014134606.22543-6-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-redundant-split_order-=-new_order-check-in-uniform_split
+++ a/mm/huge_memory.c
@@ -3545,8 +3545,6 @@ static int __split_unmapped_folio(struct
 		/* order-1 anonymous folio is not supported */
 		if (is_anon && split_order == 1)
 			continue;
-		if (uniform_split && split_order != new_order)
-			continue;
 
 		if (mapping) {
 			/*
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch
mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch
mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-cache-folio-attribute-in-__split_unmapped_folio.patch
mm-huge_memory-update-folio-stat-after-successful-split.patch
mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch
mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch
mm-huge_memory-remove-redundant-split_order-=-new_order-check-in-uniform_split.patch


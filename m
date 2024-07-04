Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50636CA64
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 01:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720058387; cv=none; b=rbvVMB/WXXZEy5vimFehm/D1cueRmIpRxVP7MA9iUKfUtCIWArhOYrSJoctfBfAAttrJyImMD8jKGndKb2s9F5Or9qXVvhjkr/F2CoNljkCeymUyxoIfffrechG+hRYfw7un6DL0YAsVJ5rqLH7waR33rb6n1v/RoztvDz8t7Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720058387; c=relaxed/simple;
	bh=1slJVy/KqMjKAsDiEcainHBCVGqAL0zXUU8ScpHEGPw=;
	h=Date:To:From:Subject:Message-Id; b=sirTmrqiouTrkDUZc1slkH2OpeqiLSgS74OBlyLOZO1PdFkjGqLxyK9TJwuThpqasSrAfKfWa53DoXlSGTMPC4rhQbe6WZqV0mM9ZS61oBbcTnXz+HxPOEtUjh64zP28VDIrsPWOZAgtwVYQ9OnfxOzPE6+Zoj21Es/KK1Td/Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oFRSVs6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oFRSVs6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976BAC2BD10;
	Thu,  4 Jul 2024 01:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720058386;
	bh=1slJVy/KqMjKAsDiEcainHBCVGqAL0zXUU8ScpHEGPw=;
	h=Date:To:From:Subject:From;
	b=oFRSVs6FxtOrWSjKnQV9E7FIFAiUcs2aATNMisxUNsP4K6ulTEd5Lu4dSfiTrFnQv
	 V/ZbQE061F+X/RpKrwsnO2zvwRfjGFjmy+8ONTbMKz7tYcxMigSQeHNrwSPh51yd6h
	 KN72HeCjH6EBHVP66dAOJWrGkS7o5M/p3y3KL2bg=
Date: Wed, 03 Jul 2024 18:59:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,libang.li@antgroup.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-docs-for-per-order-mthp-split-counters-v3.patch added to mm-unstable branch
Message-Id: <20240704015946.976BAC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-docs-for-per-order-mthp-split-counters-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-docs-for-per-order-mthp-split-counters-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-docs-for-per-order-mthp-split-counters-v3.patch

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
From: Lance Yang <ioworker0@gmail.com>
Subject: mm-add-docs-for-per-order-mthp-split-counters-v3
Date: Thu, 4 Jul 2024 09:29:05 +0800

improve the doc as suggested by Ryan

Link: https://lkml.kernel.org/r/20240704012905.42971-3-ioworker0@gmail.com
Signed-off-by: Mingzhe Yang <mingzhe.yang@ly.com>
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-add-docs-for-per-order-mthp-split-counters-v3
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -369,10 +369,6 @@ also applies to the regions registered i
 Monitoring usage
 ================
 
-.. note::
-   Currently the below counters only record events relating to
-   PMD-sized THP. Events relating to other THP sizes are not included.
-
 The number of PMD-sized anonymous transparent huge pages currently used by the
 system is available by reading the AnonHugePages field in ``/proc/meminfo``.
 To identify what applications are using PMD-sized anonymous transparent huge
@@ -516,8 +512,8 @@ file_fallback_charge
 
 split
 	is incremented every time a huge page is successfully split into
-	base pages. This can happen for a variety of reasons but a common
-	reason is that a huge page is old and is being reclaimed.
+	smaller orders. This can happen for a variety of reasons but a
+	common reason is that a huge page is old and is being reclaimed.
 	This action implies splitting any block mappings into PTEs.
 
 split_failed
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-add-per-order-mthp-split-counters.patch
mm-add-per-order-mthp-split-counters-v3.patch
mm-add-docs-for-per-order-mthp-split-counters.patch
mm-add-docs-for-per-order-mthp-split-counters-v3.patch


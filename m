Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B2A218596
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 22:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746745089; cv=none; b=n0NAtbHNMEcTuUHmxVOAl5oHKHQhYLocUHn40C8pTENW7oFZ54VQN2ePBVTZrVyCeTHXRz1X843JsfSMzfF97zGzgzzAijUizHUPff94MIEFUNn7+E7ylPDegEJS8pLxq1F5SOR9VFqtwfHh1pNIc00zlAhzabdpLd2G3Mn+yB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746745089; c=relaxed/simple;
	bh=HDJUjHVmdC6yMG6rE/FLoRJlj0AbhF1axpnbGVHbX2k=;
	h=Date:To:From:Subject:Message-Id; b=JRH4uIJc5yolAHNsJ22plmx7vOoXs2bOoGbDWWu8qpHD/s0DuK4YvOtyLS42wTkcV3fmFzsb1jqB5NnUPbQzZ41jnyGncQhpBJHFrKJcRrie10iwSv9aN03O5hCDrZH92bMPaur9tvvttcs0BoPCJXXOARksBJe/08SBqDBJ/OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=my8MSDqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="my8MSDqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F50C4CEED;
	Thu,  8 May 2025 22:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746745088;
	bh=HDJUjHVmdC6yMG6rE/FLoRJlj0AbhF1axpnbGVHbX2k=;
	h=Date:To:From:Subject:From;
	b=my8MSDqgHF7o5sj9iEYY63KigSJPIeCzk1ExJCFSEkRN8jLVDzEtJsvR1FYh9/a4s
	 BI6T2omnua5//cL2cMvsoGBFiP0Y6zQG7Z6B0g8qF2TpPGmNnIQ52Tvx5RYH3R1ckr
	 we8AKuBgHLqK4QGyXF69zvSQpiUrSbtkoEubPfg8=
Date: Thu, 08 May 2025 15:58:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix.patch added to mm-new branch
Message-Id: <20250508225808.D9F50C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix.patch

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
Subject: mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix
Date: Thu, 8 May 2025 15:42:18 -0400

address the type issue reported by kernel test robot

1. fixed test_pages_isolated() and __test_page_isolated_in_pageblock()
   signature by using the new isol_flags_t type.
2. fixed test_pages_isolated() doc: flags -> isol_flags

Link: https://lkml.kernel.org/r/C4D87FA7-4B3D-440F-9E5F-B57561AB4FE8@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    2 +-
 mm/page_isolation.c            |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/page-isolation.h~mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix
+++ a/include/linux/page-isolation.h
@@ -45,5 +45,5 @@ int start_isolate_page_range(unsigned lo
 void undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn);
 
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
-			int isol_flags);
+			isol_flags_t isol_flags);
 #endif
--- a/mm/page_isolation.c~mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix
+++ a/mm/page_isolation.c
@@ -546,7 +546,7 @@ void undo_isolate_page_range(unsigned lo
  */
 static unsigned long
 __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
-				  int flags)
+				  isol_flags_t flags)
 {
 	struct page *page;
 
@@ -585,7 +585,7 @@ __test_page_isolated_in_pageblock(unsign
  *
  * This tests if all in the specified range are free.
  *
- * If %MEMORY_OFFLINE is specified in @flags, it will consider
+ * If %MEMORY_OFFLINE is specified in @isol_flags, it will consider
  * poisoned and offlined pages free as well.
  *
  * Caller must ensure the requested range doesn't span zones.
@@ -593,7 +593,7 @@ __test_page_isolated_in_pageblock(unsign
  * Returns 0 if true, -EBUSY if one or more pages are in use.
  */
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
-			int isol_flags)
+			isol_flags_t isol_flags)
 {
 	unsigned long pfn, flags;
 	struct page *page;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix.patch


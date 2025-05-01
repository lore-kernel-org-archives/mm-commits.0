Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AF21DB13A
	for <mm-commits@vger.kernel.org>; Thu,  1 May 2025 20:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746129868; cv=none; b=Z68yZ7m5K77S96P0QLX0comn7Q27fgbp3kp1wx9ZJXhIdehbsLxQ8Wi3s04a3mNapFRQy9Giy+vM/r7nENM4yA0E4UXwZmlLk86I9Z7PKXFjAfm35uzEizSe24kpA3wXSLQIEA6GKols4v46e8gD97l7yIEoNF05GmFcp8n53fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746129868; c=relaxed/simple;
	bh=hYvkBUdaRuBCEbHyvWFDEW6EEiz1WfOTKiISYVSXa0s=;
	h=Date:To:From:Subject:Message-Id; b=QovrNCm6kWmWfQpDOi5UCXSGkDRabEs6JZPkydwgm7QcTwpLA3WaP8l3yqddvoQ0Kh3nMNXkB+f52XBaMURgBIjE9o6BH64w3y4+F+lg4pPulrwmehLC/MLDzKOlsUvtcFV8o7Nm2SqqUhp9DX5UExkpTKJOOGj/yKs68fMSMhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VPkzYiC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VPkzYiC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DAEC4CEE3;
	Thu,  1 May 2025 20:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746129867;
	bh=hYvkBUdaRuBCEbHyvWFDEW6EEiz1WfOTKiISYVSXa0s=;
	h=Date:To:From:Subject:From;
	b=VPkzYiC6FLXvVYY80Yyy6zspfGuvpqVwZ0U9jemyv3a4LWS0O7/nT4jSk+0Tmphi5
	 887Vl0Wqyb6hi0HG9cFPP0sqmddDIrLxahanRmngOhu6XOcdOGBXcfE4914RnjR8B+
	 +9DOt//1G908VZBELl/jLEUkVBcG+4tgTrl7gXhM=
Date: Thu, 01 May 2025 13:04:26 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-copy-the-cma-flag-when-demoting.patch added to mm-hotfixes-unstable branch
Message-Id: <20250501200427.42DAEC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: copy the CMA flag when demoting
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-copy-the-cma-flag-when-demoting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-copy-the-cma-flag-when-demoting.patch

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
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: copy the CMA flag when demoting
Date: Thu, 1 May 2025 04:43:24 +0000

Since commit d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA
areas"), a flag is used to mark hugetlb folios as allocated from CMA. 
This flag is also used to decide if it should be freed to CMA.

However, the flag isn't copied to the smaller folios when a hugetlb folio
is broken up for demotion, which would cause it to be freed incorrectly.

Fix this by copying the flag to the smaller order hugetlb pages created
from the original one.

Link: https://lkml.kernel.org/r/20250501044325.20365-1-fvdl@google.com
Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-copy-the-cma-flag-when-demoting
+++ a/mm/hugetlb.c
@@ -4042,10 +4042,13 @@ static long demote_free_hugetlb_folios(s
 
 	list_for_each_entry_safe(folio, next, src_list, lru) {
 		int i;
+		bool cma;
 
 		if (folio_test_hugetlb_vmemmap_optimized(folio))
 			continue;
 
+		cma = folio_test_hugetlb_cma(folio);
+
 		list_del(&folio->lru);
 
 		split_page_owner(&folio->page, huge_page_order(src), huge_page_order(dst));
@@ -4061,6 +4064,9 @@ static long demote_free_hugetlb_folios(s
 
 			new_folio->mapping = NULL;
 			init_new_hugetlb_folio(dst, new_folio);
+			/* Copy the CMA flag so that it is freed correctly */
+			if (cma)
+				folio_set_hugetlb_cma(new_folio);
 			list_add(&new_folio->lru, &dst_list);
 		}
 	}
_

Patches currently in -mm which might be from fvdl@google.com are

mm-hugetlb-copy-the-cma-flag-when-demoting.patch
mm-hugetlb-use-separate-nodemask-for-bootmem-allocations.patch


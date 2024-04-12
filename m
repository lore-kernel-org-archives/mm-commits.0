Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681EB4C6E
	for <mm-commits@vger.kernel.org>; Fri, 12 Apr 2024 22:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712962376; cv=none; b=UN8X2EiMXetSTzdZxKV/xs9yKmX7v1+kkJVRkjJh7Ed9b7e0oXzOrXSheOgllBgs58fMr1ZnCk7w/yk5eCt4pigydPjSJhZTDCTOkm7KSzdh15J7NJINn08Bl/faxhNpcREkUpTq2ojwTrrg+Wbir0MHvs7CE4x2+rk/Cl70XT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712962376; c=relaxed/simple;
	bh=O7qe/6N2Bg5hH8PqoBIsUrcLQdmZWW+XxaAnsVx9xQc=;
	h=Date:To:From:Subject:Message-Id; b=kec0WVLnORKiRuau0Cc3mhnIJZqB36SvB19T7+p8Oc8vVU/6Nk3SRZp62v0bUhtOPVP+9myrDSi+gramyn3cA6/Pm0Xm7MqtkyrBGcXCxX0x/AUfrPsFA0gswVCtD1u9L/DYd81X2jYe+YKOokt0SCZsoamQ26CKmQE+9T1bA2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0bzeIDql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0bzeIDql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F1EC113CC;
	Fri, 12 Apr 2024 22:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712962375;
	bh=O7qe/6N2Bg5hH8PqoBIsUrcLQdmZWW+XxaAnsVx9xQc=;
	h=Date:To:From:Subject:From;
	b=0bzeIDqlK5apyWXwYsrgn6qkYtqnhzL5A0AXCOeiLtqAelDdV5VLWF81eyuzUOrOb
	 Rbw5U9D5XlkSdqRAJB4bpcI9o9IRFbk+PEw4mJyDvuB+wtESKw4Gfs7JP5144BBqwt
	 oBg/PE8ATghQyE/84ujppUuMhOyyRI+7Tm6nQlQg=
Date: Fri, 12 Apr 2024 15:52:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios.patch added to mm-unstable branch
Message-Id: <20240412225255.C4F1EC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: rename dissolve_free_huge_pages() to dissolve_free_hugetlb_folios()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: rename dissolve_free_huge_pages() to dissolve_free_hugetlb_folios()
Date: Fri, 12 Apr 2024 11:21:39 -0700

dissolve_free_huge_pages() only uses folios internally, rename it to
dissolve_free_hugetlb_folios() and change the comments which reference it.

Link: https://lkml.kernel.org/r/20240412182139.120871-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |    2 +-
 mm/memory_hotplug.c     |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios
+++ a/include/linux/hugetlb.h
@@ -862,7 +862,7 @@ static inline int hstate_index(struct hs
 }
 
 extern int dissolve_free_hugetlb_folio(struct folio *folio);
-extern int dissolve_free_huge_pages(unsigned long start_pfn,
+extern int dissolve_free_hugetlb_folios(unsigned long start_pfn,
 				    unsigned long end_pfn);
 
 #ifdef CONFIG_MEMORY_FAILURE
@@ -1153,7 +1153,7 @@ static inline int dissolve_free_hugetlb_
 	return 0;
 }
 
-static inline int dissolve_free_huge_pages(unsigned long start_pfn,
+static inline int dissolve_free_hugetlb_folios(unsigned long start_pfn,
 					   unsigned long end_pfn)
 {
 	return 0;
--- a/mm/hugetlb.c~mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios
+++ a/mm/hugetlb.c
@@ -2472,7 +2472,7 @@ out:
  * Also note that if dissolve_free_hugetlb_folio() returns with an error, all
  * free hugetlb folios that were dissolved before that error are lost.
  */
-int dissolve_free_huge_pages(unsigned long start_pfn, unsigned long end_pfn)
+int dissolve_free_hugetlb_folios(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long pfn;
 	struct folio *folio;
--- a/mm/memory_hotplug.c~mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios
+++ a/mm/memory_hotplug.c
@@ -2051,11 +2051,11 @@ int __ref offline_pages(unsigned long st
 		}
 
 		/*
-		 * Dissolve free hugepages in the memory block before doing
+		 * Dissolve free hugetlb folios in the memory block before doing
 		 * offlining actually in order to make hugetlbfs's object
 		 * counting consistent.
 		 */
-		ret = dissolve_free_huge_pages(start_pfn, end_pfn);
+		ret = dissolve_free_hugetlb_folios(start_pfn, end_pfn);
 		if (ret) {
 			reason = "failure to dissolve huge pages";
 			goto failed_removal_isolated;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-convert-dissolve_free_huge_pages-to-folios.patch
mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-v2.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios.patch


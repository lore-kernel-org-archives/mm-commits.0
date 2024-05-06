Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BF15CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957036; cv=none; b=mEqR5614Xy+CvcbaPyQZLzyz7hjDqfyMaRWpQW1mwiSTSNb6mKnCvZUgZiXcY+8i9/u2RkHN1cHO1Ff8mQuN1uW/AtDdOhYlkB7ykgJ48kgFWoZ0+hRl61G9/zPU1XYYnPzl/WhwBEHyKG9rorZ+VNNp4O/q1/jWLA56CL4016g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957036; c=relaxed/simple;
	bh=UEc1fWnn7mpRXqLRH9j6bvfkOp+mUu8ifwXCJqT28r8=;
	h=Date:To:From:Subject:Message-Id; b=HSw8sS9AWzpPNK8GlcjYLaGiZoATGzAXsd24OknqlSRozbqRmBAM8YLtiw5Lcn2Y2KC0CreJG23lRDrU9BQL6UaVmrETD8FLamPRDPP0YAKAPNFHnW2bRn7Ao27w8EU1na1iGLMdpf/hUQmkln6dmDtPrNObO2bdds7wwd/QdzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RjHtAT3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RjHtAT3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9906C113CC;
	Mon,  6 May 2024 00:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957036;
	bh=UEc1fWnn7mpRXqLRH9j6bvfkOp+mUu8ifwXCJqT28r8=;
	h=Date:To:From:Subject:From;
	b=RjHtAT3j82f8XVhRygsQk6GnBp4Q8C/wabR5JHfi1xIukJmzRik8yayGgE2fxuIsS
	 urUPlIISHJR+h6HbE44fwjBhysV5k4csqz17esQGjqsO2MUieOLcnOT3Zf55//A06m
	 JQY43zvgBzktTvhLK+Lcchd/T1QCsvuFloX4WcNg=
Date: Sun, 05 May 2024 17:57:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios.patch removed from -mm tree
Message-Id: <20240506005715.E9906C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: rename dissolve_free_huge_pages() to dissolve_free_hugetlb_folios()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: rename dissolve_free_huge_pages() to dissolve_free_hugetlb_folios()
Date: Fri, 12 Apr 2024 11:21:39 -0700

dissolve_free_huge_pages() only uses folios internally, rename it to
dissolve_free_hugetlb_folios() and change the comments which reference it.

[akpm@linux-foundation.org: remove unneeded `extern']
Link: https://lkml.kernel.org/r/20240412182139.120871-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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
 
 int dissolve_free_hugetlb_folio(struct folio *folio);
-extern int dissolve_free_huge_pages(unsigned long start_pfn,
+int dissolve_free_hugetlb_folios(unsigned long start_pfn,
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



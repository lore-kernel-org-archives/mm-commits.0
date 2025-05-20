Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981EC33F9
	for <mm-commits@vger.kernel.org>; Tue, 20 May 2025 01:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747703384; cv=none; b=bbfjtZoThFFvd9+L4Xm09UFUnnoP6sgot2f+tE6ezE8voIrSitsi0h+lHN+U9i/BSpqT6GXThVX8w0FCYvX8Wju93U/nogQW8td8dk6PJzT3w0IKLP5UT+ZTc8pGuGlbEBrQ0VnkQSYS0ZpvT4Cdite2mKuDmgH7dJWBD8ftH4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747703384; c=relaxed/simple;
	bh=NdMI0R8liytIUX5B0+gog+h2Mk6FEKcE4XWjlL5gw10=;
	h=Date:To:From:Subject:Message-Id; b=NONUAweSay6dS4+/q+AI+Wf1WtkXe/0rdWWrj7/mk/RcrJbLCJ8aQJihmrJS73KZ6Xgi6vuZNPApKoPa36uEZiDf0dFLP7sy/1oJpFDuIKfCh7aaL7UG4PobecpTxDDGGpOzNFC1UGs3hRIBn4yZGBfUUL0otZrJm2IDdXv6KjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OdwuZ6h/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OdwuZ6h/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FEFC4CEE4;
	Tue, 20 May 2025 01:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747703384;
	bh=NdMI0R8liytIUX5B0+gog+h2Mk6FEKcE4XWjlL5gw10=;
	h=Date:To:From:Subject:From;
	b=OdwuZ6h/yb1jqvDgjW0hGPjFitBpx3SlG5DznIUzZsaatlUgxtcPCvmXNRswGSRK2
	 nyEIMGmmb5CqwtG1+7wbGV7xCIQlGb86exSSXrYpCYKBiDBsFzJpN8Fkw0jkUDbcNS
	 BtWAz5AoSfMedrlUylPhVQ0jmYt4VhfIyYrn7peE=
Date: Mon, 19 May 2025 18:09:43 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,lirongqing@baidu.com,xuwenjie04@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-show-nr_huge_pages-in-report_hugepages.patch added to mm-new branch
Message-Id: <20250520010944.10FEFC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: show nr_huge_pages in report_hugepages()
has been added to the -mm mm-new branch.  Its filename is
     hugetlb-show-nr_huge_pages-in-report_hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-show-nr_huge_pages-in-report_hugepages.patch

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
From: Wenjie Xu <xuwenjie04@baidu.com>
Subject: hugetlb: show nr_huge_pages in report_hugepages()
Date: Thu, 15 May 2025 19:42:31 +0800

The number of pre-allocated huge pages should be nr_huge_pages, not
free_huge_pages, although they are same during booting stage

Link: https://lkml.kernel.org/r/20250515114231.65824-1-xuwenjie04@baidu.com
Signed-off-by: Wenjie Xu <xuwenjie04@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-show-nr_huge_pages-in-report_hugepages
+++ a/mm/hugetlb.c
@@ -3733,7 +3733,7 @@ static void __init report_hugepages(void
 
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
 		pr_info("HugeTLB: registered %s page size, pre-allocated %ld pages\n",
-			buf, h->free_huge_pages);
+			buf, h->nr_huge_pages);
 		if (nrinvalid)
 			pr_info("HugeTLB: %s page size: %lu invalid page%s discarded\n",
 					buf, nrinvalid, nrinvalid > 1 ? "s" : "");
_

Patches currently in -mm which might be from xuwenjie04@baidu.com are

hugetlb-show-nr_huge_pages-in-report_hugepages.patch


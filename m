Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A36166F0C
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756841; cv=none; b=uFfBZA3xdPUvtYzFfsscc8WWKlv7vSsIT0vPOowWCXykTqVlL5GA4d/vRrYEFK+A1apehNkeVY70v0CEvItBvTaHaagvT3Is4fIBVnIVB7TbZP35onK4aY9dCR43aFwh5ayo+lAN4hfBAu2TMRt9IKXmQcsW8nFoxyS3xMKPks4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756841; c=relaxed/simple;
	bh=JtKoAAC8enbrvQx8tbdyWHODnftLLGSAGfwq8EPDG4Y=;
	h=Date:To:From:Subject:Message-Id; b=I78p10s6batoqwNupF74VN5vDFyYvj7DMbJ2r0RTHa0HLYTCXLGopQeeKQZ0P+1JyYtccIRW8Lw6bL6mx7YihKjCriQHGANjUVgmfBkybURk11BSx425bmUYsayA/JBkuit93249aQbFY1Qejet2oZMVZ2Ie9dpOeLOJ74pJQqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=audxKbDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="audxKbDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA47DC4CEED;
	Sun,  1 Jun 2025 05:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756840;
	bh=JtKoAAC8enbrvQx8tbdyWHODnftLLGSAGfwq8EPDG4Y=;
	h=Date:To:From:Subject:From;
	b=audxKbDaMrBNV2ekoMjFRGGyuMq/wBgtO91UmigWCeWdsVCVrtSRWxe19TJ8fdUDs
	 0QsUXX5w7HXzu73z4aiJC3vincnxcUZByjD1kW5XAxU9AKELOEH5lnLe34KYmWAEg7
	 sonW0jABWVIXFJAKXrUthiFlymNpBZS9RGESlN7c=
Date: Sat, 31 May 2025 22:47:20 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,lirongqing@baidu.com,xuwenjie04@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-show-nr_huge_pages-in-report_hugepages.patch removed from -mm tree
Message-Id: <20250601054720.CA47DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: show nr_huge_pages in report_hugepages()
has been removed from the -mm tree.  Its filename was
     hugetlb-show-nr_huge_pages-in-report_hugepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wenjie Xu <xuwenjie04@baidu.com>
Subject: hugetlb: show nr_huge_pages in report_hugepages()
Date: Thu, 15 May 2025 19:42:31 +0800

The number of pre-allocated huge pages should be nr_huge_pages, not
free_huge_pages, although they are same during booting stage

Link: https://lkml.kernel.org/r/20250515114231.65824-1-xuwenjie04@baidu.com
Signed-off-by: Wenjie Xu <xuwenjie04@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
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



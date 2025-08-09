Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5FC1CFBC
	for <mm-commits@vger.kernel.org>; Sat,  9 Aug 2025 00:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754700352; cv=none; b=FrCbs04qaVeY6dsnZghTQZKilSjdShIhVfQsiKetIknY+85QBcLn6TcDuk3jOFsgmz3VsxShJJ2Pbvo2JVODJTZfaSQxWuFbooUhzlHer/V0wUglpMWRCzjwO52yrBhism8V54Aqcmil2lGNySJNgrSBHO+59e+yp7gDlw0s46Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754700352; c=relaxed/simple;
	bh=iH0KyD0rx/z1CVK0M88ZI3PZYFiV3a+EJNU1nfOxCQA=;
	h=Date:To:From:Subject:Message-Id; b=MXuAb6hf/CwiUkXyJITnKbSosqCFT8PK78ewWNZ6p9BBA36+Pam8B2RDjeVc0g5NM3mKmLf7K/WNm3eTFZdzcQPiyi/0eiD9WAz/7DdfsH1v3s3KfK2D0jUktF91c2F1Bg+zl8nw/LyGg/+hVbTwbyNECrSVZ5qKj2pLvf5Fcxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lpntffRZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lpntffRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83FAC4CEF4;
	Sat,  9 Aug 2025 00:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754700351;
	bh=iH0KyD0rx/z1CVK0M88ZI3PZYFiV3a+EJNU1nfOxCQA=;
	h=Date:To:From:Subject:From;
	b=lpntffRZTRBV5n3uGwFYenRadE9hdxIOBSwqU/thNwu8y/G+4iCP1UWkZA+hClg23
	 dIgSR0PdOGNgiDP1N33kg192enagJRlSBk69fvRoYf6a1RszIYikohNrmlCuyKFDJn
	 XWVPeufuwprPrHMZVBa9SXBzid2adD7neQ0bBSCQ=
Date: Fri, 08 Aug 2025 17:45:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,donettom@linux.ibm.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch removed from -mm tree
Message-Id: <20250809004551.B83FAC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: do check_huge_anon() with a number been passed in
has been removed from the -mm tree.  Its filename was
     selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: selftests/mm: do check_huge_anon() with a number been passed in
Date: Thu, 7 Aug 2025 08:27:07 +0000

Currently it hard codes the number of hugepage to check for
check_huge_anon(), but we already have the number passed in.

Do the check based on the number of hugepage passed in is more reasonable.

Link: https://lkml.kernel.org/r/20250807082707.30647-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-do-check_huge_anon-with-a-number-been-passed-in
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -112,7 +112,7 @@ static void verify_rss_anon_split_huge_p
 	unsigned long rss_anon_before, rss_anon_after;
 	size_t i;
 
-	if (!check_huge_anon(one_page, 4, pmd_pagesize))
+	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
 	rss_anon_before = rss_anon();
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch


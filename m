Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CCD234971
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837206; cv=none; b=SjLJH8SkOqR5HOnPLcjGsjMo5dbh4jOAiLElK81uV6Ed9EHLI0dBwzC3gMSe1vV93UAiOn0GvtrhaLKCKRFUmkDWLjT87RyFU7Em1Fyxir/4NJwigZksJtDkAx5ACzYktLrF44frkR8K77m+0fVFXPbMQgnXE0PKv1GujtEpPgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837206; c=relaxed/simple;
	bh=pXiXoYS+Wj6203UEgA15Z8JI4B2dYx6SD/dWC3Vo1Bo=;
	h=Date:To:From:Subject:Message-Id; b=HO5Y26YJxi0JqSMKsK/s7+NnFxFNA9irxV7qqpc5/yGzcES1wgoO3OLnd1f3ZwM9LrjNcLfpPoQ1E0ysEIEFd5yamrlH76o4qhmu7e2gLPzNugxt+nTd0Nxn1qr1/5FPjEICpdF2oYrIy8pvaSxtBan5yHWYo6a9AzzbhvnQziU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0J14M1eP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0J14M1eP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E9FC4CEDD;
	Tue, 14 Jan 2025 06:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837205;
	bh=pXiXoYS+Wj6203UEgA15Z8JI4B2dYx6SD/dWC3Vo1Bo=;
	h=Date:To:From:Subject:From;
	b=0J14M1ePbrER5Mtxl8NKDcbVcJDUSiHKSjGQF4agvOa2lj5OEnsTGNB3M+NUROvrI
	 yj4zbPKPfE6DSaBPZ2lSIV83hqu+4siP+LG0Dn5qeP/C2Ke1+TXLPjU6NudZ8LC5ol
	 Z+Q28bDevz77kA8OBdAL/wr+k95txjLVTNlK7x/U=
Date: Mon, 13 Jan 2025 22:46:45 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-support-damos_filter-allow.patch removed from -mm tree
Message-Id: <20250114064645.B7E9FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: support damos_filter->allow
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-support-damos_filter-allow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: support damos_filter->allow
Date: Thu, 9 Jan 2025 09:51:20 -0800

Respect damos_filter->allow from 'paddr', which is a DAMON operations set
implementation for the physical address space and supports a few types of
region-internal DAMOS filters (anon, memcg and young).  The change is
similar to that of the previous commit for core layer update.

Link: https://lkml.kernel.org/r/20250109175126.57878-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-damos_filter-allow
+++ a/mm/damon/paddr.c
@@ -198,7 +198,7 @@ static unsigned int damon_pa_check_acces
 	return max_nr_accesses;
 }
 
-static bool __damos_pa_filter_out(struct damos_filter *filter,
+static bool damos_pa_filter_match(struct damos_filter *filter,
 		struct folio *folio)
 {
 	bool matched = false;
@@ -237,8 +237,8 @@ static bool damos_pa_filter_out(struct d
 	struct damos_filter *filter;
 
 	damos_for_each_filter(filter, scheme) {
-		if (__damos_pa_filter_out(filter, folio))
-			return true;
+		if (damos_pa_filter_match(filter, folio))
+			return !filter->allow;
 	}
 	return false;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch


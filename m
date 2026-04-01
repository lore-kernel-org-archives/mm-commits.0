Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FB9395250
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 20:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775077127; cv=none; b=sCCm4xrb9wXw01Nvs8IjoDvBVcDI2r9Sl5wZRFJxEY+9/1ddj2YleK92D+lyqUT4Ij46dAS+9KxuNvuOwVfXjaYpDoZaoBf2z481zOZ/uLpMFFR4c0zn0jEOaxmO4px+VwZJW0Jjt2RxBt1Cwkr5NCf4lEP8lGxAFhLYUn1c1H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775077127; c=relaxed/simple;
	bh=UPdooDRZBmyj72gzj8XLcbHFUtfJRj+v5qMjoG4KfU4=;
	h=Date:To:From:Subject:Message-Id; b=c1i3o2uw16O6JjVzkyXRYJp3ymvwXs4KVGiviam1/Ow////GoXQ4R8roe3BR4MartJIpSXVjUPMesjlHIbXkgTVI4ZbpawsGCjqy+rjy2jUBHWKyWr+SyRPFY1YDBQd1CYUfTzR2BlBD12I073B1zkVCnEU4SEcVWMR7hw+QWbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yJnNAgnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yJnNAgnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A39FC4CEF7;
	Wed,  1 Apr 2026 20:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775077127;
	bh=UPdooDRZBmyj72gzj8XLcbHFUtfJRj+v5qMjoG4KfU4=;
	h=Date:To:From:Subject:From;
	b=yJnNAgnAIT4ofy1MALNzA+d1DHPeEYY5Cxm4vDO8iQQhPVEIX9J79hbVBjm0YNzFT
	 VYLcZMJrHow/7fA7AY8fINcOnN7/fUGlR40eJ880ZaHyAZTG/vXkrJVjceWiW4gs84
	 ct30Havcmh0BVuS9hN8yGGfJgB1CqPaMZfbNt6So=
Date: Wed, 01 Apr 2026 13:58:46 -0700
To: mm-commits@vger.kernel.org,liwang@redhat.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20260401205847.6A39FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes.patch

This patch was dropped because it was folded into selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes
Date: Tue Mar 31 04:51:23 PM PDT 2026

ERROR: code indent should use tabs where possible
#94: FILE: tools/testing/selftests/mm/hugetlb_dio.c:48:
+^I^I^I        unsigned int end_off, unsigned int align)$

Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Li Wang <liwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_dio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugetlb_dio.c~selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes
+++ a/tools/testing/selftests/mm/hugetlb_dio.c
@@ -45,7 +45,7 @@ static int get_dio_alignment(int fd)
 }
 
 static bool check_dio_alignment(unsigned int start_off,
-			        unsigned int end_off, unsigned int align)
+				unsigned int end_off, unsigned int align)
 {
 	unsigned int writesize = end_off - start_off;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

liveupdate-initialize-incoming-flb-state-before-finish-fix.patch
selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch


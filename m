Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1548B4C81
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 04:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737000246; cv=none; b=GYenq5+FAZV2uCW5u1/G5+ZTjjtDVC3oX4PKwzDVBLSXuPmCSGBDZ+nYwYQwx1chtQkp1jsvaOw+sIoSJCHAQtcQeKRci5XHtBxM+emPxZHGgB8rFzZ5STXyOdmVUOoiOFOgPxAq5QJGKomZHP7SJrgdlPoey0XQ+/YAS9Vjz5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737000246; c=relaxed/simple;
	bh=rtzUbHvOUnpYiVU0PjANQgaD9h7ZtQ1h+RyEVUlNG4w=;
	h=Date:To:From:Subject:Message-Id; b=K8/h9FXEuhKTol/Ide0HotVKyFI5cSyz/s1dAtjTQAS1w9OeGc4zqoyS9JJNNH9bSwT7LThYzf3Io20ZNvG/Umn6tIPVFoPd6ZlWX7I0uh3FujoXX3othsP6ervDlQ7TuKTSKlAXeN4N+bvXyZyRi1TeYBywvIJvUiosRntNPMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l30jizVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l30jizVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63A0C4CEE3;
	Thu, 16 Jan 2025 04:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737000245;
	bh=rtzUbHvOUnpYiVU0PjANQgaD9h7ZtQ1h+RyEVUlNG4w=;
	h=Date:To:From:Subject:From;
	b=l30jizVqPNhUtCv1ho0sKH0GmHlBEG5NrcteDBSn1jr3jv1Vs8O3TJW02187+7y1h
	 6Ddx7mtRtu97sjWrG6Ua+IAdWHUr79ntXAbFoIJuaNOJbrATgkztnEciv746Xm0wPI
	 V4+fe+O5AmwMVrbrHJ5jJpr3KBmWSii+gvFZpxKw=
Date: Wed, 15 Jan 2025 20:04:05 -0800
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,shuah@kernel.org,riel@surriel.com,alexlzhu@fb.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders-fix.patch added to mm-unstable branch
Message-Id: <20250116040405.C63A0C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders-fix.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders-fix
Date: Wed, 15 Jan 2025 21:57:59 -0500

no need to test splitting to order-1

Anonymous memory does not support order-1 folio, so there is no need to
test splitting to order-1.  Kernel will WARN_ONCE for
split_pmd_thp_to_order(1) test and the whole test will fail at that point.

Link: https://lkml.kernel.org/r/DDA202EA-4664-4F50-A7FD-B00CBB7A624B@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Alexander Zhu <alexlzhu@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders-fix
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -481,7 +481,7 @@ int main(int argc, char **argv)
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-	ksft_set_plan(1+9+2+9);
+	ksft_set_plan(1+8+2+9);
 
 	pagesize = getpagesize();
 	pageshift = ffs(pagesize) - 1;
@@ -494,7 +494,8 @@ int main(int argc, char **argv)
 	split_pmd_zero_pages();
 
 	for (i = 0; i < 9; i++)
-		split_pmd_thp_to_order(i);
+		if (i != 1)
+			split_pmd_thp_to_order(i);
 
 	split_pte_mapped_thp();
 	split_file_backed_thp();
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-use-selftests-framework-to-print-test-result.patch
selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders.patch
selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders-fix.patch


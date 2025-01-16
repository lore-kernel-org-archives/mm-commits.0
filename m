Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C862729A1
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737005984; cv=none; b=mfYJ0vlZ23t/rMKkD6+zE0E7i+GH9QULw+crNXKLdJo0RwAke92bEEtzne8yaCQt2HqmrWUAM7KkI5aHo0UF/KfpfHe8Ah0Nucp+XFBJBmJPVimnCpPWT5sVrQLg7tt8JxwwLUqjWyvhDVQGvuX6v0EIKmzNdpC2VcIRDo+gtNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737005984; c=relaxed/simple;
	bh=8A12OKBgPznuUbyTPkvqLdnP6fT9StI8UhIOsZXjP4k=;
	h=Date:To:From:Subject:Message-Id; b=omG3J3VLSuqJaNdkmmJKM7faujhceDQ64QgJYUsXG96lPkViHv6jIhUnAQCrhdWG0srIns7Vqz9Cd77FfDFezWqizVgJ1vhYqXktpnZ2gNX67rOL9eP4rFtlx1pyCCNkRG0MMXggl6HT/P4fFkT51JHfxrD+Vxzh/v++y7FMccw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W2IomaJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W2IomaJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AA8C4CED6;
	Thu, 16 Jan 2025 05:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737005984;
	bh=8A12OKBgPznuUbyTPkvqLdnP6fT9StI8UhIOsZXjP4k=;
	h=Date:To:From:Subject:From;
	b=W2IomaJucV9AvZIiLo9r9vXkH3DCJFSOFCzokxKkAgu2Xpv0jClqXxyViVdeE79R+
	 L6RkVvQ+ug8BgKh7kpAbq09tGqhuxJxkGwKh0eostbr+BV/Zm19TArErc392xnI6VB
	 sDQOdvPYkV9OoeC1duE1Q5Y2lUz22L3UFTd5Ne+Q=
Date: Wed, 15 Jan 2025 21:39:43 -0800
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,shuah@kernel.org,riel@surriel.com,alexlzhu@fb.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders-fix.patch removed from -mm tree
Message-Id: <20250116053944.47AA8C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders-fix.patch

This patch was dropped because it was folded into selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders.patch

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


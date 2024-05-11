Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20491F5F6
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467346; cv=none; b=SGpBsmyMaqfmQEaM9fsfjNcuyTD7pcM/KercGo7UZAMHx9+/t8ICfbqTCKeiVjsZkgQMcMC6LP1Yf6YaUg8Q7QPdeuNm1L8Mu03hQjjuJfPfo13qLzY+CSSZlxcBZtrSr4sFtC9djXwBJUmynY/Bdq9or54gQs1Tq5epXULY9M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467346; c=relaxed/simple;
	bh=ntsCQOtfmmcB+nPLegkKg5Rl4Kz6zmniGANBiQ5GB4w=;
	h=Date:To:From:Subject:Message-Id; b=YGIO0s4TXyEgELcBAScuwRBbjw+b9mdjaTEEJhqIypRhJ1iK6FxRndAodH+cAdtlMvSCU3F5XOVyHDTVWXL6J+V0jywLK+S6LKWjHhHcQR9LTyVX0BUpt4v9dqRRho9Ui7yi4UDgOCmqWL1ZXd38Lo4vRLS+Nz4RVuaYJHE7JTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tkr4CvP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tkr4CvP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98CAC32782;
	Sat, 11 May 2024 22:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467345;
	bh=ntsCQOtfmmcB+nPLegkKg5Rl4Kz6zmniGANBiQ5GB4w=;
	h=Date:To:From:Subject:From;
	b=tkr4CvP+J7RiWr45p0XNa17vEBhuljpFYc2D26aKx+QnUhnJvf72MIbptA1hke0Mi
	 tqhXqTGu0Ar9de+uusjR/6ZNykT7qHSv7E9O3rrSTsAFh9eQ3uMv36R1CX5OkCs86I
	 wb9cOQLdMYFPKLj7vQKNNfQ0XspaSUT8oE/s1JLk=
Date: Sat, 11 May 2024 15:42:25 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugetlb_madv_vs_map-avoid-test-skipping-by-querying-hugepage-size-at-runtime.patch removed from -mm tree
Message-Id: <20240511224225.B98CAC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hugetlb_madv_vs_map: avoid test skipping by querying hugepage size at runtime
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugetlb_madv_vs_map-avoid-test-skipping-by-querying-hugepage-size-at-runtime.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: hugetlb_madv_vs_map: avoid test skipping by querying hugepage size at runtime
Date: Thu, 9 May 2024 15:24:47 +0530

Currently, the size used in mmap() is statically defined, leading to
skipping of the test on a hugepage size other than 2 MB, since munmap()
won't free the hugepage for a size greater than 2 MB.  Hence, query the
size at runtime.

Also, there is no reason why a hugepage allocation should fail, since we
are using a simple mmap() using MAP_HUGETLB; hence, instead of skipping
the test, make it fail.

Link: https://lkml.kernel.org/r/20240509095447.3791573-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_madv_vs_map.c |   16 +++++++------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c~selftests-mm-hugetlb_madv_vs_map-avoid-test-skipping-by-querying-hugepage-size-at-runtime
+++ a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -27,9 +27,9 @@
 #include "vm_util.h"
 #include "../kselftest.h"
 
-#define MMAP_SIZE (1 << 21)
 #define INLOOP_ITER 100
 
+size_t mmap_size;
 char *huge_ptr;
 
 /* Touch the memory while it is being madvised() */
@@ -44,7 +44,7 @@ void *touch(void *unused)
 void *madv(void *unused)
 {
 	for (int i = 0; i < INLOOP_ITER; i++)
-		madvise(huge_ptr, MMAP_SIZE, MADV_DONTNEED);
+		madvise(huge_ptr, mmap_size, MADV_DONTNEED);
 
 	return NULL;
 }
@@ -59,7 +59,7 @@ void *map_extra(void *unused)
 	void *ptr;
 
 	for (int i = 0; i < INLOOP_ITER; i++) {
-		ptr = mmap(NULL, MMAP_SIZE, PROT_READ | PROT_WRITE,
+		ptr = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
 			   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
 			   -1, 0);
 
@@ -93,14 +93,16 @@ int main(void)
 			       free_hugepages);
 	}
 
+	mmap_size = default_huge_page_size();
+
 	while (max--) {
-		huge_ptr = mmap(NULL, MMAP_SIZE, PROT_READ | PROT_WRITE,
+		huge_ptr = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
 				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
 				-1, 0);
 
 		if ((unsigned long)huge_ptr == -1) {
-			ksft_exit_skip("Failed to allocated huge page\n");
-			return KSFT_SKIP;
+			ksft_test_result_fail("Failed to allocate huge page\n");
+			return KSFT_FAIL;
 		}
 
 		pthread_create(&thread1, NULL, madv, NULL);
@@ -117,7 +119,7 @@ int main(void)
 		}
 
 		/* Unmap and restart */
-		munmap(huge_ptr, MMAP_SIZE);
+		munmap(huge_ptr, mmap_size);
 	}
 
 	return KSFT_PASS;
_

Patches currently in -mm which might be from dev.jain@arm.com are



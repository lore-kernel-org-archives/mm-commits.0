Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1191A2C35
	for <mm-commits@vger.kernel.org>; Thu,  9 May 2024 18:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715279557; cv=none; b=kfsYVlBZCu0VoZgvY6OGbd9AosVHAYlNRmrfhyfcJC2DICyFDRhCCmClWaaCd6IrnMrEKp+Czk7KLd9IGGC1w+4Wxh0W6nlZNp4UCU9Hn/BKsT5sPuuvvR/GTl8ohrZaFdL+ARo/A1bjhCatvnHuZEHUwZeyRaAumQIWuFlwCxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715279557; c=relaxed/simple;
	bh=bsVC3Pn+mPpUWMw2Pd/Yek/v9raIBUKf+1cfpUVyZSk=;
	h=Date:To:From:Subject:Message-Id; b=Ecv4kpyLwUfQJuE7KAAXT4Cc0bqwAcqB/eU0zYYxAXraoRrhwJF4zmyGlnawm90kTGWMtdJLU0BZKn2utXzFdfMOIpx2XRT8go3F0jmMyu+3E8SkMq9KPLN04ns0AKoigkUbCJrzrVwmJvcTG3M9+ZFEN1tKszIb31/XwrKFbvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pT1gr+5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pT1gr+5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D5AC116B1;
	Thu,  9 May 2024 18:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715279556;
	bh=bsVC3Pn+mPpUWMw2Pd/Yek/v9raIBUKf+1cfpUVyZSk=;
	h=Date:To:From:Subject:From;
	b=pT1gr+5IS6y7J69sOQ2Z0izBvG9Dt5R/3N/ZhEA9h4Pgd2GiBRga6URiKjAOA200s
	 2PX7IsNnNLznhdtu2WgtIg8/GVKbhefh2MZZWVSLjyibwlhl7WbjU8oV2PRZvTXOFD
	 FxyalMadZPfjFuqh13mtDj1sp0Chcq/gm7gu9WNc=
Date: Thu, 09 May 2024 11:32:35 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hugetlb_madv_vs_map-avoid-test-skipping-by-querying-hugepage-size-at-runtime.patch added to mm-unstable branch
Message-Id: <20240509183236.A5D5AC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hugetlb_madv_vs_map: avoid test skipping by querying hugepage size at runtime
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-hugetlb_madv_vs_map-avoid-test-skipping-by-querying-hugepage-size-at-runtime.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hugetlb_madv_vs_map-avoid-test-skipping-by-querying-hugepage-size-at-runtime.patch

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

selftests-mm-hugetlb_madv_vs_map-avoid-test-skipping-by-querying-hugepage-size-at-runtime.patch


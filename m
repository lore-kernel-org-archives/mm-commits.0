Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B04153BD9
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619851; cv=none; b=HyUFqg+8ITxll01nPKuca6KZHqflpdDGp3bKCdq4yM9e9+LZrz/yneWc8e9OltCfDfcpKwHT8LQNeAQjNUTvOloG9LwjtKmZMBlO9vLRnJxY1eRgejYTEA7t8JLtYFaflvApTGTXtAL6n+imZpBqnq9/QbTG9Q8lrTQASChWhjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619851; c=relaxed/simple;
	bh=gWMuoELLBCmNyQfo22WTY9fRcoCXoVYxaRKM/MBAYn4=;
	h=Date:To:From:Subject:Message-Id; b=jvr8bOOa4NPEFdgxD177TcKeUWKnHbHa8biCaU1tLXQmNifI05CuIJLvn94sk6/Y9dg6Xq7Uc8mLb9uEguCtoI9687LL35pUmJwcQJgeMFkm7l9CH0jr0hQG2yuqnB5zTdfxKRF4TziH492Os5N6BnsUDWKJFmCLRFW+u/RDfWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XnkA42Cj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XnkA42Cj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A4FC4CEDD;
	Sat, 22 Mar 2025 05:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619850;
	bh=gWMuoELLBCmNyQfo22WTY9fRcoCXoVYxaRKM/MBAYn4=;
	h=Date:To:From:Subject:From;
	b=XnkA42Cj9PLWfjJQNv91WO3kNhuOjC4oYKXy/lyPBKMZRnE5gRW3PxMPkd+b6EQtq
	 A3rZSt912l/5BEpPA+bCfr8OprVlwj8fqmr6Bo/8F3DXuwr5DA6cyCvo/rtzLHeP2n
	 Lkbgm23mHUI2tZeJevfu7fWyFYDxsHfgCiNxotUQ=
Date: Fri, 21 Mar 2025 22:04:10 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,raquini@redhat.com,peterx@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-uffd-unit-tests-support-for-hugepages-2m.patch removed from -mm tree
Message-Id: <20250322050410.97A4FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: uffd-unit-tests support for hugepages > 2M
has been removed from the -mm tree.  Its filename was
     selftests-mm-uffd-unit-tests-support-for-hugepages-2m.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: uffd-unit-tests support for hugepages > 2M
Date: Tue, 18 Mar 2025 17:43:40 +0000

uffd-unit-tests uses a memory area with a fixed 32M size.  Then it
calculates the number of pages by dividing by page_size, which itself is
either the base page size or the PMD huge page size depending on the test
config.  For the latter, we end up with nr_pages=1 for arm64 16K base
pages, and nr_pages=0 for 64K base pages.  This doesn't end well.

So let's make the 32M size a floor and also ensure that we have at least 2
pages given the PMD size.  With this change, the tests pass on arm64 64K
base page size configuration.

Link: https://lkml.kernel.org/r/20250318174343.243631-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Rafael Aquini <raquini@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-uffd-unit-tests-support-for-hugepages-2m
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -26,6 +26,8 @@
 #define ALIGN_UP(x, align_to) \
 	((__typeof__(x))((((unsigned long)(x)) + ((align_to)-1)) & ~((align_to)-1)))
 
+#define MAX(a, b) (((a) > (b)) ? (a) : (b))
+
 struct mem_type {
 	const char *name;
 	unsigned int mem_flag;
@@ -196,7 +198,8 @@ uffd_setup_environment(uffd_test_args_t
 	else
 		page_size = psize();
 
-	nr_pages = UFFD_TEST_MEM_SIZE / page_size;
+	/* Ensure we have at least 2 pages */
+	nr_pages = MAX(UFFD_TEST_MEM_SIZE, page_size * 2) / page_size;
 	/* TODO: remove this global var.. it's so ugly */
 	nr_parallel = 1;
 
_

Patches currently in -mm which might be from ryan.roberts@arm.com are



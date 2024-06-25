Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C69143741
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291570; cv=none; b=ntO5T2qHSeWp+5yi+gPhJFWcVhQki7NMOjpIX6Favl9TfRFECHAOIK0VUOUCBrcO8OClZCGdOY27lwXhdTsVYxCrr27vnBy1wAKXB8QZFFKUN4cL/qkpAgXXU04Wzl4xFEMPN+hvVXyry0OL1g2+nIFU6tENpEmE6NY1BuqbDZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291570; c=relaxed/simple;
	bh=l+zBfjjMlD+IMSjO9Yvn25xgJWyKti3vAeDCGpAAVOo=;
	h=Date:To:From:Subject:Message-Id; b=Xm4kOVXkMCdYyUXhxFjnHTU01WYiq/K2HKwToTsUY+3AcO7u088hY85lO0l35Vgqtq6EXsMryWU30emgJOiMcXch5Jn0NbkP05UBP7Nc3NzEumxeuQEjTBrZrtfXY4Qltw8+Hg6Uo1C3iWGpHOfMYhrmx4laVBIGQfsbZnLf5VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IE3q+JZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IE3q+JZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA414C32782;
	Tue, 25 Jun 2024 04:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291569;
	bh=l+zBfjjMlD+IMSjO9Yvn25xgJWyKti3vAeDCGpAAVOo=;
	h=Date:To:From:Subject:From;
	b=IE3q+JZ6Zyb8ZSrMH7zWEiLFpBadncaxgPFhdlnUaObYx7cR5/c2kwm+ImTkkn/Lj
	 12RWKVTldnrf9kmP7tYXDqV2E3Q6O3gRCZxSR3yqDH/NGsDtvbtNrx2qBKP8X3bR/f
	 N0xMBU8OnqoVhXDlz9KCoibGJnEFsfilA83U6KOY=
Date: Mon, 24 Jun 2024 21:59:29 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,kirill.shutemov@linux.intel.com,anshuman.khandual@arm.com,akpm@linux-foundation.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-va_high_addr_switch-dynamically-initialize-testcases-to-enable-lpa2-testing.patch removed from -mm tree
Message-Id: <20240625045929.BA414C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: va_high_addr_switch: dynamically initialize testcases to enable LPA2 testing
has been removed from the -mm tree.  Its filename was
     selftests-mm-va_high_addr_switch-dynamically-initialize-testcases-to-enable-lpa2-testing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: va_high_addr_switch: dynamically initialize testcases to enable LPA2 testing
Date: Wed, 22 May 2024 12:34:35 +0530

Post FEAT_LPA2, the Aarch64 Linux kernel extends higher address support to
4K and 16K translation granules.  To support testing this out, we need to
do away with static initialization of page size, while still maintaining
the nice array of testcases; this can be achieved by initializing and
populating the array as a stack variable, and filling in the page size and
hugepage size at runtime.

Link: https://lkml.kernel.org/r/20240522070435.773918-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.c |  454 ++++++-------
 1 file changed, 232 insertions(+), 222 deletions(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.c~selftests-mm-va_high_addr_switch-dynamically-initialize-testcases-to-enable-lpa2-testing
+++ a/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -9,26 +9,9 @@
 #include <sys/mman.h>
 #include <string.h>
 
+#include "vm_util.h"
 #include "../kselftest.h"
 
-#ifdef __powerpc64__
-#define PAGE_SIZE	(64 << 10)
-/*
- * This will work with 16M and 2M hugepage size
- */
-#define HUGETLB_SIZE	(16 << 20)
-#elif __aarch64__
-/*
- * The default hugepage size for 64k base pagesize
- * is 512MB.
- */
-#define PAGE_SIZE	(64 << 10)
-#define HUGETLB_SIZE	(512 << 20)
-#else
-#define PAGE_SIZE	(4 << 10)
-#define HUGETLB_SIZE	(2 << 20)
-#endif
-
 /*
  * The hint addr value is used to allocate addresses
  * beyond the high address switch boundary.
@@ -37,18 +20,8 @@
 #define ADDR_MARK_128TB	(1UL << 47)
 #define ADDR_MARK_256TB	(1UL << 48)
 
-#define HIGH_ADDR_128TB	((void *) (1UL << 48))
-#define HIGH_ADDR_256TB	((void *) (1UL << 49))
-
-#define LOW_ADDR	((void *) (1UL << 30))
-
-#ifdef __aarch64__
-#define ADDR_SWITCH_HINT ADDR_MARK_256TB
-#define HIGH_ADDR	 HIGH_ADDR_256TB
-#else
-#define ADDR_SWITCH_HINT ADDR_MARK_128TB
-#define HIGH_ADDR	 HIGH_ADDR_128TB
-#endif
+#define HIGH_ADDR_128TB	(1UL << 48)
+#define HIGH_ADDR_256TB	(1UL << 49)
 
 struct testcase {
 	void *addr;
@@ -59,195 +32,230 @@ struct testcase {
 	unsigned int keep_mapped:1;
 };
 
-static struct testcase testcases[] = {
-	{
-		/*
-		 * If stack is moved, we could possibly allocate
-		 * this at the requested address.
-		 */
-		.addr = ((void *)(ADDR_SWITCH_HINT - PAGE_SIZE)),
-		.size = PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(ADDR_SWITCH_HINT - PAGE_SIZE, PAGE_SIZE)",
-		.low_addr_required = 1,
-	},
-	{
-		/*
-		 * Unless MAP_FIXED is specified, allocation based on hint
-		 * addr is never at requested address or above it, which is
-		 * beyond high address switch boundary in this case. Instead,
-		 * a suitable allocation is found in lower address space.
-		 */
-		.addr = ((void *)(ADDR_SWITCH_HINT - PAGE_SIZE)),
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(ADDR_SWITCH_HINT - PAGE_SIZE, (2 * PAGE_SIZE))",
-		.low_addr_required = 1,
-	},
-	{
-		/*
-		 * Exact mapping at high address switch boundary, should
-		 * be obtained even without MAP_FIXED as area is free.
-		 */
-		.addr = ((void *)(ADDR_SWITCH_HINT)),
-		.size = PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(ADDR_SWITCH_HINT, PAGE_SIZE)",
-		.keep_mapped = 1,
-	},
-	{
-		.addr = (void *)(ADDR_SWITCH_HINT),
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
-		.msg = "mmap(ADDR_SWITCH_HINT, 2 * PAGE_SIZE, MAP_FIXED)",
-	},
-	{
-		.addr = NULL,
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(NULL)",
-		.low_addr_required = 1,
-	},
-	{
-		.addr = LOW_ADDR,
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(LOW_ADDR)",
-		.low_addr_required = 1,
-	},
-	{
-		.addr = HIGH_ADDR,
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(HIGH_ADDR)",
-		.keep_mapped = 1,
-	},
-	{
-		.addr = HIGH_ADDR,
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(HIGH_ADDR) again",
-		.keep_mapped = 1,
-	},
-	{
-		.addr = HIGH_ADDR,
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
-		.msg = "mmap(HIGH_ADDR, MAP_FIXED)",
-	},
-	{
-		.addr = (void *) -1,
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(-1)",
-		.keep_mapped = 1,
-	},
-	{
-		.addr = (void *) -1,
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(-1) again",
-	},
-	{
-		.addr = ((void *)(ADDR_SWITCH_HINT - PAGE_SIZE)),
-		.size = PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(ADDR_SWITCH_HINT - PAGE_SIZE, PAGE_SIZE)",
-		.low_addr_required = 1,
-	},
-	{
-		.addr = (void *)(ADDR_SWITCH_HINT - PAGE_SIZE),
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(ADDR_SWITCH_HINT - PAGE_SIZE, 2 * PAGE_SIZE)",
-		.low_addr_required = 1,
-		.keep_mapped = 1,
-	},
-	{
-		.addr = (void *)(ADDR_SWITCH_HINT - PAGE_SIZE / 2),
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(ADDR_SWITCH_HINT - PAGE_SIZE/2 , 2 * PAGE_SIZE)",
-		.low_addr_required = 1,
-		.keep_mapped = 1,
-	},
-	{
-		.addr = ((void *)(ADDR_SWITCH_HINT)),
-		.size = PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(ADDR_SWITCH_HINT, PAGE_SIZE)",
-	},
-	{
-		.addr = (void *)(ADDR_SWITCH_HINT),
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
-		.msg = "mmap(ADDR_SWITCH_HINT, 2 * PAGE_SIZE, MAP_FIXED)",
-	},
-};
+static struct testcase *testcases;
+static struct testcase *hugetlb_testcases;
+static int sz_testcases, sz_hugetlb_testcases;
+static unsigned long switch_hint;
 
-static struct testcase hugetlb_testcases[] = {
-	{
-		.addr = NULL,
-		.size = HUGETLB_SIZE,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(NULL, MAP_HUGETLB)",
-		.low_addr_required = 1,
-	},
-	{
-		.addr = LOW_ADDR,
-		.size = HUGETLB_SIZE,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(LOW_ADDR, MAP_HUGETLB)",
-		.low_addr_required = 1,
-	},
-	{
-		.addr = HIGH_ADDR,
-		.size = HUGETLB_SIZE,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(HIGH_ADDR, MAP_HUGETLB)",
-		.keep_mapped = 1,
-	},
-	{
-		.addr = HIGH_ADDR,
-		.size = HUGETLB_SIZE,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(HIGH_ADDR, MAP_HUGETLB) again",
-		.keep_mapped = 1,
-	},
-	{
-		.addr = HIGH_ADDR,
-		.size = HUGETLB_SIZE,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
-		.msg = "mmap(HIGH_ADDR, MAP_FIXED | MAP_HUGETLB)",
-	},
-	{
-		.addr = (void *) -1,
-		.size = HUGETLB_SIZE,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(-1, MAP_HUGETLB)",
-		.keep_mapped = 1,
-	},
-	{
-		.addr = (void *) -1,
-		.size = HUGETLB_SIZE,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(-1, MAP_HUGETLB) again",
-	},
-	{
-		.addr = (void *)(ADDR_SWITCH_HINT - PAGE_SIZE),
-		.size = 2 * HUGETLB_SIZE,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(ADDR_SWITCH_HINT - PAGE_SIZE, 2*HUGETLB_SIZE, MAP_HUGETLB)",
-		.low_addr_required = 1,
-		.keep_mapped = 1,
-	},
-	{
-		.addr = (void *)(ADDR_SWITCH_HINT),
-		.size = 2 * HUGETLB_SIZE,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
-		.msg = "mmap(ADDR_SWITCH_HINT , 2*HUGETLB_SIZE, MAP_FIXED | MAP_HUGETLB)",
-	},
-};
+/* Initialize testcases inside a function to compute parameters at runtime */
+void testcases_init(void)
+{
+	unsigned long pagesize = getpagesize();
+	unsigned long hugepagesize = default_huge_page_size();
+	unsigned long low_addr = (1UL << 30);
+	unsigned long addr_switch_hint = ADDR_MARK_128TB;
+	unsigned long high_addr = HIGH_ADDR_128TB;
+
+#ifdef __aarch64__
+
+	/* Post LPA2, the lower userspace VA on a 16K pagesize is 47 bits. */
+	if (pagesize != (16UL << 10)) {
+		addr_switch_hint = ADDR_MARK_256TB;
+		high_addr = HIGH_ADDR_256TB;
+	}
+#endif
+
+	struct testcase t[] = {
+		{
+			/*
+			 * If stack is moved, we could possibly allocate
+			 * this at the requested address.
+			 */
+			.addr = ((void *)(addr_switch_hint - pagesize)),
+			.size = pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(addr_switch_hint - pagesize, pagesize)",
+			.low_addr_required = 1,
+		},
+		{
+			/*
+			 * Unless MAP_FIXED is specified, allocation based on hint
+			 * addr is never at requested address or above it, which is
+			 * beyond high address switch boundary in this case. Instead,
+			 * a suitable allocation is found in lower address space.
+			 */
+			.addr = ((void *)(addr_switch_hint - pagesize)),
+			.size = 2 * pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(addr_switch_hint - pagesize, (2 * pagesize))",
+			.low_addr_required = 1,
+		},
+		{
+			/*
+			 * Exact mapping at high address switch boundary, should
+			 * be obtained even without MAP_FIXED as area is free.
+			 */
+			.addr = ((void *)(addr_switch_hint)),
+			.size = pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(addr_switch_hint, pagesize)",
+			.keep_mapped = 1,
+		},
+		{
+			.addr = (void *)(addr_switch_hint),
+			.size = 2 * pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
+			.msg = "mmap(addr_switch_hint, 2 * pagesize, MAP_FIXED)",
+		},
+		{
+			.addr = NULL,
+			.size = 2 * pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(NULL)",
+			.low_addr_required = 1,
+		},
+		{
+			.addr = (void *)low_addr,
+			.size = 2 * pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(low_addr)",
+			.low_addr_required = 1,
+		},
+		{
+			.addr = (void *)high_addr,
+			.size = 2 * pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(high_addr)",
+			.keep_mapped = 1,
+		},
+		{
+			.addr = (void *)high_addr,
+			.size = 2 * pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(high_addr) again",
+			.keep_mapped = 1,
+		},
+		{
+			.addr = (void *)high_addr,
+			.size = 2 * pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
+			.msg = "mmap(high_addr, MAP_FIXED)",
+		},
+		{
+			.addr = (void *) -1,
+			.size = 2 * pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(-1)",
+			.keep_mapped = 1,
+		},
+		{
+			.addr = (void *) -1,
+			.size = 2 * pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(-1) again",
+		},
+		{
+			.addr = ((void *)(addr_switch_hint - pagesize)),
+			.size = pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(addr_switch_hint - pagesize, pagesize)",
+			.low_addr_required = 1,
+		},
+		{
+			.addr = (void *)(addr_switch_hint - pagesize),
+			.size = 2 * pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(addr_switch_hint - pagesize, 2 * pagesize)",
+			.low_addr_required = 1,
+			.keep_mapped = 1,
+		},
+		{
+			.addr = (void *)(addr_switch_hint - pagesize / 2),
+			.size = 2 * pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(addr_switch_hint - pagesize/2 , 2 * pagesize)",
+			.low_addr_required = 1,
+			.keep_mapped = 1,
+		},
+		{
+			.addr = ((void *)(addr_switch_hint)),
+			.size = pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(addr_switch_hint, pagesize)",
+		},
+		{
+			.addr = (void *)(addr_switch_hint),
+			.size = 2 * pagesize,
+			.flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
+			.msg = "mmap(addr_switch_hint, 2 * pagesize, MAP_FIXED)",
+		},
+	};
+
+	struct testcase ht[] = {
+		{
+			.addr = NULL,
+			.size = hugepagesize,
+			.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(NULL, MAP_HUGETLB)",
+			.low_addr_required = 1,
+		},
+		{
+			.addr = (void *)low_addr,
+			.size = hugepagesize,
+			.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(low_addr, MAP_HUGETLB)",
+			.low_addr_required = 1,
+		},
+		{
+			.addr = (void *)high_addr,
+			.size = hugepagesize,
+			.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(high_addr, MAP_HUGETLB)",
+			.keep_mapped = 1,
+		},
+		{
+			.addr = (void *)high_addr,
+			.size = hugepagesize,
+			.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(high_addr, MAP_HUGETLB) again",
+			.keep_mapped = 1,
+		},
+		{
+			.addr = (void *)high_addr,
+			.size = hugepagesize,
+			.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
+			.msg = "mmap(high_addr, MAP_FIXED | MAP_HUGETLB)",
+		},
+		{
+			.addr = (void *) -1,
+			.size = hugepagesize,
+			.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(-1, MAP_HUGETLB)",
+			.keep_mapped = 1,
+		},
+		{
+			.addr = (void *) -1,
+			.size = hugepagesize,
+			.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(-1, MAP_HUGETLB) again",
+		},
+		{
+			.addr = (void *)(addr_switch_hint - pagesize),
+			.size = 2 * hugepagesize,
+			.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
+			.msg = "mmap(addr_switch_hint - pagesize, 2*hugepagesize, MAP_HUGETLB)",
+			.low_addr_required = 1,
+			.keep_mapped = 1,
+		},
+		{
+			.addr = (void *)(addr_switch_hint),
+			.size = 2 * hugepagesize,
+			.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
+			.msg = "mmap(addr_switch_hint , 2*hugepagesize, MAP_FIXED | MAP_HUGETLB)",
+		},
+	};
+
+	testcases = malloc(sizeof(t));
+	hugetlb_testcases = malloc(sizeof(ht));
+
+	/* Copy into global arrays */
+	memcpy(testcases, t, sizeof(t));
+	memcpy(hugetlb_testcases, ht, sizeof(ht));
+
+	sz_testcases = ARRAY_SIZE(t);
+	sz_hugetlb_testcases = ARRAY_SIZE(ht);
+	switch_hint = addr_switch_hint;
+}
 
 static int run_test(struct testcase *test, int count)
 {
@@ -267,7 +275,7 @@ static int run_test(struct testcase *tes
 			continue;
 		}
 
-		if (t->low_addr_required && p >= (void *)(ADDR_SWITCH_HINT)) {
+		if (t->low_addr_required && p >= (void *)(switch_hint)) {
 			printf("FAILED\n");
 			ret = KSFT_FAIL;
 		} else {
@@ -292,7 +300,7 @@ static int supported_arch(void)
 #elif defined(__x86_64__)
 	return 1;
 #elif defined(__aarch64__)
-	return getpagesize() == PAGE_SIZE;
+	return 1;
 #else
 	return 0;
 #endif
@@ -305,8 +313,10 @@ int main(int argc, char **argv)
 	if (!supported_arch())
 		return KSFT_SKIP;
 
-	ret = run_test(testcases, ARRAY_SIZE(testcases));
+	testcases_init();
+
+	ret = run_test(testcases, sz_testcases);
 	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
-		ret = run_test(hugetlb_testcases, ARRAY_SIZE(hugetlb_testcases));
+		ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
 	return ret;
 }
_

Patches currently in -mm which might be from dev.jain@arm.com are



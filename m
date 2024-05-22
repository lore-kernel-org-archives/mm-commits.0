Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EC957C8E
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 17:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716400489; cv=none; b=Yq+qpW7/vvlfSs+s6EyelaQ2+UPz7HHveKTjCnf+qL3M59o3E9H2FyI1iZBmMBaCJ0zG4ZmgT8ZcOKco5s7EupTSdbHMQLRRcCZVd3R1T0XhWVEs8PkM/WoS4LXaLHCcBZ+rWkEOblUq3FoOWZ5r/FXoXvrbBCHHly6Tz8UmUD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716400489; c=relaxed/simple;
	bh=9ROcf/sbzgNQYriECmcOuXceHDD4G3pO6u09CVyllfE=;
	h=Date:To:From:Subject:Message-Id; b=gNE31fZObZr06aUho6HTXR8L79qhVeDbLH/zYxtqX8S2sDNxL+ruBRhk+lKc6JcxH6oJzCgFbJWZXSTz08qEChtCQPHBAufkwWdLb9+pbiBNjyypg3c7mre63MyB+BFamq62+pMFEkwn4/PwoskckvesTcjjZWNUJfVFLTcQb8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UjqYCW/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UjqYCW/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504FCC2BBFC;
	Wed, 22 May 2024 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716400489;
	bh=9ROcf/sbzgNQYriECmcOuXceHDD4G3pO6u09CVyllfE=;
	h=Date:To:From:Subject:From;
	b=UjqYCW/sVvTgfUcYise7dc3c0EiImivDY8AeB8kgL+ZRM5wKwjSUkG+IqjxFlwrhH
	 3nlSuDVtYbTAhbp6FFgyyj/rqxhYmYziv27QFxd3zNIfZu4syY4Dt8AZTf+3APbU4E
	 cY6sOkLGthkztkp4KviutkXkEgp2pISJo0D/yksM=
Date: Wed, 22 May 2024 10:54:48 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,kirill.shutemov@linux.intel.com,anshuman.khandual@arm.com,akpm@linux-foundation.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-va_high_addr_switch-dynamically-initialize-testcases-to-enable-lpa2-testing.patch added to mm-unstable branch
Message-Id: <20240522175449.504FCC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: va_high_addr_switch: dynamically initialize testcases to enable LPA2 testing
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-va_high_addr_switch-dynamically-initialize-testcases-to-enable-lpa2-testing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-va_high_addr_switch-dynamically-initialize-testcases-to-enable-lpa2-testing.patch

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

selftests-mm-compaction_test-fix-bogus-test-success-on-aarch64.patch
selftests-mm-compaction_test-fix-incorrect-write-of-zero-to-nr_hugepages.patch
selftests-mm-compaction_test-fix-bogus-test-success-and-reduce-probability-of-oom-killer-invocation.patch
selftests-mm-va_high_addr_switch-reduce-test-noise.patch
selftests-mm-va_high_addr_switch-dynamically-initialize-testcases-to-enable-lpa2-testing.patch


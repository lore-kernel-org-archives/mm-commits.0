From: akpm@linux-foundation.org
Subject: +
 selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory.patch added
 to -mm tree
Date: Mon, 27 Nov 2017 17:11:12 -0800
Message-ID: <5a1cb7b0.ITXof7H16asI9DMY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52230 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752452AbdK1BLQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 20:11:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, shuah@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: move 128TB mmap boundary test to generic directory
has been added to the -mm tree.  Its filename is
     selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: selftests/vm: move 128TB mmap boundary test to generic directory

Architectures like ppc64 do support mmap hint addr based large address
space selection.  This test can be run on those architectures too.  Move
the test to selftest/vm so that other archs can use the same.

We also add a few new test scenarios in this patch.  We do test few
boundary condition before we do a high address mmap.  ppc64 use the addr
limit to validate addr in the fault path.  We had bugs in this area w.r.t
slb fault handling before we updated the addr limit.

We also touch the allocated space to make sure we don't have any bugs in
the fault handling path.

Link: http://lkml.kernel.org/r/20171123165226.32582-1-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile         |    1 
 tools/testing/selftests/vm/run_vmtests      |   11 
 tools/testing/selftests/vm/va_128TBswitch.c |  297 ++++++++++++++++++
 tools/testing/selftests/x86/5lvl.c          |  177 ----------
 4 files changed, 309 insertions(+), 177 deletions(-)

diff -puN tools/testing/selftests/vm/Makefile~selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory
+++ a/tools/testing/selftests/vm/Makefile
@@ -19,6 +19,7 @@ TEST_GEN_FILES += userfaultfd
 TEST_GEN_FILES += mlock-random-test
 TEST_GEN_FILES += virtual_address_range
 TEST_GEN_FILES += gup_benchmark
+TEST_GEN_FILES += va_128TBswitch
 
 TEST_PROGS := run_vmtests
 
diff -puN tools/testing/selftests/vm/run_vmtests~selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory tools/testing/selftests/vm/run_vmtests
--- a/tools/testing/selftests/vm/run_vmtests~selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -177,4 +177,15 @@ else
 	echo "[PASS]"
 fi
 
+echo "-----------------------------"
+echo "running virtual address 128TB switch test"
+echo "-----------------------------"
+./va_128TBswitch
+if [ $? -ne 0 ]; then
+    echo "[FAIL]"
+    exitcode=1
+else
+    echo "[PASS]"
+fi
+
 exit $exitcode
diff -puN /dev/null tools/testing/selftests/vm/va_128TBswitch.c
--- /dev/null
+++ a/tools/testing/selftests/vm/va_128TBswitch.c
@@ -0,0 +1,297 @@
+/*
+ *
+ * Authors: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
+ * Authors: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#include <stdio.h>
+#include <sys/mman.h>
+#include <string.h>
+
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+
+#ifdef __powerpc64__
+#define PAGE_SIZE	(64 << 10)
+/*
+ * This will work with 16M and 2M hugepage size
+ */
+#define HUGETLB_SIZE	(16 << 20)
+#else
+#define PAGE_SIZE	(4 << 10)
+#define HUGETLB_SIZE	(2 << 20)
+#endif
+
+/*
+ * >= 128TB is the hint addr value we used to select
+ * large address space.
+ */
+#define ADDR_SWITCH_HINT (1UL << 47)
+#define LOW_ADDR	((void *) (1UL << 30))
+#define HIGH_ADDR	((void *) (1UL << 48))
+
+struct testcase {
+	void *addr;
+	unsigned long size;
+	unsigned long flags;
+	const char *msg;
+	unsigned int low_addr_required:1;
+	unsigned int keep_mapped:1;
+};
+
+static struct testcase testcases[] = {
+	{
+		/*
+		 * If stack is moved, we could possibly allocate
+		 * this at the requested address.
+		 */
+		.addr = ((void *)(ADDR_SWITCH_HINT - PAGE_SIZE)),
+		.size = PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(ADDR_SWITCH_HINT - PAGE_SIZE, PAGE_SIZE)",
+		.low_addr_required = 1,
+	},
+	{
+		/*
+		 * We should never allocate at the requested address or above it
+		 * The len cross the 128TB boundary. Without MAP_FIXED
+		 * we will always search in the lower address space.
+		 */
+		.addr = ((void *)(ADDR_SWITCH_HINT - PAGE_SIZE)),
+		.size = 2 * PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(ADDR_SWITCH_HINT - PAGE_SIZE, (2 * PAGE_SIZE))",
+		.low_addr_required = 1,
+	},
+	{
+		/*
+		 * Exact mapping at 128TB, the area is free we should get that
+		 * even without MAP_FIXED.
+		 */
+		.addr = ((void *)(ADDR_SWITCH_HINT)),
+		.size = PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(ADDR_SWITCH_HINT, PAGE_SIZE)",
+		.keep_mapped = 1,
+	},
+	{
+		.addr = (void *)(ADDR_SWITCH_HINT),
+		.size = 2 * PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
+		.msg = "mmap(ADDR_SWITCH_HINT, 2 * PAGE_SIZE, MAP_FIXED)",
+	},
+	{
+		.addr = NULL,
+		.size = 2 * PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(NULL)",
+		.low_addr_required = 1,
+	},
+	{
+		.addr = LOW_ADDR,
+		.size = 2 * PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(LOW_ADDR)",
+		.low_addr_required = 1,
+	},
+	{
+		.addr = HIGH_ADDR,
+		.size = 2 * PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(HIGH_ADDR)",
+		.keep_mapped = 1,
+	},
+	{
+		.addr = HIGH_ADDR,
+		.size = 2 * PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(HIGH_ADDR) again",
+		.keep_mapped = 1,
+	},
+	{
+		.addr = HIGH_ADDR,
+		.size = 2 * PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
+		.msg = "mmap(HIGH_ADDR, MAP_FIXED)",
+	},
+	{
+		.addr = (void *) -1,
+		.size = 2 * PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(-1)",
+		.keep_mapped = 1,
+	},
+	{
+		.addr = (void *) -1,
+		.size = 2 * PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(-1) again",
+	},
+	{
+		.addr = ((void *)(ADDR_SWITCH_HINT - PAGE_SIZE)),
+		.size = PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(ADDR_SWITCH_HINT - PAGE_SIZE, PAGE_SIZE)",
+		.low_addr_required = 1,
+	},
+	{
+		.addr = (void *)(ADDR_SWITCH_HINT - PAGE_SIZE),
+		.size = 2 * PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(ADDR_SWITCH_HINT - PAGE_SIZE, 2 * PAGE_SIZE)",
+		.low_addr_required = 1,
+		.keep_mapped = 1,
+	},
+	{
+		.addr = (void *)(ADDR_SWITCH_HINT - PAGE_SIZE / 2),
+		.size = 2 * PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(ADDR_SWITCH_HINT - PAGE_SIZE/2 , 2 * PAGE_SIZE)",
+		.low_addr_required = 1,
+		.keep_mapped = 1,
+	},
+	{
+		.addr = ((void *)(ADDR_SWITCH_HINT)),
+		.size = PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(ADDR_SWITCH_HINT, PAGE_SIZE)",
+	},
+	{
+		.addr = (void *)(ADDR_SWITCH_HINT),
+		.size = 2 * PAGE_SIZE,
+		.flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
+		.msg = "mmap(ADDR_SWITCH_HINT, 2 * PAGE_SIZE, MAP_FIXED)",
+	},
+};
+
+static struct testcase hugetlb_testcases[] = {
+	{
+		.addr = NULL,
+		.size = HUGETLB_SIZE,
+		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(NULL, MAP_HUGETLB)",
+		.low_addr_required = 1,
+	},
+	{
+		.addr = LOW_ADDR,
+		.size = HUGETLB_SIZE,
+		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(LOW_ADDR, MAP_HUGETLB)",
+		.low_addr_required = 1,
+	},
+	{
+		.addr = HIGH_ADDR,
+		.size = HUGETLB_SIZE,
+		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(HIGH_ADDR, MAP_HUGETLB)",
+		.keep_mapped = 1,
+	},
+	{
+		.addr = HIGH_ADDR,
+		.size = HUGETLB_SIZE,
+		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(HIGH_ADDR, MAP_HUGETLB) again",
+		.keep_mapped = 1,
+	},
+	{
+		.addr = HIGH_ADDR,
+		.size = HUGETLB_SIZE,
+		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
+		.msg = "mmap(HIGH_ADDR, MAP_FIXED | MAP_HUGETLB)",
+	},
+	{
+		.addr = (void *) -1,
+		.size = HUGETLB_SIZE,
+		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(-1, MAP_HUGETLB)",
+		.keep_mapped = 1,
+	},
+	{
+		.addr = (void *) -1,
+		.size = HUGETLB_SIZE,
+		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(-1, MAP_HUGETLB) again",
+	},
+	{
+		.addr = (void *)(ADDR_SWITCH_HINT - PAGE_SIZE),
+		.size = 2 * HUGETLB_SIZE,
+		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
+		.msg = "mmap(ADDR_SWITCH_HINT - PAGE_SIZE, 2*HUGETLB_SIZE, MAP_HUGETLB)",
+		.low_addr_required = 1,
+		.keep_mapped = 1,
+	},
+	{
+		.addr = (void *)(ADDR_SWITCH_HINT),
+		.size = 2 * HUGETLB_SIZE,
+		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
+		.msg = "mmap(ADDR_SWITCH_HINT , 2*HUGETLB_SIZE, MAP_FIXED | MAP_HUGETLB)",
+	},
+};
+
+static int run_test(struct testcase *test, int count)
+{
+	void *p;
+	int i, ret = 0;
+
+	for (i = 0; i < count; i++) {
+		struct testcase *t = test + i;
+
+		p = mmap(t->addr, t->size, PROT_READ | PROT_WRITE, t->flags, -1, 0);
+
+		printf("%s: %p - ", t->msg, p);
+
+		if (p == MAP_FAILED) {
+			printf("FAILED\n");
+			ret = 1;
+			continue;
+		}
+
+		if (t->low_addr_required && p >= (void *)(ADDR_SWITCH_HINT)) {
+			printf("FAILED\n");
+			ret = 1;
+		} else {
+			/*
+			 * Do a dereference of the address returned so that we catch
+			 * bugs in page fault handling
+			 */
+			memset(p, 0, t->size);
+			printf("OK\n");
+		}
+		if (!t->keep_mapped)
+			munmap(p, t->size);
+	}
+
+	return ret;
+}
+
+static int supported_arch(void)
+{
+#if defined(__powerpc64__)
+	return 1;
+#elif defined(__x86_64__)
+	return 1;
+#else
+	return 0;
+#endif
+}
+
+int main(int argc, char **argv)
+{
+	int ret;
+
+	if (!supported_arch())
+		return 0;
+
+	ret = run_test(testcases, ARRAY_SIZE(testcases));
+	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
+		ret = run_test(hugetlb_testcases, ARRAY_SIZE(hugetlb_testcases));
+	return ret;
+}
diff -puN tools/testing/selftests/x86/5lvl.c~selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory /dev/null
--- a/tools/testing/selftests/x86/5lvl.c
+++ /dev/null
@@ -1,177 +0,0 @@
-#include <stdio.h>
-#include <sys/mman.h>
-
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
-
-#define PAGE_SIZE	4096
-#define LOW_ADDR	((void *) (1UL << 30))
-#define HIGH_ADDR	((void *) (1UL << 50))
-
-struct testcase {
-	void *addr;
-	unsigned long size;
-	unsigned long flags;
-	const char *msg;
-	unsigned int low_addr_required:1;
-	unsigned int keep_mapped:1;
-};
-
-static struct testcase testcases[] = {
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
-		.addr = (void*) -1,
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(-1)",
-		.keep_mapped = 1,
-	},
-	{
-		.addr = (void*) -1,
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(-1) again",
-	},
-	{
-		.addr = (void *)((1UL << 47) - PAGE_SIZE),
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap((1UL << 47), 2 * PAGE_SIZE)",
-		.low_addr_required = 1,
-		.keep_mapped = 1,
-	},
-	{
-		.addr = (void *)((1UL << 47) - PAGE_SIZE / 2),
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap((1UL << 47), 2 * PAGE_SIZE / 2)",
-		.low_addr_required = 1,
-		.keep_mapped = 1,
-	},
-	{
-		.addr = (void *)((1UL << 47) - PAGE_SIZE),
-		.size = 2 * PAGE_SIZE,
-		.flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
-		.msg = "mmap((1UL << 47) - PAGE_SIZE, 2 * PAGE_SIZE, MAP_FIXED)",
-	},
-	{
-		.addr = NULL,
-		.size = 2UL << 20,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(NULL, MAP_HUGETLB)",
-		.low_addr_required = 1,
-	},
-	{
-		.addr = LOW_ADDR,
-		.size = 2UL << 20,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(LOW_ADDR, MAP_HUGETLB)",
-		.low_addr_required = 1,
-	},
-	{
-		.addr = HIGH_ADDR,
-		.size = 2UL << 20,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(HIGH_ADDR, MAP_HUGETLB)",
-		.keep_mapped = 1,
-	},
-	{
-		.addr = HIGH_ADDR,
-		.size = 2UL << 20,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(HIGH_ADDR, MAP_HUGETLB) again",
-		.keep_mapped = 1,
-	},
-	{
-		.addr = HIGH_ADDR,
-		.size = 2UL << 20,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
-		.msg = "mmap(HIGH_ADDR, MAP_FIXED | MAP_HUGETLB)",
-	},
-	{
-		.addr = (void*) -1,
-		.size = 2UL << 20,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(-1, MAP_HUGETLB)",
-		.keep_mapped = 1,
-	},
-	{
-		.addr = (void*) -1,
-		.size = 2UL << 20,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap(-1, MAP_HUGETLB) again",
-	},
-	{
-		.addr = (void *)((1UL << 47) - PAGE_SIZE),
-		.size = 4UL << 20,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-		.msg = "mmap((1UL << 47), 4UL << 20, MAP_HUGETLB)",
-		.low_addr_required = 1,
-		.keep_mapped = 1,
-	},
-	{
-		.addr = (void *)((1UL << 47) - (2UL << 20)),
-		.size = 4UL << 20,
-		.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
-		.msg = "mmap((1UL << 47) - (2UL << 20), 4UL << 20, MAP_FIXED | MAP_HUGETLB)",
-	},
-};
-
-int main(int argc, char **argv)
-{
-	int i;
-	void *p;
-
-	for (i = 0; i < ARRAY_SIZE(testcases); i++) {
-		struct testcase *t = testcases + i;
-
-		p = mmap(t->addr, t->size, PROT_NONE, t->flags, -1, 0);
-
-		printf("%s: %p - ", t->msg, p);
-
-		if (p == MAP_FAILED) {
-			printf("FAILED\n");
-			continue;
-		}

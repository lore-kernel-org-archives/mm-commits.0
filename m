From: akpm@linux-foundation.org
Subject: + selftests-vm-add-a-test-for-virtual-address-range-mapping.patch added to -mm tree
Date: Tue, 18 Apr 2017 14:53:19 -0700
Message-ID: <58f68acf.C5xG9fCwR0SX+lrA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39624 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751977AbdDRVxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2017 17:53:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, msuchanek@suse.de, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: add a test for virtual address range mapping
has been added to the -mm tree.  Its filename is
     selftests-vm-add-a-test-for-virtual-address-range-mapping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-add-a-test-for-virtual-address-range-mapping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-add-a-test-for-virtual-address-range-mapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: selftests/vm: add a test for virtual address range mapping

This verifies virtual address mapping below and above the 128TB range and
makes sure that address returned are within the expected range depending
upon the hint passed from the user space.

Link: http://lkml.kernel.org/r/20170418095252.20533-1-khandual@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile                |    1 
 tools/testing/selftests/vm/run_vmtests             |   11 
 tools/testing/selftests/vm/virtual_address_range.c |  122 +++++++++++
 3 files changed, 134 insertions(+)

diff -puN tools/testing/selftests/vm/Makefile~selftests-vm-add-a-test-for-virtual-address-range-mapping tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-add-a-test-for-virtual-address-range-mapping
+++ a/tools/testing/selftests/vm/Makefile
@@ -16,6 +16,7 @@ TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
 TEST_GEN_FILES += mlock-random-test
+TEST_GEN_FILES += virtual_address_range
 
 TEST_PROGS := run_vmtests
 
diff -puN tools/testing/selftests/vm/run_vmtests~selftests-vm-add-a-test-for-virtual-address-range-mapping tools/testing/selftests/vm/run_vmtests
--- a/tools/testing/selftests/vm/run_vmtests~selftests-vm-add-a-test-for-virtual-address-range-mapping
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -165,4 +165,15 @@ else
 	echo "[PASS]"
 fi
 
+echo "-----------------------------"
+echo "running virtual_address_range"
+echo "-----------------------------"
+./virtual_address_range
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
 exit $exitcode
diff -puN /dev/null tools/testing/selftests/vm/virtual_address_range.c
--- /dev/null
+++ a/tools/testing/selftests/vm/virtual_address_range.c
@@ -0,0 +1,122 @@
+/*
+ * Copyright 2017, Anshuman Khandual, IBM Corp.
+ * Licensed under GPLv2.
+ *
+ * Works on architectures which support 128TB virtual
+ * address range and beyond.
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <numaif.h>
+#include <sys/mman.h>
+#include <sys/time.h>
+
+/*
+ * Maximum address range mapped with a single mmap()
+ * call is little bit more than 16GB. Hence 16GB is
+ * chosen as the single chunk size for address space
+ * mapping.
+ */
+#define MAP_CHUNK_SIZE   17179869184UL /* 16GB */
+
+/*
+ * Address space till 128TB is mapped without any hint
+ * and is enabled by default. Address space beyond 128TB
+ * till 512TB is obtained by passing hint address as the
+ * first argument into mmap() system call.
+ *
+ * The process heap address space is divided into two
+ * different areas one below 128TB and one above 128TB
+ * till it reaches 512TB. One with size 128TB and the
+ * other being 384TB.
+ */
+#define NR_CHUNKS_128TB   8192UL /* Number of 16GB chunks for 128TB */
+#define NR_CHUNKS_384TB  24576UL /* Number of 16GB chunks for 384TB */
+
+#define ADDR_MARK_128TB  (1UL << 47) /* First address beyond 128TB */
+
+static char *hind_addr(void)
+{
+	int bits = 48 + rand() % 15;
+
+	return (char *) (1UL << bits);
+}
+
+static int validate_addr(char *ptr, int high_addr)
+{
+	unsigned long addr = (unsigned long) ptr;
+
+	if (high_addr) {
+		if (addr < ADDR_MARK_128TB) {
+			printf("Bad address %lx\n", addr);
+			return 1;
+		}
+		return 0;
+	}
+
+	if (addr > ADDR_MARK_128TB) {
+		printf("Bad address %lx\n", addr);
+		return 1;
+	}
+	return 0;
+}
+
+static int validate_lower_address_hint(void)
+{
+	char *ptr;
+
+	ptr = mmap((void *) (1UL << 45), MAP_CHUNK_SIZE, PROT_READ |
+			PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+
+	if (ptr == MAP_FAILED)
+		return 0;
+
+	return 1;
+}
+
+int main(int argc, char *argv[])
+{
+	char *ptr[NR_CHUNKS_128TB];
+	char *hptr[NR_CHUNKS_384TB];
+	char *hint;
+	unsigned long i, lchunks, hchunks;
+
+	for (i = 0; i < NR_CHUNKS_128TB; i++) {
+		ptr[i] = mmap(NULL, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
+					MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+
+		if (ptr[i] == MAP_FAILED) {
+			if (validate_lower_address_hint())
+				return 1;
+			break;
+		}
+
+		if (validate_addr(ptr[i], 0))
+			return 1;
+	}
+	lchunks = i;
+
+	for (i = 0; i < NR_CHUNKS_384TB; i++) {
+		hint = hind_addr();
+		hptr[i] = mmap(hint, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
+					MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+
+		if (hptr[i] == MAP_FAILED)
+			break;
+
+		if (validate_addr(hptr[i], 1))
+			return 1;
+	}
+	hchunks = i;
+
+	for (i = 0; i < lchunks; i++)
+		munmap(ptr[i], MAP_CHUNK_SIZE);
+
+	for (i = 0; i < hchunks; i++)
+		munmap(hptr[i], MAP_CHUNK_SIZE);
+
+	return 0;
+}
_

Patches currently in -mm which might be from khandual@linux.vnet.ibm.com are

mm-mmap-replace-shm_huge_mask-with-map_huge_mask-inside-mmap_pgoff.patch
mm-madvise-clean-up-madv_soft_offline-and-madv_hwpoison.patch
mm-softoffline-add-page-flag-description-in-error-paths.patch
selftests-vm-add-a-test-for-virtual-address-range-mapping.patch


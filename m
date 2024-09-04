Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F0E6F2EB
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423495; cv=none; b=OtK8az9DjxZuyKtGX/+c5RyJgwYFhl+GesXppmhCW4ySJHfN6yoh2VygrThex/tJRi383ZX0erX2pmnH5GxI65EW7W3PD4yaTNNGXwCwzfwdWfQ1ybMHSbEXBxcCyYITD2Rr3hXv1MhQ2HCT16hH771fQ++FfS39zRK4Ln+v2Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423495; c=relaxed/simple;
	bh=g+6CZ2XIVnnioyHgiDhP/8viqUzahE5NNRojm6cwkZg=;
	h=Date:To:From:Subject:Message-Id; b=iI4sO7pd+dXEqWXritFINs4i1fOh0GPQVTbQ3SXMnvL+2wTSfPLGtX+pZiAWDOlT2CV3dUTgiR4fgGwrKFQkkBEAiyMz531Bh5kbo8FOsKYyMyjHOopCmmgFzbn+/cjiRqiQGmIwzSF6N+3nBElxMVtpERaMnAjlkmCa7BYm58M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FRK0BYvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FRK0BYvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14579C4CEC2;
	Wed,  4 Sep 2024 04:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423495;
	bh=g+6CZ2XIVnnioyHgiDhP/8viqUzahE5NNRojm6cwkZg=;
	h=Date:To:From:Subject:From;
	b=FRK0BYvKkO+6sgkBlsmsHEQyYZ6G61RtB2B9ffzqtAxJX9z1pvjnOASK4sSE7VRTM
	 THCSa+gug+ZPlhArIFoGWO3DrPBWfoo26PYZ7dPMBVNpoPHEJoOwVUI/6OaB7hcAmn
	 R3RxIZbw+/R0ID6B1RVpy/0QZST3Q2E2aykshIdE=
Date: Tue, 03 Sep 2024 21:18:14 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,rppt@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-unnecessary-ia64-code-and-comment.patch removed from -mm tree
Message-Id: <20240904041815.14579C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: remove unnecessary ia64 code and comment
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-unnecessary-ia64-code-and-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: selftests/mm: remove unnecessary ia64 code and comment
Date: Mon, 19 Aug 2024 21:06:09 +0800

IA64 has gone with commit cf8e8658100d ("arch: Remove Itanium (IA-64)
architecture"), so remove unnecessary ia64 special mm code and comment in
selftests too.

Link: https://lkml.kernel.org/r/20240819130609.3386195-1-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile           |    2 -
 tools/testing/selftests/mm/hugepage-mmap.c    |   18 ----------------
 tools/testing/selftests/mm/hugepage-shm.c     |   18 ----------------
 tools/testing/selftests/mm/hugepage-vmemmap.c |   17 +--------------
 tools/testing/selftests/mm/map_hugetlb.c      |   18 +---------------
 tools/testing/selftests/mm/run_vmtests.sh     |    2 -
 6 files changed, 8 insertions(+), 67 deletions(-)

--- a/tools/testing/selftests/mm/hugepage-mmap.c~selftests-mm-remove-unnecessary-ia64-code-and-comment
+++ a/tools/testing/selftests/mm/hugepage-mmap.c
@@ -8,13 +8,6 @@
  * like /mnt) using the command mount -t hugetlbfs nodev /mnt. In this
  * example, the app is requesting memory of size 256MB that is backed by
  * huge pages.
- *
- * For the ia64 architecture, the Linux kernel reserves Region number 4 for
- * huge pages.  That means that if one requires a fixed address, a huge page
- * aligned address starting with 0x800000... will be required.  If a fixed
- * address is not required, the kernel will select an address in the proper
- * range.
- * Other architectures, such as ppc64, i386 or x86_64 are not so constrained.
  */
 #define _GNU_SOURCE
 #include <stdlib.h>
@@ -27,15 +20,6 @@
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
 
-/* Only ia64 requires this */
-#ifdef __ia64__
-#define ADDR (void *)(0x8000000000000000UL)
-#define FLAGS (MAP_SHARED | MAP_FIXED)
-#else
-#define ADDR (void *)(0x0UL)
-#define FLAGS (MAP_SHARED)
-#endif
-
 static void check_bytes(char *addr)
 {
 	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
@@ -74,7 +58,7 @@ int main(void)
 	if (fd < 0)
 		ksft_exit_fail_msg("memfd_create() failed: %s\n", strerror(errno));
 
-	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, fd, 0);
+	addr = mmap(NULL, LENGTH, PROTECTION, MAP_SHARED, fd, 0);
 	if (addr == MAP_FAILED) {
 		close(fd);
 		ksft_exit_fail_msg("mmap(): %s\n", strerror(errno));
--- a/tools/testing/selftests/mm/hugepage-shm.c~selftests-mm-remove-unnecessary-ia64-code-and-comment
+++ a/tools/testing/selftests/mm/hugepage-shm.c
@@ -8,13 +8,6 @@
  * SHM_HUGETLB in the shmget system call to inform the kernel that it is
  * requesting huge pages.
  *
- * For the ia64 architecture, the Linux kernel reserves Region number 4 for
- * huge pages.  That means that if one requires a fixed address, a huge page
- * aligned address starting with 0x800000... will be required.  If a fixed
- * address is not required, the kernel will select an address in the proper
- * range.
- * Other architectures, such as ppc64, i386 or x86_64 are not so constrained.
- *
  * Note: The default shared memory limit is quite low on many kernels,
  * you may need to increase it via:
  *
@@ -39,15 +32,6 @@
 
 #define dprintf(x)  printf(x)
 
-/* Only ia64 requires this */
-#ifdef __ia64__
-#define ADDR (void *)(0x8000000000000000UL)
-#define SHMAT_FLAGS (SHM_RND)
-#else
-#define ADDR (void *)(0x0UL)
-#define SHMAT_FLAGS (0)
-#endif
-
 int main(void)
 {
 	int shmid;
@@ -61,7 +45,7 @@ int main(void)
 	}
 	printf("shmid: 0x%x\n", shmid);
 
-	shmaddr = shmat(shmid, ADDR, SHMAT_FLAGS);
+	shmaddr = shmat(shmid, NULL, 0);
 	if (shmaddr == (char *)-1) {
 		perror("Shared memory attach failure");
 		shmctl(shmid, IPC_RMID, NULL);
--- a/tools/testing/selftests/mm/hugepage-vmemmap.c~selftests-mm-remove-unnecessary-ia64-code-and-comment
+++ a/tools/testing/selftests/mm/hugepage-vmemmap.c
@@ -22,20 +22,6 @@
 #define PM_PFRAME_BITS		55
 #define PM_PFRAME_MASK		~((1UL << PM_PFRAME_BITS) - 1)
 
-/*
- * For ia64 architecture, Linux kernel reserves Region number 4 for hugepages.
- * That means the addresses starting with 0x800000... will need to be
- * specified.  Specifying a fixed address is not required on ppc64, i386
- * or x86_64.
- */
-#ifdef __ia64__
-#define MAP_ADDR		(void *)(0x8000000000000000UL)
-#define MAP_FLAGS		(MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_FIXED)
-#else
-#define MAP_ADDR		NULL
-#define MAP_FLAGS		(MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB)
-#endif
-
 static size_t pagesize;
 static size_t maplength;
 
@@ -113,7 +99,8 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	addr = mmap(MAP_ADDR, maplength, PROT_READ | PROT_WRITE, MAP_FLAGS, -1, 0);
+	addr = mmap(NULL, maplength, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	if (addr == MAP_FAILED) {
 		perror("mmap");
 		exit(1);
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-remove-unnecessary-ia64-code-and-comment
+++ a/tools/testing/selftests/mm/Makefile
@@ -112,7 +112,7 @@ endif
 
 endif
 
-ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 powerpc riscv64 s390x sparc64 x86_64 s390))
+ifneq (,$(filter $(ARCH),arm64 mips64 parisc64 powerpc riscv64 s390x sparc64 x86_64 s390))
 TEST_GEN_FILES += va_high_addr_switch
 TEST_GEN_FILES += virtual_address_range
 TEST_GEN_FILES += write_to_hugetlbfs
--- a/tools/testing/selftests/mm/map_hugetlb.c~selftests-mm-remove-unnecessary-ia64-code-and-comment
+++ a/tools/testing/selftests/mm/map_hugetlb.c
@@ -4,11 +4,6 @@
  * system call with MAP_HUGETLB flag.  Before running this program make
  * sure the administrator has allocated enough default sized huge pages
  * to cover the 256 MB allocation.
- *
- * For ia64 architecture, Linux kernel reserves Region number 4 for hugepages.
- * That means the addresses starting with 0x800000... will need to be
- * specified.  Specifying a fixed address is not required on ppc64, i386
- * or x86_64.
  */
 #include <stdlib.h>
 #include <stdio.h>
@@ -21,15 +16,6 @@
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
 
-/* Only ia64 requires this */
-#ifdef __ia64__
-#define ADDR (void *)(0x8000000000000000UL)
-#define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_FIXED)
-#else
-#define ADDR (void *)(0x0UL)
-#define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB)
-#endif
-
 static void check_bytes(char *addr)
 {
 	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
@@ -60,7 +46,7 @@ int main(int argc, char **argv)
 	void *addr;
 	size_t hugepage_size;
 	size_t length = LENGTH;
-	int flags = FLAGS;
+	int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
 	int shift = 0;
 
 	hugepage_size = default_huge_page_size();
@@ -85,7 +71,7 @@ int main(int argc, char **argv)
 		ksft_print_msg("Default size hugepages\n");
 	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
 
-	addr = mmap(ADDR, length, PROTECTION, flags, -1, 0);
+	addr = mmap(NULL, length, PROTECTION, flags, -1, 0);
 	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
 
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-remove-unnecessary-ia64-code-and-comment
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -189,7 +189,7 @@ else
 fi
 
 # filter 64bit architectures
-ARCH64STR="arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sparc64 x86_64"
+ARCH64STR="arm64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sparc64 x86_64"
 if [ -z "$ARCH" ]; then
 	ARCH=$(uname -m 2>/dev/null | sed -e 's/aarch64.*/arm64/')
 fi
_

Patches currently in -mm which might be from tujinjiang@huawei.com are



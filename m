From: akpm@linux-foundation.org
Subject: + move-hugepage-test-examples-to-tools-testing-selftests-vm.patch added to -mm tree
Date: Thu, 09 Feb 2012 15:03:31 -0800
Message-ID: <20120209230332.21CE9A0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:43188 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758506Ab2BIXDe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 18:03:34 -0500
Received: by faaa19 with SMTP id a19so66899faa.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Feb 2012 15:03:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dyoung@redhat.com, cl@linux.com, fengguang.wu@intel.com, fweisbec@gmail.com, penberg@cs.helsinki.fi


The patch titled
     Subject: mm: move hugepage test examples to tools/testing/selftests/vm
has been added to the -mm tree.  Its filename is
     move-hugepage-test-examples-to-tools-testing-selftests-vm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: mm: move hugepage test examples to tools/testing/selftests/vm

hugepage-mmap.c, hugepage-shm.c and map_hugetlb.c in Documentation/vm are
simple pass/fail tests, It's better to promote them to
tools/testing/selftests.

Thanks suggestion of Andrew Morton about this.  They all need firstly
setting up proper nr_hugepages and hugepage-mmap need to mount hugetlbfs. 
So I add a shell script run_vmtests to do such work which will call the
three test programs and check the return value of them.

Changes to original code including below:
a. add run_vmtests script
b. return error when read_bytes mismatch with writed bytes.
c. coding style fixes: do not use assignment in if condition

Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/Makefile                  |    8 -
 Documentation/vm/hugepage-mmap.c           |   91 -----------------
 Documentation/vm/hugepage-shm.c            |   98 ------------------
 Documentation/vm/map_hugetlb.c             |   77 --------------
 tools/testing/selftests/Makefile           |    2 
 tools/testing/selftests/vm/Makefile        |   14 ++
 tools/testing/selftests/vm/hugepage-mmap.c |   92 +++++++++++++++++
 tools/testing/selftests/vm/hugepage-shm.c  |  100 +++++++++++++++++++
 tools/testing/selftests/vm/map_hugetlb.c   |   79 +++++++++++++++
 tools/testing/selftests/vm/run_vmtests     |   77 ++++++++++++++
 10 files changed, 363 insertions(+), 275 deletions(-)

diff -puN Documentation/vm/Makefile~move-hugepage-test-examples-to-tools-testing-selftests-vm /dev/null
--- a/Documentation/vm/Makefile
+++ /dev/null
@@ -1,8 +0,0 @@
-# kbuild trick to avoid linker error. Can be omitted if a module is built.
-obj- := dummy.o
-
-# List of programs to build
-hostprogs-y := hugepage-mmap hugepage-shm map_hugetlb
-
-# Tell kbuild to always build the programs
-always := $(hostprogs-y)
diff -puN Documentation/vm/hugepage-mmap.c~move-hugepage-test-examples-to-tools-testing-selftests-vm /dev/null
--- a/Documentation/vm/hugepage-mmap.c
+++ /dev/null
@@ -1,91 +0,0 @@
-/*
- * hugepage-mmap:
- *
- * Example of using huge page memory in a user application using the mmap
- * system call.  Before running this application, make sure that the
- * administrator has mounted the hugetlbfs filesystem (on some directory
- * like /mnt) using the command mount -t hugetlbfs nodev /mnt. In this
- * example, the app is requesting memory of size 256MB that is backed by
- * huge pages.
- *
- * For the ia64 architecture, the Linux kernel reserves Region number 4 for
- * huge pages.  That means that if one requires a fixed address, a huge page
- * aligned address starting with 0x800000... will be required.  If a fixed
- * address is not required, the kernel will select an address in the proper
- * range.
- * Other architectures, such as ppc64, i386 or x86_64 are not so constrained.
- */
-
-#include <stdlib.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <sys/mman.h>
-#include <fcntl.h>
-
-#define FILE_NAME "/mnt/hugepagefile"
-#define LENGTH (256UL*1024*1024)
-#define PROTECTION (PROT_READ | PROT_WRITE)
-
-/* Only ia64 requires this */
-#ifdef __ia64__
-#define ADDR (void *)(0x8000000000000000UL)
-#define FLAGS (MAP_SHARED | MAP_FIXED)
-#else
-#define ADDR (void *)(0x0UL)
-#define FLAGS (MAP_SHARED)
-#endif
-
-static void check_bytes(char *addr)
-{
-	printf("First hex is %x\n", *((unsigned int *)addr));
-}
-
-static void write_bytes(char *addr)
-{
-	unsigned long i;
-
-	for (i = 0; i < LENGTH; i++)
-		*(addr + i) = (char)i;
-}
-
-static void read_bytes(char *addr)
-{
-	unsigned long i;
-
-	check_bytes(addr);
-	for (i = 0; i < LENGTH; i++)
-		if (*(addr + i) != (char)i) {
-			printf("Mismatch at %lu\n", i);
-			break;
-		}
-}
-
-int main(void)
-{
-	void *addr;
-	int fd;
-
-	fd = open(FILE_NAME, O_CREAT | O_RDWR, 0755);
-	if (fd < 0) {
-		perror("Open failed");
-		exit(1);
-	}
-
-	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, fd, 0);
-	if (addr == MAP_FAILED) {
-		perror("mmap");
-		unlink(FILE_NAME);
-		exit(1);
-	}
-
-	printf("Returned address is %p\n", addr);
-	check_bytes(addr);
-	write_bytes(addr);
-	read_bytes(addr);
-
-	munmap(addr, LENGTH);
-	close(fd);
-	unlink(FILE_NAME);
-
-	return 0;
-}
diff -puN Documentation/vm/hugepage-shm.c~move-hugepage-test-examples-to-tools-testing-selftests-vm /dev/null
--- a/Documentation/vm/hugepage-shm.c
+++ /dev/null
@@ -1,98 +0,0 @@
-/*
- * hugepage-shm:
- *
- * Example of using huge page memory in a user application using Sys V shared
- * memory system calls.  In this example the app is requesting 256MB of
- * memory that is backed by huge pages.  The application uses the flag
- * SHM_HUGETLB in the shmget system call to inform the kernel that it is
- * requesting huge pages.
- *
- * For the ia64 architecture, the Linux kernel reserves Region number 4 for
- * huge pages.  That means that if one requires a fixed address, a huge page
- * aligned address starting with 0x800000... will be required.  If a fixed
- * address is not required, the kernel will select an address in the proper
- * range.
- * Other architectures, such as ppc64, i386 or x86_64 are not so constrained.
- *
- * Note: The default shared memory limit is quite low on many kernels,
- * you may need to increase it via:
- *
- * echo 268435456 > /proc/sys/kernel/shmmax
- *
- * This will increase the maximum size per shared memory segment to 256MB.
- * The other limit that you will hit eventually is shmall which is the
- * total amount of shared memory in pages. To set it to 16GB on a system
- * with a 4kB pagesize do:
- *
- * echo 4194304 > /proc/sys/kernel/shmall
- */
-
-#include <stdlib.h>
-#include <stdio.h>
-#include <sys/types.h>
-#include <sys/ipc.h>
-#include <sys/shm.h>
-#include <sys/mman.h>
-
-#ifndef SHM_HUGETLB
-#define SHM_HUGETLB 04000
-#endif
-
-#define LENGTH (256UL*1024*1024)
-
-#define dprintf(x)  printf(x)
-
-/* Only ia64 requires this */
-#ifdef __ia64__
-#define ADDR (void *)(0x8000000000000000UL)
-#define SHMAT_FLAGS (SHM_RND)
-#else
-#define ADDR (void *)(0x0UL)
-#define SHMAT_FLAGS (0)
-#endif
-
-int main(void)
-{
-	int shmid;
-	unsigned long i;
-	char *shmaddr;
-
-	if ((shmid = shmget(2, LENGTH,
-			    SHM_HUGETLB | IPC_CREAT | SHM_R | SHM_W)) < 0) {
-		perror("shmget");
-		exit(1);
-	}
-	printf("shmid: 0x%x\n", shmid);
-
-	shmaddr = shmat(shmid, ADDR, SHMAT_FLAGS);
-	if (shmaddr == (char *)-1) {
-		perror("Shared memory attach failure");
-		shmctl(shmid, IPC_RMID, NULL);
-		exit(2);
-	}
-	printf("shmaddr: %p\n", shmaddr);
-
-	dprintf("Starting the writes:\n");
-	for (i = 0; i < LENGTH; i++) {
-		shmaddr[i] = (char)(i);
-		if (!(i % (1024 * 1024)))
-			dprintf(".");
-	}
-	dprintf("\n");
-
-	dprintf("Starting the Check...");
-	for (i = 0; i < LENGTH; i++)
-		if (shmaddr[i] != (char)i)
-			printf("\nIndex %lu mismatched\n", i);
-	dprintf("Done.\n");
-
-	if (shmdt((const void *)shmaddr) != 0) {
-		perror("Detach failure");
-		shmctl(shmid, IPC_RMID, NULL);
-		exit(3);
-	}
-
-	shmctl(shmid, IPC_RMID, NULL);
-
-	return 0;
-}
diff -puN Documentation/vm/map_hugetlb.c~move-hugepage-test-examples-to-tools-testing-selftests-vm /dev/null
--- a/Documentation/vm/map_hugetlb.c
+++ /dev/null
@@ -1,77 +0,0 @@
-/*
- * Example of using hugepage memory in a user application using the mmap
- * system call with MAP_HUGETLB flag.  Before running this program make
- * sure the administrator has allocated enough default sized huge pages
- * to cover the 256 MB allocation.
- *
- * For ia64 architecture, Linux kernel reserves Region number 4 for hugepages.
- * That means the addresses starting with 0x800000... will need to be
- * specified.  Specifying a fixed address is not required on ppc64, i386
- * or x86_64.
- */
-#include <stdlib.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <sys/mman.h>
-#include <fcntl.h>
-
-#define LENGTH (256UL*1024*1024)
-#define PROTECTION (PROT_READ | PROT_WRITE)
-
-#ifndef MAP_HUGETLB
-#define MAP_HUGETLB 0x40000 /* arch specific */
-#endif
-
-/* Only ia64 requires this */
-#ifdef __ia64__
-#define ADDR (void *)(0x8000000000000000UL)
-#define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_FIXED)
-#else
-#define ADDR (void *)(0x0UL)
-#define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB)
-#endif
-
-static void check_bytes(char *addr)
-{
-	printf("First hex is %x\n", *((unsigned int *)addr));
-}
-
-static void write_bytes(char *addr)
-{
-	unsigned long i;
-
-	for (i = 0; i < LENGTH; i++)
-		*(addr + i) = (char)i;
-}
-
-static void read_bytes(char *addr)
-{
-	unsigned long i;
-
-	check_bytes(addr);
-	for (i = 0; i < LENGTH; i++)
-		if (*(addr + i) != (char)i) {
-			printf("Mismatch at %lu\n", i);
-			break;
-		}
-}
-
-int main(void)
-{
-	void *addr;
-
-	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, 0, 0);
-	if (addr == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
-
-	printf("Returned address is %p\n", addr);
-	check_bytes(addr);
-	write_bytes(addr);
-	read_bytes(addr);
-
-	munmap(addr, LENGTH);
-
-	return 0;
-}
diff -puN tools/testing/selftests/Makefile~move-hugepage-test-examples-to-tools-testing-selftests-vm tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~move-hugepage-test-examples-to-tools-testing-selftests-vm
+++ a/tools/testing/selftests/Makefile
@@ -1,4 +1,4 @@
-TARGETS = breakpoints
+TARGETS = breakpoints vm
 
 all:
 	for TARGET in $(TARGETS); do \
diff -puN /dev/null tools/testing/selftests/vm/Makefile
--- /dev/null
+++ a/tools/testing/selftests/vm/Makefile
@@ -0,0 +1,14 @@
+# Makefile for vm selftests
+
+CC = $(CROSS_COMPILE)gcc
+CFLAGS = -Wall -Wextra
+
+all: hugepage-mmap hugepage-shm  map_hugetlb
+%: %.c
+	$(CC) $(CFLAGS) -o $@ $^
+
+run_tests:
+	/bin/sh ./run_vmtests
+
+clean:
+	$(RM) hugepage-mmap hugepage-shm  map_hugetlb
diff -puN /dev/null tools/testing/selftests/vm/hugepage-mmap.c
--- /dev/null
+++ a/tools/testing/selftests/vm/hugepage-mmap.c
@@ -0,0 +1,92 @@
+/*
+ * hugepage-mmap:
+ *
+ * Example of using huge page memory in a user application using the mmap
+ * system call.  Before running this application, make sure that the
+ * administrator has mounted the hugetlbfs filesystem (on some directory
+ * like /mnt) using the command mount -t hugetlbfs nodev /mnt. In this
+ * example, the app is requesting memory of size 256MB that is backed by
+ * huge pages.
+ *
+ * For the ia64 architecture, the Linux kernel reserves Region number 4 for
+ * huge pages.  That means that if one requires a fixed address, a huge page
+ * aligned address starting with 0x800000... will be required.  If a fixed
+ * address is not required, the kernel will select an address in the proper
+ * range.
+ * Other architectures, such as ppc64, i386 or x86_64 are not so constrained.
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <fcntl.h>
+
+#define FILE_NAME "huge/hugepagefile"
+#define LENGTH (256UL*1024*1024)
+#define PROTECTION (PROT_READ | PROT_WRITE)
+
+/* Only ia64 requires this */
+#ifdef __ia64__
+#define ADDR (void *)(0x8000000000000000UL)
+#define FLAGS (MAP_SHARED | MAP_FIXED)
+#else
+#define ADDR (void *)(0x0UL)
+#define FLAGS (MAP_SHARED)
+#endif
+
+static void check_bytes(char *addr)
+{
+	printf("First hex is %x\n", *((unsigned int *)addr));
+}
+
+static void write_bytes(char *addr)
+{
+	unsigned long i;
+
+	for (i = 0; i < LENGTH; i++)
+		*(addr + i) = (char)i;
+}
+
+static int read_bytes(char *addr)
+{
+	unsigned long i;
+
+	check_bytes(addr);
+	for (i = 0; i < LENGTH; i++)
+		if (*(addr + i) != (char)i) {
+			printf("Mismatch at %lu\n", i);
+			return 1;
+		}
+	return 0;
+}
+
+int main(void)
+{
+	void *addr;
+	int fd, ret;
+
+	fd = open(FILE_NAME, O_CREAT | O_RDWR, 0755);
+	if (fd < 0) {
+		perror("Open failed");
+		exit(1);
+	}
+
+	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, fd, 0);
+	if (addr == MAP_FAILED) {
+		perror("mmap");
+		unlink(FILE_NAME);
+		exit(1);
+	}
+
+	printf("Returned address is %p\n", addr);
+	check_bytes(addr);
+	write_bytes(addr);
+	ret = read_bytes(addr);
+
+	munmap(addr, LENGTH);
+	close(fd);
+	unlink(FILE_NAME);
+
+	return ret;
+}
diff -puN /dev/null tools/testing/selftests/vm/hugepage-shm.c
--- /dev/null
+++ a/tools/testing/selftests/vm/hugepage-shm.c
@@ -0,0 +1,100 @@
+/*
+ * hugepage-shm:
+ *
+ * Example of using huge page memory in a user application using Sys V shared
+ * memory system calls.  In this example the app is requesting 256MB of
+ * memory that is backed by huge pages.  The application uses the flag
+ * SHM_HUGETLB in the shmget system call to inform the kernel that it is
+ * requesting huge pages.
+ *
+ * For the ia64 architecture, the Linux kernel reserves Region number 4 for
+ * huge pages.  That means that if one requires a fixed address, a huge page
+ * aligned address starting with 0x800000... will be required.  If a fixed
+ * address is not required, the kernel will select an address in the proper
+ * range.
+ * Other architectures, such as ppc64, i386 or x86_64 are not so constrained.
+ *
+ * Note: The default shared memory limit is quite low on many kernels,
+ * you may need to increase it via:
+ *
+ * echo 268435456 > /proc/sys/kernel/shmmax
+ *
+ * This will increase the maximum size per shared memory segment to 256MB.
+ * The other limit that you will hit eventually is shmall which is the
+ * total amount of shared memory in pages. To set it to 16GB on a system
+ * with a 4kB pagesize do:
+ *
+ * echo 4194304 > /proc/sys/kernel/shmall
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/ipc.h>
+#include <sys/shm.h>
+#include <sys/mman.h>
+
+#ifndef SHM_HUGETLB
+#define SHM_HUGETLB 04000
+#endif
+
+#define LENGTH (256UL*1024*1024)
+
+#define dprintf(x)  printf(x)
+
+/* Only ia64 requires this */
+#ifdef __ia64__
+#define ADDR (void *)(0x8000000000000000UL)
+#define SHMAT_FLAGS (SHM_RND)
+#else
+#define ADDR (void *)(0x0UL)
+#define SHMAT_FLAGS (0)
+#endif
+
+int main(void)
+{
+	int shmid;
+	unsigned long i;
+	char *shmaddr;
+
+	shmid = shmget(2, LENGTH, SHM_HUGETLB | IPC_CREAT | SHM_R | SHM_W);
+	if (shmid < 0) {
+		perror("shmget");
+		exit(1);
+	}
+	printf("shmid: 0x%x\n", shmid);
+
+	shmaddr = shmat(shmid, ADDR, SHMAT_FLAGS);
+	if (shmaddr == (char *)-1) {
+		perror("Shared memory attach failure");
+		shmctl(shmid, IPC_RMID, NULL);
+		exit(2);
+	}
+	printf("shmaddr: %p\n", shmaddr);
+
+	dprintf("Starting the writes:\n");
+	for (i = 0; i < LENGTH; i++) {
+		shmaddr[i] = (char)(i);
+		if (!(i % (1024 * 1024)))
+			dprintf(".");
+	}
+	dprintf("\n");
+
+	dprintf("Starting the Check...");
+	for (i = 0; i < LENGTH; i++)
+		if (shmaddr[i] != (char)i) {
+			printf("\nIndex %lu mismatched\n", i);
+			exit(3);
+		}
+	dprintf("Done.\n");
+
+	if (shmdt((const void *)shmaddr) != 0) {
+		perror("Detach failure");
+		shmctl(shmid, IPC_RMID, NULL);
+		exit(4);
+	}
+
+	shmctl(shmid, IPC_RMID, NULL);
+
+	return 0;
+}
diff -puN /dev/null tools/testing/selftests/vm/map_hugetlb.c
--- /dev/null
+++ a/tools/testing/selftests/vm/map_hugetlb.c
@@ -0,0 +1,79 @@
+/*
+ * Example of using hugepage memory in a user application using the mmap
+ * system call with MAP_HUGETLB flag.  Before running this program make
+ * sure the administrator has allocated enough default sized huge pages
+ * to cover the 256 MB allocation.
+ *
+ * For ia64 architecture, Linux kernel reserves Region number 4 for hugepages.
+ * That means the addresses starting with 0x800000... will need to be
+ * specified.  Specifying a fixed address is not required on ppc64, i386
+ * or x86_64.
+ */
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <fcntl.h>
+
+#define LENGTH (256UL*1024*1024)
+#define PROTECTION (PROT_READ | PROT_WRITE)
+
+#ifndef MAP_HUGETLB
+#define MAP_HUGETLB 0x40000 /* arch specific */
+#endif
+
+/* Only ia64 requires this */
+#ifdef __ia64__
+#define ADDR (void *)(0x8000000000000000UL)
+#define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_FIXED)
+#else
+#define ADDR (void *)(0x0UL)
+#define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB)
+#endif
+
+static void check_bytes(char *addr)
+{
+	printf("First hex is %x\n", *((unsigned int *)addr));
+}
+
+static void write_bytes(char *addr)
+{
+	unsigned long i;
+
+	for (i = 0; i < LENGTH; i++)
+		*(addr + i) = (char)i;
+}
+
+static int read_bytes(char *addr)
+{
+	unsigned long i;
+
+	check_bytes(addr);
+	for (i = 0; i < LENGTH; i++)
+		if (*(addr + i) != (char)i) {
+			printf("Mismatch at %lu\n", i);
+			return 1;
+		}
+	return 0;
+}
+
+int main(void)
+{
+	void *addr;
+	int ret;
+
+	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, 0, 0);
+	if (addr == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+
+	printf("Returned address is %p\n", addr);
+	check_bytes(addr);
+	write_bytes(addr);
+	ret = read_bytes(addr);
+
+	munmap(addr, LENGTH);
+
+	return ret;
+}
diff -puN /dev/null tools/testing/selftests/vm/run_vmtests
--- /dev/null
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -0,0 +1,77 @@
+#!/bin/bash
+#please run as root
+
+#we need 256M, below is the size in kB
+needmem=262144
+mnt=./huge
+
+#get pagesize and freepages from /proc/meminfo
+while read name size unit; do
+	if [ "$name" = "HugePages_Free:" ]; then
+		freepgs=$size
+	fi
+	if [ "$name" = "Hugepagesize:" ]; then
+		pgsize=$size
+	fi
+done < /proc/meminfo
+
+#set proper nr_hugepages
+if [ -n "$freepgs" ] && [ -n "$pgsize" ]; then
+	nr_hugepgs=`cat /proc/sys/vm/nr_hugepages`
+	needpgs=`expr $needmem / $pgsize`
+	if [ $freepgs -lt $needpgs ]; then
+		lackpgs=$(( $needpgs - $freepgs ))
+		echo $(( $lackpgs + $nr_hugepgs )) > /proc/sys/vm/nr_hugepages
+		if [ $? -ne 0 ]; then
+			echo "Please run this test as root"
+			exit 1
+		fi
+	fi
+else
+	echo "no hugetlbfs support in kernel?"
+	exit 1
+fi
+
+mkdir $mnt
+mount -t hugetlbfs none $mnt
+
+echo "--------------------"
+echo "runing hugepage-mmap"
+echo "--------------------"
+./hugepage-mmap
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+else
+	echo "[PASS]"
+fi
+
+shmmax=`cat /proc/sys/kernel/shmmax`
+shmall=`cat /proc/sys/kernel/shmall`
+echo 268435456 > /proc/sys/kernel/shmmax
+echo 4194304 > /proc/sys/kernel/shmall
+echo "--------------------"
+echo "runing hugepage-shm"
+echo "--------------------"
+./hugepage-shm
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+else
+	echo "[PASS]"
+fi
+echo $shmmax > /proc/sys/kernel/shmmax
+echo $shmall > /proc/sys/kernel/shmall
+
+echo "--------------------"
+echo "runing map_hugetlb"
+echo "--------------------"
+./map_hugetlb
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+else
+	echo "[PASS]"
+fi
+
+#cleanup
+umount $mnt
+rm -rf $mnt
+echo $nr_hugepgs > /proc/sys/vm/nr_hugepages
_
Subject: Subject: mm: move hugepage test examples to tools/testing/selftests/vm

Patches currently in -mm which might be from dyoung@redhat.com are

linux-next.patch
loop-zero-fill-bio-instead-of-return-eio-for-partial-read.patch
selftests-launch-individual-selftests-from-the-main-makefile.patch
move-page-typesc-from-documentation-to-tools-vm.patch
move-slabinfoc-to-tools-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch


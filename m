From: akpm@linux-foundation.org
Subject: [merged] documentation-vm-split-txt-and-source-files.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:57:52 -0400
Message-ID: <201003150658.o2F6wPww016446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935709Ab0COG6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ebmunson@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/vm/: split txt and source files
has been removed from the -mm tree.  Its filename was
     documentation-vm-split-txt-and-source-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/vm/: split txt and source files
From: Randy Dunlap <randy.dunlap@oracle.com>

Documentation/vm/:
Expose example and tool source files in the Documentation/ directory in
their own files instead of being buried (almost hidden) in readme/txt files.
This should help to prevent bitrot.

This will make them more visible/usable to users who may need
to use them, to developers who may need to test with them, and
to anyone who would fix/update them if they were more visible.

Also, if any of these possibly should not be in the kernel tree at
all, it will be clearer that they are here and we can discuss if
they should be removed.

Also build the recently-added map_hugetlb.c.
Make several functions static to prevent linker warnings.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Eric B Munson <ebmunson@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/00-INDEX        |   16 ++
 Documentation/vm/Makefile        |    2 
 Documentation/vm/hugepage-mmap.c |   91 +++++++++++++++
 Documentation/vm/hugepage-shm.c  |   98 ++++++++++++++++
 Documentation/vm/hugetlbpage.txt |  169 -----------------------------
 Documentation/vm/map_hugetlb.c   |    6 -
 6 files changed, 209 insertions(+), 173 deletions(-)

diff -puN Documentation/vm/00-INDEX~documentation-vm-split-txt-and-source-files Documentation/vm/00-INDEX
--- a/Documentation/vm/00-INDEX~documentation-vm-split-txt-and-source-files
+++ a/Documentation/vm/00-INDEX
@@ -4,23 +4,35 @@ active_mm.txt
 	- An explanation from Linus about tsk->active_mm vs tsk->mm.
 balance
 	- various information on memory balancing.
+hugepage-mmap.c
+	- Example app using huge page memory with the mmap system call.
+hugepage-shm.c
+	- Example app using huge page memory with Sys V shared memory system calls.
 hugetlbpage.txt
 	- a brief summary of hugetlbpage support in the Linux kernel.
+hwpoison.txt
+	- explains what hwpoison is
 ksm.txt
 	- how to use the Kernel Samepage Merging feature.
 locking
 	- info on how locking and synchronization is done in the Linux vm code.
+map_hugetlb.c
+	- an example program that uses the MAP_HUGETLB mmap flag.
 numa
 	- information about NUMA specific code in the Linux vm.
 numa_memory_policy.txt
 	- documentation of concepts and APIs of the 2.6 memory policy support.
 overcommit-accounting
 	- description of the Linux kernels overcommit handling modes.
+page-types.c
+	- Tool for querying page flags
 page_migration
 	- description of page migration in NUMA systems.
+pagemap.txt
+	- pagemap, from the userspace perspective
 slabinfo.c
 	- source code for a tool to get reports about slabs.
 slub.txt
 	- a short users guide for SLUB.
-map_hugetlb.c
-	- an example program that uses the MAP_HUGETLB mmap flag.
+unevictable-lru.txt
+	- Unevictable LRU infrastructure
diff -puN Documentation/vm/Makefile~documentation-vm-split-txt-and-source-files Documentation/vm/Makefile
--- a/Documentation/vm/Makefile~documentation-vm-split-txt-and-source-files
+++ a/Documentation/vm/Makefile
@@ -2,7 +2,7 @@
 obj- := dummy.o
 
 # List of programs to build
-hostprogs-y := slabinfo page-types
+hostprogs-y := slabinfo page-types hugepage-mmap hugepage-shm map_hugetlb
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
diff -puN /dev/null Documentation/vm/hugepage-mmap.c
--- /dev/null
+++ a/Documentation/vm/hugepage-mmap.c
@@ -0,0 +1,91 @@
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
+#define FILE_NAME "/mnt/hugepagefile"
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
+static void read_bytes(char *addr)
+{
+	unsigned long i;
+
+	check_bytes(addr);
+	for (i = 0; i < LENGTH; i++)
+		if (*(addr + i) != (char)i) {
+			printf("Mismatch at %lu\n", i);
+			break;
+		}
+}
+
+int main(void)
+{
+	void *addr;
+	int fd;
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
+	read_bytes(addr);
+
+	munmap(addr, LENGTH);
+	close(fd);
+	unlink(FILE_NAME);
+
+	return 0;
+}
diff -puN /dev/null Documentation/vm/hugepage-shm.c
--- /dev/null
+++ a/Documentation/vm/hugepage-shm.c
@@ -0,0 +1,98 @@
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
+	if ((shmid = shmget(2, LENGTH,
+			    SHM_HUGETLB | IPC_CREAT | SHM_R | SHM_W)) < 0) {
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
+		if (shmaddr[i] != (char)i)
+			printf("\nIndex %lu mismatched\n", i);
+	dprintf("Done.\n");
+
+	if (shmdt((const void *)shmaddr) != 0) {
+		perror("Detach failure");
+		shmctl(shmid, IPC_RMID, NULL);
+		exit(3);
+	}
+
+	shmctl(shmid, IPC_RMID, NULL);
+
+	return 0;
+}
diff -puN Documentation/vm/hugetlbpage.txt~documentation-vm-split-txt-and-source-files Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~documentation-vm-split-txt-and-source-files
+++ a/Documentation/vm/hugetlbpage.txt
@@ -299,176 +299,11 @@ map_hugetlb.c.
 *******************************************************************
 
 /*
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
+ * hugepage-shm:  see Documentation/vm/hugepage-shm.c
  */
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
-#define ADDR (void *)(0x0UL)	/* let kernel choose address */
-#define SHMAT_FLAGS (0)
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
 
 *******************************************************************
 
 /*
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
+ * hugepage-mmap:  see Documentation/vm/hugepage-mmap.c
  */
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
-#define ADDR (void *)(0x0UL)	/* let kernel choose address */
-#define FLAGS (MAP_SHARED)
-
-void check_bytes(char *addr)
-{
-	printf("First hex is %x\n", *((unsigned int *)addr));
-}
-
-void write_bytes(char *addr)
-{
-	unsigned long i;
-
-	for (i = 0; i < LENGTH; i++)
-		*(addr + i) = (char)i;
-}
-
-void read_bytes(char *addr)
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
diff -puN Documentation/vm/map_hugetlb.c~documentation-vm-split-txt-and-source-files Documentation/vm/map_hugetlb.c
--- a/Documentation/vm/map_hugetlb.c~documentation-vm-split-txt-and-source-files
+++ a/Documentation/vm/map_hugetlb.c
@@ -31,12 +31,12 @@
 #define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB)
 #endif
 
-void check_bytes(char *addr)
+static void check_bytes(char *addr)
 {
 	printf("First hex is %x\n", *((unsigned int *)addr));
 }
 
-void write_bytes(char *addr)
+static void write_bytes(char *addr)
 {
 	unsigned long i;
 
@@ -44,7 +44,7 @@ void write_bytes(char *addr)
 		*(addr + i) = (char)i;
 }
 
-void read_bytes(char *addr)
+static void read_bytes(char *addr)
 {
 	unsigned long i;
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


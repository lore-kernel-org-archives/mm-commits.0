Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793942359;
	b=3U1Lxc2ezYYMVsH2JOlErKqno0bWRP0km8zSEsYWAwX7elfHhgfHJ+k+Xz5sZP3KmrGn
	 4Kqc6FKnrABFYWjXwpNHrRYSG41UHENbqZBBzLP4MdZV9SfPNcOhZzoffbNFnovI/pGcC
	 M7MoKwc612BMjGG3zDenuBT4Jd08o1NBjtB7CSZ5Vs8kfZ5z/SRizeniE0r7ptL2Rfn5V
	 ddec19aDRPBIe6dh7IQp5qRCX3O8c6uEtPTi7oK5+QkEBagUgfsC+cGHBRaLd2XE6u1ek
	 dHVRsZItAO6vWkem+BZr6HhE253hlNTDlYJhuzUR3Z6lpBlTFaKOaxVb8SaMY6/te+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793942359;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Ka1jgbzl1IN4ckhmjPRPHz9lAmOGBJZkxb2fAXHIb+4=;
	b=gxExCJ6NQDx8DnBTCcd76UerJt7kcMTEKNeUEX70JDOxyX0g//iiwZdWqjSGf2tUqBap
	 DVCmUj7QPyQco2jPuATmZIDxEO1O2cG77vvNcUjPjIOahrsF2tdrArQITopgao6XUaYfL
	 /zRwup7Qc60GXgtNBcmYzuGbX3XjPIY5JAPHZ+3qRNIOG3sVTHxQG/cOal3jY0fSPDKvT
	 XOWCb8L3XgJs8aY3ryrYqvHT8R+Qb9zzOWAAtDLd20jz80tfmW8nmUkzTsMBY2R5YUCzW
	 KDuiHxikCK1YIKQdOU2DxdtDs20rWga9dwk1uCxE/ygFrBSuz5qobUysLsUVfqSpSFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ORG6BiWY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0601606A32E
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 05:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ORG6BiWY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBA91F0089F;
	Fri,  6 Nov 2026 05:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793942358;
	bh=Ka1jgbzl1IN4ckhmjPRPHz9lAmOGBJZkxb2fAXHIb+4=;
	h=Date:To:From:Subject;
	b=ORG6BiWY2+x34nMXZtkzEoUX8eOw0hvrH7TEMkoiw3fCFrExCKmceinuF4MB3ExNP
	 M8HgFz00Dt0mt/xTjP2HOs5aOsrAVQQmxXkPh248Oe6Wu5AnMZCY61Yl8N3ustVdRe
	 efFmxscLwHMkHH6NahdT7QILd5nyvQz6kqjGA+tA=
Date: Thu, 05 Nov 2026 21:19:18 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,
	shuah@kernel.org,ryan.roberts@arm.com,ritesh.list@gmail.com,
	peterx@redhat.com,nico.pache@linux.dev,maddy@linux.ibm.com,
	loic.molinari@collabora.com,ljs@kernel.org,liam@infradead.org,
	lance.yang@linux.dev,kas@kernel.org,jgg@ziepe.ca,dev.jain@arm.com,
	david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	azpijr@gmail.com,alex@shazbot.org,khorenko@virtuozzo.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-test-fork-of-pmd-mapped-shmem-thps.patch added to mm-new branch
Message-Id: <20261106051918.9EBA91F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: test fork of PMD-mapped shmem THPs
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-test-fork-of-pmd-mapped-shmem-thps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-test-fork-of-pmd-mapped-shmem-thps.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: selftests/mm: test fork of PMD-mapped shmem THPs
Date: Wed, 04 Nov 2026 21:40:58 +0100

Fork a process that maps shmem THPs with PMDs, in a VMA whose page
tables fork copies: a private mapping with an anon_vma, and a shared
one with a guard region. The child must find the PMDs before it
touches the mapping, and its exit must leave the parent's mapping and
the system-wide ShmemPmdMapped counter as they were.

With folio_dup_file_rmap_pmd() adding PTE mappings, the child's exit
takes the parent's share off ShmemPmdMapped while the parent still maps
the folios. Unmapping them drops it once more, so every mapping stays
until exit, where the kernel reports "Bad page cache", or hits a
VM_BUG_ON with CONFIG_DEBUG_VM. A kernel that leaves file THPs to a
refault in the child skips the test.

ShmemPmdMapped is system-wide, and reclaim or NUMA balancing can take a
PMD from the parent while the test runs. So the test makes up to three
attempts, each on a fresh file, and fails only if all of them see the
counter drop by exactly the parent's share: the bug does that on every
fork, other processes only by chance. It passes on the first clean
attempt and skips when none is clean.

The test mounts a tmpfs with huge=always over /tmp in a private mount
namespace, so it leaves the THP settings and the host's mounts and
files alone.

Link: https://lore.kernel.org/20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-4-c56d0d26f970@virtuozzo.com
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: Loïc Molinari <loic.molinari@collabora.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
---

 MAINTAINERS                                |    1 
 tools/testing/selftests/mm/Makefile        |    1 
 tools/testing/selftests/mm/fork_file_thp.c |  256 +++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh  |    1 
 4 files changed, 259 insertions(+)

--- a/MAINTAINERS~selftests-mm-test-fork-of-pmd-mapped-shmem-thps
+++ a/MAINTAINERS
@@ -17937,6 +17937,7 @@ F:	mm/huge_memory.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
 F:	tools/mm/thpmaps
+F:	tools/testing/selftests/mm/fork_file_thp.c
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
diff --git a/tools/testing/selftests/mm/fork_file_thp.c a/tools/testing/selftests/mm/fork_file_thp.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mm/fork_file_thp.c
@@ -0,0 +1,256 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * fork() of a process that maps shmem THPs with PMDs, in a VMA whose page
+ * tables fork copies: a private mapping with an anon_vma, and a shared
+ * mapping with a guard region.
+ *
+ * The child must get the PMDs without faulting, and its exit must leave the
+ * parent's mapping and the system-wide ShmemPmdMapped counter as they were.
+ * Kernels that leave file THPs to a refault in the child skip the test.
+ */
+#define _GNU_SOURCE
+#include <asm-generic/mman.h> /* Force the import of the tools version. */
+#include <errno.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sched.h>
+#include <sys/mman.h>
+#include <sys/mount.h>
+#include <sys/wait.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+
+#define NR_PMDS		4
+#define MAX_PMDSIZE	(32UL << 20)
+/* Other processes, reclaim and NUMA balancing can disturb an attempt. */
+#define ATTEMPTS	3
+
+static size_t pagesize, pmdsize, size;
+
+static long meminfo_kb(const char *key)
+{
+	char line[256];
+	long kb = -1;
+	FILE *f = fopen("/proc/meminfo", "r");
+
+	if (!f)
+		return -1;
+	while (fgets(line, sizeof(line), f))
+		if (!strncmp(line, key, strlen(key))) {
+			kb = strtol(line + strlen(key), NULL, 10);
+			break;
+		}
+	fclose(f);
+	return kb;
+}
+
+/* Skips the last page, which may be a guard page, and @skip. */
+static bool data_ok(const char *mem, size_t skip)
+{
+	size_t off;
+
+	for (off = 0; off < size - pagesize; off += pagesize)
+		if (off != skip && mem[off] != (char)(off / pmdsize + 1))
+			return false;
+	return true;
+}
+
+/* The last PMD is zapped by the setup, the others must be PMD-mapped. */
+static bool pmds_ok(char *mem)
+{
+	return check_huge_file(mem, size - pmdsize, NR_PMDS - 1, pmdsize);
+}
+
+/* Maps a fresh shmem file of NR_PMDS PMDs, PMD-aligned, until exit. */
+static char *map_file(bool shared)
+{
+	char *area, *buf, *mem;
+	size_t off;
+	int fd;
+
+	fd = open("/tmp/fork_file_thp", O_RDWR | O_CREAT | O_TRUNC, 0600);
+	if (fd < 0)
+		ksft_exit_fail_perror("open");
+	unlink("/tmp/fork_file_thp");
+	buf = malloc(pmdsize);
+	if (!buf)
+		ksft_exit_fail_msg("malloc failed\n");
+	for (off = 0; off < size; off += pmdsize) {
+		memset(buf, off / pmdsize + 1, pmdsize);
+		if (pwrite(fd, buf, pmdsize, off) != (ssize_t)pmdsize)
+			ksft_exit_fail_perror("pwrite");
+	}
+	free(buf);
+
+	area = mmap(NULL, size + pmdsize, PROT_NONE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (area == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+	mem = (char *)(((unsigned long)area + pmdsize - 1) & ~(pmdsize - 1));
+	mem = mmap(mem, size, PROT_READ | PROT_WRITE,
+		   (shared ? MAP_SHARED : MAP_PRIVATE) | MAP_FIXED, fd, 0);
+	if (mem == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+	close(fd);
+	for (off = 0; off < size; off += pmdsize)
+		FORCE_READ(mem[off]);
+	return mem;
+}
+
+/* Child exit codes, apart from what kselftest helpers exit with. */
+enum result { PASS, NO_PMDS = 10, FAIL_DATA, FAIL_COUNTER, FAIL_PARENT,
+	      FAIL_KILLED, COUNTER_OFF, CHANGED, LOST_PMDS, NO_THP };
+
+static enum result fork_once(char *mem, bool shared, long *before, long *after)
+{
+	/* The parent alone maps this much with PMDs. */
+	long own = (NR_PMDS - 1) * (pmdsize >> 10);
+	bool parent_pmds;
+	int status;
+	pid_t pid;
+
+	*before = *after = meminfo_kb("ShmemPmdMapped:");
+	if (*before < own)
+		return COUNTER_OFF;
+	fflush(stdout);
+	pid = fork();
+	if (pid < 0)
+		ksft_exit_fail_perror("fork");
+	if (!pid) {
+		/* Look before touching anything: the PMDs must be there. */
+		if (!pmds_ok(mem))
+			_exit(NO_PMDS);
+		if (!data_ok(mem, pmdsize))
+			_exit(FAIL_DATA);
+		mem[pmdsize] = 'c';
+		_exit(PASS);
+	}
+	if (waitpid(pid, &status, 0) != pid)
+		ksft_exit_fail_perror("waitpid");
+	*after = meminfo_kb("ShmemPmdMapped:");
+
+	if (!WIFEXITED(status))
+		return FAIL_KILLED;
+	/* Reclaim or NUMA balancing took a PMD from the parent. */
+	parent_pmds = pmds_ok(mem);
+	if (WEXITSTATUS(status) == NO_PMDS && !parent_pmds)
+		return LOST_PMDS;
+	if (WEXITSTATUS(status) != PASS)
+		return WEXITSTATUS(status);
+	if (mem[pmdsize] != (shared ? 'c' : 2) || !data_ok(mem, pmdsize))
+		return FAIL_PARENT;
+	if (!parent_pmds)
+		return LOST_PMDS;
+	/* The child's exit took the parent's share off the counter. */
+	if (*before - *after == own)
+		return FAIL_COUNTER;
+	if (*after != *before)
+		return CHANGED;
+	return PASS;
+}
+
+static void test_fork(bool shared)
+{
+	const char *desc = shared ? "shared mapping with a guard region" :
+				    "private mapping with an anon_vma";
+	long before = 0, after = 0;
+	enum result res = NO_THP;
+	int i, drops = 0;
+	char *mem;
+
+	for (i = 0; i < ATTEMPTS; i++) {
+		mem = map_file(shared);
+		/* Make fork copy the page tables; the last PMD gets zapped. */
+		if (shared) {
+			if (madvise(mem + size - pagesize, pagesize,
+				    MADV_GUARD_INSTALL)) {
+				ksft_test_result_skip("%s: MADV_GUARD_INSTALL: %s\n",
+						      desc, strerror(errno));
+				return;
+			}
+		} else {
+			mem[size - pagesize] = 'p';
+		}
+
+		res = pmds_ok(mem) ? fork_once(mem, shared, &before, &after) :
+				     res == NO_THP ? NO_THP : LOST_PMDS;
+		/* Later children get only their own mapping. */
+		madvise(mem, size, MADV_DONTFORK);
+		if (res == FAIL_COUNTER)
+			drops++;
+		else if (res != CHANGED && res != LOST_PMDS && res != NO_THP)
+			break;
+	}
+	/* Other processes can mimic the bug's drop, but not on every attempt. */
+	if (res == FAIL_COUNTER && drops < ATTEMPTS)
+		res = CHANGED;
+
+	switch (res) {
+	case PASS:
+		ksft_test_result_pass("%s\n", desc);
+		break;
+	case NO_THP:
+		ksft_test_result_skip("%s: shmem is not mapped with PMDs\n",
+				      desc);
+		break;
+	case NO_PMDS:
+		ksft_test_result_skip("%s: fork does not copy file THPs\n", desc);
+		break;
+	case COUNTER_OFF:
+		ksft_test_result_skip("%s: ShmemPmdMapped %ld kB is below what this process maps\n",
+				      desc, before);
+		break;
+	case CHANGED:
+		ksft_test_result_skip("%s: ShmemPmdMapped keeps changing\n", desc);
+		break;
+	case LOST_PMDS:
+		ksft_test_result_skip("%s: the parent keeps losing its PMDs\n",
+				      desc);
+		break;
+	case FAIL_DATA:
+		ksft_test_result_fail("%s: child sees wrong data\n", desc);
+		break;
+	case FAIL_COUNTER:
+		ksft_test_result_fail("%s: ShmemPmdMapped %ld kB before fork, %ld kB after\n",
+				      desc, before, after);
+		break;
+	case FAIL_PARENT:
+		ksft_test_result_fail("%s: parent's mapping changed\n", desc);
+		break;
+	case FAIL_KILLED:
+		ksft_test_result_fail("%s: child killed by a signal\n", desc);
+		break;
+	default:
+		ksft_test_result_fail("%s: child error %d\n", desc, res);
+		break;
+	}
+}
+
+int main(void)
+{
+	ksft_print_header();
+	pagesize = getpagesize();
+	pmdsize = read_pmd_pagesize();
+	if (!pmdsize)
+		ksft_exit_skip("THP is not supported\n");
+	if (pmdsize > MAX_PMDSIZE)
+		ksft_exit_skip("PMD size %zu MiB is too large\n", pmdsize >> 20);
+	size = NR_PMDS * pmdsize;
+	if (geteuid())
+		ksft_exit_skip("needs root to mount tmpfs\n");
+	/* The tmpfs over /tmp lives and dies with a private mount namespace. */
+	if (unshare(CLONE_NEWNS) || mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL))
+		ksft_exit_skip("private mount namespace: %s\n", strerror(errno));
+	if (mount("tmpfs", "/tmp", "tmpfs", 0, "huge=always"))
+		ksft_exit_skip("tmpfs with huge=always: %s\n", strerror(errno));
+
+	ksft_set_plan(2);
+	test_fork(false);
+	test_fork(true);
+	ksft_finished();
+}
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-test-fork-of-pmd-mapped-shmem-thps
+++ a/tools/testing/selftests/mm/Makefile
@@ -109,6 +109,7 @@ TEST_GEN_FILES += folio_split_race_test
 TEST_GEN_FILES += folio_order_check
 TEST_GEN_FILES += khugepaged_sync_check
 TEST_GEN_FILES += khugepaged_race
+TEST_GEN_FILES += fork_file_thp
 TEST_GEN_FILES += soft-dirty
 
 ifeq ($(ARCH),x86_64)
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-test-fork-of-pmd-mapped-shmem-thps
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -451,6 +451,7 @@ fi
 CATEGORY="thp" run_test ./transhuge-stress -d 20
 
 CATEGORY="thp" run_test ./folio_split_race_test
+CATEGORY="thp" run_test ./fork_file_thp
 
 CATEGORY="migration" run_test ./migration
 
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are

mm-rmap-duplicate-a-pmd-mapping-as-one-in-folio_dup_file_rmap_pmd.patch
mm-huge_memory-copy-file-thps-at-fork-like-copy_present_ptes-does.patch
mm-huge_memory-read-a-special-pmd-under-the-lock-in-copy_huge_pmd.patch
selftests-mm-test-fork-of-pmd-mapped-shmem-thps.patch


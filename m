Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7661D5146
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 02:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754448131; cv=none; b=gGrT9U6HLbqGxkiCNu13c2iQnY0c08Nz7ezJAtl3+6UQFOwV3kvTXbCVNxO56umasiNiIhNnjdnUjzTcx9KoO+dxuQ017adTDSnp8e6rEL0lblDPnONDTmQOeG2iyI7WvqctWDDJC6y4ZHz7yp865xUcR1X6froDn1hwXZd3lIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754448131; c=relaxed/simple;
	bh=y5OqZr01s/zd46QyZH6Ak5FWXUf+GFwP0dbPDYZaLio=;
	h=Date:To:From:Subject:Message-Id; b=iDXL40mQkhNP6Vdrkig8QZ0j4YF2lcfVXkxgQVLGQhkBQFs6KsOvtP6ESxRIE24vTvpj91T0nFfjPTehAKlu6OWvtM4HDG43S0Ln5z05vjs5n+UbUNVHe3WFbEkh2A2J76KzaQNiGm7WGj76KOAUjlpecu9VGqOQzJ1AOjB3qEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sUalV1G3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sUalV1G3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D420C4CEF0;
	Wed,  6 Aug 2025 02:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754448129;
	bh=y5OqZr01s/zd46QyZH6Ak5FWXUf+GFwP0dbPDYZaLio=;
	h=Date:To:From:Subject:From;
	b=sUalV1G3/WVFuXicQdVUT9eT4SfE0VX4cSfIgIRh7eSLsB29eanyg1Zr/pB2mITZR
	 Oi6qOnI2MMEHsMYOBXkL5ulee7suXZhDMlYTjkhJq4QaDM6k9FMB/3h/a1Aub7kdTH
	 f1mKo0JvXOUip59/EKmhH1bBlSiS5iM6gERZxIPk=
Date: Tue, 05 Aug 2025 19:42:08 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,axelrasmussen@google.com,sudarsanm@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-pass-filename-as-input-param-to-vm_pfnmap-tests.patch added to mm-new branch
Message-Id: <20250806024209.5D420C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: pass filename as input param to VM_PFNMAP tests
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-pass-filename-as-input-param-to-vm_pfnmap-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-pass-filename-as-input-param-to-vm_pfnmap-tests.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Sudarsan Mahendran <sudarsanm@google.com>
Subject: selftests/mm: pass filename as input param to VM_PFNMAP tests
Date: Mon, 4 Aug 2025 18:36:29 -0700

Enable these tests to be run on other pfnmap'ed memory like NVIDIA's EGM.

Add '--' as a separator to pass in file path.  This allows passing of cmd
line arguments to kselftest_harness.  Use '/dev/mem' as default filename.

Existing test passes:
	pfnmap
	TAP version 13
	1..6
	# Starting 6 tests from 1 test cases.
	# PASSED: 6 / 6 tests passed.
	# Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0

Pass params to kselftest_harness:
	pfnmap -r pfnmap:mremap_fixed
	TAP version 13
	1..1
	# Starting 1 tests from 1 test cases.
	#  RUN           pfnmap.mremap_fixed ...
	#            OK  pfnmap.mremap_fixed
	ok 1 pfnmap.mremap_fixed
	# PASSED: 1 / 1 tests passed.
	# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

Pass non-existent file name as input:
	pfnmap -- /dev/blah
	TAP version 13
	1..6
	# Starting 6 tests from 1 test cases.
	#  RUN           pfnmap.madvise_disallowed ...
	#      SKIP      Cannot open '/dev/blah'

Pass non pfnmap'ed file as input:
	pfnmap -r pfnmap.madvise_disallowed -- randfile.txt
	TAP version 13
	1..1
	# Starting 1 tests from 1 test cases.
	#  RUN           pfnmap.madvise_disallowed ...
	#      SKIP      Invalid file: 'randfile.txt'. Not pfnmap'ed

Link: https://lkml.kernel.org/r/20250805013629.47629-1-sudarsanm@google.com
Signed-off-by: Sudarsan Mahendran <sudarsanm@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Shuah Khan <shuah@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pfnmap.c  |   48 +++++++++++++++++--------
 tools/testing/selftests/mm/vm_util.c |   14 ++++++-
 tools/testing/selftests/mm/vm_util.h |    1 
 3 files changed, 47 insertions(+), 16 deletions(-)

--- a/tools/testing/selftests/mm/pfnmap.c~selftests-mm-pass-filename-as-input-param-to-vm_pfnmap-tests
+++ a/tools/testing/selftests/mm/pfnmap.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Basic VM_PFNMAP tests relying on mmap() of '/dev/mem'
+ * Basic VM_PFNMAP tests relying on mmap() of input file provided.
+ * Use '/dev/mem' as default.
  *
  * Copyright 2025, Red Hat, Inc.
  *
@@ -25,6 +26,7 @@
 #include "vm_util.h"
 
 static sigjmp_buf sigjmp_buf_env;
+static char *file = "/dev/mem";
 
 static void signal_handler(int sig)
 {
@@ -51,7 +53,7 @@ static int test_read_access(char *addr,
 	return ret;
 }
 
-static int find_ram_target(off_t *phys_addr,
+static int find_ram_target(off_t *offset,
 		unsigned long long pagesize)
 {
 	unsigned long long start, end;
@@ -91,7 +93,7 @@ static int find_ram_target(off_t *phys_a
 		/* We need two pages. */
 		if (end > start + 2 * pagesize) {
 			fclose(file);
-			*phys_addr = start;
+			*offset = start;
 			return 0;
 		}
 	}
@@ -100,7 +102,7 @@ static int find_ram_target(off_t *phys_a
 
 FIXTURE(pfnmap)
 {
-	off_t phys_addr;
+	off_t offset;
 	size_t pagesize;
 	int dev_mem_fd;
 	char *addr1;
@@ -113,23 +115,31 @@ FIXTURE_SETUP(pfnmap)
 {
 	self->pagesize = getpagesize();
 
-	/* We'll require two physical pages throughout our tests ... */
-	if (find_ram_target(&self->phys_addr, self->pagesize))
-		SKIP(return, "Cannot find ram target in '/proc/iomem'\n");
+	if (strncmp(file, "/dev/mem", strlen("/dev/mem")) == 0) {
+		/* We'll require two physical pages throughout our tests ... */
+		if (find_ram_target(&self->offset, self->pagesize))
+			SKIP(return,
+				   "Cannot find ram target in '/proc/iomem'\n");
+	} else {
+		self->offset = 0;
+	}
 
-	self->dev_mem_fd = open("/dev/mem", O_RDONLY);
+	self->dev_mem_fd = open(file, O_RDONLY);
 	if (self->dev_mem_fd < 0)
-		SKIP(return, "Cannot open '/dev/mem'\n");
+		SKIP(return, "Cannot open '%s'\n", file);
 
 	self->size1 = self->pagesize * 2;
 	self->addr1 = mmap(NULL, self->size1, PROT_READ, MAP_SHARED,
-			   self->dev_mem_fd, self->phys_addr);
+			   self->dev_mem_fd, self->offset);
 	if (self->addr1 == MAP_FAILED)
-		SKIP(return, "Cannot mmap '/dev/mem'\n");
+		SKIP(return, "Cannot mmap '%s'\n", file);
+
+	if (!check_vmflag_pfnmap(self->addr1))
+		SKIP(return, "Invalid file: '%s'. Not pfnmap'ed\n", file);
 
 	/* ... and want to be able to read from them. */
 	if (test_read_access(self->addr1, self->size1, self->pagesize))
-		SKIP(return, "Cannot read-access mmap'ed '/dev/mem'\n");
+		SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
 
 	self->size2 = 0;
 	self->addr2 = MAP_FAILED;
@@ -182,7 +192,7 @@ TEST_F(pfnmap, munmap_split)
 	 */
 	self->size2 = self->pagesize;
 	self->addr2 = mmap(NULL, self->pagesize, PROT_READ, MAP_SHARED,
-			   self->dev_mem_fd, self->phys_addr);
+			   self->dev_mem_fd, self->offset);
 	ASSERT_NE(self->addr2, MAP_FAILED);
 }
 
@@ -246,4 +256,14 @@ TEST_F(pfnmap, fork)
 	ASSERT_EQ(ret, 0);
 }
 
-TEST_HARNESS_MAIN
+int main(int argc, char **argv)
+{
+	for (int i = 1; i < argc; i++) {
+		if (strcmp(argv[i], "--") == 0) {
+			if (i + 1 < argc && strlen(argv[i + 1]) > 0)
+				file = argv[i + 1];
+			return test_harness_run(i, argv);
+		}
+	}
+	return test_harness_run(argc, argv);
+}
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-pass-filename-as-input-param-to-vm_pfnmap-tests
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -402,7 +402,7 @@ unsigned long get_free_hugepages(void)
 	return fhp;
 }
 
-bool check_vmflag_io(void *addr)
+static bool check_vmflag(void *addr, const char *flag)
 {
 	char buffer[MAX_LINE_LENGTH];
 	const char *flags;
@@ -419,13 +419,23 @@ bool check_vmflag_io(void *addr)
 		if (!flaglen)
 			return false;
 
-		if (flaglen == strlen("io") && !memcmp(flags, "io", flaglen))
+		if (flaglen == strlen(flag) && !memcmp(flags, flag, flaglen))
 			return true;
 
 		flags += flaglen;
 	}
 }
 
+bool check_vmflag_io(void *addr)
+{
+	return check_vmflag(addr, "io");
+}
+
+bool check_vmflag_pfnmap(void *addr)
+{
+	return check_vmflag(addr, "pf");
+}
+
 /*
  * Open an fd at /proc/$pid/maps and configure procmap_out ready for
  * PROCMAP_QUERY query. Returns 0 on success, or an error code otherwise.
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-pass-filename-as-input-param-to-vm_pfnmap-tests
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -93,6 +93,7 @@ int uffd_register_with_ioctls(int uffd,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls);
 unsigned long get_free_hugepages(void);
 bool check_vmflag_io(void *addr);
+bool check_vmflag_pfnmap(void *addr);
 int open_procmap(pid_t pid, struct procmap_fd *procmap_out);
 int query_procmap(struct procmap_fd *procmap);
 bool find_vma_procmap(struct procmap_fd *procmap, void *address);
_

Patches currently in -mm which might be from sudarsanm@google.com are

selftests-mm-pass-filename-as-input-param-to-vm_pfnmap-tests.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC33769D2B
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 02:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754103219; cv=none; b=r5Lq/EKnsAl1G/cR3CNs+AnWuwlNZRW0CpbIonhq6T+PUB2zDz6r5B5DQFOjoZjkYpl3tMirNcu98hMRQF7rpf7Rk41fcAtgHalCfysJILhFZ5ajjgDitdjFdCiJWXQZ/3Z7mItaeX/PNj0Pc1sMIRRghu8B04oqeOXPQbdeROc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754103219; c=relaxed/simple;
	bh=qj493qykik/q1U6bKKATqA1/arssT69Q20Bi6HLS0tM=;
	h=Date:To:From:Subject:Message-Id; b=izLRIyOoW425tiORH0nsJxJhbaSkF3L5BEw0ZrJ7gSeC2qSI4Iz9mYF2dQQx+nlEIoVmbwSbYWkqzRGl5FOlCaIZSYoWzqGD7OQMFSktBQCi9OoTDYaYA/lJhWYdfkQNB1aLHfel8N55Lq2179fU/pivC+neU1istcrfovuC1Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P0eRH8gq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P0eRH8gq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFD5C4CEE7;
	Sat,  2 Aug 2025 02:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754103218;
	bh=qj493qykik/q1U6bKKATqA1/arssT69Q20Bi6HLS0tM=;
	h=Date:To:From:Subject:From;
	b=P0eRH8gq9+ocntUPKcDBMToXoAuMyFlwE6QpTZrDVKIIocXYpdUZrXFzhhQltTCg3
	 V/YBYieEivFwkYyLHNzvWJOtIqII5T6oYQCYBFWh/kJ7hgMdUWyrY0r851853mMhQU
	 zBZ6mMZBrdlmn8lQaJN9uX1gftBsDV9wbQ2RuPN8=
Date: Fri, 01 Aug 2025 19:53:37 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,axelrasmussen@google.com,sudarsanm@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-pass-filename-as-input-param-to-vm_pfnmap-tests.patch added to mm-new branch
Message-Id: <20250802025338.0BFD5C4CEE7@smtp.kernel.org>
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
Date: Fri, 1 Aug 2025 16:45:59 -0700

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
	pfnmap -r pfnmap.madvise_disallowed -- randfile
	TAP version 13
	1..1
	# Starting 1 tests from 1 test cases.
	#  RUN           pfnmap.madvise_disallowed ...
	#      SKIP      Invalid file: 'randfile'. Not pfnmap'ed

Link: https://lkml.kernel.org/r/20250801234559.1178521-1-sudarsanm@google.com
Signed-off-by: Sudarsan Mahendran <sudarsanm@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pfnmap.c |   62 ++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 9 deletions(-)

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
@@ -98,6 +100,30 @@ static int find_ram_target(off_t *phys_a
 	return -ENOENT;
 }
 
+static int verify_pfnmap(void)
+{
+	FILE *smaps_fp;
+	char line[512];
+	int found_mmap_entry = 0;
+
+	smaps_fp = fopen("/proc/self/smaps", "r");
+	if (!smaps_fp)
+		return -errno;
+	while (fgets(line, sizeof(line), smaps_fp) != NULL) {
+		if (strstr(line, file) && strstr(line, " r--s "))
+			found_mmap_entry = 1;
+
+		if (found_mmap_entry &&
+		    strncmp(line, "VmFlags:", strlen("VmFlags:")) == 0) {
+			if (strstr(line, " pf "))
+				return 0;
+			found_mmap_entry = 0;
+		}
+	}
+	fclose(smaps_fp);
+	return -ENOENT;
+}
+
 FIXTURE(pfnmap)
 {
 	off_t phys_addr;
@@ -113,23 +139,31 @@ FIXTURE_SETUP(pfnmap)
 {
 	self->pagesize = getpagesize();
 
-	/* We'll require two physical pages throughout our tests ... */
-	if (find_ram_target(&self->phys_addr, self->pagesize))
-		SKIP(return, "Cannot find ram target in '/proc/iomem'\n");
+	if (strncmp(file, "/dev/mem", strlen("/dev/mem")) == 0) {
+		/* We'll require two physical pages throughout our tests ... */
+		if (find_ram_target(&self->phys_addr, self->pagesize))
+			SKIP(return,
+				   "Cannot find ram target in '/proc/iomem'\n");
+	} else {
+		self->phys_addr = 0;
+	}
 
-	self->dev_mem_fd = open("/dev/mem", O_RDONLY);
+	self->dev_mem_fd = open(file, O_RDONLY);
 	if (self->dev_mem_fd < 0)
-		SKIP(return, "Cannot open '/dev/mem'\n");
+		SKIP(return, "Cannot open '%s'\n", file);
 
 	self->size1 = self->pagesize * 2;
 	self->addr1 = mmap(NULL, self->size1, PROT_READ, MAP_SHARED,
 			   self->dev_mem_fd, self->phys_addr);
 	if (self->addr1 == MAP_FAILED)
-		SKIP(return, "Cannot mmap '/dev/mem'\n");
+		SKIP(return, "Cannot mmap '%s'\n", file);
+
+	if (verify_pfnmap())
+		SKIP(return, "Invalid file: '%s'. Not pfnmap'ed\n", file);
 
 	/* ... and want to be able to read from them. */
 	if (test_read_access(self->addr1, self->size1, self->pagesize))
-		SKIP(return, "Cannot read-access mmap'ed '/dev/mem'\n");
+		SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
 
 	self->size2 = 0;
 	self->addr2 = MAP_FAILED;
@@ -246,4 +280,14 @@ TEST_F(pfnmap, fork)
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
_

Patches currently in -mm which might be from sudarsanm@google.com are

selftests-mm-pass-filename-as-input-param-to-vm_pfnmap-tests.patch


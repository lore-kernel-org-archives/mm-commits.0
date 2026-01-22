Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5D0367F5D
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769106405; cv=none; b=PbgjRI9gOA3y6dbRr94KGhWN3iY0rTELMLmFBp3o+SJZ6WwCAjKaOiO96BAB9IhdGqE1eMUIASqLRhTZHtfgIMr/XGuRL3SeaP/N2116IoEnTlUC8Zu6vjkRP+a48YiC6qLB3AA5QFc5kbp5vJH/U27Y+aHB6MZNdYb7w7thm8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769106405; c=relaxed/simple;
	bh=UMukpV23YWhPUkXHNub9+rhi6rdu67Itk9+eDvD7aGQ=;
	h=Date:To:From:Subject:Message-Id; b=NSUAn3gamd5p3osQc4y9evW5GWguCFu95VmhY6CZkb9O67F1is5/Na53LJdX5M0+5YkcBxKArbYOnBYZiKF0Cm0SWOSVfhUrPNWgPWqdO1PSAHUFwGf+lHqmHsyLmKbZSdXUEXONzLYBqtks8Ld0u/RE+jvn4bliD3CSBopJ3Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LrQKb951; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LrQKb951"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A46C116D0;
	Thu, 22 Jan 2026 18:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769106402;
	bh=UMukpV23YWhPUkXHNub9+rhi6rdu67Itk9+eDvD7aGQ=;
	h=Date:To:From:Subject:From;
	b=LrQKb951xEL0MIbJaS7IKUmkR+Fv61ZaRZFPZGayn2cQy9HNUKJrTdeLyH5HFESg7
	 Cefz9wHyEJn6Pf34xqxQsjaOL8aG4V/ptTsQ6RNHqbFsiZJZHXYN2BGbMz/UwYD66L
	 grUlaml8rpawwcs0uRKzkk1ZaR4OIGQHmuCP0LKI=
Date: Thu, 22 Jan 2026 10:26:41 -0800
To: mm-commits@vger.kernel.org,Usama.Anjum@arm.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,pabeni@redhat.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,lianux.mm@gmail.com,jhubbard@nvidia.com,jgg@nvidia.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch added to mm-unstable branch
Message-Id: <20260122182642.87A46C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: report SKIP in pfnmap if a check fails
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: report SKIP in pfnmap if a check fails
Date: Thu, 22 Jan 2026 17:02:24 +0000

pfnmap currently checks the target file in FIXTURE_SETUP(pfnmap), meaning
once for every test, and skips the test if any check fails.

The target file is the same for every test so this is a little overkill. 
More importantly, this approach means that the whole suite will report
PASS even if all the tests are skipped because kernel configuration (e.g. 
CONFIG_STRICT_DEVMEM=y) prevented /dev/mem from being mapped, for
instance.

Let's ensure that KSFT_SKIP is returned as exit code if any check fails by
performing the checks in pfnmap_init(), run once.  That function also
takes care of finding the offset of the pages to be mapped and saves it in
a global.  The file is now opened only once and the fd saved in a global,
but it is still mapped/unmapped for every test, as some of them modify the
mapping.

Link: https://lkml.kernel.org/r/20260122170224.4056513-10-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pfnmap.c |   84 ++++++++++++++++----------
 1 file changed, 53 insertions(+), 31 deletions(-)

--- a/tools/testing/selftests/mm/pfnmap.c~selftests-mm-report-skip-in-pfnmap-if-a-check-fails
+++ a/tools/testing/selftests/mm/pfnmap.c
@@ -25,8 +25,12 @@
 #include "kselftest_harness.h"
 #include "vm_util.h"
 
+#define DEV_MEM_NPAGES	2
+
 static sigjmp_buf sigjmp_buf_env;
 static char *file = "/dev/mem";
+static off_t file_offset;
+static int fd;
 
 static void signal_handler(int sig)
 {
@@ -88,7 +92,7 @@ static int find_ram_target(off_t *offset
 			break;
 
 		/* We need two pages. */
-		if (end > start + 2 * pagesize) {
+		if (end > start + DEV_MEM_NPAGES * pagesize) {
 			fclose(file);
 			*offset = start;
 			return 0;
@@ -97,11 +101,48 @@ static int find_ram_target(off_t *offset
 	return -ENOENT;
 }
 
+static void pfnmap_init(void)
+{
+	size_t pagesize = getpagesize();
+	size_t size = DEV_MEM_NPAGES * pagesize;
+	void *addr;
+
+	if (strncmp(file, "/dev/mem", strlen("/dev/mem")) == 0) {
+		int err = find_ram_target(&file_offset, pagesize);
+
+		if (err)
+			ksft_exit_skip("Cannot find ram target in '/proc/iomem': %s\n",
+				       strerror(-err));
+	} else {
+		file_offset = 0;
+	}
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		ksft_exit_skip("Cannot open '%s': %s\n", file, strerror(errno));
+
+	/*
+	 * Make sure we can map the file, and perform some basic checks; skip
+	 * the whole suite if anything goes wrong.
+	 * A fresh mapping is then created for every test case by
+	 * FIXTURE_SETUP(pfnmap).
+	 */
+	addr = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, file_offset);
+	if (addr == MAP_FAILED)
+		ksft_exit_skip("Cannot mmap '%s': %s\n", file, strerror(errno));
+
+	if (!check_vmflag_pfnmap(addr))
+		ksft_exit_skip("Invalid file: '%s'. Not pfnmap'ed\n", file);
+
+	if (test_read_access(addr, size, pagesize))
+		ksft_exit_skip("Cannot read-access mmap'ed '%s'\n", file);
+
+	munmap(addr, size);
+}
+
 FIXTURE(pfnmap)
 {
-	off_t offset;
 	size_t pagesize;
-	int dev_mem_fd;
 	char *addr1;
 	size_t size1;
 	char *addr2;
@@ -112,31 +153,10 @@ FIXTURE_SETUP(pfnmap)
 {
 	self->pagesize = getpagesize();
 
-	if (strncmp(file, "/dev/mem", strlen("/dev/mem")) == 0) {
-		/* We'll require two physical pages throughout our tests ... */
-		if (find_ram_target(&self->offset, self->pagesize))
-			SKIP(return,
-				   "Cannot find ram target in '/proc/iomem'\n");
-	} else {
-		self->offset = 0;
-	}
-
-	self->dev_mem_fd = open(file, O_RDONLY);
-	if (self->dev_mem_fd < 0)
-		SKIP(return, "Cannot open '%s'\n", file);
-
-	self->size1 = self->pagesize * 2;
+	self->size1 = DEV_MEM_NPAGES * self->pagesize;
 	self->addr1 = mmap(NULL, self->size1, PROT_READ, MAP_SHARED,
-			   self->dev_mem_fd, self->offset);
-	if (self->addr1 == MAP_FAILED)
-		SKIP(return, "Cannot mmap '%s'\n", file);
-
-	if (!check_vmflag_pfnmap(self->addr1))
-		SKIP(return, "Invalid file: '%s'. Not pfnmap'ed\n", file);
-
-	/* ... and want to be able to read from them. */
-	if (test_read_access(self->addr1, self->size1, self->pagesize))
-		SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
+			   fd, file_offset);
+	ASSERT_NE(self->addr1, MAP_FAILED);
 
 	self->size2 = 0;
 	self->addr2 = MAP_FAILED;
@@ -148,8 +168,6 @@ FIXTURE_TEARDOWN(pfnmap)
 		munmap(self->addr2, self->size2);
 	if (self->addr1 != MAP_FAILED)
 		munmap(self->addr1, self->size1);
-	if (self->dev_mem_fd >= 0)
-		close(self->dev_mem_fd);
 }
 
 TEST_F(pfnmap, madvise_disallowed)
@@ -189,7 +207,7 @@ TEST_F(pfnmap, munmap_split)
 	 */
 	self->size2 = self->pagesize;
 	self->addr2 = mmap(NULL, self->pagesize, PROT_READ, MAP_SHARED,
-			   self->dev_mem_fd, self->offset);
+			   fd, file_offset);
 	ASSERT_NE(self->addr2, MAP_FAILED);
 }
 
@@ -259,8 +277,12 @@ int main(int argc, char **argv)
 		if (strcmp(argv[i], "--") == 0) {
 			if (i + 1 < argc && strlen(argv[i + 1]) > 0)
 				file = argv[i + 1];
-			return test_harness_run(i, argv);
+			argc = i;
+			break;
 		}
 	}
+
+	pfnmap_init();
+
 	return test_harness_run(argc, argv);
 }
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests.patch
selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-check-that-force_read-succeeded.patch
selftests-mm-introduce-helper-to-read-every-page.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch


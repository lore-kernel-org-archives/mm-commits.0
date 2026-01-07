Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BFC3563D0
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 17:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806511; cv=none; b=qwlGE44FNUVvNfsZLQPtaGBEK/GS7BBlrX6N1cVEqYkuZnhJF5RQjujXPY/24hy4SUdspA6w2nlzRbiv1o2Zz9DoCgGYFt2vVbQ2WXY+u9D9XqheShq1JaFrB39k5bg851OtxSdvlaoEtrQlbTl01udqgXPU8E44p+IwKx9sjYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806511; c=relaxed/simple;
	bh=JKzuEtjkf/4+Krsc619cdsiOjR7/z8NTut2d+VAsEsY=;
	h=Date:To:From:Subject:Message-Id; b=V1ENTyEcnUGd4Y8gn8BHOtYugKxTYzMHO7PLhwbB7ye4tUm9PyBh4U8mYhYkWGMJpAJ1V4f2WXmuIYtjtIeXZIOefwcexTwMGDF+4z6dBVuGuKk+CtxxWhGIrCDDOfG/ARAXli5eabN55V6HDu0tFtbWa+ecJJBPZz0rMbAYBco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1gp0xQMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1gp0xQMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D7BC19422;
	Wed,  7 Jan 2026 17:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767806508;
	bh=JKzuEtjkf/4+Krsc619cdsiOjR7/z8NTut2d+VAsEsY=;
	h=Date:To:From:Subject:From;
	b=1gp0xQMRoXBXVxIJ6rJoi0tmkIQ831V3ar0y76teX0KTDiMvgaDu5ehzmgpL4YTp9
	 S29v7sR+o0sjzUbHwJYy0ve2+pJeBLTHv0AAgXqTKG8FNQEcdFsmlQbOIC28gPEcME
	 7BCQIK5o8wagzNHJVVmjgys3V6luesyzpGYsjlKg=
Date: Wed, 07 Jan 2026 09:21:47 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Usama.Anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,pabeni@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,Liam.Howlett@oracle.com,jhubbard@nvidia.com,jgg@nvidia.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch added to mm-new branch
Message-Id: <20260107172148.52D7BC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: report SKIP in pfnmap if a check fails
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Date: Wed, 7 Jan 2026 16:48:42 +0000

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
a global.  The file is still mapped/unmapped for every test, as some of
them modify the mapping.

Link: https://lkml.kernel.org/r/20260107164842.3289559-9-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pfnmap.c |   81 +++++++++++++++++---------
 1 file changed, 55 insertions(+), 26 deletions(-)

--- a/tools/testing/selftests/mm/pfnmap.c~selftests-mm-report-skip-in-pfnmap-if-a-check-fails
+++ a/tools/testing/selftests/mm/pfnmap.c
@@ -25,8 +25,11 @@
 #include "kselftest_harness.h"
 #include "vm_util.h"
 
+#define DEV_MEM_NPAGES	2
+
 static sigjmp_buf sigjmp_buf_env;
 static char *file = "/dev/mem";
+static off_t file_offset;
 
 static void signal_handler(int sig)
 {
@@ -88,7 +91,7 @@ static int find_ram_target(off_t *offset
 			break;
 
 		/* We need two pages. */
-		if (end > start + 2 * pagesize) {
+		if (end > start + DEV_MEM_NPAGES * pagesize) {
 			fclose(file);
 			*offset = start;
 			return 0;
@@ -97,9 +100,49 @@ static int find_ram_target(off_t *offset
 	return -ENOENT;
 }
 
+static void pfnmap_init(void)
+{
+	size_t pagesize = getpagesize();
+	size_t size = DEV_MEM_NPAGES * pagesize;
+	int fd;
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
+	/*
+	 * Make sure we can open and map the file, and perform some basic
+	 * checks; skip the whole suite if anything goes wrong.
+	 * A fresh mapping is then created for every test case by
+	 * FIXTURE_SETUP(pfnmap).
+	 */
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		ksft_exit_skip("Cannot open '%s': %s\n", file, strerror(errno));
+
+	addr = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, file_offset);
+	if (addr == MAP_FAILED)
+		ksft_exit_skip("Cannot mmap '%s': %s\n", file, strerror(errno));
+
+	if (!check_vmflag_pfnmap(addr))
+		ksft_exit_skip("Invalid file: '%s'. Not pfnmap'ed\n", file);
+
+	if (test_read_access(addr, size))
+		ksft_exit_skip("Cannot read-access mmap'ed '%s'\n", file);
+
+	munmap(addr, size);
+	close(fd);
+}
+
 FIXTURE(pfnmap)
 {
-	off_t offset;
 	size_t pagesize;
 	int dev_mem_fd;
 	char *addr1;
@@ -112,31 +155,13 @@ FIXTURE_SETUP(pfnmap)
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
 	self->dev_mem_fd = open(file, O_RDONLY);
-	if (self->dev_mem_fd < 0)
-		SKIP(return, "Cannot open '%s'\n", file);
+	ASSERT_GE(self->dev_mem_fd, 0);
 
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
-	if (test_read_access(self->addr1, self->size1))
-		SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
+			   self->dev_mem_fd, file_offset);
+	ASSERT_NE(self->addr1, MAP_FAILED);
 
 	self->size2 = 0;
 	self->addr2 = MAP_FAILED;
@@ -189,7 +214,7 @@ TEST_F(pfnmap, munmap_split)
 	 */
 	self->size2 = self->pagesize;
 	self->addr2 = mmap(NULL, self->pagesize, PROT_READ, MAP_SHARED,
-			   self->dev_mem_fd, self->offset);
+			   self->dev_mem_fd, file_offset);
 	ASSERT_NE(self->addr2, MAP_FAILED);
 }
 
@@ -258,8 +283,12 @@ int main(int argc, char **argv)
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

x86-xen-simplify-flush_lazy_mmu.patch
powerpc-mm-implement-arch_flush_lazy_mmu_mode.patch
sparc-mm-implement-arch_flush_lazy_mmu_mode.patch
mm-clarify-lazy_mmu-sleeping-constraints.patch
mm-introduce-config_arch_has_lazy_mmu_mode.patch
mm-introduce-generic-lazy_mmu-helpers.patch
mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch
mm-enable-lazy_mmu-sections-to-nest.patch
arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch
powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
sparc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
x86-xen-use-lazy_mmu_state-when-context-switching.patch
mm-add-basic-tests-for-lazy_mmu.patch
mm-add-basic-tests-for-lazy_mmu-fix-fix-fix.patch
selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-introduce-helper-to-read-every-page-in-range.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch


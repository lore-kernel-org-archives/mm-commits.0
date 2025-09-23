Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D17A5789D;
	Tue, 23 Sep 2025 03:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597512; cv=none; b=IEFK6j9X/L7y0EVPlbovG1ULM2H51Dg4m2P+bgLsjq6nsUZb2FUfAMoG6QLfwx6h9z9f8obbfQnqJLul9Nsc28/Ah/NCNIUiAV5h5eKRslC+iZG1a4OkOd5qap6Z2JsybX9/2JgcjESXMTfWhGfS7y40meEszfb4FNh+Y9MFQZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597512; c=relaxed/simple;
	bh=NXz40ixBjnc7WfRXtPH5KPUfovehKAkZNYbCPATLQVQ=;
	h=Date:To:From:Subject:Message-Id; b=doqUjgPAd1604QRh/sh9cNbL/nYLRLar+5EssdCHiqyQpyfKpK/PhbXcQpqX9P84hVxQPvqt7bzg9idYFi2kOa0zgr/bLAhrxERfohAlqmOHHphXyK5DDtY2NEmbksUoj+NcHWFMd18aoclTKh7M7hRzA6yPUGeu4RjQvx2SRqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r1SqWGEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r1SqWGEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE58CC4CEF0;
	Tue, 23 Sep 2025 03:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597512;
	bh=NXz40ixBjnc7WfRXtPH5KPUfovehKAkZNYbCPATLQVQ=;
	h=Date:To:From:Subject:From;
	b=r1SqWGEoe1HYqnGtO2qLdKZuN/0bqmXdbpGL59ecS707LHQDGL28zdInu1LrLqBMo
	 MN+bLjwnrrZXXF2c3YbBADlP7zUdp7NQCv4nwRCs7k/KeZ6wHRuw/VbNgjlhuqRRx7
	 xS5dcZjRfjHnsk2y3rcByVVB3dTGOkgaU+wM+wFA=
Date: Mon, 22 Sep 2025 20:18:31 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,krisman@collabora.com,david@redhat.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-soft-dirty-tests-when-config_mem_soft_dirty-is-disabled.patch removed from -mm tree
Message-Id: <20250923031831.DE58CC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-soft-dirty-tests-when-config_mem_soft_dirty-is-disabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled
Date: Wed, 17 Sep 2025 21:31:37 +0800

The madv_populate and soft-dirty kselftests currently fail on systems
where CONFIG_MEM_SOFT_DIRTY is disabled.

Introduce a new helper softdirty_supported() into vm_util.c/h to ensure
tests are properly skipped when the feature is not enabled.

Link: https://lkml.kernel.org/r/20250917133137.62802-1-lance.yang@linux.dev
Fixes: 9f3265db6ae8 ("selftests: vm: add test for Soft-Dirty PTE bit")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/madv_populate.c |   21 +------------------
 tools/testing/selftests/mm/soft-dirty.c    |    5 +++-
 tools/testing/selftests/mm/vm_util.c       |   17 +++++++++++++++
 tools/testing/selftests/mm/vm_util.h       |    1 
 4 files changed, 24 insertions(+), 20 deletions(-)

--- a/tools/testing/selftests/mm/madv_populate.c~selftests-mm-skip-soft-dirty-tests-when-config_mem_soft_dirty-is-disabled
+++ a/tools/testing/selftests/mm/madv_populate.c
@@ -264,23 +264,6 @@ static void test_softdirty(void)
 	munmap(addr, SIZE);
 }
 
-static int system_has_softdirty(void)
-{
-	/*
-	 * There is no way to check if the kernel supports soft-dirty, other
-	 * than by writing to a page and seeing if the bit was set. But the
-	 * tests are intended to check that the bit gets set when it should, so
-	 * doing that check would turn a potentially legitimate fail into a
-	 * skip. Fortunately, we know for sure that arm64 does not support
-	 * soft-dirty. So for now, let's just use the arch as a corse guide.
-	 */
-#if defined(__aarch64__)
-	return 0;
-#else
-	return 1;
-#endif
-}
-
 int main(int argc, char **argv)
 {
 	int nr_tests = 16;
@@ -288,7 +271,7 @@ int main(int argc, char **argv)
 
 	pagesize = getpagesize();
 
-	if (system_has_softdirty())
+	if (softdirty_supported())
 		nr_tests += 5;
 
 	ksft_print_header();
@@ -300,7 +283,7 @@ int main(int argc, char **argv)
 	test_holes();
 	test_populate_read();
 	test_populate_write();
-	if (system_has_softdirty())
+	if (softdirty_supported())
 		test_softdirty();
 
 	err = ksft_get_fail_cnt();
--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-skip-soft-dirty-tests-when-config_mem_soft_dirty-is-disabled
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -200,8 +200,11 @@ int main(int argc, char **argv)
 	int pagesize;
 
 	ksft_print_header();
-	ksft_set_plan(15);
 
+	if (!softdirty_supported())
+		ksft_exit_skip("soft-dirty is not support\n");
+
+	ksft_set_plan(15);
 	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-skip-soft-dirty-tests-when-config_mem_soft_dirty-is-disabled
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -449,6 +449,23 @@ bool check_vmflag_pfnmap(void *addr)
 	return check_vmflag(addr, "pf");
 }
 
+bool softdirty_supported(void)
+{
+	char *addr;
+	bool supported = false;
+	const size_t pagesize = getpagesize();
+
+	/* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */
+	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (!addr)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	supported = check_vmflag(addr, "sd");
+	munmap(addr, pagesize);
+	return supported;
+}
+
 /*
  * Open an fd at /proc/$pid/maps and configure procmap_out ready for
  * PROCMAP_QUERY query. Returns 0 on success, or an error code otherwise.
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-skip-soft-dirty-tests-when-config_mem_soft_dirty-is-disabled
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -104,6 +104,7 @@ bool find_vma_procmap(struct procmap_fd
 int close_procmap(struct procmap_fd *procmap);
 int write_sysfs(const char *file_path, unsigned long val);
 int read_sysfs(const char *file_path, unsigned long *val);
+bool softdirty_supported(void);
 
 static inline int open_self_procmap(struct procmap_fd *procmap_out)
 {
_

Patches currently in -mm which might be from lance.yang@linux.dev are

hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch
mm-thp-fix-mte-tag-mismatch-when-replacing-zero-filled-subpages.patch


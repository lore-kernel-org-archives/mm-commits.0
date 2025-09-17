Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D6727B328;
	Wed, 17 Sep 2025 22:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758148277; cv=none; b=PCr8nwEGzsVhiuoOx3Cp/uOy2K82lSB5dg8KITL7Vx3Zm2p653L9IUwx0YoCoGTRBttAKN20kYFGyD2pFyVUzxV7sCg+tMG6DH430GGjitqNP1nBLe881TLIXZT6b+DAOFJ87lviTDokQyrSpe75R3biy3BqjeOpDv2GqERJo/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758148277; c=relaxed/simple;
	bh=jcz2bedhP+luopgsdMLmEGjgZvawm0Ycx4QlSiLfpMc=;
	h=Date:To:From:Subject:Message-Id; b=fsLl/KQyrEv1ici6xpNdk4nWSjrXiW5JUZ+OWO2JswqtwRg8657WPL2E/QQvXWovhUH4iKFTOHRNpJww/yXyIBvG3BxMO/CNP1OwJ6L8dDNltEKRzmLfq2aJsUL06LYsz7QlA+TIlQOYAz9eMiSp+Q57Lkn+OXRPXv1pTMeVQBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FHUpHJ/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FHUpHJ/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2D7C4CEE7;
	Wed, 17 Sep 2025 22:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758148276;
	bh=jcz2bedhP+luopgsdMLmEGjgZvawm0Ycx4QlSiLfpMc=;
	h=Date:To:From:Subject:From;
	b=FHUpHJ/qpuOpQLeCBVIA9zqpVG/aVkjBebYofE0wnpOQ7r1Bir70294HtGC5lZUAi
	 UdngtyhKkSZd6SuARvCZc84wQYeTeOOh6+N5OhzLN4bEcvwr4IWrv5rfYH2DW/kP9M
	 lKm+lztUoFORePZ9PTGp5Mx4MYChqCEz+tRvs9rk=
Date: Wed, 17 Sep 2025 15:31:15 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,krisman@collabora.com,david@redhat.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-soft-dirty-tests-when-config_mem_soft_dirty-is-disabled.patch added to mm-new branch
Message-Id: <20250917223115.DF2D7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-soft-dirty-tests-when-config_mem_soft_dirty-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-soft-dirty-tests-when-config_mem_soft_dirty-is-disabled.patch

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
mm-skip-mlocked-thps-that-are-underused-early-in-deferred_split_scan.patch
selftests-mm-skip-soft-dirty-tests-when-config_mem_soft_dirty-is-disabled.patch


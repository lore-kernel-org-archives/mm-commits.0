Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8408121ADC7;
	Thu,  8 May 2025 06:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686460; cv=none; b=lZ8s8MwN7bMyGoE3xcLjE7hVaABXMnbUdvbrDEhQmhNJgvbat/78Xi7btHXmp6YCM9ohnpYEWVN6P+KWL40Nj2tLd8JxUG6fH2Dtz3tiJgOFWS+5WFp+8Y3OEGaN0oVjyIX9Am2gJ3INbLgdI9eoCwPtj2OKyjNYMMrb+ZWMpqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686460; c=relaxed/simple;
	bh=OoqqGUPlcC+oI2DBFfk/ulBweP7jyvWwtt+p7Pn5j6U=;
	h=Date:To:From:Subject:Message-Id; b=DlrHC9prs3HVABWNJRoIQcsE2pay2oOHWfCCuQFNWD3qDVHv2U2M7YwdMn27keBUvjzxFsBOpNQMapmA4na+PgZFtzHtcwZqkZZQDaPuGi8uaE9WGoi1+RgJ13opeqdQ3/jxit7Q0FdQ/mZ4TqoiWXCYbwmS6dratBYMdQR5x7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kCxmCjBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kCxmCjBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BFDC4CEEB;
	Thu,  8 May 2025 06:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686460;
	bh=OoqqGUPlcC+oI2DBFfk/ulBweP7jyvWwtt+p7Pn5j6U=;
	h=Date:To:From:Subject:From;
	b=kCxmCjBF8M/80LCvYB/su7+4mUEWhmwClOw3qOPa7+KZ8hZCMvsaDX4ZO8lhGcyLB
	 9VE35MQkebjiYeqHm/yh1vNoc5CFQkYzaQu0h7B1EcBUpDIIekzk+RaiZfl22n0Zd+
	 pnB4H7z4Id0TZp4QyMIdihGFJddU0pEqH7H2FWvA=
Date: Wed, 07 May 2025 23:40:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-testing-selftests-fix-guard-region-test-tmpfs-assumption.patch removed from -mm tree
Message-Id: <20250508064100.57BFDC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/selftests: fix guard region test tmpfs assumption
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-fix-guard-region-test-tmpfs-assumption.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests: fix guard region test tmpfs assumption
Date: Fri, 25 Apr 2025 17:24:36 +0100

The current implementation of the guard region tests assume that /tmp is
mounted as tmpfs, that is shmem.

This isn't always the case, and at least one instance of a spurious test
failure has been reported as a result.

This assumption is unsafe, rushed and silly - and easily remedied by
simply using memfd, so do so.

We also have to fixup the readonly_file test to explicitly only be
applicable to file-backed cases.

Link: https://lkml.kernel.org/r/20250425162436.564002-1-lorenzo.stoakes@oracle.com
Fixes: 272f37d3e99a ("tools/selftests: expand all guard region tests to file-backed")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/linux-mm/a2d2766b-0ab4-437b-951a-8595a7506fe9@arm.com/
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/guard-regions.c~tools-testing-selftests-fix-guard-region-test-tmpfs-assumption
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -271,12 +271,16 @@ FIXTURE_SETUP(guard_regions)
 	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
 	setup_sighandler();
 
-	if (variant->backing == ANON_BACKED)
+	switch (variant->backing) {
+	case ANON_BACKED:
 		return;
-
-	self->fd = open_file(
-		variant->backing == SHMEM_BACKED ? "/tmp/" : "",
-		self->path);
+	case LOCAL_FILE_BACKED:
+		self->fd = open_file("", self->path);
+		break;
+	case SHMEM_BACKED:
+		self->fd = memfd_create(self->path, 0);
+		break;
+	}
 
 	/* We truncate file to at least 100 pages, tests can modify as needed. */
 	ASSERT_EQ(ftruncate(self->fd, 100 * self->page_size), 0);
@@ -1696,7 +1700,7 @@ TEST_F(guard_regions, readonly_file)
 	char *ptr;
 	int i;
 
-	if (variant->backing == ANON_BACKED)
+	if (variant->backing != LOCAL_FILE_BACKED)
 		SKIP(return, "Read-only test specific to file-backed");
 
 	/* Map shared so we can populate with pattern, populate it, unmap. */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-mm-gup-section.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch
mm-abstract-initial-stack-setup-to-mm-subsystem.patch
mm-move-dup_mmap-to-mm.patch
mm-perform-vma-allocation-freeing-duplication-in-mm.patch
mm-introduce-new-mmap_prepare-file-callback.patch
mm-secretmem-convert-to-mmap_prepare-hook.patch
mm-vma-remove-mmap-retry-merge.patch


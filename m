Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E3A226183;
	Fri, 25 Apr 2025 23:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745623905; cv=none; b=PtbmKqUo8TFgbiaOvrTMc/RBHXZFmFP6FBXjU1r9sD0yJV9Py1T67JJCcpU9sfWZSkG4vXtFgG8byuSna1ysmUfd4inXhQQ/n1Ed+OiUJFscZqSX5CU55U/5cQayOmjkPDiuWlR3VgDAUckoXRE/2at1KgDuJhJYTiFwKHyM7gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745623905; c=relaxed/simple;
	bh=yysLB0MwDSTEJW0odRZr/Y6pQfcBm0g6rSH/F6gEzbE=;
	h=Date:To:From:Subject:Message-Id; b=ATFX1VJ0oHO51beZcMVDNcmRgTRK/qfQ/fDTuQEFswtBHunh6bQaTcSi4svcJE5pW7Ihq3mRqXwv/6L0x4q2yDBUFcsDqrLYXkEbDYkmYP1qzBog2N/juJDFl/4nb9FzCI1Gg62oezHhIXl5Gxl3PYVsuRqyliznbUBo0eA5Q4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nzmpPx+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nzmpPx+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A933C4CEE4;
	Fri, 25 Apr 2025 23:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745623905;
	bh=yysLB0MwDSTEJW0odRZr/Y6pQfcBm0g6rSH/F6gEzbE=;
	h=Date:To:From:Subject:From;
	b=nzmpPx+BiR/q8u+ICk/By+IN9jcj5FkICpzNGprF6TD3WiBZp49LaGoKU8nB2FHVZ
	 N1zFeQAUMd9+EJ3yueNmLrvctXzpMdu1GZu+GaRnTn+VQZOxbfKd+cHHpIfmhxqCsB
	 JfJ2iH8En5kP7a6wSD+ZSVpCAsGwZYIZyuexELJQ=
Date: Fri, 25 Apr 2025 16:31:44 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-fix-guard-region-test-tmpfs-assumption.patch added to mm-hotfixes-unstable branch
Message-Id: <20250425233145.1A933C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: fix guard region test tmpfs assumption
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-testing-selftests-fix-guard-region-test-tmpfs-assumption.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-fix-guard-region-test-tmpfs-assumption.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

maintainers-add-reverse-mapping-section.patch
maintainers-add-core-mm-section.patch
maintainers-add-mm-thp-section.patch
maintainers-add-mm-thp-section-fix.patch
tools-testing-selftests-fix-guard-region-test-tmpfs-assumption.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch


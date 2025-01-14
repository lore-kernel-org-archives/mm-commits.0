Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C9423C6F6
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837014; cv=none; b=gAYEU6aywbU092p6GB94pEfvseB+DveIgGmpkrP1JwJWazpYveBRtsGOK+0GlyGscV0heoVh4XNgo1lAmxK4enNaEZk3jRex1ibGNylhEQTjiiW8jbSxRo1cwDPXJR/BomoLCtM6FH9MRx6+S47FLtH/ZN9e/podi6P99XCxOPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837014; c=relaxed/simple;
	bh=h4nXUK5OhhVs/Ld+cvGoZMUirGeBiVH9wxHX1Deh5jU=;
	h=Date:To:From:Subject:Message-Id; b=F8Xxr6JOe7SQH2dH+iuDgsoeskp5H7dnlM//PsB0lQYeFVs/zgbTwLWWHVCB2GpEI85URtbLQw8/EKcgBCZaAb9ULE5TIIqUziaxN88F7lBOCXoiYkR0fGRvDtfu8qHo0Gg6ThLoCwcmG/Y/ciSkZ491NHHSATjQy71Atqqc8rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tl7YDcoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tl7YDcoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3703EC4CEDD;
	Tue, 14 Jan 2025 06:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837014;
	bh=h4nXUK5OhhVs/Ld+cvGoZMUirGeBiVH9wxHX1Deh5jU=;
	h=Date:To:From:Subject:From;
	b=tl7YDcoEg2mYh0FlF8yqCERjnO59OZoQ9O/8O6R0tFwEQzrgP3w++XClO+EP84S6u
	 rhyVXpevy7P6+14JkYKqz/mHkAZdXdzWXhJZT6I170lBLkqwDmbLEP4/UVkXqJOpVo
	 cyZ9PDkWBqIaRm4UBEqz6HxiCHz0PuztYkj5ARU8=
Date: Mon, 13 Jan 2025 22:43:33 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shuah@kernel.org,ryan.roberts@arm.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-fork-cow-guard-page-test.patch removed from -mm tree
Message-Id: <20250114064334.3703EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add fork CoW guard page test
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-fork-cow-guard-page-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: selftests/mm: add fork CoW guard page test
Date: Thu, 5 Dec 2024 19:07:48 +0000

When we fork anonymous pages, apply a guard page then remove it, the
previous CoW mapping is cleared.

This might not be obvious to an outside observer without taking some time
to think about how the overall process functions, so document that this is
the case through a test, which also usefully asserts that the behaviour is
as we expect.

This is grouped with other, more important, fork tests that ensure that
guard pages are correctly propagated on fork.

Fix a typo in a nearby comment at the same time.

[ryan.roberts@arm.com: static process_madvise() wrapper for guard-pages]
  Link: https://lkml.kernel.org/r/20250107142937.1870478-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20241205190748.115656-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-pages.c  |   83 +++++++++++++++++++-
 tools/testing/selftests/mm/run_vmtests.sh |    5 +
 2 files changed, 85 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/guard-pages.c~selftests-mm-add-fork-cow-guard-page-test
+++ a/tools/testing/selftests/mm/guard-pages.c
@@ -55,6 +55,12 @@ static int pidfd_open(pid_t pid, unsigne
 	return syscall(SYS_pidfd_open, pid, flags);
 }
 
+static ssize_t sys_process_madvise(int pidfd, const struct iovec *iovec,
+				   size_t n, int advice, unsigned int flags)
+{
+	return syscall(__NR_process_madvise, pidfd, iovec, n, advice, flags);
+}
+
 /*
  * Enable our signal catcher and try to read/write the specified buffer. The
  * return value indicates whether the read/write succeeds without a fatal
@@ -419,7 +425,7 @@ TEST_F(guard_pages, process_madvise)
 	ASSERT_EQ(munmap(&ptr_region[99 * page_size], page_size), 0);
 
 	/* Now guard in one step. */
-	count = process_madvise(pidfd, vec, 6, MADV_GUARD_INSTALL, 0);
+	count = sys_process_madvise(pidfd, vec, 6, MADV_GUARD_INSTALL, 0);
 
 	/* OK we don't have permission to do this, skip. */
 	if (count == -1 && errno == EPERM)
@@ -440,7 +446,7 @@ TEST_F(guard_pages, process_madvise)
 	ASSERT_FALSE(try_read_write_buf(&ptr3[19 * page_size]));
 
 	/* Now do the same with unguard... */
-	count = process_madvise(pidfd, vec, 6, MADV_GUARD_REMOVE, 0);
+	count = sys_process_madvise(pidfd, vec, 6, MADV_GUARD_REMOVE, 0);
 
 	/* ...and everything should now succeed. */
 
@@ -990,7 +996,7 @@ TEST_F(guard_pages, fork)
 		   MAP_ANON | MAP_PRIVATE, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
-	/* Establish guard apges in the first 5 pages. */
+	/* Establish guard pages in the first 5 pages. */
 	ASSERT_EQ(madvise(ptr, 5 * page_size, MADV_GUARD_INSTALL), 0);
 
 	pid = fork();
@@ -1026,6 +1032,77 @@ TEST_F(guard_pages, fork)
 	}
 
 	/* Cleanup. */
+	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
+}
+
+/*
+ * Assert expected behaviour after we fork populated ranges of anonymous memory
+ * and then guard and unguard the range.
+ */
+TEST_F(guard_pages, fork_cow)
+{
+	const unsigned long page_size = self->page_size;
+	char *ptr;
+	pid_t pid;
+	int i;
+
+	/* Map 10 pages. */
+	ptr = mmap(NULL, 10 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/* Populate range. */
+	for (i = 0; i < 10 * page_size; i++) {
+		char chr = 'a' + (i % 26);
+
+		ptr[i] = chr;
+	}
+
+	pid = fork();
+	ASSERT_NE(pid, -1);
+	if (!pid) {
+		/* This is the child process now. */
+
+		/* Ensure the range is as expected. */
+		for (i = 0; i < 10 * page_size; i++) {
+			char expected = 'a' + (i % 26);
+			char actual = ptr[i];
+
+			ASSERT_EQ(actual, expected);
+		}
+
+		/* Establish guard pages across the whole range. */
+		ASSERT_EQ(madvise(ptr, 10 * page_size, MADV_GUARD_INSTALL), 0);
+		/* Remove it. */
+		ASSERT_EQ(madvise(ptr, 10 * page_size, MADV_GUARD_REMOVE), 0);
+
+		/*
+		 * By removing the guard pages, the page tables will be
+		 * cleared. Assert that we are looking at the zero page now.
+		 */
+		for (i = 0; i < 10 * page_size; i++) {
+			char actual = ptr[i];
+
+			ASSERT_EQ(actual, '\0');
+		}
+
+		exit(0);
+	}
+
+	/* Parent process. */
+
+	/* Parent simply waits on child. */
+	waitpid(pid, NULL, 0);
+
+	/* Ensure the range is unchanged in parent anon range. */
+	for (i = 0; i < 10 * page_size; i++) {
+		char expected = 'a' + (i % 26);
+		char actual = ptr[i];
+
+		ASSERT_EQ(actual, expected);
+	}
+
+	/* Cleanup. */
 	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
 }
 
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-add-fork-cow-guard-page-test
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -45,6 +45,8 @@ separated by spaces:
 	vmalloc smoke tests
 - hmm
 	hmm smoke tests
+- madv_guard
+	test madvise(2) MADV_GUARD_INSTALL and MADV_GUARD_REMOVE options
 - madv_populate
 	test memadvise(2) MADV_POPULATE_{READ,WRITE} options
 - memfd_secret
@@ -375,6 +377,9 @@ CATEGORY="mremap" run_test ./mremap_dont
 
 CATEGORY="hmm" run_test bash ./test_hmm.sh smoke
 
+# MADV_GUARD_INSTALL and MADV_GUARD_REMOVE tests
+CATEGORY="madv_guard" run_test ./guard-pages
+
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch


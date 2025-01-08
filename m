Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90446194A66
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 04:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736311951; cv=none; b=hSQ2H87Ezon5u2BpqBBV3Gwrt+3CZPHA7DWvPHrW2m0GLW02mTvQ7sdyj2tBCJijOEZQZmQ9cRNyTg260PUwHsrIbsuvp39n5iVi3+86HyUr4EEibtsRUXIHwfPutMQhgSWQiPYr7tu0763PNZQCigrMR3tzQeqzpgS1GXvFQgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736311951; c=relaxed/simple;
	bh=yBSMnM2mHH9mdsO/86wGIOoU9mGDNiCnF3kSKdu2qeQ=;
	h=Date:To:From:Subject:Message-Id; b=KTrYF8YtExF/MPg0IWz/MPL9h0oTFHNFTN8k5ICtoeNUFq7/AsIXjLjZZ+lB6NPBWTu5OSYut454hdd0aHFsOa5Bjq9HDxX5aWqo4wRjDQv7J1V8ULVYCxFsdnRqOPqo276Ela293AcpoMXLV6iXlLr/Z5P2wNMXFfXQ4EzpTEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x4zz18tL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x4zz18tL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0C3C4CED0;
	Wed,  8 Jan 2025 04:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736311951;
	bh=yBSMnM2mHH9mdsO/86wGIOoU9mGDNiCnF3kSKdu2qeQ=;
	h=Date:To:From:Subject:From;
	b=x4zz18tLxK2MLoBVZsV7t8dSEbzMe7U5FJIswu8fIlHArHJER0rJ2UmASxB88EVt2
	 1bJJb6BWcgVIHY8Ioooxq3fhBhoEyDGBM0zZRyf8M0Sr4dDIv7ByKTjp3eCnLNVwK1
	 rISiXf7kErxuAlQWr0gNQhvELnna4KFMxkpxhxXk=
Date: Tue, 07 Jan 2025 20:52:30 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shuah@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-fork-cow-guard-page-test-fix.patch added to mm-unstable branch
Message-Id: <20250108045231.0B0C3C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: static process_madvise() wrapper for guard-pages
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-fork-cow-guard-page-test-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-fork-cow-guard-page-test-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: static process_madvise() wrapper for guard-pages
Date: Tue, 7 Jan 2025 14:29:35 +0000

The recently introduced guard-pages mm selftest uses the process_madvise()
syscall, a wrapper for which was added to glibc v2.36.  For those of us
stuck with older distributions this causes a compile error when compiling
the mm selftests.  For example Ubuntu 22.04 uses glibc 2.35, which does
not have the wrapper.

To workaround the issue, let's introduce our own static process_madvise()
wrapper that uses glibc's syscall() helper.

While we are at it, add the guard-page test suite to run_vmtests.sh so
that it can be automatically run by CI systems.

Link: https://lkml.kernel.org/r/20250107142937.1870478-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-pages.c  |   10 ++++++++--
 tools/testing/selftests/mm/run_vmtests.sh |    5 +++++
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/guard-pages.c~selftests-mm-add-fork-cow-guard-page-test-fix
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
 
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-add-fork-cow-guard-page-test-fix
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

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-clear-uffd-wp-pte-pmd-state-on-mremap.patch
selftests-mm-add-fork-cow-guard-page-test-fix.patch
selftests-mm-introduce-uffd-wp-mremap-regression-test.patch


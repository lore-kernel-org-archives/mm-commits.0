Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A68D22F11
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736835967; cv=none; b=YfGEI6ns8i4WgzafihG0iCoLMMDYscU9+bjJOdeKuyGIGcDYbF1EZB9FACrgR9VsY3JqumLnbpSA24R6Y64FJxBc/AwhLfdJNJMJBJh4YhEYpEoC9twwOZlo7JFjzzt6ISSHZpzQk9+U4Lo2HfObYvu0ard+zwav5yGkemdROWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736835967; c=relaxed/simple;
	bh=bcXCsgADa2NEgT1hWVET01fND/ZehFhFOrXITcdhh5o=;
	h=Date:To:From:Subject:Message-Id; b=YZKpQoQXo92SEBSfPlp7iHV0LhAPlNof+EqfXkjC7udfKMYuvuh2TNymBMloukH0pbnYJAGL7ApyestjiDqJZukbTBOZrjadPhF/i/PdIrwXMgGpcztqRMKsClm4evKyAOEY0UzkvjgYdfDjHxuKIP+rlTnJfH6KhkStL8msCbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iEAr53d/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iEAr53d/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE0AC4CEDD;
	Tue, 14 Jan 2025 06:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736835966;
	bh=bcXCsgADa2NEgT1hWVET01fND/ZehFhFOrXITcdhh5o=;
	h=Date:To:From:Subject:From;
	b=iEAr53d/qthy0yax2mNl1qOUICs50ZaNvrA1WMGziDNJkB4FJ14SjGWSp4UJRfCzG
	 aTQNneLZAlVsabltUMYifVbvX1RSC7ymuY13gZkDPkcMkB33sIU+9y+E6mcTB23gyk
	 h1BgWCY5hGj/e9uDNx0vUliW3H4xaMk1x8wLHOYY=
Date: Mon, 13 Jan 2025 22:26:05 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shuah@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-add-fork-cow-guard-page-test-fix.patch removed from -mm tree
Message-Id: <20250114062605.EAE0AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: static process_madvise() wrapper for guard-pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-fork-cow-guard-page-test-fix.patch

This patch was dropped because it was folded into selftests-mm-add-fork-cow-guard-page-test.patch

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

selftests-mm-add-fork-cow-guard-page-test.patch
selftests-mm-introduce-uffd-wp-mremap-regression-test.patch


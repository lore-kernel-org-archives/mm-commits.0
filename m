Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94DF1CEEAE;
	Fri,  1 Nov 2024 18:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730487261; cv=none; b=MtlabDyVTBhraDmfxO15Y+NC7tpd1eFtenef5ypvwg6FYstZzGfz+s4IfAJFVHGWSCu2NwI692+TBfpvFQRyw361dpd65yDAk9UjmCnRzSBIzEyGsJB5squgbOEBHoQZ1sj5jbKacJhXAajZMRd284xyY9XSy0ldmlwvOJ/7uGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730487261; c=relaxed/simple;
	bh=9Y2RG5x4MgeACg6s1JpH/DRQQ+SOj7arnBvLaGCVtLE=;
	h=Date:To:From:Subject:Message-Id; b=p67htMeVSDqGmtK8zsAQU8O3/kTI5dZjNtNhWNuZ/jiWBYevUskLHxYlZ2kwYW7QMHFdaGmCurtg1MmgbDwimgMZh4VVcz/keKlvbfg1QtXzEVz0ty6RnWERA61qtLgkzm1Y4L5OQ/83PyiNQbUXYjaogXzeI7e5BTbMPlsrCfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f4eUZrx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f4eUZrx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA3CC4CED1;
	Fri,  1 Nov 2024 18:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730487261;
	bh=9Y2RG5x4MgeACg6s1JpH/DRQQ+SOj7arnBvLaGCVtLE=;
	h=Date:To:From:Subject:From;
	b=f4eUZrx1mZyvI7HFv+DQvlwG/AWevLH7nP5DKBebNy4GsFf3DBbCTTFUJ1avGiOOz
	 C6jwD8rLq7i4ytbjVrLunGZHmvt8kJd9yW65HNT7zih1EhCdm3vI7Xx4jL21yzebAP
	 iU0UaC2T0JoXlAUnOFAs3k1U+Klsoda+w4yn4Lww=
Date: Fri, 01 Nov 2024 11:54:20 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,donettom@linux.ibm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-hugetlb_dio-check-for-initial-conditions-to-skip-in-the-start.patch added to mm-hotfixes-unstable branch
Message-Id: <20241101185421.2AA3CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: hugetlb_dio: check for initial conditions to skip in the start
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-hugetlb_dio-check-for-initial-conditions-to-skip-in-the-start.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-hugetlb_dio-check-for-initial-conditions-to-skip-in-the-start.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: hugetlb_dio: check for initial conditions to skip in the start
Date: Fri, 1 Nov 2024 19:15:57 +0500

The test should be skipped if initial conditions aren't fulfilled in the
start instead of failing and outputting non-compliant TAP logs.  This kind
of failure pollutes the results.  The initial conditions are:

- The test should only execute if /tmp file can be allocated.
- The test should only execute if huge pages are free.

Before:
TAP version 13
1..4
Bail out! Error opening file
: Read-only file system (30)
 # Planned tests != run tests (4 != 0)
 # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0

After:
TAP version 13
1..0 # SKIP Unable to allocate file: Read-only file system

Link: https://lkml.kernel.org/r/20241101141557.3159432-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Fixes: 3a103b5315b7 ("selftest: mm: Test if hugepage does not get leaked during __bio_release_pages()")
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_dio.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_dio.c~selftests-hugetlb_dio-check-for-initial-conditions-to-skip-in-the-start
+++ a/tools/testing/selftests/mm/hugetlb_dio.c
@@ -44,13 +44,6 @@ void run_dio_using_hugetlb(unsigned int
 	if (fd < 0)
 		ksft_exit_fail_perror("Error opening file\n");
 
-	/* Get the free huge pages before allocation */
-	free_hpage_b = get_free_hugepages();
-	if (free_hpage_b == 0) {
-		close(fd);
-		ksft_exit_skip("No free hugepage, exiting!\n");
-	}
-
 	/* Allocate a hugetlb page */
 	orig_buffer = mmap(NULL, h_pagesize, mmap_prot, mmap_flags, -1, 0);
 	if (orig_buffer == MAP_FAILED) {
@@ -94,8 +87,20 @@ void run_dio_using_hugetlb(unsigned int
 int main(void)
 {
 	size_t pagesize = 0;
+	int fd;
 
 	ksft_print_header();
+
+	/* Open the file to DIO */
+	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
+	if (fd < 0)
+		ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
+	close(fd);
+
+	/* Check if huge pages are free */
+	if (!get_free_hugepages())
+		ksft_exit_skip("No free hugepage, exiting\n");
+
 	ksft_set_plan(4);
 
 	/* Get base page size */
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-hugetlb_dio-check-for-initial-conditions-to-skip-in-the-start.patch


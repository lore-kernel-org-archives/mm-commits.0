Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEF22E62BB
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 21:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715977; cv=none; b=eb1dsQMVW4xmaWZfs6EFzPGxGNLa5r7DIt2Z5bqNiK3JYVgexbLShdHwGtINOeIiGuGh+bt99ifFyCzQEx2bntf9g5RbCFuAj/HrIBPX4fHwNSUSlcow6S3ebDbisw4vwLqGiKPhNC2zhRcWsiH/L2HbA+EPuiiO/F7rLY/aUuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715977; c=relaxed/simple;
	bh=/a1SDRzwgE1RunzZxkma5UN8H+LYQwi8kk6eg+i9lzA=;
	h=Date:To:From:Subject:Message-Id; b=SHfbISmTt7Nlqpush43Z1J3n0xFbYvfwZlBIULc6M0X9vvdR1FOAckmqULKtvwwsD1Fbbdk9ev+V3xp/cQBHIuuOLsblKym3j5m5nhBjFI5pNV6woSxMpklsiVvyToFohnw6M4yaI0afFzOi55q+aHMPiTeFmUJmyFuidULXZsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PkiE9Ejl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PkiE9Ejl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABF1C4CEE3;
	Thu,  3 Apr 2025 21:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743715976;
	bh=/a1SDRzwgE1RunzZxkma5UN8H+LYQwi8kk6eg+i9lzA=;
	h=Date:To:From:Subject:From;
	b=PkiE9EjlUeTCdGKRGI78i2QM5rzx0b1lqWDGvqXyKjCWuUiCAuWtDMxqW5YO1hGLK
	 786xINSjdbwvbmKGoTs4zS6Q8VLqUUWD4kn7iHtefbQUMjUue0rNudacGyp/LD4zKC
	 tH3vjx+6yvvvriOCMBEWpZGwEnImsNeIt2lAyLmg=
Date: Thu, 03 Apr 2025 14:32:55 -0700
To: mm-commits@vger.kernel.org,dcb314@hotmail.com,siddarthsgml@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-convert-page_size-to-unsigned-long.patch added to mm-new branch
Message-Id: <20250403213256.4ABF1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: convert page_size to unsigned long
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-convert-page_size-to-unsigned-long.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-convert-page_size-to-unsigned-long.patch

This patch will later appear in the mm-new branch at
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
From: Siddarth G <siddarthsgml@gmail.com>
Subject: selftests/mm: convert page_size to unsigned long
Date: Thu, 3 Apr 2025 15:43:45 +0530

Cppcheck warning:
int result is assigned to long long variable. If the variable is long long
to avoid loss of information, then you have loss of information.

This patch changes the type of page_size from 'unsigned int' to
'unsigned long' instead of using ULL suffixes. Changing hpage_size to
'unsigned long' was considered, but since gethugepage() expects an int,
this change was avoided.

Link: https://lkml.kernel.org/r/20250403101345.29226-1-siddarthsgml@gmail.com
Signed-off-by: Siddarth G <siddarthsgml@gmail.com>
Reported-by: David Binderman <dcb314@hotmail.com>
Closes: https://lore.kernel.org/all/AS8PR02MB10217315060BBFDB21F19643E9CA62@AS8PR02MB10217.eurprd02.prod.outlook.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-convert-page_size-to-unsigned-long
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -34,7 +34,7 @@
 #define PAGEMAP "/proc/self/pagemap"
 int pagemap_fd;
 int uffd;
-unsigned int page_size;
+unsigned long page_size;
 unsigned int hpage_size;
 const char *progname;
 
@@ -184,7 +184,7 @@ void *gethugetlb_mem(int size, int *shmi
 
 int userfaultfd_tests(void)
 {
-	int mem_size, vec_size, written, num_pages = 16;
+	long mem_size, vec_size, written, num_pages = 16;
 	char *mem, *vec;
 
 	mem_size = num_pages * page_size;
@@ -213,7 +213,7 @@ int userfaultfd_tests(void)
 	written = pagemap_ioctl(mem, mem_size, vec, 1, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 				vec_size - 2, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
 	if (written < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", written, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", written, errno, strerror(errno));
 
 	ksft_test_result(written == 0, "%s all new pages must not be written (dirty)\n", __func__);
 
@@ -995,7 +995,7 @@ int unmapped_region_tests(void)
 {
 	void *start = (void *)0x10000000;
 	int written, len = 0x00040000;
-	int vec_size = len / page_size;
+	long vec_size = len / page_size;
 	struct page_region *vec = malloc(sizeof(struct page_region) * vec_size);
 
 	/* 1. Get written pages */
@@ -1051,7 +1051,7 @@ static void test_simple(void)
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
-	int ret, fd, i, buf_size;
+	long ret, fd, i, buf_size;
 	struct page_region *vec;
 	char *mem, *fmem;
 	struct stat sbuf;
@@ -1160,7 +1160,7 @@ int sanity_tests(void)
 
 	ret = stat(progname, &sbuf);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
 	fmem = mmap(NULL, sbuf.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
 	if (fmem == MAP_FAILED)
_

Patches currently in -mm which might be from siddarthsgml@gmail.com are

selftests-mm-convert-page_size-to-unsigned-long.patch


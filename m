Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5F7218D6F;
	Thu,  7 Nov 2024 22:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017732; cv=none; b=K4jTNjO7rm/Q/P3hs5wu0vxuTiKUID0WgctUcGI31J/IadXlHveXIUftRh71Ym/fHaTuP1PM7YuMTs7ixz8l/pq//ZUnJMrEcUAsyomSz0Eyth8Me4R1nzo8/wZFZfcYRGSOyJZ30px4O5dqDpTHe7xAx3WJqVZrUFQJynJbXKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017732; c=relaxed/simple;
	bh=fhxwnsqenNHL1v16W2Mb1XPqeJ3+IY5yeh82gTYDn0g=;
	h=Date:To:From:Subject:Message-Id; b=h5+XcyMhyQg+bgNKp6du5K+4qcNhjOrIipYS/JjqtLxNV2C10SKHh5hLRisynxpnu1j0+rJSaYubVeprI4fmrP3Pw2E6/h3fX6fmARwdgLI93r8dBD0D5XgwD/pt4Sk8HL8wjAOQEwB4EJ4qUWbZy2tpB3Oq73g9If9BcdGvQSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XQZ23+k4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XQZ23+k4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1662C4CECC;
	Thu,  7 Nov 2024 22:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731017731;
	bh=fhxwnsqenNHL1v16W2Mb1XPqeJ3+IY5yeh82gTYDn0g=;
	h=Date:To:From:Subject:From;
	b=XQZ23+k4l4mV5dAKxZhwDlnzdH88DBePUh03AYefQPfCbTpY3yZEfVTXgXQY+sDFN
	 aUW9kNF6+UDlHVm0EXfKdemUgwIKFEXuAIv7TZA0St+ETxdsVvosnCSfUp9vIMJy7J
	 VaeQ7o15a3BIgAck0liLV1bxfH28gkcdVTzz3Kd8=
Date: Thu, 07 Nov 2024 14:15:31 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,donettom@linux.ibm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-hugetlb_dio-check-for-initial-conditions-to-skip-in-the-start.patch removed from -mm tree
Message-Id: <20241107221531.D1662C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: hugetlb_dio: check for initial conditions to skip in the start
has been removed from the -mm tree.  Its filename was
     selftests-hugetlb_dio-check-for-initial-conditions-to-skip-in-the-start.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



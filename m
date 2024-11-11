Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C5A1547F5;
	Mon, 11 Nov 2024 06:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731308317; cv=none; b=dwtVGmoOlz8BZcCtocYRcUdvOn7bZYF42N6SZbiUIQLQk46FXor/enT5S2WOf0qMnlBdxuAmes+2ZROS/9ZUoP4xWIWVIOSUVHys4Gg8mWd4uU9eSAJqDpi6i0bY9oxrudSFoOG8fL/KUKkLz6iM7s9qcwPuS/U6C+XP8rtYE5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731308317; c=relaxed/simple;
	bh=iiGqctAArRjmCn+XYc5FF9rdR+3ATCKDY9oRyMWFeS0=;
	h=Date:To:From:Subject:Message-Id; b=EyexXpJ4xeNe3KnAUm+OQo1NHHKp0NLdwKEkXD1XaC72v+9hRRBI96A9KAEnUtNHqIbeaXA7ix/spOGdCcruC7amGDzz8VdHQFejb2AsGRULWsfBQbfCLZkm/oWSQmef6u25v38hve2lKLCvDPQEP8M3/jS3mXD4BwIYD2+atVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sdlUlG1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sdlUlG1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BCBC4CED0;
	Mon, 11 Nov 2024 06:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731308317;
	bh=iiGqctAArRjmCn+XYc5FF9rdR+3ATCKDY9oRyMWFeS0=;
	h=Date:To:From:Subject:From;
	b=sdlUlG1gchVfy9NChQ58PB5RNzR/3RrCr40YSci7ygtCheA6ekv57nk12JtrRu/td
	 qni2bQbapqlMcaUa5z2ZL382LULkZ5GQ0UvegtostCjYd2Bs7jpCPRyXOK+9GiMpmN
	 X+5EPtJ24RGRAedIl8+3egKKAs8LLrEFy69SzJkQ=
Date: Sun, 10 Nov 2024 22:58:36 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,stable@vger.kernel.org,shuah@kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-hugetlb_dio-fixup-check-for-initial-conditions-to-skip-in-the-start.patch added to mm-hotfixes-unstable branch
Message-Id: <20241111065837.46BCBC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: hugetlb_dio: fixup check for initial conditions to skip in the start
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-hugetlb_dio-fixup-check-for-initial-conditions-to-skip-in-the-start.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-hugetlb_dio-fixup-check-for-initial-conditions-to-skip-in-the-start.patch

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: selftests: hugetlb_dio: fixup check for initial conditions to skip in the start
Date: Sun, 10 Nov 2024 00:49:03 -0600

This test verifies that a hugepage, used as a user buffer for DIO
operations, is correctly freed upon unmapping.  To test this, we read the
count of free hugepages before and after the mmap, DIO, and munmap
operations, then check if the free hugepage count is the same.

Reading free hugepages before the test was removed by commit 0268d4579901
('selftests: hugetlb_dio: check for initial conditions to skip at the
start'), causing the test to always fail.

This patch adds back reading the free hugepages before starting the test. 
With this patch, the tests are now passing.

Test results without this patch:

./tools/testing/selftests/mm/hugetlb_dio
TAP version 13
1..4
 # No. Free pages before allocation : 0
 # No. Free pages after munmap : 100
not ok 1 : Huge pages not freed!
 # No. Free pages before allocation : 0
 # No. Free pages after munmap : 100
not ok 2 : Huge pages not freed!
 # No. Free pages before allocation : 0
 # No. Free pages after munmap : 100
not ok 3 : Huge pages not freed!
 # No. Free pages before allocation : 0
 # No. Free pages after munmap : 100
not ok 4 : Huge pages not freed!
 # Totals: pass:0 fail:4 xfail:0 xpass:0 skip:0 error:0

Test results with this patch:

/tools/testing/selftests/mm/hugetlb_dio
TAP version 13
1..4
# No. Free pages before allocation : 100
# No. Free pages after munmap : 100
ok 1 : Huge pages freed successfully !
# No. Free pages before allocation : 100
# No. Free pages after munmap : 100
ok 2 : Huge pages freed successfully !
# No. Free pages before allocation : 100
# No. Free pages after munmap : 100
ok 3 : Huge pages freed successfully !
# No. Free pages before allocation : 100
# No. Free pages after munmap : 100
ok 4 : Huge pages freed successfully !

# Totals: pass:4 fail:0 xfail:0 xpass:0 skip:0 error:0

Link: https://lkml.kernel.org/r/20241110064903.23626-1-donettom@linux.ibm.com
Fixes: 0268d4579901 ("selftests: hugetlb_dio: check for initial conditions to skip in the start")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_dio.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/mm/hugetlb_dio.c~selftests-hugetlb_dio-fixup-check-for-initial-conditions-to-skip-in-the-start
+++ a/tools/testing/selftests/mm/hugetlb_dio.c
@@ -44,6 +44,13 @@ void run_dio_using_hugetlb(unsigned int
 	if (fd < 0)
 		ksft_exit_fail_perror("Error opening file\n");
 
+	/* Get the free huge pages before allocation */
+	free_hpage_b = get_free_hugepages();
+	if (free_hpage_b == 0) {
+		close(fd);
+		ksft_exit_skip("No free hugepage, exiting!\n");
+	}
+
 	/* Allocate a hugetlb page */
 	orig_buffer = mmap(NULL, h_pagesize, mmap_prot, mmap_flags, -1, 0);
 	if (orig_buffer == MAP_FAILED) {
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

selftests-hugetlb_dio-fixup-check-for-initial-conditions-to-skip-in-the-start.patch


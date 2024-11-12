Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1254215021;
	Tue, 12 Nov 2024 18:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731435271; cv=none; b=KzY2P7Ddhj+Sf62nCUyjNFa+R0beCGzBmuv43CmqoKfiUMNu2jX2vGqAuwpVxU4S94OAihKDOPIX5qmRtXIdd1qF31SpqqL/ZXO/j6pDBAtGKdWIJV0rugE6W9EoHQmxYiJ284vhOUNjqqrlbMcyRWZqJxe7tA6QjYXXYoqzXb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731435271; c=relaxed/simple;
	bh=E1F1Eo/GeJe0d4SWjnY7HHztQ3rwhHjK/4Oq/UoWHcw=;
	h=Date:To:From:Subject:Message-Id; b=C55g73F9grOky1HMfHEKQEjPNDm7ayN5K/Riw63xlMg+MxzkHDHzYCcy1fuRLwSEYd9kO7N74XEFxXgS/MOjwrktVSyO7UKrEOMBK5w+FRa5clGFmw/i82yXhi62LjhZEaxAAhRQVjSkd5CxyGQo5YS2UZ2tZ7qE2YP+LyGp86E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bTDZTJKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bTDZTJKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D21C4CED5;
	Tue, 12 Nov 2024 18:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731435271;
	bh=E1F1Eo/GeJe0d4SWjnY7HHztQ3rwhHjK/4Oq/UoWHcw=;
	h=Date:To:From:Subject:From;
	b=bTDZTJKPd8+wiTa8A+mxTQh0RGTgYldVBlKeVm4sofHZFo3VfGiWApzcew3rRRQap
	 /3LDpGWcgj0RX+YEKyDASjsg/IOlqBPGpjq8d9KtcEXgKdMYQcrnvx00rNVZqLjr6B
	 ReDrxyUX8bYW5X29MKi4yanPZhe/sPH6rrTx3OTQ=
Date: Tue, 12 Nov 2024 10:14:30 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,stable@vger.kernel.org,shuah@kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-hugetlb_dio-fixup-check-for-initial-conditions-to-skip-in-the-start.patch removed from -mm tree
Message-Id: <20241112181431.55D21C4CED5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: hugetlb_dio: fixup check for initial conditions to skip in the start
has been removed from the -mm tree.  Its filename was
     selftests-hugetlb_dio-fixup-check-for-initial-conditions-to-skip-in-the-start.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



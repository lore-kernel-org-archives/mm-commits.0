Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6601D28DC7
	for <mm-commits@vger.kernel.org>; Tue,  4 Jun 2024 22:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717540849; cv=none; b=jBL+kScflQwJ/8AceZLRql43qPICDZzeuJgQhGACogKeDcFYjkVpVFZZSUThzK5c1tiNDqSSgMGpq2o1QoxpEl12nvrdFcI5tbv6V8himqApnY421vhw4mFlwabkaelo5GEktDnp/ieFMmz/AXWOhv+YGec0HHEHRcOkpZz+Ik8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717540849; c=relaxed/simple;
	bh=C4+na+vL2Rh9ci5Wkd1XFMzR5NLPvJ2XN0Hzmc9H0Rk=;
	h=Date:To:From:Subject:Message-Id; b=K5hd0BwGxIqZyeY2rxyr8ZHFFO20s05xs/DwfMN7HvTpQEwRiYDnIa7yzjxenxi68dS99sRkhQm29DdBoKkkzZlrRqMQ2qyO8o8Xqxlrab3qM2IXQjcIwsuhbfAn31mCc3vHPUIkf544nEw1ekr/HP0c9VQ7o0s1sb7e86wJ6n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Og2utEgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Og2utEgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AFDC2BBFC;
	Tue,  4 Jun 2024 22:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717540848;
	bh=C4+na+vL2Rh9ci5Wkd1XFMzR5NLPvJ2XN0Hzmc9H0Rk=;
	h=Date:To:From:Subject:From;
	b=Og2utEgde6pVAU3AT368o28meagIoJvfPx8p3GSEuDRj4o1WzBCN409kv7Rett3gO
	 FvmhHXRowgMhSUH8VPPzh+1s0J/A7CTk7x5hSFRi6M8ARrSgQ6Ha4ruUPvxT4rrCFQ
	 kFISs8bBzMMqFe40q6H4QUChp7NzgM/jPVgoMFcY=
Date: Tue, 04 Jun 2024 15:40:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tonyb@cybernetics.com,songmuchun@bytedance.com,shuah@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,david@redhat.com,axboe@kernel.dk,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v2.patch added to mm-unstable branch
Message-Id: <20240604224048.C6AFDC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v2
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v2.patch

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v2
Date: Tue, 4 Jun 2024 08:28:01 -0500

address review comments from Muhammad

Link: https://lkml.kernel.org/r/20240604132801.23377-1-donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_dio.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_dio.c~selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v2
+++ a/tools/testing/selftests/mm/hugetlb_dio.c
@@ -29,6 +29,8 @@ void run_dio_using_hugetlb(unsigned int
 	size_t writesize;
 	int free_hpage_b = 0;
 	int free_hpage_a = 0;
+	const int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
+	const int mmap_prot  = PROT_READ | PROT_WRITE;
 
 	writesize = end_off - start_off;
 
@@ -40,7 +42,7 @@ void run_dio_using_hugetlb(unsigned int
 	/* Open the file to DIO */
 	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT);
 	if (fd < 0)
-		ksft_exit_fail_msg("Error opening file");
+		ksft_exit_fail_perror("Error opening file\n");
 
 	/* Get the free huge pages before allocation */
 	free_hpage_b = get_free_hugepages();
@@ -50,11 +52,10 @@ void run_dio_using_hugetlb(unsigned int
 	}
 
 	/* Allocate a hugetlb page */
-	orig_buffer = mmap(NULL, h_pagesize, PROT_READ | PROT_WRITE, MAP_PRIVATE
-			| MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+	orig_buffer = mmap(NULL, h_pagesize, mmap_prot, mmap_flags, -1, 0);
 	if (orig_buffer == MAP_FAILED) {
 		close(fd);
-		ksft_exit_fail_msg("Error mapping memory");
+		ksft_exit_fail_perror("Error mapping memory\n");
 	}
 	buffer = orig_buffer;
 	buffer += start_off;
@@ -65,7 +66,7 @@ void run_dio_using_hugetlb(unsigned int
 	if (write(fd, buffer, writesize) != (writesize)) {
 		munmap(orig_buffer, h_pagesize);
 		close(fd);
-		ksft_exit_fail_msg("Error writing to file");
+		ksft_exit_fail_perror("Error writing to file\n");
 	}
 
 	/* unmap the huge page */
@@ -80,12 +81,12 @@ void run_dio_using_hugetlb(unsigned int
 	 * not match - that means there could still be a page which is pinned.
 	 */
 	if (free_hpage_a != free_hpage_b) {
-		printf("No. Free pages before allocation : %d\n", free_hpage_b);
-		printf("No. Free pages after munmap : %d\n", free_hpage_a);
+		ksft_print_msg("No. Free pages before allocation : %d\n", free_hpage_b);
+		ksft_print_msg("No. Free pages after munmap : %d\n", free_hpage_a);
 		ksft_test_result_fail(": Huge pages not freed!\n");
 	} else {
-		printf("No. Free pages before allocation : %d\n", free_hpage_b);
-		printf("No. Free pages after munmap : %d\n", free_hpage_a);
+		ksft_print_msg("No. Free pages before allocation : %d\n", free_hpage_b);
+		ksft_print_msg("No. Free pages after munmap : %d\n", free_hpage_a);
 		ksft_test_result_pass(": Huge pages freed successfully !\n");
 	}
 }
@@ -113,6 +114,5 @@ int main(void)
 	run_dio_using_hugetlb(pagesize / 2, (pagesize * 3) + (pagesize / 2));
 
 	ksft_finished();
-	return 0;
 }
 
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages.patch
selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v2.patch


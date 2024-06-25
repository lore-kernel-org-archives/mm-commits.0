Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02421849
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289078; cv=none; b=D2U0h1PHF+jWxtIFRLSQjaJMi7/cQBxtToSTc7aBU3TXLe+8MmLL7UHXwxNJvT3/EnkC02fTWZb59NSW3bOiFVtcJSxZ0hs5eS9PGBf0XdhQyjudRAfJ4D9vRfhJyjAYEWFk0reLtnZ5NHqADW3zql76FtVmxt1E5i7mE/PVOgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289078; c=relaxed/simple;
	bh=KqE9Z3g++inYvTY/Ca5D2gifUhA1CB8GVTg1BNJl0JA=;
	h=Date:To:From:Subject:Message-Id; b=mD12yRABWRyhG4vhJjWVXWeVUjKcpK1M6czzx/o/A5FsiWYBXc5EmB6r/FWbCi+QLFYQp+lma+qhDSeKyLs6DarRddBVqNXjOmthv2RNUSLqtHrZ/Y+/LfvNpGAHhfTBwUBo+ZPVd2cwmWklItq2YcPJo8PSzjhCuLdmc0E/1Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=deVcKWQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="deVcKWQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725A3C32782;
	Tue, 25 Jun 2024 04:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289077;
	bh=KqE9Z3g++inYvTY/Ca5D2gifUhA1CB8GVTg1BNJl0JA=;
	h=Date:To:From:Subject:From;
	b=deVcKWQscDoH6lYFKejZA/8U3zPbxN4LZo8PkBFk2jvrM9mVWHA6MAAMRgZX+eXNg
	 1LmW+RRk7st0vo+S87I3hKl2aRrk8mO5Ji2hvzgQmUaS8JN4a4ib/MDoCkovZRpq4o
	 3ReWQt70EfdeUygmYQtISHDtIVMffwgbEzL1KXSA=
Date: Mon, 24 Jun 2024 21:17:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,usama.anjum@collabora.com,tonyb@cybernetics.com,songmuchun@bytedance.com,shuah@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,david@redhat.com,axboe@kernel.dk,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v2.patch removed from -mm tree
Message-Id: <20240625041757.725A3C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v2
has been removed from the -mm tree.  Its filename was
     selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v2.patch

This patch was dropped because it was folded into selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages.patch

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
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
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
@@ -113,5 +114,4 @@ int main(void)
 	run_dio_using_hugetlb(pagesize / 2, (pagesize * 3) + (pagesize / 2));
 
 	ksft_finished();
-	return 0;
 }
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages.patch
selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v4.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4471849
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289079; cv=none; b=PLeXN9J+hzkxPdkg3z7r5OED5p6ZP5LPHL62i1p2xVRlZ21jJjt2ZEye6t366RbsuMlQjeggHoUcU0xeecrcvyuJDBzk9GCeit+panwDjaksCjNzsAByjY5v9jSzTmfpY11gUzYCFPS/IjQrBi6mMm4DO1xhfCvNTCEGG5xa30E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289079; c=relaxed/simple;
	bh=emBsJ4LFZzMYaEhSXstRf61f4xJHDHM2DFs1G6EFJ2k=;
	h=Date:To:From:Subject:Message-Id; b=T3QjC1zeUlSavQKepax9anQtzyCimh4IV44YZNHasxkot0hRQFqbM8cp3FY605y3jrNYtC1qpIVIO4wF3D7B/5MlP3LwBbswXSfXr8PAlgNMHfOIEXQAw0msGZUPweP+Y0md0gocZi+I2JsYetCYchItmHRI7ad6TurQ8vmS4ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bZlDj3GY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bZlDj3GY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3559C32782;
	Tue, 25 Jun 2024 04:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289078;
	bh=emBsJ4LFZzMYaEhSXstRf61f4xJHDHM2DFs1G6EFJ2k=;
	h=Date:To:From:Subject:From;
	b=bZlDj3GYzDFZo6xbAoKGAE44vp/gatsUjI3D/zKGSTqSFD8i5EqjigY4YxTa1A8nV
	 ciiWNS75EpvW2NlF0muvBgTONbF/kafQCMXESqBRrCz5DJzltGbaSs8mQc0AV46gN0
	 G9/d66+x8trsBzHctNQM0f45gwZx3fePjEn9+tqI=
Date: Mon, 24 Jun 2024 21:17:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,usama.anjum@collabora.com,tonyb@cybernetics.com,songmuchun@bytedance.com,shuah@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,david@redhat.com,axboe@kernel.dk,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v4.patch removed from -mm tree
Message-Id: <20240625041758.B3559C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest: mm: Test if hugepage does not get leaked during __bio_release_pages()
has been removed from the -mm tree.  Its filename was
     selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v4.patch

This patch was dropped because it was folded into selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages.patch

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: selftest: mm: Test if hugepage does not get leaked during __bio_release_pages()
Date: Fri, 7 Jun 2024 13:20:00 -0500

add this test to run_vmtests.sh

Link: https://lkml.kernel.org/r/20240607182000.6494-1-donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_dio.c  |    2 +-
 tools/testing/selftests/mm/run_vmtests.sh |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugetlb_dio.c~selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v4
+++ a/tools/testing/selftests/mm/hugetlb_dio.c
@@ -40,7 +40,7 @@ void run_dio_using_hugetlb(unsigned int
 		ksft_exit_fail_msg("Unable to determine huge page size\n");
 
 	/* Open the file to DIO */
-	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT);
+	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
 	if (fd < 0)
 		ksft_exit_fail_perror("Error opening file\n");
 
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages-v4
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -265,6 +265,7 @@ CATEGORY="hugetlb" run_test ./map_hugetl
 CATEGORY="hugetlb" run_test ./hugepage-mremap
 CATEGORY="hugetlb" run_test ./hugepage-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
+CATEGORY="hugetlb" run_test ./hugetlb_dio
 
 nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
 # For this test, we need one and just one huge page
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages.patch


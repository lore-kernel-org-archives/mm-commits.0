Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B57136F8F0
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067202; cv=none; b=bFyyVkNFLvytvtbsMu+yH7bMIvQdg+LUMpeJDyTUMZov56P7Qd/VsEWuceSKV6ABvY2lCKoJzJuFbEwmbkRRBgjFT2HdfEabInvnX74XQG19w61ifXvsO5s7GVl+og97ja99tK4dzWZsw3W4R5BBzu6lIaSBNgi60HOvSzJOYA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067202; c=relaxed/simple;
	bh=UHY8X/9d6I8NzMLxJTktBNDOsrlXl5eI5reubfknmxQ=;
	h=Date:To:From:Subject:Message-Id; b=K3+kQw4c8FAz0I1/BLh00YUOasjCdcW04wZv4aCLVoTy9k4ZqPZi4KyZ+wf26gyZXMPp/X78zwVty4FtLccqRtCf/DgSSP1kb7wRcVw0mPIUG9O2Gp0V6JX8LEObEp8eyQelEw/IQ0jojLDVgRDhjL3lLTlejfXpRyBtgMnaYD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aNlprbof; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aNlprbof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F42D1F000E9;
	Sun, 21 Jun 2026 18:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067201;
	bh=hLU3sq77Ir0rCKEqm9yvvfASSmOaL/w102Q9ArSJNXc=;
	h=Date:To:From:Subject;
	b=aNlprbof24oFQhIfOvbbDsN8rL317jB4KLhmMFUqt5/J6HbuyScpO2WDjI6uh2ZyQ
	 9XvtWHrVmFIVl28chway+90rWpyHx+0XQrkSVmLX78ts+u3OdHZawTIb/Rp2J3JlRS
	 AAY6czrv/ngPrWeL7vjGZAOw+l8GLGQaXiGHT3TU=
Date: Sun, 21 Jun 2026 11:40:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,venkat88@linux.ibm.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-free-dynamically-allocated-pmd-sized-buffers-in-split_huge_page_test.patch removed from -mm tree
Message-Id: <20260621184001.3F42D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: free dynamically allocated PMD-sized buffers in split_huge_page_test
has been removed from the -mm tree.  Its filename was
     selftests-mm-free-dynamically-allocated-pmd-sized-buffers-in-split_huge_page_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: free dynamically allocated PMD-sized buffers in split_huge_page_test
Date: Thu, 21 May 2026 12:17:47 +0530

Dynamically allocated buffers of PMD size for file-backed THP operations
(file_buf1 and file_buf2) were not freed on the success path and some
failure paths.  Since the function is called repeatedly in a loop for each
split order, this can cause significant memory leaks.

On architectures with large PMD sizes, repeated leaks could exhaust system
memory and trigger the OOM killer during test execution.

Ensure all allocated buffers are freed to maintain stable repeated test
runs.

Link: https://lore.kernel.org/060c673b376bbeeed2b1fb1d48a825e846654191.1779296493.git.sayalip@linux.ibm.com
Fixes: 035a112e5fd5 ("selftests/mm: make file-backed THP split work by writing PMD size data")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   22 ++++++++----
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-free-dynamically-allocated-pmd-sized-buffers-in-split_huge_page_test
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -473,12 +473,15 @@ static void split_file_backed_thp(int or
 	unsigned long size = 2 * pmd_pagesize;
 	char opts[64];
 	ssize_t num_written, num_read;
-	char *file_buf1, *file_buf2;
+	char *file_buf1 = NULL, *file_buf2 = NULL;
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
 	int i;
 
 	ksft_print_msg("Please enable pr_debug in split_huge_pages_in_file() for more info.\n");
 
+	if (!tmpfs_loc)
+		ksft_exit_fail_msg("mkdtemp failed\n");
+
 	file_buf1 = (char *)malloc(pmd_pagesize);
 	file_buf2 = (char *)malloc(pmd_pagesize);
 
@@ -494,8 +497,10 @@ static void split_file_backed_thp(int or
 	snprintf(opts, sizeof(opts), "huge=always,size=%lu", size);
 	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, opts);
 
-	if (status)
-		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
+	if (status) {
+		ksft_print_msg("Unable to create a tmpfs for testing\n");
+		goto out;
+	}
 
 	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
 	if (status >= INPUT_MAX) {
@@ -547,10 +552,13 @@ static void split_file_backed_thp(int or
 
 	status = umount(tmpfs_loc);
 	if (status) {
-		rmdir(tmpfs_loc);
-		ksft_exit_fail_msg("Unable to umount %s\n", tmpfs_loc);
+		ksft_print_msg("Unable to umount %s\n", tmpfs_loc);
+		goto out;
 	}
 
+	free(file_buf1);
+	free(file_buf2);
+
 	status = rmdir(tmpfs_loc);
 	if (status)
 		ksft_exit_fail_msg("cannot remove tmp dir: %s\n", strerror(errno));
@@ -563,8 +571,10 @@ close_file:
 	close(fd);
 cleanup:
 	umount(tmpfs_loc);
-	rmdir(tmpfs_loc);
 out:
+	free(file_buf1);
+	free(file_buf2);
+	rmdir(tmpfs_loc);
 	ksft_exit_fail_msg("Error occurred\n");
 }
 
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are



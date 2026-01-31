Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F96238A734
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898313; cv=none; b=hjPCV9zGVWD/RgqQDLuxffEwQecbVDFCoYJya6xFz8ru/z44l7vDODq7yn+SOGSLQm3JT/VkWk4q/Xjy4y5tKxHwpxQYY8RwX0XQqxXTRxxIbCDH9HHRz+k/GiUr+IG8fyiUxcYOKQo2BQyFmQwiMhXUNVKT287Kjdpdyl0FtkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898313; c=relaxed/simple;
	bh=8DzwyjNrhkgrRjKjHKe5jv//+oXvtkDN9JAUcJf6rX8=;
	h=Date:To:From:Subject:Message-Id; b=WP5jJOwhP/aXDtmxWpoUqJvXVyFSp/4NcpwsD+7056nvzyLFJJSZ6ioyj6zdxJK3taFBdgDOWh+Dbc7SjGXXo/ZWWjXts7gYVof732R3Y4RMtYnSuFGCQydPE7khXUJXucH2D/8VKlZbVL872zadOFAViTy8hBCel9A/bpgKpfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0WMNq8ii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0WMNq8ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1807C4CEF1;
	Sat, 31 Jan 2026 22:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898312;
	bh=8DzwyjNrhkgrRjKjHKe5jv//+oXvtkDN9JAUcJf6rX8=;
	h=Date:To:From:Subject:From;
	b=0WMNq8iiZ5tmrv2VCZx8kSOkENc9zoYjEjvYTgrHXqlvXYSbAci9D7FWa1skOzSCb
	 HkfrPTsYeMcsOq4tEU+y6hCCfa8lpyjOuzuBeNQ3z0yOMGJwRM0FdDMCxgF4Ke0RJL
	 H7vAUSqMi7z6n9ispAsW5TkRTE2NpXvZIyGkJ+2s=
Date: Sat, 31 Jan 2026 14:25:12 -0800
To: mm-commits@vger.kernel.org,Usama.Anjum@arm.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,pabeni@redhat.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,lianux.mm@gmail.com,jhubbard@nvidia.com,jgg@nvidia.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-check-that-force_read-succeeded.patch removed from -mm tree
Message-Id: <20260131222512.D1807C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: check that FORCE_READ() succeeded
has been removed from the -mm tree.  Its filename was
     selftests-mm-check-that-force_read-succeeded.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: check that FORCE_READ() succeeded
Date: Thu, 22 Jan 2026 17:02:20 +0000

Many cow tests rely on FORCE_READ() to populate pages.  Introduce a helper
to make sure that the pages are actually populated, and fail otherwise.

Link: https://lkml.kernel.org/r/20260122170224.4056513-6-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |   43 ++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-check-that-force_read-succeeded
+++ a/tools/testing/selftests/mm/cow.c
@@ -75,6 +75,18 @@ static bool range_is_swapped(void *addr,
 	return true;
 }
 
+static bool populate_page_checked(char *addr)
+{
+	bool ret;
+
+	FORCE_READ(*addr);
+	ret = pagemap_is_populated(pagemap_fd, addr);
+	if (!ret)
+		ksft_print_msg("Failed to populate page\n");
+
+	return ret;
+}
+
 struct comm_pipes {
 	int child_ready[2];
 	int parent_ready[2];
@@ -1549,8 +1561,10 @@ static void run_with_zeropage(non_anon_t
 	}
 
 	/* Read from the page to populate the shared zeropage. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1612,8 +1626,11 @@ static void run_with_huge_zeropage(non_a
 	 * the first sub-page and test if we get another sub-page populated
 	 * automatically.
 	 */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
+
 	if (!pagemap_is_populated(pagemap_fd, mem + pagesize) ||
 	    !pagemap_is_populated(pagemap_fd, smem + pagesize)) {
 		ksft_test_result_skip("Did not get THPs populated\n");
@@ -1663,8 +1680,10 @@ static void run_with_memfd(non_anon_test
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1719,8 +1738,10 @@ static void run_with_tmpfile(non_anon_te
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1773,8 +1794,10 @@ static void run_with_memfd_hugetlb(non_a
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, hugetlbsize);
 munmap:
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are



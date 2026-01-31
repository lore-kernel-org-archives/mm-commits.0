Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F9A38A734
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898317; cv=none; b=GWa0f4aTQ3TpCFO8dlRDGfI+kGe62FEL2SfdyyN998BHIipS6XKo4De/qV75RfGK7DuCJLO+sHNTRKPUP1u8w1FA1SpfbKHrjnoB8v+/13kmy5ZSX0VnY+huXyxnoXqSPwQSBsPYjcFQg63zja1xZmgNH7emhIGrWnM0Pk6AR2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898317; c=relaxed/simple;
	bh=BI7y7297j3t7PqypHShxv4pet4VXCK5+1/COa5S0Ag4=;
	h=Date:To:From:Subject:Message-Id; b=TCydZdHJHxXCA+3kbUzu5ekjJph3oZwFZ3ZX+LYYKSE5ZeJznx18cyeJydhpCVi6lYDhmP5rdO0Z5wYZGBBiplEB2DNmY0Uv47JBUXBzikyIAeZ8ZT4O9cl6I1ODw1LTugF1mu69m5L7kdNqA6XYs+yS44j7fthkZumcVRwSWyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ccBkN2bA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ccBkN2bA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09659C4CEF1;
	Sat, 31 Jan 2026 22:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898317;
	bh=BI7y7297j3t7PqypHShxv4pet4VXCK5+1/COa5S0Ag4=;
	h=Date:To:From:Subject:From;
	b=ccBkN2bAKKbEM1WEyQmNynK9cPliH0SPqMB+ViOXpP7678PSQT+pFXupMsMGpWeDq
	 0nMfXwEbpCvBN18nGsqke8iOtmaS/RqWX+OjewCi4pScoXL+YNlgxxqCtXFZsuLwLs
	 Y4OwhX5RIHAPJ7+GAy+O6ajHHzlhEW9mQpwzUqN0=
Date: Sat, 31 Jan 2026 14:25:16 -0800
To: mm-commits@vger.kernel.org,Usama.Anjum@arm.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,pabeni@redhat.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,lianux.mm@gmail.com,jhubbard@nvidia.com,jgg@nvidia.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-exit-code-in-pagemap_ioctl.patch removed from -mm tree
Message-Id: <20260131222517.09659C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix exit code in pagemap_ioctl
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-exit-code-in-pagemap_ioctl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: fix exit code in pagemap_ioctl
Date: Thu, 22 Jan 2026 17:02:23 +0000

Make sure pagemap_ioctl exits with an appropriate value:

* If the tests are run, call ksft_finished() to report the right
  status instead of reporting PASS unconditionally.

* Report SKIP if userfaultfd isn't available (in line with other
  tests)

* Report FAIL if we failed to open /proc/self/pagemap, as this file
  has been added a long time ago and doesn't depend on any CONFIG
  option (returning -EINVAL from main() is meaningless)

Link: https://lkml.kernel.org/r/20260122170224.4056513-9-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-fix-exit-code-in-pagemap_ioctl
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1552,7 +1552,7 @@ int main(int __attribute__((unused)) arg
 	ksft_print_header();
 
 	if (init_uffd())
-		ksft_exit_pass();
+		ksft_exit_skip("Failed to initialize userfaultfd\n");
 
 	ksft_set_plan(117);
 
@@ -1561,7 +1561,7 @@ int main(int __attribute__((unused)) arg
 
 	pagemap_fd = open(PAGEMAP, O_RDONLY);
 	if (pagemap_fd < 0)
-		return -EINVAL;
+		ksft_exit_fail_msg("Failed to open " PAGEMAP "\n");
 
 	/* 1. Sanity testing */
 	sanity_tests_sd();
@@ -1733,5 +1733,5 @@ int main(int __attribute__((unused)) arg
 	zeropfn_tests();
 
 	close(pagemap_fd);
-	ksft_exit_pass();
+	ksft_finished();
 }
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are



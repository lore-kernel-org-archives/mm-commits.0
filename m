Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339FA23A10F
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836952; cv=none; b=jSLpajGqoBKuIvV1jrKZrohGfTqXtwYMF7FZOCg5QWCynSWwm9p5WljZlZQGRDT4VDi4juHlb+ToW+qyLt8mOU9aT/nN57Nod4r3iuRiIUX6FL0C0yIcna0VO7O0ylf1CM8OrqEqeYr/blxLBRyIOF0BVaLENHEY7CHj6LoplQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836952; c=relaxed/simple;
	bh=DbO3CzbCmYi+9E4pnykL1qm34GdYPFOiUU/pEJQScO4=;
	h=Date:To:From:Subject:Message-Id; b=df57kz+zWnJtApUgnA127PX2oqGUgSkL+QD87kQNrN/WqMMOMY/Pft5rvWR/q9gpI0Mt52zh2JZoe+p7CQdF9QHR6qNjIqE0W/1vlFhLUEDxhTAw7TX91LpS5qp0fxCmykGsD81Kk7KsJSbFiB2rnJR2qzhJezF3MYIVOOPPLRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fVUQXvcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fVUQXvcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2277C4CEDD;
	Tue, 14 Jan 2025 06:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836951;
	bh=DbO3CzbCmYi+9E4pnykL1qm34GdYPFOiUU/pEJQScO4=;
	h=Date:To:From:Subject:From;
	b=fVUQXvcOgYHEzxZMhXjHqaE83kl+oIzzpzLrexqzVjfYZLKgfTvsd9xaDJDooMedl
	 q2fzaOTgaL5/G1iiQS7+wj7I1kh3EwBsUnWzSlNhLCben7GHCl5AljyqQAWSElx559
	 V6QWLVksCDKadRTTZThfEelmi70Haik0dXGPI3fA=
Date: Mon, 13 Jan 2025 22:42:31 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,guanjing@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-conversion-specifiers-in-transact_test.patch removed from -mm tree
Message-Id: <20250114064231.A2277C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: fix conversion specifiers in transact_test()
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-conversion-specifiers-in-transact_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: guanjing <guanjing@cmss.chinamobile.com>
Subject: selftests: mm: fix conversion specifiers in transact_test()
Date: Sun, 17 Nov 2024 15:12:31 +0800

Lots of incorrect conversion specifiers. Fix them.

Link: https://lkml.kernel.org/r/20241117071231.177864-1-guanjing@cmss.chinamobile.com
Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
Signed-off-by: guanjing <guanjing@cmss.chinamobile.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-fix-conversion-specifiers-in-transact_test
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1405,9 +1405,9 @@ static void transact_test(int page_size)
 	memset(mem, 0, 0x1000 * nthreads * pages_per_thread);
 
 	count = get_dirty_pages_reset(mem, nthreads * pages_per_thread, 1, page_size);
-	ksft_test_result(count > 0, "%s count %d\n", __func__, count);
+	ksft_test_result(count > 0, "%s count %u\n", __func__, count);
 	count = get_dirty_pages_reset(mem, nthreads * pages_per_thread, 1, page_size);
-	ksft_test_result(count == 0, "%s count %d\n", __func__, count);
+	ksft_test_result(count == 0, "%s count %u\n", __func__, count);
 
 	finish = 0;
 	for (i = 0; i < nthreads; ++i)
@@ -1429,7 +1429,7 @@ static void transact_test(int page_size)
 			ksft_exit_fail_msg("pthread_barrier_wait\n");
 
 		if (count > nthreads * access_per_thread)
-			ksft_exit_fail_msg("Too big count %d expected %d, iter %d\n",
+			ksft_exit_fail_msg("Too big count %u expected %u, iter %u\n",
 					   count, nthreads * access_per_thread, i);
 
 		c = get_dirty_pages_reset(mem, nthreads * pages_per_thread, 1, page_size);
@@ -1454,7 +1454,7 @@ static void transact_test(int page_size)
 			 * access and application gets page fault again for the same write.
 			 */
 			if (count < nthreads * access_per_thread) {
-				ksft_test_result_fail("Lost update, iter %d, %d vs %d.\n", i, count,
+				ksft_test_result_fail("Lost update, iter %u, %u vs %u.\n", i, count,
 						      nthreads * access_per_thread);
 				return;
 			}
@@ -1467,7 +1467,7 @@ static void transact_test(int page_size)
 	finish = 1;
 	pthread_barrier_wait(&end_barrier);
 
-	ksft_test_result_pass("%s Extra pages %u (%.1lf%%), extra thread faults %d.\n", __func__,
+	ksft_test_result_pass("%s Extra pages %u (%.1lf%%), extra thread faults %u.\n", __func__,
 			      extra_pages,
 			      100.0 * extra_pages / (iter_count * nthreads * access_per_thread),
 			      extra_thread_faults);
_

Patches currently in -mm which might be from guanjing@cmss.chinamobile.com are



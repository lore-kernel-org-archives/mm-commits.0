Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C55554727
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732939236; cv=none; b=hMck0peJ3oDEXjW2rEhbZoXIhO2ohAUGizvRpvc4qYLoD99OHEO4+r0D7iFHQEmOX7lHWmZm+W52UZI1wTTAfg5ou8G5POXR9thucrwOUU1PusY/KjipAAFeUK/7YV5l24utuOEojz8+Wb0rBmA7aEWH6XZj2YpnOEaGsC0TItU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732939236; c=relaxed/simple;
	bh=t2G2gOLreuPNxMG/7rPPqa3vKk8bhQZoqLqcD38cgOc=;
	h=Date:To:From:Subject:Message-Id; b=miVF783vo2rEjBbniMywfMYP6sQaT7/OZPg47VPRyVMAm7KII4E9BMl8/eMnzeTPt6GK05uQyyR1xDqFI19epmi4scmQ9YQZ+bKmGTFtyQxbG1MnWb7XdD7GNZYaa5xvCwCkF4S8oLgLYQYRClxw9QM1jzUNr+k0j4SeyIv9/Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0IdiNUgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0IdiNUgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA734C4CECC;
	Sat, 30 Nov 2024 04:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732939235;
	bh=t2G2gOLreuPNxMG/7rPPqa3vKk8bhQZoqLqcD38cgOc=;
	h=Date:To:From:Subject:From;
	b=0IdiNUgYhAX36T+3+zohKLYppt19aA2xG3ayotDxRYD+5OzkpsufeSx9J9PjZFC75
	 CSExN4iidZ66p7RQFIH61V0JJOhcnZaKAnh03dbQdhX9cfTywTg8++R1ffG5o9gitl
	 MS1wjpg5G9KEkZSMS6DHC3TcdvCAuHlrgLtYZxUY=
Date: Fri, 29 Nov 2024 20:00:35 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,guanjing@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-conversion-specifiers-in-transact_test.patch added to mm-unstable branch
Message-Id: <20241130040035.CA734C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: fix conversion specifiers in transact_test()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-conversion-specifiers-in-transact_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-conversion-specifiers-in-transact_test.patch

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

selftests-mm-fix-conversion-specifiers-in-transact_test.patch


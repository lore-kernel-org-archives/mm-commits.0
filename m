Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781561A08CA
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011144; cv=none; b=NTQnUBdj1cBhk5Cd37wu3DrHvwCiqNjC+I4KSyf1xVSGKRhbzhh6dwgftxyPwVSRWHLj8HluzqFE6E/r80xbqVTtmsGYwfIXPTsypUBeB7epfNqhVhxRg38dYSozW2gBLevZEZajhtDpMbYm637D5AS1YrJXmK9CHjNLcPxw/W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011144; c=relaxed/simple;
	bh=bZkl1CVmw9IGLcEIdUzBTTG1iugq6hnjBXifa9iRUtE=;
	h=Date:To:From:Subject:Message-Id; b=tBdPJ/dfVeW1RZMzODBZHXYPZXUsiMfkTzOuZOPGtdOJaO3tLnerLrSv5WyiUXNBV4NCOqiN6c1SPZ15CMOV6fMQKmE6MievP8NlYEfllMdN3yzphLkZO1dDnvtpLFY1R6UcEFOqL4J8OYu0P/QLdQcZHeQq9UeQQ16toa1Cs6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z51RXw7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z51RXw7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4F9C4CEE4;
	Mon, 12 May 2025 00:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011144;
	bh=bZkl1CVmw9IGLcEIdUzBTTG1iugq6hnjBXifa9iRUtE=;
	h=Date:To:From:Subject:From;
	b=Z51RXw7GrK1p9bM89WvGD/99qdWBHqhbSRzsOuVTgKlu7ZIshJKQXSmX9QWlb/HWz
	 8WtZ/ZQa7Pc9yPoQCNYn32txd3mD8jukLC3Q7o8i0ZEJfr46pNoZztUZCDh1lkNf0M
	 M1nNzfOXZvENah7ApUEMxYNRpZfybPwUN31Ihvb8=
Date: Sun, 11 May 2025 17:52:23 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,hch@infradead.org,bhe@redhat.com,ahuang12@lenovo.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_vmallocc-replace-rwsem-to-srcu-for-setup.patch removed from -mm tree
Message-Id: <20250512005224.4F4F9C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_vmalloc.c: replace RWSEM to SRCU for setup
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-replace-rwsem-to-srcu-for-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc.c: replace RWSEM to SRCU for setup
Date: Thu, 17 Apr 2025 18:12:13 +0200

The test has the initialization step during which threads are created.  To
prevent the workers from starting prematurely a write lock was previously
used by the main setup thread, while each worker would block on a read
lock.

Replace this RWSEM based synchronization with a simpler SRCU based
approach.  Which does two basic steps:

- Main thread wraps the setup phase in an SRCU read-side critical
  section.  Pair of srcu_read_lock()/srcu_read_unlock().
- Each worker calls synchronize_srcu() on entry, ensuring it waits for
  the initialization phase to be completed.

This patch eliminates the need for down_read()/up_read() and
down_write()/up_write() pairs thus simplifying the logic and improving
clarity.

[urezki@gmail.com: fix compile error with CONFIG_TINY_RCU]
  Link: https://lkml.kernel.org/r/20250420142029.103169-1-urezki@gmail.com
Link: https://lkml.kernel.org/r/20250417161216.88318-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Adrian Huang <ahuang12@lenovo.com>
Tested-by: Adrian Huang <ahuang12@lenovo.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christop Hellwig <hch@infradead.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-replace-rwsem-to-srcu-for-setup
+++ a/lib/test_vmalloc.c
@@ -13,9 +13,9 @@
 #include <linux/moduleparam.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
-#include <linux/rwsem.h>
 #include <linux/mm.h>
 #include <linux/rcupdate.h>
+#include <linux/srcu.h>
 #include <linux/slab.h>
 
 #define __param(type, name, init, msg)		\
@@ -58,10 +58,9 @@ __param(int, run_test_mask, INT_MAX,
 );
 
 /*
- * Read write semaphore for synchronization of setup
- * phase that is done in main thread and workers.
+ * This is for synchronization of setup phase.
  */
-static DECLARE_RWSEM(prepare_for_test_rwsem);
+DEFINE_STATIC_SRCU(prepare_for_test_srcu);
 
 /*
  * Completion tracking for worker threads.
@@ -458,7 +457,7 @@ static int test_func(void *private)
 	/*
 	 * Block until initialization is done.
 	 */
-	down_read(&prepare_for_test_rwsem);
+	synchronize_srcu(&prepare_for_test_srcu);
 
 	t->start = get_cycles();
 	for (i = 0; i < ARRAY_SIZE(test_case_array); i++) {
@@ -487,8 +486,6 @@ static int test_func(void *private)
 		t->data[index].time = delta;
 	}
 	t->stop = get_cycles();
-
-	up_read(&prepare_for_test_rwsem);
 	test_report_one_done();
 
 	/*
@@ -526,7 +523,7 @@ init_test_configuration(void)
 
 static void do_concurrent_test(void)
 {
-	int i, ret;
+	int i, ret, idx;
 
 	/*
 	 * Set some basic configurations plus sanity check.
@@ -538,7 +535,7 @@ static void do_concurrent_test(void)
 	/*
 	 * Put on hold all workers.
 	 */
-	down_write(&prepare_for_test_rwsem);
+	idx = srcu_read_lock(&prepare_for_test_srcu);
 
 	for (i = 0; i < nr_threads; i++) {
 		struct test_driver *t = &tdriver[i];
@@ -555,7 +552,7 @@ static void do_concurrent_test(void)
 	/*
 	 * Now let the workers do their job.
 	 */
-	up_write(&prepare_for_test_rwsem);
+	srcu_read_unlock(&prepare_for_test_srcu, idx);
 
 	/*
 	 * Sleep quiet until all workers are done with 1 second
_

Patches currently in -mm which might be from urezki@gmail.com are

maintainers-add-myself-as-vmalloc-co-maintainer.patch


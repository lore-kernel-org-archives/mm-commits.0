Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE8D21506E
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 23:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744933964; cv=none; b=PpYqnHuYD84CA/oDk73Ds8d4Q5vlUIac0awEj7ZtcRWCd/QeU8ck/b4lQAJm6vA6FIN5mXctiVPyXmJWaydMLs8h/5N+rG3fc2VJK5lmJh1MBtawTxcrVTCK7Tq4mLFEDO3uMKILRJ4jN+nA6aok+qTL6PQEu+TOn07FoxhuIL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744933964; c=relaxed/simple;
	bh=vOmM0GEONOZiNRdOHgRnYMNboQnuj48Q1qCE4kjsSB8=;
	h=Date:To:From:Subject:Message-Id; b=IoV0D07IFzWviW+VkaUtF8XmUmwhgnCsJIljgkSG55xejBEFsYl/OU5rI/qkSOfbxvjSk3kpPqHKX82BA2o/nl6vmlp2BtgI+HDWKzlbbvZSRh0I1GkF+D5qUCKZlntkRrQ5kGX6/1QAN9ssYvBQLjMJMckkYGiXfSCrI+WtRcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fm4MVZ28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fm4MVZ28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B839C4CEE4;
	Thu, 17 Apr 2025 23:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744933964;
	bh=vOmM0GEONOZiNRdOHgRnYMNboQnuj48Q1qCE4kjsSB8=;
	h=Date:To:From:Subject:From;
	b=fm4MVZ28cxob4EsLwkKMUB17KKRz6VA3aPfftpgI/4jE4SEeeLgqZvRH1Z5eoaMpS
	 anGn1Wl/qWhZrT8iPoFmDScI/CPod72SlixpWBsTIN/xGx13x08CTzt3BDudb9w8rB
	 BSoVJX2svWBKNHnwNk+lPNUSOhNvvTJgmZrxuWrY=
Date: Thu, 17 Apr 2025 16:52:42 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,hch@infradead.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmallocc-replace-rwsem-to-srcu-for-setup.patch added to mm-new branch
Message-Id: <20250417235244.2B839C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_vmalloc.c: replace RWSEM to SRCU for setup
has been added to the -mm mm-new branch.  Its filename is
     lib-test_vmallocc-replace-rwsem-to-srcu-for-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmallocc-replace-rwsem-to-srcu-for-setup.patch

This patch will later appear in the mm-new branch at
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

Link: https://lkml.kernel.org/r/20250417161216.88318-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
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
+#include <linux/srcutree.h>
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

vmalloc-add-for_each_vmap_node-helper.patch
vmalloc-switch-to-for_each_vmap_node-helper.patch
vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch
vmalloc-use-atomic_long_add_return_relaxed.patch
lib-test_vmallocc-replace-rwsem-to-srcu-for-setup.patch
lib-test_vmallocc-allow-built-in-execution.patch
maintainers-add-test_vmallocc-to-vmalloc-section.patch
vmalloc-align-nr_vmalloc_pages-and-vmap_lazy_nr.patch


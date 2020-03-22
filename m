From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?tools-testing-selftests-vm-mlock2-tests-fix-mlock2-false-n?=
 =?US-ASCII?Q?egative-errors.patch?= added to -mm tree
Date: Sat, 21 Mar 2020 18:39:40 -0700
Message-ID: <20200322013940.Q_VfhpYgQ%akpm@linux-foundation.org>
References: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727296AbgCVBjm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 21 Mar 2020 21:39:42 -0400
In-Reply-To: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, mm-commits@vger.kernel.org, shakeelb@google.com, shuah@kernel.org, vbabka@suse.cz


The patch titled
     Subject: tools/testing/selftests/vm/mlock2-tests: fix mlock2 false-negative errors
has been added to the -mm tree.  Its filename is
     tools-testing-selftests-vm-mlock2-tests-fix-mlock2-false-negative-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-testing-selftests-vm-mlock2-tests-fix-mlock2-false-negative-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-testing-selftests-vm-mlock2-tests-fix-mlock2-false-negative-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: tools/testing/selftests/vm/mlock2-tests: fix mlock2 false-negative errors

Changes for commit 9c4e6b1a7027f ("mm, mlock, vmscan: no more skipping
pagevecs") break this test expectations on the behavior of mlock syscall
family immediately inserting the recently faulted pages into the
UNEVICTABLE_LRU, when MCL_ONFAULT is passed to the syscall as part of its
flag-set.

There is no functional error introduced by the aforementioned commit, but
it opens up a time window where the recently faulted and locked pages
might yet not be put back into the UNEVICTABLE_LRU, thus causing a
subsequent and immediate PFN flag check for the UNEVICTABLE bit to trip on
false-negative errors, as it happens with this test.

This patch fix the false negative by forcefully resorting to a code path
that will call a CPU pagevec drain right after the fault but before the
PFN flag check takes place, sorting out the race that way.

Link: http://lkml.kernel.org/r/20200322013525.1095493-1-aquini@redhat.com
Fixes: 9c4e6b1a7027f ("mm, mlock, vmscan: no more skipping pagevecs")
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mlock2-tests.c |   22 ++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/tools/testing/selftests/vm/mlock2-tests.c~tools-testing-selftests-vm-mlock2-tests-fix-mlock2-false-negative-errors
+++ a/tools/testing/selftests/vm/mlock2-tests.c
@@ -7,6 +7,7 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <stdbool.h>
+#include <sched.h>
 #include "mlock2.h"
 
 #include "../kselftest.h"
@@ -328,6 +329,22 @@ out:
 	return ret;
 }
 
+/*
+ * After commit 9c4e6b1a7027f ("mm, mlock, vmscan: no more skipping pagevecs")
+ * changes made by calls to mlock* family might not be immediately reflected
+ * on the LRUs, thus checking the PFN flags might race against pagevec drain.
+ *
+ * In order to sort out that race, and get the after fault checks consistent,
+ * the "quick and dirty" trick below is required in order to force a call to
+ * lru_add_drain_all() to get the recently MLOCK_ONFAULT pages moved to
+ * the unevictable LRU, as expected by the checks in this selftest.
+ */
+static void force_lru_add_drain_all(void)
+{
+	sched_yield();
+	system("echo 1 > /proc/sys/vm/compact_memory");
+}
+
 static int onfault_check(char *map)
 {
 	unsigned long page_size = getpagesize();
@@ -343,6 +360,9 @@ static int onfault_check(char *map)
 	}
 
 	*map = 'a';
+
+	force_lru_add_drain_all();
+
 	page1_flags = get_pageflags((unsigned long)map);
 	page2_flags = get_pageflags((unsigned long)map + page_size);
 
@@ -465,6 +485,8 @@ static int test_lock_onfault_of_present(
 		goto unmap;
 	}
 
+	force_lru_add_drain_all();
+
 	page1_flags = get_pageflags((unsigned long)map);
 	page2_flags = get_pageflags((unsigned long)map + page_size);
 	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
_

Patches currently in -mm which might be from aquini@redhat.com are

tools-testing-selftests-vm-mlock2-tests-fix-mlock2-false-negative-errors.patch

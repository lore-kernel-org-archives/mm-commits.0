Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4C04DB54F
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 21:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786050014; cv=none; b=UBcXAfi6rI8LWtPYmMK1PnjPLzS4ZnowIdQrsjq6h251V7Th6O/hMSJclulF1c0tJadE1XDgHESkZxEcSi2MCqMZDSR53whuJvATTOHv5l+yTJvaCdi9yNiQ4Nl95oHQwivtfOy4DL3+lhLnLJJNraTnL7rRz0jB0nQ982yHNn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786050014; c=relaxed/simple;
	bh=i6o1jngbfwWRBe+EYAI3OumIbahrXV0tgoxeKih6pCE=;
	h=Date:To:From:Subject:Message-Id; b=WEL+jJ8k5fzoZA0BhVxgs6Kpibeoa1QAFuSEgBvuAYp9wA13zIaytDpspAPGhacmEm0oUhu7cM6SRkH3OXYYge8EpMt890dsoibNd0VpvOY8knLDNH2r8qZeFvCXLCb+iUphWjqjNQNFzIgbfB7XuBTIDEgQzSr7dI16/5kzX00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BKwYnob7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BKwYnob7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A7F1F00A3A;
	Thu,  6 Aug 2026 21:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786050012;
	bh=rA7x6Jjl31KNa7sxlnAj2FeySFM9IjfHR+uuoO8fvPY=;
	h=Date:To:From:Subject;
	b=BKwYnob7n1egeFZY/ZSMrwmXFvPgmraSSSpmUFZV9zB6XmcfqclQ/BQxlIwG7F3Me
	 RcuYBprzAblnhJnGn4pM4o9xtMhqasa9v/w4B2wNl1CQ7alyInT0PUg8nPzKeYtp2j
	 ySKuCGjpCOhT2lW+PyNnXfy8gIOkBR58judLpylg=
Date: Thu, 06 Aug 2026 14:00:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-retry-migration-failures-for-the-full-runtime.patch added to mm-new branch
Message-Id: <20260806210012.40A7F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: retry migration failures for the full runtime
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-retry-migration-failures-for-the-full-runtime.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-retry-migration-failures-for-the-full-runtime.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: selftests/mm: retry migration failures for the full runtime
Date: Mon, 27 Jul 2026 10:52:21 +0100

move_pages() is best effort and can temporarily fail when concurrent
faults race with page unmapping.  A busy shared-anon workload can exhaust
the current 100 retries long before the intended 20-second runtime and
produce a false failure.

Use the full runtime as the retry window.  Since the initial page location
is unknown, require it to reach both alternating NUMA targets to confirm
that cross-node migration made progress despite transient contention.

Link: https://lore.kernel.org/20260727095225.372655-6-usama.anjum@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/migration.c |   37 ++++++++++++-----------
 1 file changed, 20 insertions(+), 17 deletions(-)

--- a/tools/testing/selftests/mm/migration.c~selftests-mm-retry-migration-failures-for-the-full-runtime
+++ a/tools/testing/selftests/mm/migration.c
@@ -7,7 +7,7 @@
 #include "kselftest_harness.h"
 #include "hugepage_settings.h"
 
-#include <strings.h>
+#include <string.h>
 #include <pthread.h>
 #include <numa.h>
 #include <numaif.h>
@@ -20,7 +20,6 @@
 
 #define TWOMEG		(2<<20)
 #define RUNTIME		(20)
-#define MAX_RETRIES	100
 #define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
 
 HUGETLB_SETUP_DEFAULT_PAGES(1)
@@ -110,7 +109,7 @@ int migrate(uint64_t *ptr, int n1, int n
 	int ret, tmp;
 	int status = 0;
 	struct timespec ts1, ts2;
-	int failures = 0;
+	int success = 0;
 
 	if (clock_gettime(CLOCK_MONOTONIC, &ts1))
 		return -1;
@@ -119,29 +118,33 @@ int migrate(uint64_t *ptr, int n1, int n
 		if (clock_gettime(CLOCK_MONOTONIC, &ts2))
 			return -1;
 
-		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME)
-			return 0;
+		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME) {
+			/* Reaching both targets verifies a cross-node move. */
+			if (success >= 2)
+				return 0;
+			else
+				return -2;
+		}
 
 		ret = move_pages(0, 1, (void **) &ptr, &n2, &status,
 				MPOL_MF_MOVE_ALL);
-		if (ret) {
-			if (ret > 0) {
-				/* Migration is best effort; try again */
-				if (++failures < MAX_RETRIES)
-					continue;
-				printf("Didn't migrate %d pages\n", ret);
-			}
-			else
-				perror("Couldn't migrate pages");
+		if (ret < 0) {
+			perror("Couldn't migrate pages");
+			return ret;
+		}
+		/* Migration is best effort. Try again */
+		if (ret > 0 || status < 0)
+			continue;
+		if (status != n2) {
+			printf("Page is on node %d instead of target node %d\n",
+			       status, n2);
 			return -2;
 		}
-		failures = 0;
+		success++;
 		tmp = n2;
 		n2 = n1;
 		n1 = tmp;
 	}
-
-	return 0;
 }
 
 void *access_mem(void *ptr)
_

Patches currently in -mm which might be from usama.anjum@arm.com are

selftests-mm-unpoison-pages-in-memory-failure-teardown.patch
selftests-mm-skip-cow-tmpfile-cases-when-fallocate-is-unsupported.patch
selftests-mm-skip-guard-hole-punch-test-if-madv_remove-is-unsupported.patch
selftests-mm-skip-khugepaged-swap-tests-without-swap.patch
selftests-mm-skip-hard-dirty-page-cache-test-on-nfs.patch
selftests-mm-retry-migration-failures-for-the-full-runtime.patch


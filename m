Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6BF349CFF
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622867; cv=none; b=GJWXtAoNKelDuQfH4E96sF3vKMR6F162oK3p2vHS6mTHKT8Ry0KuYkgvW0pU2QBLqXXnmKQERQVxIFkLXnDix3FPiiFiPyxkb5MU8VcgDsbS7Ta3Y62BGWI64nZ2mwGAdHotqozThE9UaEZZ8NqIlXLTqhS4nl9m9Z5NYuOpe1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622867; c=relaxed/simple;
	bh=S3MWQix91sFhYWnZHT2fSSc+990IBw5NRHe683+2z3Y=;
	h=Date:To:From:Subject:Message-Id; b=NwHnGcqrIX56LPoAZlKa41nxmpqtJ6OkVx6engCUsGjlD4l2GYeHwIeq10uIerhdK8x6WE0tILD0ZVTKv4fRGj2YFLihWcrhrDLNRnVezHlzxNmRRYb1xqGDA1UX1TtwQ1bxUB4JdijQq4qX+X/MdK2h1a0LtLQ+RZQDj1Y/U/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IYI1AF47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IYI1AF47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63921F000E9;
	Tue, 25 Aug 2026 01:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622865;
	bh=OAYGUX+kS8egXuOiC9V38PmtJEfaw9ScFvCjWiyTLe8=;
	h=Date:To:From:Subject;
	b=IYI1AF47k2s3GW2H0Rk3XuCl275iM2BVNXKnI8vYeJ6O0k8bGNOBCyaREZGP9JuYR
	 PFtYD4wt9OSm3NyNkYAcfR1nCPOAv9dKH83RuY6mUjyYihmFtYab1PNtNwbdX95C3L
	 CHEZqkKG6L4Len7maF3BhJuIq6y/52s82bPT06wI=
Date: Mon, 24 Aug 2026 18:54:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-retry-migration-failures-for-the-full-runtime.patch removed from -mm tree
Message-Id: <20260825015425.D63921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: retry migration failures for the full runtime
has been removed from the -mm tree.  Its filename was
     selftests-mm-retry-migration-failures-for-the-full-runtime.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



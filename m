Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246B918E356
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925253; cv=none; b=Ot7tZAemeEOuDyFRCLQdARqCUYwrhLyzO9bsJOlNOneEJXlVpHE48n3H9mKyWdrhyE4wO8WEotSGYbjSWGcB5AfC/g94jye49NojFFyw5b9gqrFl1ASF0kXukypSj7EDQ8CY5KIoC2bSHXOLZy4t8QkS/aFhEfDS1ce/VnRQrd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925253; c=relaxed/simple;
	bh=cyN3KCduIaclwOG48jabpfc5sYCMP1wGiroFqKoQq+k=;
	h=Date:To:From:Subject:Message-Id; b=HgP5/aCutfh1V4Cw1eHsuNxSBTFfN3Zxx8e2FYBpU8D1bSOcHsaqZqwYMneRoLwFzGpEOTz6IYh3HfoF9/0a+trYZmtW8b3OHkgtM8hlIq5C4k5bSI8SAxaXti3jskgXhuXaO1ibWVZUNvlGI3SbfUJSMOIdzdFf/Nu8fL2JIbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XA3ySEsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XA3ySEsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C64C4CEC5;
	Mon,  9 Sep 2024 23:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925253;
	bh=cyN3KCduIaclwOG48jabpfc5sYCMP1wGiroFqKoQq+k=;
	h=Date:To:From:Subject:From;
	b=XA3ySEsmwDTm87OR76X3mmwvlcI5gIUmDYn139AiKgJS5JaBqNw5A5mgW0eWuPFEZ
	 ZXqtDzqyp4b/izymuZCZ5a2oxJzf0nJIH3Mc8ybKV3oIGkzndI7neXh3Em6p2IU7MB
	 UzBU2qB1rg872iYjsc5CeCgzN6rnLlGrRn9pCbfE=
Date: Mon, 09 Sep 2024 16:40:52 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,shuah@kernel.org,ryan.roberts@arm.com,osalvador@suse.de,mhocko@suse.com,mgorman@techsingularity.net,mark.rutland@arm.com,kirill.shutemov@linux.intel.com,ioworker0@gmail.com,hughd@google.com,gshan@redhat.com,david@redhat.com,dave.hansen@linux.intel.com,cl@gentwo.org,catalin.marinas@arm.com,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,aneesh.kumar@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-relax-test-to-fail-after-100-migration-failures.patch removed from -mm tree
Message-Id: <20240909234052.D9C64C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: relax test to fail after 100 migration failures
has been removed from the -mm tree.  Its filename was
     selftests-mm-relax-test-to-fail-after-100-migration-failures.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: relax test to fail after 100 migration failures
Date: Fri, 30 Aug 2024 10:46:09 +0530

It was recently observed at [1] that during the folio unmapping stage of
migration, when the PTEs are cleared, a racing thread faulting on that
folio may increase the refcount of the folio, sleep on the folio lock (the
migration path has the lock), and migration ultimately fails when
asserting the actual refcount against the expected.  Thereby, the
migration selftest fails on shared-anon mappings.  The above enforces the
fact that migration is a best-effort service, therefore, it is wrong to
fail the test for just a single failure; hence, fail the test after 100
consecutive failures (where 100 is still a subjective choice).  Note that,
this has no effect on the execution time of the test since that is
controlled by a timeout.

[1] https://lore.kernel.org/all/20240801081657.1386743-1-dev.jain@arm.com/

Link: https://lkml.kernel.org/r/20240830051609.4037834-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/migration.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/migration.c~selftests-mm-relax-test-to-fail-after-100-migration-failures
+++ a/tools/testing/selftests/mm/migration.c
@@ -15,10 +15,10 @@
 #include <signal.h>
 #include <time.h>
 
-#define TWOMEG (2<<20)
-#define RUNTIME (20)
-
-#define ALIGN(x, a) (((x) + (a - 1)) & (~((a) - 1)))
+#define TWOMEG		(2<<20)
+#define RUNTIME		(20)
+#define MAX_RETRIES	100
+#define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
 
 FIXTURE(migration)
 {
@@ -65,6 +65,7 @@ int migrate(uint64_t *ptr, int n1, int n
 	int ret, tmp;
 	int status = 0;
 	struct timespec ts1, ts2;
+	int failures = 0;
 
 	if (clock_gettime(CLOCK_MONOTONIC, &ts1))
 		return -1;
@@ -79,13 +80,17 @@ int migrate(uint64_t *ptr, int n1, int n
 		ret = move_pages(0, 1, (void **) &ptr, &n2, &status,
 				MPOL_MF_MOVE_ALL);
 		if (ret) {
-			if (ret > 0)
+			if (ret > 0) {
+				/* Migration is best effort; try again */
+				if (++failures < MAX_RETRIES)
+					continue;
 				printf("Didn't migrate %d pages\n", ret);
+			}
 			else
 				perror("Couldn't migrate pages");
 			return -2;
 		}
-
+		failures = 0;
 		tmp = n2;
 		n2 = n1;
 		n1 = tmp;
_

Patches currently in -mm which might be from dev.jain@arm.com are



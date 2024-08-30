Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CAF15C150
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725058560; cv=none; b=rIDTGGaD7RxghJe8i2iOgYdoMIrMOAAUeDYEGxLkw351Kz/QVrL1xyrP0hrXy4DaWQfYkEIyVYztJWtuK81YHWFOmLdeaBD/vcHv4Em7MyIghseC4L4+XvUXOl2gjrhCUIj+DGsdygHRmBBnpMR+tYQK3upNErbIk4GVBLsGdR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725058560; c=relaxed/simple;
	bh=V+LgPQJyh0PCsBk9JkP78pUBt+0hw11gN0JJVR0pgQk=;
	h=Date:To:From:Subject:Message-Id; b=ZDzyMbhlud1QSfYrThGdO4/mmDhTmP0+4MjKoXiMiBDKgz4jcF7D86Xn2Y+ZRkK9aAkGaaaiMeBhnDJNYMuSnG5sJxrtlggxaeoAbxucxJJHhvaOJhOTK63RWvzEEqVBy9rlzBsg7PrjOSh6GbmyaonXUOws0qGeXoo6pJ8n3Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qrGGbLrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qrGGbLrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EE7C4CEC2;
	Fri, 30 Aug 2024 22:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725058560;
	bh=V+LgPQJyh0PCsBk9JkP78pUBt+0hw11gN0JJVR0pgQk=;
	h=Date:To:From:Subject:From;
	b=qrGGbLrRpQHYL764ndL61sqW+VZFdU+gtfUudQwemaTI7/Q9VjZGXHirwVB7ReGgO
	 5PdgHeAJB64Kj3WUqc/3bb7k2RtR6ZlyToXa4LLzjx5tnDE/CUKEa6SwQOITYzY9HQ
	 98KiMQ1LxAG3TfKNq5BHJbvwQFL+CrkeIUlkVCHE=
Date: Fri, 30 Aug 2024 15:55:59 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,shuah@kernel.org,ryan.roberts@arm.com,osalvador@suse.de,mhocko@suse.com,mgorman@techsingularity.net,mark.rutland@arm.com,kirill.shutemov@linux.intel.com,ioworker0@gmail.com,hughd@google.com,gshan@redhat.com,david@redhat.com,dave.hansen@linux.intel.com,cl@gentwo.org,catalin.marinas@arm.com,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,aneesh.kumar@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-relax-test-to-fail-after-100-migration-failures.patch added to mm-unstable branch
Message-Id: <20240830225600.09EE7C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: relax test to fail after 100 migration failures
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-relax-test-to-fail-after-100-migration-failures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-relax-test-to-fail-after-100-migration-failures.patch

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

selftests-mm-relax-test-to-fail-after-100-migration-failures.patch


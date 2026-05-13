Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3031C84BB
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 23:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778715637; cv=none; b=UbxqoOPUTnqA5pChaZUPawpFyd1VbK0UL6zOL42QISJt9UjqK6RrT8SoFlQb0T3vQyx4LytRr/E595kGO/gnHg1FOuse+wnSWxa9v7qFO93THj1h3Fr1ow6hgXd6P+nbBmhyV1ZofnRYxZ5PSQKmqAof8XvBEhf6J83mqyNwtQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778715637; c=relaxed/simple;
	bh=FOkaV0tEwiyll+UvYiic9AXHEpeIcgR6GtdnHrseLBs=;
	h=Date:To:From:Subject:Message-Id; b=ASjbiTMXOlz93lK8sfrgSsNhg6K7iLzEwLsx9WUYx3APcqkSpM0vHtkIjyjLvyT/b0xmJ3fKlroHUTQ0YedDSQYRmXEd1Z7XoPtLGPfsRt0O4hIlE7mWZhIjzOfArMIfUTclZ8e7Gz1s9PN8CucBBskN2YWR0SfNbUaEa/DzNj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fXL9eXCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fXL9eXCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621D2C19425;
	Wed, 13 May 2026 23:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778715637;
	bh=FOkaV0tEwiyll+UvYiic9AXHEpeIcgR6GtdnHrseLBs=;
	h=Date:To:From:Subject:From;
	b=fXL9eXCEzRaGAhkowKq4vHpiABvV+YsGXnOZu6IRuLlPIKb1vrYDmLHGKEwivhIBh
	 LvpSu7LNrM6VM43TobUbMtwWQawkJFbncUjxNs/RcLAe3T1Xz7Qr1glKTi/CjDGlg3
	 sab6R652ZJtzfhAq9OLiqDaB707KJc2+eej/uscc=
Date: Wed, 13 May 2026 16:40:36 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,dev.jain@arm.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed.patch added to mm-new branch
Message-Id: <20260513234037.621D2C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix incorrect mmap() error handling with NULL instead of MAP_FAILED
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: fix incorrect mmap() error handling with NULL instead of MAP_FAILED
Date: Wed, 13 May 2026 10:52:23 +0800

mmap() returns MAP_FAILED, which is defined as (void *)-1, on error, not
NULL.  Several selftests incorrectly check the return value of mmap()
using !ptr or ptr == NULL, which would erroneously treat MAP_FAILED as a
valid pointer since MAP_FAILED is non-zero and non-NULL.  This can lead to
segfaults when mmap() actually fails under memory pressure.

Link: https://lore.kernel.org/20260513025223.592766-1-lihongfu@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_tests.c     |    2 +-
 tools/testing/selftests/mm/madv_populate.c |    2 +-
 tools/testing/selftests/mm/soft-dirty.c    |    4 ++--
 tools/testing/selftests/mm/vm_util.c       |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/ksm_tests.c~selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -174,7 +174,7 @@ static void  *allocate_memory(void *ptr,
 {
 	void *map_ptr = mmap(ptr, map_size, PROT_WRITE, mapping, -1, 0);
 
-	if (!map_ptr) {
+	if (map_ptr == MAP_FAILED) {
 		ksft_perror("mmap");
 		return NULL;
 	}
--- a/tools/testing/selftests/mm/madv_populate.c~selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed
+++ a/tools/testing/selftests/mm/madv_populate.c
@@ -34,7 +34,7 @@ static void sense_support(void)
 
 	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
 		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
-	if (!addr)
+	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 
 	ret = madvise(addr, pagesize, MADV_POPULATE_READ);
--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -143,7 +143,7 @@ static void test_mprotect(int pagemap_fd
 	if (anon) {
 		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
 			   MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-		if (!map)
+		if (map == MAP_FAILED)
 			ksft_exit_fail_msg("anon mmap failed\n");
 	} else {
 		test_fd = open(fname, O_RDWR | O_CREAT, 0664);
@@ -155,7 +155,7 @@ static void test_mprotect(int pagemap_fd
 		ftruncate(test_fd, pagesize);
 		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
 			   MAP_SHARED, test_fd, 0);
-		if (!map)
+		if (map == MAP_FAILED)
 			ksft_exit_fail_msg("file mmap failed\n");
 	}
 
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -396,7 +396,7 @@ bool softdirty_supported(void)
 	/* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */
 	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
 		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
-	if (!addr)
+	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 
 	supported = check_vmflag(addr, "sd");
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-fix-mmap-return-value-check-in-run_migration_benchmark.patch
selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed.patch
selftests-perf_events-fix-mmap-error-check-in-sigtrap_threads.patch


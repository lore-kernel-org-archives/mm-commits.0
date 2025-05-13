Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E99C17578
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118457; cv=none; b=POt3eHk90z3fkq9RFKuAKMkfIYmq1lqcjdFocBRWrewRtjbKYbEEIjHprmPj+LXA2nQ1zLLu8g6bXNe+DkRp14uS+oJr27hQN16SySEwBSnrS9dbDGosyBNjprsy23qaNt6/l8BdyOOlbvlkpzCIckHPCM9ayTCjUb13HuiB0N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118457; c=relaxed/simple;
	bh=XmQ5HbpP+hITFpWiA/UexEGovr4cP5ItsAg5rfNKSFw=;
	h=Date:To:From:Subject:Message-Id; b=WFCvdOnka+v2NtOqQxcggDfL5kRvzaltcBIeWe//DiT2P2LV3JpGCzQ44MhRIGi7uss3yyQjWfS4OyqyJKtamxatEZwsDyN+3bO5NaO5Fd0ydvSHXyIbCmHPjPex5PIqvpSDLroWVES59eosulkscn1ozFmWtrEjXadTPo1EFNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fep/SIMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fep/SIMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD3EC4CEE4;
	Tue, 13 May 2025 06:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118456;
	bh=XmQ5HbpP+hITFpWiA/UexEGovr4cP5ItsAg5rfNKSFw=;
	h=Date:To:From:Subject:From;
	b=Fep/SIMDqNFSXi+9f1RPx0wh6dfQsMjjClbbvy8lmCLUMxNj+C+xhqgNt4exihhiv
	 rj3vSs6w2rp3fapkQq54X0t8r0kKgFcxSF2YHOIgFPgPEH2PL9pEkOJc836t+PumYK
	 jBZWSNzdIrI3J5oJLnBXHiro0cn0Ze4QdE/bd7H0=
Date: Mon, 12 May 2025 23:40:56 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20250513064056.AAD3EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes
Date: Thu Apr 24 05:15:43 PM PDT 2025

WARNING: do not add new typedefs
#86: FILE: tools/testing/selftests/mm/uffd-unit-tests.c:1284:
+typedef enum {

WARNING: braces {} are not necessary for single statement blocks
#106: FILE: tools/testing/selftests/mm/uffd-unit-tests.c:1304:
+	if (!fp) {
+		return THR_STATE_UNKNOWN;
+	}

WARNING: Use of volatile is usually wrong: see Documentation/process/volatile-considered-harmful.rst
#135: FILE: tools/testing/selftests/mm/uffd-unit-tests.c:1333:
+	volatile pid_t *pid = opaque;

ERROR: trailing statements should be on next line
#154: FILE: tools/testing/selftests/mm/uffd-unit-tests.c:1352:
+	while (uffd_read_msg(fd, &msg));

WARNING: Use of volatile is usually wrong: see Documentation/process/volatile-considered-harmful.rst
#180: FILE: tools/testing/selftests/mm/uffd-unit-tests.c:1378:
+	while (!(volatile pid_t)pid)

total: 1 errors, 4 warnings, 215 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1301,9 +1301,8 @@ static thread_state thread_state_get(pid
 	snprintf(tmp, sizeof(tmp), "/proc/%d/status", tid);
 	fp = fopen(tmp, "r");
 
-	if (!fp) {
+	if (!fp)
 		return THR_STATE_UNKNOWN;
-	}
 
 	while (fgets(tmp, sizeof(tmp), fp)) {
 		p = strstr(tmp, header);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch


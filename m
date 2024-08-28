Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B7D11CA0
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724807262; cv=none; b=EV6TqITvusaPBPRSbiirmHpKZZqjdNZ9J3+2xEzrJygY8N8ie7ED8HnDt4yBNmXBXThyub/ArUkxTqAGbIXIEmltv98oyJwWeCobCWhPVx+bnbkYEMPXkxJ+od6cv3vM4di2peTXHqT18FC1g/pksVRFFx86QzbX9GV8plsNz9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724807262; c=relaxed/simple;
	bh=Lqnru+JGY2NhBJiSslx3GomnD7qVMYRTJMLdSd24Cxo=;
	h=Date:To:From:Subject:Message-Id; b=rmSEwSqj99h7soyMK8YG5BM/NpCmmd+R5bcW9+VNI1QcSoaYetrHU0Mn7UShNHojhNZMz7Pm5C+qAFjyY8UbKlqILT0zHWRqO8N2W2BYRxTB/Zq95u/g5dxgHKqrKuQPMgUkt84tDleYkUPFDrDZ6AmXWSzAeeTWVJj9vb5Gn1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GwTfSrjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GwTfSrjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF12C4AF60;
	Wed, 28 Aug 2024 01:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724807261;
	bh=Lqnru+JGY2NhBJiSslx3GomnD7qVMYRTJMLdSd24Cxo=;
	h=Date:To:From:Subject:From;
	b=GwTfSrjInGQfr+BBx9E9gf06BOwnr6Hk8X1O2f08ZU4o1tswrtDceBd9p8xMNKFwk
	 3xC5/aToGPDjlmlkmmeiDXEAH0PDXAU/xJ7pS9ox00Dg0Gh0Q8ajGOi+ZIZZ6ijA3i
	 KlEdIsLCohVmd+QvZ9tXQOcLS5OR+ZrcjlyDcZIo=
Date: Tue, 27 Aug 2024 18:07:41 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch added to mm-unstable branch
Message-Id: <20240828010741.BDF12C4AF60@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: remove per-scheme region priority histogram buffer
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: remove per-scheme region priority histogram buffer
Date: Sun, 25 Aug 2024 21:23:22 -0700

Nobody is reading from or writing to the per-scheme region priorities
histogram buffer.  It is only wasting memory.  Remove it.

Link: https://lkml.kernel.org/r/20240826042323.87025-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-remove-per-scheme-region-priority-histogram-buffer
+++ a/include/linux/damon.h
@@ -233,7 +233,6 @@ struct damos_quota {
 	unsigned long charge_addr_from;
 
 	/* For prioritization */
-	unsigned long histogram[DAMOS_MAX_SCORE + 1];
 	unsigned int min_score;
 
 	/* For feedback loop */
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-access_memory_even-to-gitignore.patch
selftests-damon-cleanup-__pycache__-with-make-clean.patch
selftests-damon-add-execute-permissions-to-test-scripts.patch
mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test.patch
mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case.patch
mm-damon-dbgfs-test-skip-dbgfs_set_targets-test-if-paddr-is-not-registered.patch
mm-damon-dbgfs-test-skip-dbgfs_set_init_regions-test-if-paddr-is-not-registered.patch
mm-damon-move-kunit-tests-to-tests-subdirectory-with-_kunit-suffix.patch
mm-damon-tests-add-kunitconfig-file-for-damon-kunit-tests.patch
mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch


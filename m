Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F254135C6B9
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 03:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791863934; cv=none; b=R6VHsmNPjOttFJKs/9EBnz7uDr17xl4bS4hR7WBmUts0PdjR6vpi2HJFYb2paONbcNgyNnHzkx0QXqKYtoxJWnWzwJgkIQZ+Nj7Ycf3rvzLpLSIT29OuKVSo08nGc8HgZFrX8Z/e9sEo9nNyU9RqBOo+phgGfWFVZpRxzNjX12A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791863934; c=relaxed/simple;
	bh=34D+t3HMMc87dIdTkC6JiXY6/QRGuKA7dkoNN2mKfG0=;
	h=Date:To:From:Subject:Message-Id; b=ADmBbjD/RjGbnl2oyHa/+0CqNJX0jkAOCDjX1I6SKBaXOt/ehPmfl7TveFm+eogoynzP1prJSmOKpBCJwNV2Fp1XNj2Z0tcpvvUTIO401VehdeHkTipu5tVpUqsYxeKkmwsGcKunfHNeY+Vfwn/v9AGf/GmyoU4+nZTfq0Vsxc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nvNsWoIQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nvNsWoIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6561F000FF;
	Tue, 13 Oct 2026 03:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791863933;
	bh=ETo69VTBRcB8gi3aj4Sh7emgzAeGPTtULQx1+wPkI4w=;
	h=Date:To:From:Subject;
	b=nvNsWoIQFPMgHbD0akA95IOv0aiMBkjgYKWnLzEDxuTpM/YzycVJ4SrqzXj5wcYMi
	 gxwXRmdUYsYXlFXaTIjJs475X8AkF3gzRMkVKtA78GPSwPVDYBXfJ92otND7+rtDZT
	 Xc/G6Q/Pe3yseWJhOzeuO9NF2CJCuPzEPT0OnI1k=
Date: Mon, 12 Oct 2026 20:58:52 -0700
To: mm-commits@vger.kernel.org,wyihan@google.com,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-selftests-add-shmem-into-memory-failure-test-fix.patch removed from -mm tree
Message-Id: <20261013035853.7A6561F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-selftests-add-shmem-into-memory-failure-test-fix
has been removed from the -mm tree.  Its filename was
     mm-selftests-add-shmem-into-memory-failure-test-fix.patch

This patch was dropped because it was folded into mm-selftests-add-shmem-into-memory-failure-test.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-selftests-add-shmem-into-memory-failure-test-fix
Date: Thu Sep 17 05:06:00 PM PDT 2026

fix commant typo, per Lisa

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Lisa Wang <wyihan@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
---

 tools/testing/selftests/mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/memory-failure.c~mm-selftests-add-shmem-into-memory-failure-test-fix
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -165,7 +165,7 @@ static void check(struct __test_metadata
 	case MADV_SOFT_DIRTY_SHMEM:
 		/* The page content should remain unchanged. */
 		ASSERT_TRUE(check_memory(vaddr, self->page_size));
-		/* FALLTHORUGH */
+		/* FALLTHROUGH */
 	case MADV_HARD_CLEAN_SHMEM:
 	case MADV_SOFT_CLEAN_SHMEM:
 		/* It is not expected to receive a SIGBUS signal. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-selftests-add-shmem-into-memory-failure-test.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch
mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


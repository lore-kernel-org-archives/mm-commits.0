Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C939986334
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122626; cv=none; b=ritAuO4ENKfyRlHnPIKNzZJhpCTQsvoRbrooTop3aXR0CFqkTcCxR1YvkZcW6YtNvY+g7yaMcIKO8BUdGek35pSlQ0afHaixgnEfgmQKuApdYC8BacmnSyoCZj2WsCqnZCkIgGCmX4HHOYUTw58bwk+KaJd2OAEdcEH8Ac8pdE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122626; c=relaxed/simple;
	bh=HgY0GtcpXzkOPCVzLvjzu33ONPPEsFsaqya0K93iGvg=;
	h=Date:To:From:Subject:Message-Id; b=DB0M1DG145TB5Ofo/3ydkkanotFM1ZtRUKrzuv/fy2CS9s1ZcuJD/l6y9rfIzsgWxmUqIv0EhNLDryn/S6o7gtKvKwjWlLhQbsr2cK0mrs2AQk69bVvcbxHOt1Stp+a9kcXeHELqFj9OYK/h0xewVzXZAKKObSmRY+kBVwQg8Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IhaXPcK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IhaXPcK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7F9C4CEE3;
	Thu, 10 Jul 2025 04:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122626;
	bh=HgY0GtcpXzkOPCVzLvjzu33ONPPEsFsaqya0K93iGvg=;
	h=Date:To:From:Subject:From;
	b=IhaXPcK46PB5RzZQEvQUG34dXUDS9chl/GJGt8bcgyE5leUDgYdbiUhdR1mgtwHs6
	 GemprYYjKEUl5BdsgfaOAkG2M6Fh4Nt9Jb9bO6UpdttAF/boTYHKoncRAA+LtizCQZ
	 EBGNXsF931uXPO6aYWAJbzRs3p+s8KkLbea2G1LA=
Date: Wed, 09 Jul 2025 21:43:45 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jackmanb@google.com,david@redhat.com,axelrasmussen@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix.patch removed from -mm tree
Message-Id: <20250710044346.3A7F9C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix.patch

This patch was dropped because it was folded into selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix
Date: Thu Jun 26 14:22:21 2025 -0400

reduce uffd-unit-test poison test to minimum

Link: https://lkml.kernel.org/r/aF2RSsjuEOtzXcUa@x1.local
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1040,7 +1040,7 @@ static void uffd_poison_test(uffd_test_a
 	unsigned long nr, poison_pages = UFFD_POISON_TEST_NPAGES;
 
 	if (nr_pages < poison_pages) {
-		uffd_test_skip("Too less pages for POISON test");
+		uffd_test_skip("Too few pages for POISON test");
 		return;
 	}
 
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum.patch
mm-hugetlb-remove-prepare_hugepage_range.patch
mm-deduplicate-mm_get_unmapped_area.patch


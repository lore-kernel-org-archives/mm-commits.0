Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6192D5932
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 19:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787943952; cv=none; b=c939BJScIRb0+I4PVQSN0uvslhs9G+HsMN+og1B63tBHgXIX901ZHqNUxMbchq91RhbhA7B5sPoyBC3JTdl/mM1wS7YtyqoDnlKzw5eTRHQWt8kfhdjqpbtxTElMuCwa6rgkjkdZql36naG9hevxzMTUHLBSczuNRWjhAU4bTMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787943952; c=relaxed/simple;
	bh=vRSwAx9TNCltOHgob0tTo5N8uOaN6mjxrKxRrM29cvI=;
	h=Date:To:From:Subject:Message-Id; b=UNEnroA7rWRjIFF84J7ZUNRaDpW3V1vIRe8UGDwugSb7s1np4bO+G90QvNw58kV+ZwzDJTBPhlwofWK8FFzaY1StXmuQ1Usgo4O4cOsvOgofKr9Z4RiviyhnKbklxuiu15U02MI9f1jBVpLxxc+cZpw/GRjRo2i0oxBvk9OxxPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ugudhIqb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ugudhIqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A614F1F000E9;
	Fri, 28 Aug 2026 19:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787943950;
	bh=8IQbG0g1QO2CsiQJu1h+ECeuiPsDMTMFWqjtQ4ffnKM=;
	h=Date:To:From:Subject;
	b=ugudhIqbUvbYgq8GnAOZyP/BOS4a+J0KTJTd6hPF54s6OEQxgwGkP/8SmzxcwTPyL
	 B7yNMtyb8i46zbgVW6IOn3/PoRJLPHqtTrbr4TpvdnW7yfGgblYul5bMsL05Zjcxjr
	 xyzu/csCfc6J5esTWoEW7O7lLT943cXNxwM+SyD4=
Date: Fri, 28 Aug 2026 12:05:50 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,nphamcs@gmail.com,mkoutny@suse.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-test_zswap-fix-implicit-unsigned-promotion-bug-in-test_no_kmem_bypass.patch added to mm-new branch
Message-Id: <20260828190550.A614F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in test_no_kmem_bypass
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-test_zswap-fix-implicit-unsigned-promotion-bug-in-test_no_kmem_bypass.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-test_zswap-fix-implicit-unsigned-promotion-bug-in-test_no_kmem_bypass.patch

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
From: Wilson Felipe Pereira <wfelipe@google.com>
Subject: selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in test_no_kmem_bypass
Date: Fri, 28 Aug 2026 03:37:32 +0000

In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
checked against stored_pages * page_size / 4 to verify that the pages
pushed to zswap belong to the test memory cgroup.

Due to slight stat update timing differences, delta can evaluate to a
small negative number (e.g.  -5MB out of 1GB).  Because delta is declared
as a signed int and stored_pages is an unsigned size_t, C's usual
arithmetic conversions implicitly promote a negative delta to a large
unsigned 64-bit integer, causing `delta < stored_pages * page_size / 4` to
falsely evaluate to 0 and fail the test.

Fix this by declaring zswapped and delta as signed long long and comparing
against a signed threshold, ensuring negative deltas correctly evaluate to
true.

Link: https://lore.kernel.org/20260828033741.2184560-3-wfelipe@google.com
Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem bypass test")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-fix-implicit-unsigned-promotion-bug-in-test_no_kmem_bypass
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -630,11 +630,14 @@ static int test_no_kmem_bypass(const cha
 			break;
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
-			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
-			int delta = stored_pages * page_size - zswapped;
-			int result_ok = delta < stored_pages * page_size / 4;
+			long zswapped = cg_read_key_long(
+				test_group, "memory.stat", "zswapped ");
+			long long delta =
+				(long long)stored_pages * page_size - zswapped;
+			long long max_delta =
+				(long long)stored_pages * page_size / 4;
 
-			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
+			ret = (delta < max_delta) ? KSFT_PASS : KSFT_FAIL;
 			break;
 		}
 	}
_

Patches currently in -mm which might be from wfelipe@google.com are

selftests-cgroup-test_zswap-wait-for-cgroup-to-unpopulate-in-test_zswap_writeback.patch
selftests-cgroup-test_zswap-fix-implicit-unsigned-promotion-bug-in-test_no_kmem_bypass.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AB62DFA3A
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334209; cv=none; b=uKMPJMJGqkZazUxcB/BINdRr9F+zuL+lLwgYUH5ogE6xYKPQKhaF0gHv2NzCTE/EibI8gAKABP4ohauBo/D2dKKXoXsoIHPIea2RTVeiytd63fAlEAGU82Koc4CBP4MDKvI3Gwhd65raTzOJfmsIUuEyZeRqzENXLK4b+edlB3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334209; c=relaxed/simple;
	bh=GaImOTGT2vIR5l6FoAHG3AoSmt3SxbRwapo1vE5roIQ=;
	h=Date:To:From:Subject:Message-Id; b=k7cGi8Xk7/47FLb1CFZFC9Wf/wW4gs4mqJZ6E9RtDyKCHIDG0Gjgu08+MM+YyZEL2Yqt/fraV8o9kpv3YThJf/Qafp8fkLHVULFGoh23P1McuzlxD3DWsoJ91WLmKNlySbrBkmp0xpHDKVE2QM8rDgiLFHpB5WIZBmaR8MgxMAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T9RoTR3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T9RoTR3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964711F0089E;
	Wed,  7 Oct 2026 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334207;
	bh=O2WWcxLxJTOs1dvuKt6zBiVpXbdnqfKCC2+9ztR3GQw=;
	h=Date:To:From:Subject;
	b=T9RoTR3KtFUWWVYQxfbrxv+bSxsWnBftUE2AJaoTONc5EnDaHHf80q8PcwwVxYxZ3
	 oD6fmRdnpRIxqbpcoUFHBm0yEvtZS6rr/8ZN1SdLfMbPqhjA0yVLfBXBDrDEnI5JI2
	 6FrxfF+aAHjcu858OvQBg3ITK1OV9fAfnS/FCUGg=
Date: Tue, 06 Oct 2026 17:50:07 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,nphamcs@gmail.com,mkoutny@suse.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-test_zswap-fix-implicit-unsigned-promotion-bug-in-test_no_kmem_bypass.patch removed from -mm tree
Message-Id: <20261007005007.964711F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in test_no_kmem_bypass
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-test_zswap-fix-implicit-unsigned-promotion-bug-in-test_no_kmem_bypass.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Koutný <mkoutny@suse.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-fix-implicit-unsigned-promotion-bug-in-test_no_kmem_bypass
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -654,11 +654,14 @@ static int test_no_kmem_bypass(const cha
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

mm-zswap-convert-zswap_store_page-and-zswap_compress-to-take-a-folio.patch
init-main-fix-off-by-one-in-argv_init-cleanup.patch
init-main-fix-false-positive-kernel-panic-on-environment-variable-overwrite.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC9128B7EA
	for <mm-commits@vger.kernel.org>; Mon, 24 Aug 2026 20:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787602768; cv=none; b=rClmbd9HfhqPsHMXU2vhj+s2E7+kPvyYdbmMJoHmyptEEkXhBN2MO5bKaKEJiIOv+T5p7/51uGThPRs234dxqLfaRSRrD9Zk3ESdRNfKrlVB1q+v6zsBW7v9p1VIjLCkK4BXF+E+134+Mb6jypSbW/8oMtCTFUUw91bt7KWHbgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787602768; c=relaxed/simple;
	bh=SItm2iMGXfyVxNENc9ufORDd+l+bja1b9VyWmy4AJ84=;
	h=Date:To:From:Subject:Message-Id; b=oUfAsXaz6XQxzrhz0Yt2CcsGlRgKCXBSTIBVyVZDsw6RYTXr/kiX06C1QnxzzYCYz0FvB+dq5a2KKmdEVgG1NmHM7mi4Pkqqn2xgNX43PrpgwnQAaKuecwjqLEmr1ibV0g7serKiE9V/7mFGBwXWUsNWtY6ZUQ1zB4+ip8xuY7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XjN+wrL3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XjN+wrL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8841F000E9;
	Mon, 24 Aug 2026 20:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787602766;
	bh=Y9jVRFygSS3wjdu7n7+IRgJP2bE3918hzfAW+an8ops=;
	h=Date:To:From:Subject;
	b=XjN+wrL3mKAB1w4yHqglWFddXp6q6czKI/T6YoR3XJ4citR8mIKC8eayAIQcAixIU
	 UwM9wj05BKOvVFvRNFJabNM+3Y4IPrNyJFsJJydn/QybSEnuL30NEWrKDZeOMeHg6x
	 oz4utgz8BY/dL6HaXrM6dY3j2Hph7J3X37bxnYkg=
Date: Mon, 24 Aug 2026 13:19:26 -0700
To: mm-commits@vger.kernel.org,wfelipe@google.com,tj@kernel.org,sj@kernel.org,shuah@kernel.org,nphamcs@gmail.com,mkoutny@suse.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,anshuman.khandual@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch removed from -mm tree
Message-Id: <20260824201926.8C8841F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch

This patch was dropped because it was folded into selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix
Date: Tue Aug 11 07:04:40 PM PDT 2026

clarify debugfs-unavailable error message

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wilson Felipe Pereira <wfelipe@google.com>
Cc: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -578,7 +578,7 @@ static int test_no_kmem_bypass(const cha
 		return KSFT_SKIP;
 	}
 	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
-		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
+		ksft_print_msg("debugfs not mounted at /sys/kernel/debug\n");
 		return KSFT_SKIP;
 	}
 	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
maple_tree-document-erase-and-allocations-better-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


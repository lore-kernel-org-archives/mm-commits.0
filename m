Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C16A94F
	for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2025 22:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752791018; cv=none; b=rUWfbVTO1db3EyZzWRQ9nLsnxSKHuQJ3sn/UL3G3yIq8rr/a2bWsC/+Lmll333rWbdz75P2jKaVKUvRZlQs0xcfrN0alEdlvXBshrPkYTk3lA3nFHDdyzKaRg+4ndVj29FsYCNTv0mHqY1v1pabD0c53T2AEME3O3BbR5QWui1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752791018; c=relaxed/simple;
	bh=gNECbzwFcLsmHfkWscw5DLFLALTVc2Q/W5cI4cM0Msc=;
	h=Date:To:From:Subject:Message-Id; b=TwxkEXc4x3cd+ELZ1mJJi+LcH6OwV66/kCQd7m0eZRu8BjyhzEhIIxlS3B2LZ9rT+Nkn2EbC2IHDaQC3J5a4cNn/gs5wUKhqUyJIgS4rs4GDaI0O4i74TaOL8bgC4016qjK6xvrvP96o+sb7DSSi2nevgipLXjIZUNEwYoHRUlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gn1IM6EH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gn1IM6EH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7D7C4CEE3;
	Thu, 17 Jul 2025 22:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752791018;
	bh=gNECbzwFcLsmHfkWscw5DLFLALTVc2Q/W5cI4cM0Msc=;
	h=Date:To:From:Subject:From;
	b=gn1IM6EHQ7/OHKSePgriSw0ef9Yx8JTcBvnjAMt8JDpNSgJ2cPds5ye6Nq25c9ZmA
	 m4RCR9ispJ4mLzMTqZXeHbu6S86C9+/rmjt/HbZmSNf1+D+RMtGNZkffaz9qOw/2In
	 jB1kACDIjm4vBwuQi9sqW4+ayn6vR+COAwBhEmCA=
Date: Thu, 17 Jul 2025 15:23:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sj@kernel.org,shuah@kernel.org,ryncsn@gmail.com,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,broonie@kernel.org,brauner@kernel.org,lianux.mm@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-guard-regions-use-skip-instead-of-ksft_exit_skip.patch added to mm-unstable branch
Message-Id: <20250717222337.DE7D7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: guard-regions: Use SKIP() instead of ksft_exit_skip()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-guard-regions-use-skip-instead-of-ksft_exit_skip.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-guard-regions-use-skip-instead-of-ksft_exit_skip.patch

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
From: wang lian <lianux.mm@gmail.com>
Subject: selftests/mm: guard-regions: Use SKIP() instead of ksft_exit_skip()
Date: Thu, 17 Jul 2025 21:18:57 +0800

To ensure only the current test is skipped on permission failure, instead
of terminating the entire test binary.

Link: https://lkml.kernel.org/r/20250717131857.59909-3-lianux.mm@gmail.com
Signed-off-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/guard-regions.c~selftests-mm-guard-regions-use-skip-instead-of-ksft_exit_skip
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -575,7 +575,7 @@ TEST_F(guard_regions, process_madvise)
 
 	/* OK we don't have permission to do this, skip. */
 	if (count == -1 && errno == EPERM)
-		ksft_exit_skip("No process_madvise() permissions, try running as root.\n");
+		SKIP(return, "No process_madvise() permissions, try running as root.\n");
 
 	/* Returns the number of bytes advised. */
 	ASSERT_EQ(count, 6 * page_size);
_

Patches currently in -mm which might be from lianux.mm@gmail.com are

selftests-mm-reuse-force_read-to-replace-asm-volatile-r-xxx.patch
selftests-mm-guard-regions-use-skip-instead-of-ksft_exit_skip.patch


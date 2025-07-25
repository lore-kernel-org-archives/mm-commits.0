Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8131B221FBB
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409742; cv=none; b=lta/5QRR51lYnjzSQiFvnuNSzdmBf54qDQWsYu63J2q2+TJFCgMcIP9f0UR+5gzeUhes/TxCm/tzehtZaAp7/aveJ5gFFRnizJID0BsA6iCpoXYw+Uu/FjRN1jdh9rLisnU6D+HZFzHtwQIIf0CikPx5jLd4f1c6RJQyHT/2Ymg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409742; c=relaxed/simple;
	bh=dVb/HURjp/+T0YDt3WiHCKdVqnX4uxkhvrg9N9sxTVY=;
	h=Date:To:From:Subject:Message-Id; b=qBeuxOkDvnh+Rq4ZxiV/Vm09hkLAlm31FCKiOqN9HkaNwsZE93jTDV0xMvacU0s/ddsEusG95ZV/3Z31oZ7fTJo8KidbvQP9DRujH6/KM62IhI5bLhp9MWcAiyKFHKTqWmzcir0CDwP5HMe3OhTBhfcitnEFE9iUoZNs5KF6HtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t5CxUteJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t5CxUteJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE639C4CEED;
	Fri, 25 Jul 2025 02:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409742;
	bh=dVb/HURjp/+T0YDt3WiHCKdVqnX4uxkhvrg9N9sxTVY=;
	h=Date:To:From:Subject:From;
	b=t5CxUteJF494e5hIPoIeCt9Tr4/UJvqaBz1mQ89jEU7YwD6r1oxN+XcerSg1kiXM2
	 /t1JO4VvCY/CSHo/ztvQjN4gIaJrNm6OpkXrHfhKMh7hTZYbu5gmjs6k/RY/zEN9Gt
	 bG11IM8bm1KF6maZDH1po3okPWq0dVk1OBFhQSTk=
Date: Thu, 24 Jul 2025 19:15:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sj@kernel.org,shuah@kernel.org,ryncsn@gmail.com,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,broonie@kernel.org,brauner@kernel.org,lianux.mm@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-guard-regions-use-skip-instead-of-ksft_exit_skip.patch removed from -mm tree
Message-Id: <20250725021541.EE639C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: guard-regions: Use SKIP() instead of ksft_exit_skip()
has been removed from the -mm tree.  Its filename was
     selftests-mm-guard-regions-use-skip-instead-of-ksft_exit_skip.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

selftests-mm-add-process_madvise-tests.patch


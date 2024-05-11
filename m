Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9822845BF3
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467338; cv=none; b=nsLC5WRiIXbTCNT8lIXUjkKrkB35GCTjq9QFg/TIxH+MLf0TI57iN96Au73M8BHjSjRUv3CUhzLCdTV0qBQ3rWi1SH4fA1EylP8tObmfpGVgdz3fzLW52dbfhfDab6UOUoazbZ0bOEBUmpNw9y6pd1RgUqkjspt31J3NsW99Ufs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467338; c=relaxed/simple;
	bh=+G6Phpu2w6vahyHdB16NeAiPQxbM6SOH0g1LI3g2PM0=;
	h=Date:To:From:Subject:Message-Id; b=ng7GBqB3MzkwheXV+5OtGJXlCkXWcK6SmW9641ZNFi7xqT6gx8zv4/xVTurA6LKNc1l3gwxC1BYXrEuurqCUNSSAOOr6xKtnW0JfAErYyfZtB73j08CPhrjk677amtpLXB6doMoLxAYMrybUv/q9mtmHY6r5GmE464bggSb+Nbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fysy0PGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fysy0PGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFD3C4AF07;
	Sat, 11 May 2024 22:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467338;
	bh=+G6Phpu2w6vahyHdB16NeAiPQxbM6SOH0g1LI3g2PM0=;
	h=Date:To:From:Subject:From;
	b=fysy0PGys3SWeGqrhdyAD1uuT0wBxw7eV7ufupVpON/tf6UuppxwikhJCZZ5FT3eG
	 R44Iyt5IIm/ST3iquvdi+6EJqtwxEgMXatAZ+Hy0z9YxOeQmBwdGYRZJtqQHdsNPyk
	 1rt1KFnMM0QxlfAXKr7tJG6D05NVMU0SaJ0CLfOE=
Date: Sat, 11 May 2024 15:42:17 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-remove-redundant-addition-of-memory-controller.patch removed from -mm tree
Message-Id: <20240511224218.1BFD3C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: cgroup: remove redundant enabling of memory controller
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-remove-redundant-addition-of-memory-controller.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: selftests: cgroup: remove redundant enabling of memory controller
Date: Thu, 2 May 2024 21:04:26 +0100

Memory controller is already enabled in main which invokes the test, hence
this does not need to be done in test_no_kmem_bypass.

Link: https://lkml.kernel.org/r/20240502200529.4193651-2-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-remove-redundant-addition-of-memory-controller
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -364,8 +364,6 @@ static int test_no_kmem_bypass(const cha
 	trigger_allocation_size = sys_info.totalram / 20;
 
 	/* Set up test memcg */
-	if (cg_write(root, "cgroup.subtree_control", "+memory"))
-		goto out;
 	test_group = cg_name(root, "kmem_bypass_test");
 	if (!test_group)
 		goto out;
_

Patches currently in -mm which might be from usamaarif642@gmail.com are



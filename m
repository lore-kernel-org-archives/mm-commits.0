Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A84579C0
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725246555; cv=none; b=fvFHts7Q/slXHb5p4t0SNuGKp2qBNeZrx1HcuxFPn2Ubt9pBTdgCauq++MLG6eyLqVsbQroNi6aBThDVQllbEntBLiYPfKlH+9euFRaqBUrfs/Vtc5U5+LOjHMGxVPMxCbab0QRtpHK+s2LFR6sHFNanSK4Ph99j86mg8z2ZYGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725246555; c=relaxed/simple;
	bh=j8Gee6qA76PRwKKLUBpqPVQM5UEymdqBYW7HhzKQ3RQ=;
	h=Date:To:From:Subject:Message-Id; b=Kn2cny3E84jIMNnt+MSS7uwMwSmcwZe9d5UD+bPp2TIciIcoN24EjYzVYMCEloLLYNmWV9tBnSvg3hxZYP8nzilie8uSssayTQ2dAHwU98fL67BHda/q3wbo4Lb3EWgV0YFm0+b2rn9G29sC7Ljt7SJKE8VCAGKsbmz4eE7NXIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=feaZs4SE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="feaZs4SE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4149C4CEC3;
	Mon,  2 Sep 2024 03:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725246554;
	bh=j8Gee6qA76PRwKKLUBpqPVQM5UEymdqBYW7HhzKQ3RQ=;
	h=Date:To:From:Subject:From;
	b=feaZs4SEK/+1J9JbVWhCw3wKqA7B1NILGHMDE5up94PiCqzKpbC5AXQXqZiY6cbke
	 1HJyGQjkgj/1bVPJJLJT6nc+mBCf3iG/xybXBllm/UQWzIusaVD6AB0bdv7YuDQCWw
	 SMbJvfXMoO3fk4HstrbA+7m+DSA3T53YKjYEOKmg=
Date: Sun, 01 Sep 2024 20:09:14 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,longman@redhat.com,lizefan.x@bytedance.com,hannes@cmpxchg.org,corbet@lwn.net,davidf@vimeo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-cg2-memoryswappeak-write-tests-v7.patch removed from -mm tree
Message-Id: <20240902030914.C4149C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, memcg: cg2 memory{.swap,}.peak write tests
has been removed from the -mm tree.  Its filename was
     mm-memcg-cg2-memoryswappeak-write-tests-v7.patch

This patch was dropped because it was folded into mm-memcg-cg2-memoryswappeak-write-tests.patch

------------------------------------------------------
From: David Finkel <davidf@vimeo.com>
Subject: mm, memcg: cg2 memory{.swap,}.peak write tests
Date: Tue, 30 Jul 2024 19:13:04 -0400

update tests

Link: https://lkml.kernel.org/r/20240730231304.761942-3-davidf@vimeo.com
Signed-off-by: David Finkel <davidf@vimeo.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |   49 +++++++++++--
 1 file changed, 42 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~mm-memcg-cg2-memoryswappeak-write-tests-v7
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -170,6 +170,7 @@ static int test_memcg_current_peak(const
 	char *memcg;
 	bool fd2_closed = false, fd3_closed = false, fd4_closed = false;
 	int peak_fd = -1, peak_fd2 = -1, peak_fd3 = -1, peak_fd4 = -1;
+	struct stat ss;
 
 	memcg = cg_name(root, "memcg_test");
 	if (!memcg)
@@ -200,9 +201,25 @@ static int test_memcg_current_peak(const
 	 */
 	peak_fd = cg_open(memcg, "memory.peak", O_RDWR | O_APPEND | O_CLOEXEC);
 
-	if (peak_fd == -1)
+	if (peak_fd == -1) {
+		if (errno == ENOENT)
+			ret = KSFT_SKIP;
+		goto cleanup;
+	}
+
+	/*
+	 * Before we try to use memory.peak's fd, try to figure out whether
+	 * this kernel supports writing to that file in the first place. (by
+	 * checking the writable bit on the file's st_mode)
+	 */
+	if (fstat(peak_fd, &ss))
 		goto cleanup;
 
+	if ((ss.st_mode & S_IWUSR) == 0) {
+		ret = KSFT_SKIP;
+		goto cleanup;
+	}
+
 	peak_fd2 = cg_open(memcg, "memory.peak", O_RDWR | O_APPEND | O_CLOEXEC);
 
 	if (peak_fd2 == -1)
@@ -920,6 +937,8 @@ static int test_memcg_swap_max_peak(cons
 	int ret = KSFT_FAIL;
 	char *memcg;
 	long max, peak;
+	struct stat ss;
+	int swap_peak_fd = -1, mem_peak_fd = -1;
 
 	/* any non-empty string resets */
 	static const char reset_string[] = "foobarbaz";
@@ -939,13 +958,29 @@ static int test_memcg_swap_max_peak(cons
 		goto cleanup;
 	}
 
-	int swap_peak_fd = cg_open(memcg, "memory.swap.peak",
-				   O_RDWR | O_APPEND | O_CLOEXEC);
+	swap_peak_fd = cg_open(memcg, "memory.swap.peak",
+			       O_RDWR | O_APPEND | O_CLOEXEC);
 
-	if (swap_peak_fd == -1)
+	if (swap_peak_fd == -1) {
+		if (errno == ENOENT)
+			ret = KSFT_SKIP;
+		goto cleanup;
+	}
+
+	/*
+	 * Before we try to use memory.swap.peak's fd, try to figure out
+	 * whether this kernel supports writing to that file in the first
+	 * place. (by checking the writable bit on the file's st_mode)
+	 */
+	if (fstat(swap_peak_fd, &ss))
 		goto cleanup;
 
-	int mem_peak_fd = cg_open(memcg, "memory.peak", O_RDWR | O_APPEND | O_CLOEXEC);
+	if ((ss.st_mode & S_IWUSR) == 0) {
+		ret = KSFT_SKIP;
+		goto cleanup;
+	}
+
+	mem_peak_fd = cg_open(memcg, "memory.peak", O_RDWR | O_APPEND | O_CLOEXEC);
 
 	if (mem_peak_fd == -1)
 		goto cleanup;
@@ -1081,9 +1116,9 @@ static int test_memcg_swap_max_peak(cons
 	ret = KSFT_PASS;
 
 cleanup:
-	if (close(mem_peak_fd))
+	if (mem_peak_fd != -1 && close(mem_peak_fd))
 		ret = KSFT_FAIL;
-	if (close(swap_peak_fd))
+	if (swap_peak_fd != -1 && close(swap_peak_fd))
 		ret = KSFT_FAIL;
 	cg_destroy(memcg);
 	free(memcg);
_

Patches currently in -mm which might be from davidf@vimeo.com are

mm-memcg-cg2-memoryswappeak-write-handlers.patch
mm-memcg-cg2-memoryswappeak-write-tests.patch


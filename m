Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3515DC2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011135; cv=none; b=Nm6eYYtT6EfmNA7iqYJ+LG2T+Db/LkaK27KvlH5JGXTjA+Xsxrg1aDNRFLd5gIk7UndxutEBCXMV3J5Eg6qhEfZ6/a5aDIqNsuGR2PlyG+CD97h+XTXwPFRVBpy7uXKA/8tqAR0UB3v+tNNd9iI3vFaoyHqTdW6j6q8g7kcCx7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011135; c=relaxed/simple;
	bh=V9tpkTu0bSg+NdCY2q3HaBWJkf8DgL2LZlNwzs9UXTQ=;
	h=Date:To:From:Subject:Message-Id; b=ocvzoy4y+PO8Bhl3xj0yFiLJ273nWrKSk8mNHH/u7ovUzAq7VyncswGjT4AphTCCQy2dleohJLbejy1sV6ivdAE75PcYSLa5PgelRAltyX/Qv8WmcxHO2hrka82yMhR6FxgA3tsjKtCpIDqggzWrtKHDGbpUV/KltqGO9GlcyQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TZjX9Xe3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TZjX9Xe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B908C4CEE4;
	Mon, 12 May 2025 00:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011135;
	bh=V9tpkTu0bSg+NdCY2q3HaBWJkf8DgL2LZlNwzs9UXTQ=;
	h=Date:To:From:Subject:From;
	b=TZjX9Xe39ifZOhRdbxEBBKylj/oFCBMQvGLvcF9LLAglJV7yPvvW5D+7dBvJoknRJ
	 c8R3FlijOXgFVsoFs9mUWG4oNQ+TqSFfWxVvLU4EYHHX8G0CSOe4fqQJSYz9AmT1ZP
	 AlVk5VEZT/Qjn8fehyI6Sr0JzfpRDyx/YX3Noazs=
Date: Sun, 11 May 2025 17:52:14 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-prcl-fix-a-comment-typo.patch removed from -mm tree
Message-Id: <20250512005215.0B908C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/prcl: fix a comment typo
has been removed from the -mm tree.  Its filename was
     samples-damon-prcl-fix-a-comment-typo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: samples/damon/prcl: fix a comment typo
Date: Fri, 11 Apr 2025 15:38:00 +0800

This patch just fixes a typo in the comment.

Link: https://lkml.kernel.org/r/20250411073800.1444481-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/damon/prcl.c~samples-damon-prcl-fix-a-comment-typo
+++ a/samples/damon/prcl.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * proactive reclamation: monitor access pattern of a given process, find
- * regiosn that seems not accessed, and proactively page out the regions.
+ * regions that seems not accessed, and proactively page out the regions.
  */
 
 #define pr_fmt(fmt) "damon_sample_prcl: " fmt
_

Patches currently in -mm which might be from lienze@kylinos.cn are



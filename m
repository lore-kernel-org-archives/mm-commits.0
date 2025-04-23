Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD2D19DF4A
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 22:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745446870; cv=none; b=r7P+tNEzKCnhSkoE4jAMcYiRmiu9sWliH8GZC1U+qJxZ0yBdF2gS4HnvSN+xuvzho1CDy9IFir30l1ubLisLqsl/0wAZ6Xc3KQZIdObPIzDvES1zaWy5YfrvtR/PjMt1yF2flVTmLBAR0wzIdcFsFuc8xUdIbsOMuRvkw9RnAKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745446870; c=relaxed/simple;
	bh=EX/o8K7N1kXHAFadXdWzVTIsLaHXZ5/s5BcjExVrQjM=;
	h=Date:To:From:Subject:Message-Id; b=b+JbFpwcjJgVIr9y2F4BlNOP0kupcFwiN5nIdXalAfuMimMbFmMbaa96JEwouIjm8kJG1rBiCEwpVgeTS2QNfWOBxACZKFipT1BI5CpCZdKPqeCdadDjum23QXbIZTYF/v2z/i+rQaojbIaFnGpvna/DttnFaROCXePU322SNwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yz3LE3YZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yz3LE3YZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB628C4CEE2;
	Wed, 23 Apr 2025 22:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745446869;
	bh=EX/o8K7N1kXHAFadXdWzVTIsLaHXZ5/s5BcjExVrQjM=;
	h=Date:To:From:Subject:From;
	b=yz3LE3YZ/545O2pknJ/Omd7ZujasDty6m+ogtkcFzcRcTpRfruSmQXJNoRvbLWEeM
	 2u97VyuxSRirSj5VjVgfPd4b448ptwJtI9TR65IXav/RKSbJqO2GFTvowKrECjVJ/W
	 KK4SdGQzNQLUWIslprkmN8yHafyhy8fDnNN0Q5YQ=
Date: Wed, 23 Apr 2025 15:21:09 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,suhui@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch removed from -mm tree
Message-Id: <20250423222109.CB628C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: use kmalloc_array() and size_add()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Su Hui <suhui@nfschina.com>
Subject: mm/damon/sysfs-schemes: use kmalloc_array() and size_add()
Date: Mon, 21 Apr 2025 14:24:24 +0800

It's safer to use kmalloc_array() and size_add() because it can prevent
possible overflow problem.

Link: https://lkml.kernel.org/r/20250421062423.740605-1-suhui@nfschina.com
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add
+++ a/mm/damon/sysfs-schemes.c
@@ -465,7 +465,8 @@ static ssize_t memcg_path_store(struct k
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
-	char *path = kmalloc(sizeof(*path) * (count + 1), GFP_KERNEL);
+	char *path = kmalloc_array(size_add(count, 1), sizeof(*path),
+				   GFP_KERNEL);
 
 	if (!path)
 		return -ENOMEM;
@@ -2064,7 +2065,7 @@ static int damon_sysfs_memcg_path_to_id(
 	if (!memcg_path)
 		return -EINVAL;
 
-	path = kmalloc(sizeof(*path) * PATH_MAX, GFP_KERNEL);
+	path = kmalloc_array(PATH_MAX, sizeof(*path), GFP_KERNEL);
 	if (!path)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from suhui@nfschina.com are



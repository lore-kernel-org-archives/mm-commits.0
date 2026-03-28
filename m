Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FE822B584
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671902; cv=none; b=DBTT1CHwkuwlUonvuXMP88pqCNA42qg8/A1DWA6ck8YAjtPlq23lxYLjlw+Brj5cBC2EtWAgou23XIxphrgNmjM5MoSIwlbJ5GJdP41fJ+1K4LAFrZ7L/TcsX3FHMNFn4WnrkAiNt3gMF/c8379gd07Q7/IOpH/EPfvwq3PY9lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671902; c=relaxed/simple;
	bh=IdcnNtVLwa1C6EJagzc3WNWO39fudveMCxFfLFcEgnA=;
	h=Date:To:From:Subject:Message-Id; b=Oi53fJfzMabOYrxZKmXOQgG17/2CNy+12i67VJqq8qiRe11aloBAm4UutSjIHCCGN4ZI50ZGPpN74O0sERJAvqFf6a0gfL+yfo4zIOTWNQJEQwVxdztYTk+vDfTgfUvvYK+gejb+UW2e6AifF12KvyTc02Tvbo/sxygqgnHlCBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ETkAGB9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ETkAGB9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8D4C4CEF7;
	Sat, 28 Mar 2026 04:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671902;
	bh=IdcnNtVLwa1C6EJagzc3WNWO39fudveMCxFfLFcEgnA=;
	h=Date:To:From:Subject:From;
	b=ETkAGB9/zKAzeMFEUyCwSY9trmKZQAe2jxLthelgdArbyfSHcE22zYlqFe1SS/Qxs
	 xBFPXmjZVn8GXNN3N+OyxYo2dWp02gsPOW7vlEfh8NpdIman8huUU4afABxcqJqHew
	 PEJSHOJD92ouqwtXh0sUKQM1uQRwXoL7r5bTSEIQ=
Date: Fri, 27 Mar 2026 21:25:01 -0700
To: mm-commits@vger.kernel.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch removed from -mm tree
Message-Id: <20260328042502.3D8D4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: glob: fix grammar and replace non-inclusive terminology
has been removed from the -mm tree.  Its filename was
     lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib: glob: fix grammar and replace non-inclusive terminology
Date: Sun, 1 Mar 2026 15:45:53 +0000

Fix a missing article ('a') in the comment describing the glob
implementation, and replace 'blacklists' with 'denylists' to align with
the kernel's inclusive terminology guidelines.

Link: https://lkml.kernel.org/r/20260301154553.2592681-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/glob.c~lib-glob-fix-grammar-and-replace-non-inclusive-terminology
+++ a/lib/glob.c
@@ -21,7 +21,7 @@ MODULE_LICENSE("Dual MIT/GPL");
  * Pattern metacharacters are ?, *, [ and \.
  * (And, inside character classes, !, - and ].)
  *
- * This is small and simple implementation intended for device blacklists
+ * This is a small and simple implementation intended for device denylists
  * where a string is matched against a number of patterns.  Thus, it
  * does not preprocess the patterns.  It is non-recursive, and run-time
  * is at most quadratic: strlen(@str)*strlen(@pat).
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch


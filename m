Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E450833557B
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671925; cv=none; b=QJDZHMyfIJ3l8IyluNqmnSG2DMsgkYLsY8lOhqTSTNr40hj3nUS7RsEXH1LnYZqndjEl2E75Jce+nbboIqkEaPa2eWKT6Drwz2ttTRCFpJebhwKNc58ItWlubDjQuMmSXWaavukxy0EEIJfCbR4VzRRPv18xiKJCXtMER10WPkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671925; c=relaxed/simple;
	bh=zwbKULw01jojEb0s5lGCW1WGUwb4Xu3lxY4BnhIE6Lc=;
	h=Date:To:From:Subject:Message-Id; b=Wg57uP3U6ZCX7CyFDMmlnx/3dTnvJB2V66z5+WaO+jC//thQAsfJLBxKwYpFnYZNR1HRWE/WJPOliwWUH7hXTaglQlpIlkhX+pvCqaDEW0MR/+71cAl52CsuY3XmGT8DYjwThLb3fRYeK5AOhFN+3sZMCBs8OsvH6xfqQ1NMg7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IXCsDmvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IXCsDmvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4A2C4CEF7;
	Sat, 28 Mar 2026 04:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671924;
	bh=zwbKULw01jojEb0s5lGCW1WGUwb4Xu3lxY4BnhIE6Lc=;
	h=Date:To:From:Subject:From;
	b=IXCsDmvEiyYIqrTyukeuCJinvU/fM5Pdq7hRvyDkdv+0TubkHz0PANpWWx9oC6nEB
	 utwol4sAJsKJBEGeBqCaJXT5LhOeu5ByRa0FZe2RfItOT4BIeTNc4WYJqLH1Y7PT9w
	 MyuMa2WJ5oUh/Zihq5/OZAtkSnq7hvhUy0cr6Zps=
Date: Fri, 27 Mar 2026 21:25:23 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch removed from -mm tree
Message-Id: <20260328042524.7B4A2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/inflate: fix memory leak in inflate_fixed() on inflate_codes() failure
has been removed from the -mm tree.  Its filename was
     lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/inflate: fix memory leak in inflate_fixed() on inflate_codes() failure
Date: Fri, 6 Mar 2026 16:16:12 +0000

When inflate_codes() fails in inflate_fixed(), only the length list 'l' is
freed, but the Huffman tables 'tl' and 'td' are leaked.  Add the missing
huft_free() calls on the error path.

Link: https://lkml.kernel.org/r/20260306161612.2811703-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/inflate.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/inflate.c~lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure
+++ a/lib/inflate.c
@@ -811,6 +811,8 @@ DEBG("<fix");
 
   /* decompress until an end-of-block code */
   if (inflate_codes(tl, td, bl, bd)) {
+    huft_free(tl);
+    huft_free(td);
     free(l);
     return 1;
   }
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch


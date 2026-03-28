Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F9A33557B
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671925; cv=none; b=KU+eOoZ10fc4jGLaoaZ+M/lp8GhCICOgNpoQ44SayRHkX5HoD75npM7CXER8KY1t+KAq539dUVZZU3jv2oOPMNKP9kma3lm5N1xoSj6/+1oQX/nmEfupbZ/9twJ9a3rLJOokaW4GsP5dy7pinWBAbDIf4vLDQimuY8sFmzl8z/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671925; c=relaxed/simple;
	bh=3N/EbqA+mAwZeoqCJp24ixMJR0NEwb1w08tHqIY1E48=;
	h=Date:To:From:Subject:Message-Id; b=XSsQ0GWS4mVemW1FiZyAwkvNBt23bwN5+EZwmxktB+K5gkZXqoFM8szhQbMtOk3z+EbL+3hh/OuE2fU/RVDFXUv2RBcCwUaqxyvZYc6vN0sgNza4o9Bmg/tbs1NGOQOTFS6eYChJCD19YScX4SMYoY9rWvOhg9cjtsLSpolDMGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1UJ+7jYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1UJ+7jYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD27C4CEF7;
	Sat, 28 Mar 2026 04:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671925;
	bh=3N/EbqA+mAwZeoqCJp24ixMJR0NEwb1w08tHqIY1E48=;
	h=Date:To:From:Subject:From;
	b=1UJ+7jYKzOiBUIy0xOVqQvpKx97+89YKu3MpY+hQatYEVTvDTIKB+1JO3Zrb9xnY6
	 duB/wWuydZzMod1om4ahnyr48LN88M/esQ1IsZ1A9eh7TU9KmPgI4p7mao2/RTnv3C
	 N77CIYneNbClHqKVKyDzWkUAiFnt3gWZp9co5f3A=
Date: Fri, 27 Mar 2026 21:25:25 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch removed from -mm tree
Message-Id: <20260328042525.AFD27C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/inflate: fix memory leak in inflate_dynamic() on inflate_codes() failure
has been removed from the -mm tree.  Its filename was
     lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/inflate: fix memory leak in inflate_dynamic() on inflate_codes() failure
Date: Fri, 6 Mar 2026 16:16:47 +0000

When inflate_codes() fails in inflate_dynamic(), the code jumps to the
'out' label which only frees 'll', leaking the Huffman tables 'tl' and
'td'.  Restructure the code so that the decoding tables are always freed
before reaching the 'out' label.

Link: https://lkml.kernel.org/r/20260306161647.2811874-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/inflate.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/lib/inflate.c~lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure
+++ a/lib/inflate.c
@@ -1009,10 +1009,10 @@ DEBG("dyn5d ");
 DEBG("dyn6 ");
 
   /* decompress until an end-of-block code */
-  if (inflate_codes(tl, td, bl, bd)) {
+  if (inflate_codes(tl, td, bl, bd))
     ret = 1;
-    goto out;
-  }
+  else
+    ret = 0;
 
 DEBG("dyn7 ");
 
@@ -1021,7 +1021,6 @@ DEBG("dyn7 ");
   huft_free(td);
 
   DEBG(">");
-  ret = 0;
 out:
   free(ll);
   return ret;
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch


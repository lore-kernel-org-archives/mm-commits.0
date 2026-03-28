Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784F822B584
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671930; cv=none; b=QVxP5eYCbgUyHXAmyidpE/CEYlWqEZ378br3qlPNNuh6w0TOkqKtnaLigihkUC9RvFJYr1YcGdegCIHh0nm0OTohgQ4dpzEOX+sVX9zEPSyDGCX5ksAvWcCz08D3oT2UpTl+QY7OMoAzjxL/KllONmuKZuXNOxIGse7jZggA+Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671930; c=relaxed/simple;
	bh=/oqxgwPaCBIklDaJt+CN/3dNzlpcr7BjeYuGnKVzzSY=;
	h=Date:To:From:Subject:Message-Id; b=Q6vzJhRJutGlnTZS38TtSt7nI1V70GvVVE0qFZc1TYw23WnY6XkuYUdPXj7DvCwgrEu5Z1wkeSgdeGoMjuIWslCUePXznsWTYD8UHK5IF0+FhYiLOJrcGfKbiZvtFAw3xxY1MYL0eScNWjLxw4h27Yyf8tv37zCo24Y9o2/5V+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YMOGpalS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YMOGpalS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515B4C4CEF7;
	Sat, 28 Mar 2026 04:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671930;
	bh=/oqxgwPaCBIklDaJt+CN/3dNzlpcr7BjeYuGnKVzzSY=;
	h=Date:To:From:Subject:From;
	b=YMOGpalSMVYYn39QA4YN9V80Wri5fQs2SG8+RH6+KGMAlwtvGIUkkAQHTc4zvt+sf
	 4rQ683XI+parS+bffckAQzj5Migf0+oZ6wOML+ziC7xzin75AI962azh+Va7kIygDT
	 av8kEEUfokQ0noIhn4wuGfrb4o2yPYy4rVP9SRHI=
Date: Fri, 27 Mar 2026 21:25:29 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch removed from -mm tree
Message-Id: <20260328042530.515B4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/inflate: fix typo "This results" to "The results" in comment
has been removed from the -mm tree.  Its filename was
     lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/inflate: fix typo "This results" to "The results" in comment
Date: Fri, 6 Mar 2026 16:17:32 +0000

Fix "This results of this trade" to "The results of this trade" in the
comment describing the lbits and dbits tuning parameters.

Link: https://lkml.kernel.org/r/20260306161732.2812132-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/inflate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/inflate.c~lib-inflate-fix-typo-this-results-to-the-results-in-comment
+++ a/lib/inflate.c
@@ -286,7 +286,7 @@ static void free(void *where)
    the longer codes.  The time it costs to decode the longer codes is
    then traded against the time it takes to make longer tables.
 
-   This results of this trade are in the variables lbits and dbits
+   The results of this trade are in the variables lbits and dbits
    below.  lbits is the number of bits the first level table for literal/
    length codes can decode in one step, and dbits is the same thing for
    the distance codes.  Subsequent tables are also less than or equal to
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch


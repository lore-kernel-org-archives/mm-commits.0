Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7B11A9FA8
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671952; cv=none; b=EbaqJ5S9YKC+rgqSzfOfshSI/JgTH38Qa3WRcc8H+93WN3xbpD38TXCD/esXet1ZtGj4say8Jeyigeb1YdM9y3CAnn5B22tkx25a1CkPqemjfzJohx0rgbHY9ZSRYpiXyuDSMz/40KmVT0RaxpJIi3Bm7FSGiikuYY2VsMv11Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671952; c=relaxed/simple;
	bh=UG/XpDSJyKdzhxfTZ6V9i3IJ4mGwbAVpNMyIGpsMieE=;
	h=Date:To:From:Subject:Message-Id; b=RsK5VTQ9wt3J1EXAA/Mm+Pcq/ARA4EK9YAHCfp2JoiOya7sIhh9yrOM061PX5iT8XnWlFjssT57z0s/rx0UyP7sXuf+pUO+HsMrnLAcGXkYjzYnA6LPTKUmjmLtsuJloPsSTuZ4/g/4B6xha5OfkJ0RlyrP9Iffhhr/dkqpwQF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M2TefTmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M2TefTmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B382EC4CEF7;
	Sat, 28 Mar 2026 04:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671952;
	bh=UG/XpDSJyKdzhxfTZ6V9i3IJ4mGwbAVpNMyIGpsMieE=;
	h=Date:To:From:Subject:From;
	b=M2TefTmO2rHIik5RSqwG789/USWqjs0yRV/o698es+MK4POS0UKPOvTg9P067gfAI
	 04YeCHXLJccS2AxSv/fdh0DQ49vlmhsFUTMaurrOd8N1HCnRncMcYCZmRPuHtqv7Oy
	 fyiwfp0o9aPmmhWEBej8RcKTLECtvCJtjFp/RPmM=
Date: Fri, 27 Mar 2026 21:25:52 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch removed from -mm tree
Message-Id: <20260328042552.B382EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/glob: initialize back_str to silence uninitialized variable warning
has been removed from the -mm tree.  Its filename was
     lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/glob: initialize back_str to silence uninitialized variable warning
Date: Thu, 12 Mar 2026 21:52:49 +0000

back_str is only used when back_pat is non-NULL, and both are always set
together, so it is safe in practice.  Initialize back_str to NULL to make
this safety invariant explicit and silence compiler/static analysis
warnings.

Link: https://lkml.kernel.org/r/20260312215249.50165-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/glob.c~lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning
+++ a/lib/glob.c
@@ -47,7 +47,7 @@ bool __pure glob_match(char const *pat,
 	 * (no exception for /), it can be easily proved that there's
 	 * never a need to backtrack multiple levels.
 	 */
-	char const *back_pat = NULL, *back_str;
+	char const *back_pat = NULL, *back_str = NULL;
 
 	/*
 	 * Loop over each token (character or class) in pat, matching
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch


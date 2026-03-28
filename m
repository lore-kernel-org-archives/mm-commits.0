Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1127F22B584
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671906; cv=none; b=FxHewIUN3r8rR5qzGQV3ydmEi27bYcwj4LW1VU3U59s2vqriY5i6yBqrgn76+o38y3SzfKT4DQcyocdFHTDPRTwDbwZKb1G+hKCF3ZuwKG1zi5piCeNxVjwHf/VfEiOALWSdluEsCTrWjTz5o+OqsRuCgHOj2q4wx1IipkZK95M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671906; c=relaxed/simple;
	bh=aonHKUrWp8YEDG9eNzyFvtlZN9MlAkzacVvoT48bRWY=;
	h=Date:To:From:Subject:Message-Id; b=N1dWjH1veEsOfJpT3HVZdF0dRi1zbVfkOhxtpE4gaHNQU1I6v16ORP8naygxcpD2aiP4Bqpe+SRMyXiR/u31IvSbLbuQuFdkHg5dMMnxt8fkh829WZU6PSE7NQy8jAlCmImia8ZOfSyRoqwnV7PfOUOUg/3RRLF0HZf8vK6RDVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2ME45P4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2ME45P4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6EBC4CEF7;
	Sat, 28 Mar 2026 04:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671906;
	bh=aonHKUrWp8YEDG9eNzyFvtlZN9MlAkzacVvoT48bRWY=;
	h=Date:To:From:Subject:From;
	b=2ME45P4PND59DOswL3Gd6qDPp9+StA5DVomDGvC2td1pO00AOjtrfzHbx6iQbqenv
	 Q0bNosBKLDqQHfCS4mazRmy8Xg1YzGhBLZsxuUUoAqkB9JUi0IsMYwPJAo/aQpTGu7
	 IPe5/wUGkyBkggmvFnDv7C3XebajJLY41cZkkP+M=
Date: Fri, 27 Mar 2026 21:25:05 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch removed from -mm tree
Message-Id: <20260328042505.DF6EBC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/glob: clean up "bool abuse" in pointer arithmetic
has been removed from the -mm tree.  Its filename was
     lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/glob: clean up "bool abuse" in pointer arithmetic
Date: Sun, 1 Mar 2026 20:38:45 +0000

Replace the implicit 'bool' to 'int' conversion with an explicit ternary
operator.  This makes the pointer arithmetic clearer and avoids relying on
boolean memory representation for logic flow.

Link: https://lkml.kernel.org/r/20260301203845.2617217-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/glob.c~lib-glob-clean-up-bool-abuse-in-pointer-arithmetic
+++ a/lib/glob.c
@@ -73,7 +73,7 @@ bool __pure glob_match(char const *pat,
 			if (c == '\0')	/* No possible match */
 				return false;
 			bool match = false, inverted = (*pat == '!');
-			char const *class = pat + inverted;
+			char const *class = inverted ? pat + 1 : pat;
 			unsigned char a = *class++;
 
 			/*
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch


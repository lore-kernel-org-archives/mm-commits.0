Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC582E2852
	for <mm-commits@vger.kernel.org>; Sun,  1 Mar 2026 19:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772393165; cv=none; b=nt1V5YqbZjgHUYgddzvyA2YkSdl4Eifv2/hpxWHGQyVkN3XsOA//trpzUb7cqoMTfSycZaLjGQHv8vE/99JzMPlm6Nm6en06ILqL8ca3BP4jZol0ddTkMuXJUe7a5/dngB0LfvAW86XgcfONjbGxDZJqHcXAOmm2Tn48L2KeZpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772393165; c=relaxed/simple;
	bh=qWAfYiq2Zp2nibbuthSH188+6SRT5HtqaONsR5aeEmQ=;
	h=Date:To:From:Subject:Message-Id; b=KjhO5cd4y+Y+ZZlFuAe/EUAcdShKG992rnz2dhiLX7uPcdcNIDc5AzSz3ZMm94jf61S8J/r5GmD1Adu/nYqjAaUSmCVC3CM2SVCfbpbOU5dZjQWzqzAPS6Og4TLe5k6xet1WVq5kLUgCKDGP35oETcBUGGnB7X2GNHkfpB5UVvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HBpXrf2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HBpXrf2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBF0C2BC86;
	Sun,  1 Mar 2026 19:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772393164;
	bh=qWAfYiq2Zp2nibbuthSH188+6SRT5HtqaONsR5aeEmQ=;
	h=Date:To:From:Subject:From;
	b=HBpXrf2RkGvXsZFdw9BM9tHL0GS0dDh5Mr6GZWBSOqmQBxDJAVa5nm9nZXfIr2Cpt
	 iJKGUyklB8AS8Xp2mZsDwNGdUc9NQN0A5+lkGirJ5oUqg3IdGRZ4M/eot1fEwbTJfJ
	 4YTW4NT3/vOr9FhzSafsJOrVjVtgPivFP71BmbvI=
Date: Sun, 01 Mar 2026 11:26:04 -0800
To: mm-commits@vger.kernel.org,objecting@objecting.org,akpm@linux-foundation.org,hlcj1234567@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch added to mm-nonmm-unstable branch
Message-Id: <20260301192604.9BBF0C2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: glob: replace bitwise OR with logical operation on boolean
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Josh Law <hlcj1234567@gmail.com>
Subject: lib: glob: replace bitwise OR with logical operation on boolean
Date: Sun, 1 Mar 2026 15:21:42 +0000

Using bitwise OR (|=) on a boolean variable is valid C, but replacing it
with a direct logical assignment makes the intent clearer and appeases
strict static analysis tools.

Link: https://lkml.kernel.org/r/20260301152143.2572137-2-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/glob.c~lib-glob-replace-bitwise-or-with-logical-operation-on-boolean
+++ a/lib/glob.c
@@ -96,7 +96,8 @@ bool __pure glob_match(char const *pat,
 					class += 2;
 					/* Any special action if a > b? */
 				}
-				match |= (a <= c && c <= b);
+				if (a <= c && c <= b)
+					match = true;
 			} while ((a = *class++) != ']');
 
 			if (match == inverted)
_

Patches currently in -mm which might be from hlcj1234567@gmail.com are

lib-glob-add-missing-spdx-license-identifier.patch
lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch
lib-glob-add-explicit-include-for-exporth.patch
lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch


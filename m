Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E811E520
	for <mm-commits@vger.kernel.org>; Thu, 18 Jul 2024 04:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721275924; cv=none; b=bI0tVr8EXkhPdd9WkWseqVjJo3qeuHIplXtnvwP51/0UqnClHXyLDEVjqLpNhQ3UnWjh8yXcVq26EVQG6wp9Yi7X3B6qMplslJSmyeMVhcbfpxFcOaFPTDm17DbWnEnKxL1BwNRSCkqjheZoIJqborM5fZgqp+1P9hL1/oFYM/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721275924; c=relaxed/simple;
	bh=7hkHI8x0jTL/yqB0Pinioih4pMb0tZ98FPS6IGmqYUA=;
	h=Date:To:From:Subject:Message-Id; b=Anl5Lb3k0HRFpG3R7Glt9f9MiHpbQUTWrrGROY5VUDShE51GRjx+VDAvgp+y4Mq6u+Tfk9ABsd9KVe/NjyHu46nPLVeUiJsPEArX/vnXqqZ5m2vLtUt53pns6CpqfAVFXKLVUBUYkep29S0enKAHuY5qsxMspV/qDDJzqiw6B0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=at+mPvQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="at+mPvQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEEAC116B1;
	Thu, 18 Jul 2024 04:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721275924;
	bh=7hkHI8x0jTL/yqB0Pinioih4pMb0tZ98FPS6IGmqYUA=;
	h=Date:To:From:Subject:From;
	b=at+mPvQB38OR6+drxut/N+dNRlKUvNzbR3FuIl/WH4e1yF7hZRiTughOEaVSLUo6r
	 MdW46CK7zaHNu3J5zz+bu5mBaJYK6Z0J0H6svdL6I1NG86w3IgAKvUucX+ZrofcCO6
	 rQlBi6R91Hr04NHn2YiJsQXqBNBdpxThcQXYhr2o=
Date: Wed, 17 Jul 2024 21:12:03 -0700
To: mm-commits@vger.kernel.org,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-scrub-ia64-from-poisonh.patch removed from -mm tree
Message-Id: <20240718041204.2DEEAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ia64: scrub ia64 from poison.h
has been removed from the -mm tree.  Its filename was
     ia64-scrub-ia64-from-poisonh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ia64: scrub ia64 from poison.h
Date: Mon, 15 Jul 2024 08:25:33 +0300

Link: https://lkml.kernel.org/r/c72e5467-06a8-4739-ae6a-7c84c96cad77@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/poison.h~ia64-scrub-ia64-from-poisonh
+++ a/include/linux/poison.h
@@ -52,12 +52,6 @@
 /********** arch/$ARCH/mm/init.c **********/
 #define POISON_FREE_INITMEM	0xcc
 
-/********** arch/ia64/hp/common/sba_iommu.c **********/
-/*
- * arch/ia64/hp/common/sba_iommu.c uses a 16-byte poison string with a
- * value of "SBAIOMMU POISON\0" for spill-over poisoning.
- */
-
 /********** fs/jbd/journal.c **********/
 #define JBD_POISON_FREE		0x5b
 #define JBD2_POISON_FREE	0x5c
_

Patches currently in -mm which might be from adobriyan@gmail.com are



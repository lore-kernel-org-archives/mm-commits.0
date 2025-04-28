Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DC726157B
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 09:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745832488; cv=none; b=RDwUNFhue16jdV6l4A7ylBmpgfE1VU///O92w37IriMnHtmqbPKop8DoqSAd31WKdqOGEAizxp+1rss2vunJR8QzBlHf+qZB2tdq+N/igqWeu2Uf9ep+7ZPTgqkcKgoH5uwck8opAns+BeFFp1pLc+zUw9UuCMj2ZTawmnDwG+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745832488; c=relaxed/simple;
	bh=s6nqjm/1yFe4etBjsK+x9sVZVW5Yc3+SvRGmlfM9ZHk=;
	h=Date:To:From:Subject:Message-Id; b=RmIn7D8TnvsQKZk8cPcushAGG/jDyOpBeKyWBecOdxCUhPjLmipJLyZMmfPLrfxCj9RUStUfovk8fdAprN9f0wodkcs8d2oa5wfg1yXoO8XX4meg+FGUwdmK0TJnISw8AS8vtGICAYiFuRe3uH2uKphuX1ABsrgA7R7PM5vrg1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LyJhKpKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LyJhKpKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796B0C4CEED;
	Mon, 28 Apr 2025 09:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745832487;
	bh=s6nqjm/1yFe4etBjsK+x9sVZVW5Yc3+SvRGmlfM9ZHk=;
	h=Date:To:From:Subject:From;
	b=LyJhKpKyITncNNJksMkXksmZr++YTHCjVeTqhcyC2x8YB+QBW2XOOveZnici1yEtU
	 Yim8NeX3MOWsimnii9ryhSfSjWyzJf+DHv1/sBdOzNAaf6os/8q7oANv9V4/hD6pJ6
	 goAbDC871rxX4IILRhkhej2WjGQRK8rtVQIIH7Pk=
Date: Mon, 28 Apr 2025 02:28:06 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,nphamcs@gmail.com,hannes@cmpxchg.org,david@redhat.com,igor.b@beldev.am,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zblock-avoid-failing-the-build.patch added to mm-new branch
Message-Id: <20250428092807.796B0C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zblock: avoid failing the build
has been added to the -mm mm-new branch.  Its filename is
     mm-zblock-avoid-failing-the-build.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zblock-avoid-failing-the-build.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Igor Belousov <igor.b@beldev.am>
Subject: mm/zblock: avoid failing the build
Date: Mon, 28 Apr 2025 08:57:27 +0200

Don't break the build for a PAGE_SIZE that is not fully supported,
just print out a warning in that case.

Link: https://lkml.kernel.org/r/20250428065727.57990-1-igor.b@beldev.am
Signed-off-by: Igor Belousov <igor.b@beldev.am>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zblock.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/zblock.h~mm-zblock-avoid-failing-the-build
+++ a/mm/zblock.h
@@ -21,7 +21,8 @@
 /* max 256 slots per block, max table size 64 */
 #define SLOT_BITS 8
 #else
-#error Unsupported PAGE_SIZE
+#warn This PAGE_SIZE is not quite supported yet
+#define SLOT_BITS 8
 #endif
 
 #define MAX_SLOTS (1 << SLOT_BITS)
@@ -101,7 +102,7 @@ static const struct block_desc block_des
 	{ SLOT_SIZE(10, 3), 10, 3 },
 	{ SLOT_SIZE(9, 3), 9, 3 },
 	{ SLOT_SIZE(4, 2), 4, 2 },
-#elif PAGE_SIZE == 0x4000
+#else
 	{ SLOT_SIZE(255, 0), 255, 0 },
 	{ SLOT_SIZE(185, 0), 185, 0 },
 	{ SLOT_SIZE(145, 0), 145, 0 },
_

Patches currently in -mm which might be from igor.b@beldev.am are

mm-zblock-add-debugfs.patch
mm-zblock-avoid-failing-the-build.patch


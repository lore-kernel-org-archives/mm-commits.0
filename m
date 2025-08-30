Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50D12741CD
	for <mm-commits@vger.kernel.org>; Sat, 30 Aug 2025 03:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756524537; cv=none; b=nooSVP78KP5zaRn1eP7ewbZGK6T0PUH33Pv4pUHmyzVnDr4v+eLcSwV4XnoDlCsm8weEw6WXy+bYSEV53vzlows4ldBTlkhidY8ztGKusRVXZ+1JEwBwoRFs1GIjO+O/Iz3SNes+0HpWe0xckKipV3mznTgIcdELz2RYW2nP+XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756524537; c=relaxed/simple;
	bh=6LpBYwRZ3T57FjiAK+Tcu9EDX7SGJNKuz/WiIOt9dUk=;
	h=Date:To:From:Subject:Message-Id; b=dn3C2h1G1WXE183DT0YI7AXxZLFrryghW1QQpRV6km6HGwRgFEqQPfJYLA88quPfmw2xH7lojaHOi4cPlmb4wZX+0cRkGW/hTsrvPhGXRNZh53TmpcpsYYj8DlqASvuSYQscgxtsPIPVL+E8CYG3YVkWyO6WuI9c0+E1H2BZRBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JuNdJpTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JuNdJpTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457BAC4CEF0;
	Sat, 30 Aug 2025 03:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756524537;
	bh=6LpBYwRZ3T57FjiAK+Tcu9EDX7SGJNKuz/WiIOt9dUk=;
	h=Date:To:From:Subject:From;
	b=JuNdJpTMmSNFuYdT3Yf+NmCZKGUvLzo6yf9A94HEny76jKMsjLfIzbq2rEKnXhVjU
	 fHpGeTXp6OLAYlYIU8+J/BYHA53Qd4SoxwtoDKD8R8u5PJ2pY1d7+RTaK1l9KY4uLj
	 zulOmlb0MXyPxXxRcVdmcQlLaix7yd+TMcaklZIc=
Date: Fri, 29 Aug 2025 20:28:56 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,sj@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zpdesc-minor-naming-and-comment-corrections.patch added to mm-new branch
Message-Id: <20250830032857.457BAC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zpdesc: minor naming and comment corrections
has been added to the -mm mm-new branch.  Its filename is
     mm-zpdesc-minor-naming-and-comment-corrections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zpdesc-minor-naming-and-comment-corrections.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zpdesc: minor naming and comment corrections
Date: Fri, 29 Aug 2025 17:15:28 +0100

zpdesc is the page descriptor used by the zsmalloc backend allocator,
which in turn is used by zswap and zram.  The zpool layer is gone.

Link: https://lkml.kernel.org/r/20250829162212.208258-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpdesc.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/zpdesc.h~mm-zpdesc-minor-naming-and-comment-corrections
+++ a/mm/zpdesc.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* zpdesc.h: zswap.zpool memory descriptor
+/* zpdesc.h: zsmalloc pool memory descriptor
  *
  * Written by Alex Shi <alexs@kernel.org>
  *	      Hyeonggon Yoo <42.hyeyoo@gmail.com>
@@ -11,14 +11,14 @@
 #include <linux/pagemap.h>
 
 /*
- * struct zpdesc -	Memory descriptor for zpool memory.
+ * struct zpdesc -	Memory descriptor for zsmalloc pool memory.
  * @flags:		Page flags, mostly unused by zsmalloc.
  * @lru:		Indirectly used by page migration.
  * @movable_ops:	Used by page migration.
- * @next:		Next zpdesc in a zspage in zsmalloc zpool.
- * @handle:		For huge zspage in zsmalloc zpool.
+ * @next:		Next zpdesc in a zspage in zsmalloc pool.
+ * @handle:		For huge zspage in zsmalloc pool.
  * @zspage:		Points to the zspage this zpdesc is a part of.
- * @first_obj_offset:	First object offset in zsmalloc zpool.
+ * @first_obj_offset:	First object offset in zsmalloc pool.
  * @_refcount:		The number of references to this zpdesc.
  *
  * This struct overlays struct page for now. Do not modify without a good
@@ -79,8 +79,8 @@ static_assert(sizeof(struct zpdesc) <= s
  * zpdesc_folio - The folio allocated for a zpdesc
  * @zp: The zpdesc.
  *
- * Zpdescs are descriptors for zpool memory. The zpool memory itself is
- * allocated as folios that contain the zpool objects, and zpdesc uses specific
+ * Zpdescs are descriptors for zsmalloc memory. The memory itself is allocated
+ * as folios that contain the zsmalloc objects, and zpdesc uses specific
  * fields in the first struct page of the folio - those fields are now accessed
  * by struct zpdesc.
  *
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-interact-directly-with-zsmalloc.patch
mm-remove-unused-zpool-layer.patch
mm-zpdesc-minor-naming-and-comment-corrections.patch


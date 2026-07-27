Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E1C3C3C10
	for <mm-commits@vger.kernel.org>; Mon, 27 Jul 2026 18:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785178762; cv=none; b=KaW1Dq0/RlnjHmmjuipMut41to+BUFHzUtg/0viGH1zh1lUge6tZ/nITbbzBMC71fSSscOIImdPw8miCr77xgVlaaB4ub7hvWeejq1egud0VVBF8fI59RBOqdj1EnGa4EX7WvBjEZKdzAWe8giUh6erL0NqE5IRcNH1blkz7wag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785178762; c=relaxed/simple;
	bh=FaqzGUnaR4URaGK3BFpPw3T1yy2DXKCJ8MDmGH7RZbI=;
	h=Date:To:From:Subject:Message-Id; b=T7BVUVokDdS0PK84foRX7Bu8NfRZ691pebsWQ0yBjGWYJgEqtykKZX0mKZSWnWv+t1CkNVKjhiB10vRVqKM2oHQ2N2WkGgKU7TnKpmOwLeg6q4JkcaY1BR5qDuycAqWOn/gjfJ0CffbFVdLK/f0uWv92vAU6QaLUsSMYzwUUUFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=buhAEn5I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="buhAEn5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05C71F000E9;
	Mon, 27 Jul 2026 18:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785178758;
	bh=4gWELzGDyHQsmRv3zR/ZS2AvzCzTsWzHAGdRSBaXw4k=;
	h=Date:To:From:Subject;
	b=buhAEn5I0S2N2tmoCh2gI6kaLFB3rAzACQBwcv/9D8oU55SwA7CUFl5LOBySV/SZ0
	 1cAWrbVJaliczufUFI/iv8jT+7yoZyiZZq/dMds/GCFyUESZ9xCjaWF5K+MSBXkuow
	 bQE0bw4tHHp6I/jY4TXBmjylCnJr3G1G2b+nxvcc=
Date: Mon, 27 Jul 2026 11:59:18 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,brendan.jackman@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode-fix.patch added to mm-unstable branch
Message-Id: <20260727185918.D05C71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: "Brendan Jackman" <brendan.jackman@linux.dev>
Subject: mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode-fix
Date: Sat, 25 Jul 2026 12:34:29 +0000

fix try_to_compact_pages() kerneldoc

Link: https://lore.kernel.org/DK7NM9RPUJOD.11PNJJ5N2OBED@linux.dev
Signed-off-by: "Brendan Jackman" <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode-fix
+++ a/mm/compaction.c
@@ -2823,7 +2823,7 @@ static enum compact_result compact_zone_
 /**
  * try_to_compact_pages - Direct compact to satisfy a high-order allocation
  * @gfp_mask: The GFP mask of the current allocation
- * @order: The order of the current allocation
+ * @order: The order to try to make available
  * @alloc_flags: The allocation flags of the current allocation
  * @ac: The context of current allocation
  * @prio: Determines how hard direct compaction should try to succeed
_

Patches currently in -mm which might be from brendan.jackman@linux.dev are

mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode-fix.patch


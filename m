Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9599A18E375
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925326; cv=none; b=fgi7lzzF8/SLvNNiksefARwHoyXCw+Idf2kuyAoUEOij4BRw/AHsjNOp/JeNzgZ9A3uBseGfGDXv0LLQE2X9s3EChFiGQyz3YVrvhFcevaEtwbKAkb5vZbOCrSwUob9UfIO17iXgEpOYntQrEUnK+U20wcBANrQFQq9AJxHUlUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925326; c=relaxed/simple;
	bh=JUxB8P4RAyBl0fy44XYiaPHq9wjXsa//sc+SZvnXxYI=;
	h=Date:To:From:Subject:Message-Id; b=osRtieDUW1Yw+SBiM1uR5udx1X4PABPR/dhUj8Nyu2lPWoli7lgk6gvBvxOrTHyumklhS/0WxmyCJtZfWRri+Hi8OPopnBLK7WyBksY5luXRvVZHRwqga/FKSpiu/mIBPjZUpMLJcKqFioaOHgBB5ldEuIu6sJeAu/99A6QcrYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=myrOi3NW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="myrOi3NW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9D9C4CEC5;
	Mon,  9 Sep 2024 23:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925326;
	bh=JUxB8P4RAyBl0fy44XYiaPHq9wjXsa//sc+SZvnXxYI=;
	h=Date:To:From:Subject:From;
	b=myrOi3NWP4eS0rRB0CkNhs9hkgZbhDY7dnOx8IcenSIihebqS/2N5knAbZhkjg8zn
	 AL6lbknPsbD7igePWz6OJjGCIWrRP4x0IUWsOqZv4uuXt/xZ/64PvRz9KPeALAVcVG
	 BgnOIZHYSri/mcwNETBbhZgfhFldoDZkEkL/VBQs=
Date: Mon, 09 Sep 2024 16:42:05 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,muchun.song@linux.dev,kent.overstreet@linux.dev,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-codetag-fix-a-typo.patch removed from -mm tree
Message-Id: <20240909234206.6C9D9C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/codetag: fix a typo
has been removed from the -mm tree.  Its filename was
     mm-codetag-fix-a-typo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/codetag: fix a typo
Date: Thu, 5 Sep 2024 22:21:06 -0600

Link: https://lkml.kernel.org/r/20240906042108.1150526-1-yuzhao@google.com
Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~mm-codetag-fix-a-typo
+++ a/include/linux/alloc_tag.h
@@ -70,7 +70,7 @@ static inline struct alloc_tag *ct_to_al
 /*
  * When percpu variables are required to be defined as weak, static percpu
  * variables can't be used inside a function (see comments for DECLARE_PER_CPU_SECTION).
- * Instead we will accound all module allocations to a single counter.
+ * Instead we will account all module allocations to a single counter.
  */
 DECLARE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
 
_

Patches currently in -mm which might be from yuzhao@google.com are



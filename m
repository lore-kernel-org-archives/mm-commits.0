Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262BE79B74
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 18:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146597; cv=none; b=MwEl6z+e1XGAXNGrDNWa3pvKu80DWwMzHsxg4l5U5t4WYPgcP9xLsSfAoHtbV5WW/dO0wLLXOccxwA30Evh5itHTMY+UgEwaA/dmecJyELxrvfj9joISFWtjZNZFHojsBmzIvh4ZiNXyQNNEo/ULX91KfdS5MTZEn2d0NCqvlHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146597; c=relaxed/simple;
	bh=5e/kbg058QQcBvhP9l+Cg3ae1J8a6JdkcP57me1u0/k=;
	h=Date:To:From:Subject:Message-Id; b=l9n4BCA3u292udoJ2jmsRbKRPmXLttreOMhhYqdjUG/hkVIsEj8F6xSuuixLJteEWCupDV+iu4LUMIyCJ+qjtQ1E8/zsJaELfL+SIYEnvw7FeEqbCD4szqeoqU0XQHjUJeZBau+v4UH75IijGex4Wm3Jl4jjpIMi7GlCk8rWS3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KW0oKx7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KW0oKx7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0387C433F1;
	Wed, 28 Feb 2024 18:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709146596;
	bh=5e/kbg058QQcBvhP9l+Cg3ae1J8a6JdkcP57me1u0/k=;
	h=Date:To:From:Subject:From;
	b=KW0oKx7pcrI9lem0kIOdydsEdDR9VcgfK/2pTFAu1XrLHVgKUP5hAkWIdu+fMkKy6
	 BCOBnwbjBhY2DjkVOXuCkU3UtJGzvrRZ0dBKZFRhYGBQ31hu8DKbt4uXUvEwRAqrHI
	 Z9hn/ep+BOkZzpxg+zDQXFnTEdAhXs8bBy41w9Ac=
Date: Wed, 28 Feb 2024 10:56:36 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-dont-need-to-reserve-lsb-in-handle.patch added to mm-unstable branch
Message-Id: <20240228185636.D0387C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: don't need to reserve LSB in handle
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-dont-need-to-reserve-lsb-in-handle.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-dont-need-to-reserve-lsb-in-handle.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/zsmalloc: don't need to reserve LSB in handle
Date: Wed, 28 Feb 2024 02:38:54 +0000

We will save allocated tag in the object header to indicate that it's
allocated.

	handle |= OBJ_ALLOCATED_TAG;

So the object header needs to reserve LSB for this tag bit.

But the handle itself doesn't need to reserve LSB to save tag, since it's
only used to find the position of object, by (pfn + obj_idx).  So remove
LSB reserve from handle, one more bit can be used as obj_idx.

Link: https://lkml.kernel.org/r/20240228023854.3511239-1-chengming.zhou@linux.dev
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-dont-need-to-reserve-lsb-in-handle
+++ a/mm/zsmalloc.c
@@ -110,7 +110,7 @@
 #define OBJ_TAG_BITS	1
 #define OBJ_TAG_MASK	OBJ_ALLOCATED_TAG
 
-#define OBJ_INDEX_BITS	(BITS_PER_LONG - _PFN_BITS - OBJ_TAG_BITS)
+#define OBJ_INDEX_BITS	(BITS_PER_LONG - _PFN_BITS)
 #define OBJ_INDEX_MASK	((_AC(1, UL) << OBJ_INDEX_BITS) - 1)
 
 #define HUGE_BITS	1
@@ -737,14 +737,12 @@ static struct page *get_next_page(struct
 static void obj_to_location(unsigned long obj, struct page **page,
 				unsigned int *obj_idx)
 {
-	obj >>= OBJ_TAG_BITS;
 	*page = pfn_to_page(obj >> OBJ_INDEX_BITS);
 	*obj_idx = (obj & OBJ_INDEX_MASK);
 }
 
 static void obj_to_page(unsigned long obj, struct page **page)
 {
-	obj >>= OBJ_TAG_BITS;
 	*page = pfn_to_page(obj >> OBJ_INDEX_BITS);
 }
 
@@ -759,7 +757,6 @@ static unsigned long location_to_obj(str
 
 	obj = page_to_pfn(page) << OBJ_INDEX_BITS;
 	obj |= obj_idx & OBJ_INDEX_MASK;
-	obj <<= OBJ_TAG_BITS;
 
 	return obj;
 }
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are

mm-zswap-change-zswap_pool-kref-to-percpu_ref-fix.patch
mm-zsmalloc-dont-need-to-reserve-lsb-in-handle.patch


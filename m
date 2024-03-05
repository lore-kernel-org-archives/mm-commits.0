Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7660412B6C
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600586; cv=none; b=TTlC+FOz1RxQgZZTMDQezoth+DI2uCnj6iRdTZKXIhZzdBpRNh6ISbigH0AYaA9ff7U2v8cH0XEGpVMo5iy1HRBD+YgKaGhdO5Vr1Db+vStnwXIdDdanUoC1bPR7HqUJ8jfQ0anA5gk4Dj2iONDX79QdwXgQj15zm+Kr2mRIvqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600586; c=relaxed/simple;
	bh=Dx54D2yJXAd27CBvE7xRiD2rqyUsyzB97QYyOWdA/n8=;
	h=Date:To:From:Subject:Message-Id; b=ejDmIxB7D/CIkoL6V2Rr5dxBtzs007f8koIjzR2JtHSv3YKX1t5rOianqNmWttgSXpXi/W2eaxmFdLTdbaYv3dueTF//xH/YlxCapdjxyEmZyZCAVOuNPF9u9HcTyYtWB0IfpbLyL1HjiGhmnRyi3q2ebcvUf4qBvXtqPle92Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZKvEZukU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZKvEZukU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42945C433C7;
	Tue,  5 Mar 2024 01:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600586;
	bh=Dx54D2yJXAd27CBvE7xRiD2rqyUsyzB97QYyOWdA/n8=;
	h=Date:To:From:Subject:From;
	b=ZKvEZukUdvpN8f4MloszRgihIjiGKvqWYNC6rwFCQjQv9PJEmPHTaQuOXImeCiq4k
	 Uolnt3DNvE/W711FCNq6V6w8X6+w9BW6GnqfIEd6wE/VdxhREMZlEu+cMCfd/x2eJu
	 DvP1yqIe5VZsyrMtSwgYu5+pyDNoYx1egAdKQGZ8=
Date: Mon, 04 Mar 2024 17:03:05 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-dont-need-to-reserve-lsb-in-handle.patch removed from -mm tree
Message-Id: <20240305010306.42945C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: don't need to reserve LSB in handle
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-dont-need-to-reserve-lsb-in-handle.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



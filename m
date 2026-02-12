Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67232857CF
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939990; cv=none; b=W4OLxOAIrryAis46gzj8chd4gCGhLR7BjGT6O/IzHQyHeuKqgCF6AEwcN/LGpOL5fPS7+TwQ5d68pR2P8PL5u9DY0WnBEz4jLXy9GpLPqZAxBtwo9/72xyUkyIjnckkDoF2pmoaTK8RzHQTYE5SJCbNNC8Eiks01KhOCcQV8LHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939990; c=relaxed/simple;
	bh=0zShU7P4RiTS1/F9ssQbszha19eWI99Zrxr1fEgqHFU=;
	h=Date:To:From:Subject:Message-Id; b=k93D0AWdoo7tB2DL3Y/XZDf0eQGwJqhkj3vSpD+yky2DGvlHf8xSRyrbJOt5C7F0a4bHssgZScGgrrAFY7Nov3E6M1DeavpEjJpT1c+tScmkUKIVPXYD+fDxySltyE7Ja0nETL5xd1wFeu8fGTa5n5VIYKagR9/mbkzvcRLoEmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fcqh62uY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fcqh62uY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F9EC4CEF7;
	Thu, 12 Feb 2026 23:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939990;
	bh=0zShU7P4RiTS1/F9ssQbszha19eWI99Zrxr1fEgqHFU=;
	h=Date:To:From:Subject:From;
	b=fcqh62uYX966TCl7nVqXdVEynMzXJWhuy+xVdmIhUxACP18dptsSHjJgaBRyoEZIx
	 kt5KPkaQNQyBFVqntbG/L8AsFRFLoiSEj6Bi6NpdTyMGK85SYzS9Glm9tRq1uprKPS
	 0CFlVIxiLuIpQmILKXXiMehbYMFY3yN5GUUPHq9o=
Date: Thu, 12 Feb 2026 15:46:29 -0800
To: mm-commits@vger.kernel.org,wuqiang.matt@bytedance.com,mhiramat@kernel.org,akpm@linux-foundation.org,zhouwenhao7600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] objpool-fix-the-overestimation-of-object-pooling-metadata-size.patch removed from -mm tree
Message-Id: <20260212234630.60F9EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: objpool: fix the overestimation of object pooling metadata size
has been removed from the -mm tree.  Its filename was
     objpool-fix-the-overestimation-of-object-pooling-metadata-size.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhouwenhao <zhouwenhao7600@gmail.com>
Subject: objpool: fix the overestimation of object pooling metadata size
Date: Mon, 2 Feb 2026 21:28:46 +0800

objpool uses struct objpool_head to store metadata information, and its
cpu_slots member points to an array of pointers that store the addresses
of the percpu ring arrays.  However, the memory size allocated during the
initialization of cpu_slots is nr_cpu_ids * sizeof(struct objpool_slot). 
On a 64-bit machine, the size of struct objpool_slot is 16 bytes, which is
twice the size of the actual pointer required, and the extra memory is
never be used, resulting in a waste of memory.  Therefore, the memory size
required for cpu_slots needs to be corrected.

Link: https://lkml.kernel.org/r/20260202132846.68257-1-zhouwenhao7600@gmail.com
Fixes: b4edb8d2d464 ("lib: objpool added: ring-array based lockless MPMC")
Signed-off-by: zhouwenhao <zhouwenhao7600@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matt Wu <wuqiang.matt@bytedance.com>
Cc: wuqiang.matt <wuqiang.matt@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/objpool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/objpool.c~objpool-fix-the-overestimation-of-object-pooling-metadata-size
+++ a/lib/objpool.c
@@ -142,7 +142,7 @@ int objpool_init(struct objpool_head *po
 	pool->gfp = gfp & ~__GFP_ZERO;
 	pool->context = context;
 	pool->release = release;
-	slot_size = nr_cpu_ids * sizeof(struct objpool_slot);
+	slot_size = nr_cpu_ids * sizeof(struct objpool_slot *);
 	pool->cpu_slots = kzalloc(slot_size, pool->gfp);
 	if (!pool->cpu_slots)
 		return -ENOMEM;
_

Patches currently in -mm which might be from zhouwenhao7600@gmail.com are



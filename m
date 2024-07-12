Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFBC1CF96
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824854; cv=none; b=Re+dFuq2C1MpEzz8BMEdeBiqqY9CcuspyG/mHuIMA3Neypxs/y1VSttm+PX/PzmW6zoUhjAPJC1qbN/iJpV6//LbyVakiKxf+8q/gRBGDN9smzdDnsBX3/64gTjEJ31rjQ56DOYwlYlej77v6JzTBacLEN9h3KgZtvin32jK8b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824854; c=relaxed/simple;
	bh=rnnEdN1kbSSMVMInWyvo3R80wkEKk+JLbT5q+0JB+sI=;
	h=Date:To:From:Subject:Message-Id; b=CAxCZNkJmTQluuF9AY5BvlKWY0NduZeEcygpFwJNqsfYxAgS03UbHkEE6ryeJkpLyRSpGmBxj3JA7C+v8q1w9RiaH5XZsWSW6aWlOExhjnuUVgneoGzW4QCG9VbsFNuwo5xkPaf3fAf4QcZgOkef/OdNnHC3w7d9nnxuOlSWHPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I927Eq2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I927Eq2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E47C32782;
	Fri, 12 Jul 2024 22:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824854;
	bh=rnnEdN1kbSSMVMInWyvo3R80wkEKk+JLbT5q+0JB+sI=;
	h=Date:To:From:Subject:From;
	b=I927Eq2niJv6J5ML3R6oYD607v2RJJLjm/Vbir5+VnZFgulf2wP2EWEmT2Ichb84i
	 UXdNXh9Ispmp/NeHXrZYJem4fYYL1ghzkdp5YYP+9D88FBhJSnNRd9wmOvWi6INWY0
	 imj4w4XGI1HKeG8f59sCmK9xZ5WJoq55DIwnqiA0=
Date: Fri, 12 Jul 2024 15:54:14 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-fix-class-per-fullness-zspage-counts.patch removed from -mm tree
Message-Id: <20240712225414.90E47C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: clarify class per-fullness zspage counts
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-fix-class-per-fullness-zspage-counts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/zsmalloc: clarify class per-fullness zspage counts
Date: Thu, 27 Jun 2024 15:59:58 +0800

We always use insert_zspage() and remove_zspage() to update zspage's
fullness location, which will account correctly.

But this special async free path use "splice" instead of remove_zspage(),
so the per-fullness zspage count for ZS_INUSE_RATIO_0 won't decrease.

Clean things up by decreasing when iterate over the zspage free list.

This doesn't actually fix anything.  ZS_INUSE_RATIO_0 is just a
"placeholder" which is never used anywhere.

Link: https://lkml.kernel.org/r/20240627075959.611783-1-chengming.zhou@linux.dev
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zsmalloc.c~mm-zsmalloc-fix-class-per-fullness-zspage-counts
+++ a/mm/zsmalloc.c
@@ -1883,6 +1883,7 @@ static void async_free_zspage(struct wor
 
 		class = zspage_class(pool, zspage);
 		spin_lock(&class->lock);
+		class_stat_dec(class, ZS_INUSE_RATIO_0, 1);
 		__free_zspage(pool, class, zspage);
 		spin_unlock(&class->lock);
 	}
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are



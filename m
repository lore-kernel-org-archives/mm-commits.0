Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CD260BA8
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 17:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707932139; cv=none; b=c4GkHSs2tnkuMtENGg33RqeWXOTy8+GCFsmY3EVIoTAUWepmlNhkZPzwPErgdtkhzRpWR3SPG9j9mHc1mC/PTWUOl2wUknu1RL3K8R2sWVmhMoeBNpG7PieauRsRQYY0LWxE0Fbq4a/v+Wj3kjMMqwYD4FYxlTwkm2nBp4a7ftc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707932139; c=relaxed/simple;
	bh=NnVdBZv34dSgNh/j5I6Kz5CiiDfXM1zOg4xuykvN+kE=;
	h=Date:To:From:Subject:Message-Id; b=t85WOHxuaRRBkALtk8kGvBCEDcRRjke6aHdJVqSnQ5LH1OO4wKeaZ4BW5oawQ7KgDuYxH+4MnTMyn19H/r0lLYeajN0PfcRYGmxnpV5V+YvdQ2UEN2mM+LiLl0C7LSyO9wetwBokLkRf3jRzj1bqzFtS7VNtuxUQBqJ69Ovlxks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XhZoQUSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XhZoQUSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED70C433C7;
	Wed, 14 Feb 2024 17:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707932138;
	bh=NnVdBZv34dSgNh/j5I6Kz5CiiDfXM1zOg4xuykvN+kE=;
	h=Date:To:From:Subject:From;
	b=XhZoQUSchzai7l7QEk9gidHlaaJSKhgYq90ramqsdHZP7Q84QnzS6RnR56cojh89Y
	 k+VY715CvDrUzyPJQVMeAgPcvWA04zg7GHhY+0zjM0vQvW0fbLW1kUNwBQEzfBPMfI
	 xG6262eU62S81MtlGios/t7neNNxQbKsa5Iw6da4=
Date: Wed, 14 Feb 2024 09:35:38 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-allocate-physically-contiguous-strm-buffers.patch added to mm-unstable branch
Message-Id: <20240214173538.BED70C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not allocate physically contiguous strm buffers
has been added to the -mm mm-unstable branch.  Its filename is
     zram-do-not-allocate-physically-contiguous-strm-buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-allocate-physically-contiguous-strm-buffers.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: zram: do not allocate physically contiguous strm buffers
Date: Tue, 13 Feb 2024 19:54:00 +1300

Currently zram allocates 2 physically contiguous pages per-CPU's
compression stream (we may have up to 4 streams per-CPU).  Since those
buffers are per-CPU we allocate them from CPU hotplug path, which may have
higher risks of failed allocations on devices with fragmented memory.

Switch to virtually contiguous allocations - crypto comp does not seem
impose requirements on compression working buffers to be physically
contiguous.

Link: https://lkml.kernel.org/r/20240213065400.6561-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zcomp.c~zram-do-not-allocate-physically-contiguous-strm-buffers
+++ a/drivers/block/zram/zcomp.c
@@ -11,6 +11,7 @@
 #include <linux/sched.h>
 #include <linux/cpu.h>
 #include <linux/crypto.h>
+#include <linux/vmalloc.h>
 
 #include "zcomp.h"
 
@@ -37,7 +38,7 @@ static void zcomp_strm_free(struct zcomp
 {
 	if (!IS_ERR_OR_NULL(zstrm->tfm))
 		crypto_free_comp(zstrm->tfm);
-	free_pages((unsigned long)zstrm->buffer, 1);
+	vfree(zstrm->buffer);
 	zstrm->tfm = NULL;
 	zstrm->buffer = NULL;
 }
@@ -53,7 +54,7 @@ static int zcomp_strm_init(struct zcomp_
 	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
 	 * case when compressed size is larger than the original one
 	 */
-	zstrm->buffer = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
+	zstrm->buffer = vzalloc(2 * PAGE_SIZE);
 	if (IS_ERR_OR_NULL(zstrm->tfm) || !zstrm->buffer) {
 		zcomp_strm_free(zstrm);
 		return -ENOMEM;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

zram-do-not-allocate-physically-contiguous-strm-buffers.patch


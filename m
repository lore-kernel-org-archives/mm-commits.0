Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2B734676F
	for <mm-commits@vger.kernel.org>; Wed,  8 Apr 2026 01:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775612782; cv=none; b=cVXquxJNU30Fqce/h22L8r/fYN2zBJ5NHOcELSd2tcMP6+7ZpjdhLoW15lgBqRdwyFadApUJqzJebjLzy8gcKBVSYIGeCqe7vviavh5UDcmWWK5yJhQFy/5RHs4UN9mDR6Eg/V0v2gkpMvFuYU+0GMz8abgrQBSj/5OWlAtJMDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775612782; c=relaxed/simple;
	bh=rTlcN8b2fcVGM4NG3AElZDPXtZ/Hh7CF/JiXJ9wAKmA=;
	h=Date:To:From:Subject:Message-Id; b=qtbE5fE6bPYH1xBgHrowYb3QFFQaLDjrGj/aVIFDy0mige/dWdWYeq4MVaL9XpT5d4+kpcVGu9TXBM6WGQwW7uKJX+DKXj52gwLdXmqXsdj6+46OjGxfOQBCmrKirlZhr+zMRmIeMQ2fFs8ogw+zZNtXvzUQqn7+c5H+q4dnQXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hMZHvUPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hMZHvUPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6644BC19421;
	Wed,  8 Apr 2026 01:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775612782;
	bh=rTlcN8b2fcVGM4NG3AElZDPXtZ/Hh7CF/JiXJ9wAKmA=;
	h=Date:To:From:Subject:From;
	b=hMZHvUPfB6OqDl7UfzOTIS03bwg4/RG4VZju7zS1W9eEA/wPrM5386oL1fIlPeqPD
	 J0QRcmEVbDdXC19ut2WfO8354IEEJD5x43nER9M9LqO09hhFOLM7lV/WMai/ccKz5l
	 MWc11m75zHPR23U5m8U6oZU+6cmLA4QsoYi9iWvA=
Date: Tue, 07 Apr 2026 18:46:21 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,astellman@stellman-greene.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-reject-unrecognized-type=-values-in-recompress_store.patch added to mm-unstable branch
Message-Id: <20260408014622.6644BC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: reject unrecognized type= values in recompress_store()
has been added to the -mm mm-unstable branch.  Its filename is
     zram-reject-unrecognized-type=-values-in-recompress_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-reject-unrecognized-type=-values-in-recompress_store.patch

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
From: Andrew Stellman <astellman@stellman-greene.com>
Subject: zram: reject unrecognized type= values in recompress_store()
Date: Tue, 7 Apr 2026 11:30:27 -0400

recompress_store() parses the type= parameter with three if statements
checking for "idle", "huge", and "huge_idle".  An unrecognized value
silently falls through with mode left at 0, causing the recompression pass
to run with no slot filter — processing all slots instead of the
intended subset.

Add a !mode check after the type parsing block to return -EINVAL for
unrecognized values, consistent with the function's other parameter
validation.

Link: https://lkml.kernel.org/r/20260407153027.42425-1-astellman@stellman-greene.com
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-reject-unrecognized-type=-values-in-recompress_store
+++ a/drivers/block/zram/zram_drv.c
@@ -2546,6 +2546,8 @@ static ssize_t recompress_store(struct d
 				mode = RECOMPRESS_HUGE;
 			if (!strcmp(val, "huge_idle"))
 				mode = RECOMPRESS_IDLE | RECOMPRESS_HUGE;
+			if (!mode)
+				return -EINVAL;
 			continue;
 		}
 
_

Patches currently in -mm which might be from astellman@stellman-greene.com are

zram-reject-unrecognized-type=-values-in-recompress_store.patch


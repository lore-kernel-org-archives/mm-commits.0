Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2844C14B959
	for <mm-commits@vger.kernel.org>; Wed, 15 Jan 2025 23:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736983724; cv=none; b=l5o8dqXvDbPKbPJZzY4qaFxU0HmmZ6L+c15ivNFD5b55nu1mJ9Cc6ZDzdZ0Q5JKX99F8Go93Wu6WMjyZ4tJsgfTGDgj0RLN8oRJAudQiZAscJcyfXGQD8X/+Vm/IS/Oxxw/5XzkFCuN6kt79n+RdiVd4ZWEoywc58N0boIdu5SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736983724; c=relaxed/simple;
	bh=vlfUy8x9466rr0AFmbYQarMx8dwPfnAahuI8XgJgaDg=;
	h=Date:To:From:Subject:Message-Id; b=YSQ5wB+vajPypBXhcvPEQ5GMk6ZHierAqHxOtavmJVeEoYnnKo6iP/R87dcxpOFRqnYvvQx+7ScUapeP/3RS523KdUKMnqC9TWwIlEXVO1FE5hLn0z/3dFYOjpGV/mNwNxvQ82BvK6B+uaa90haoVQiGTpwo+hwZpFp5EPY5HHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tXrF83Pr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tXrF83Pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98030C4CEE1;
	Wed, 15 Jan 2025 23:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736983723;
	bh=vlfUy8x9466rr0AFmbYQarMx8dwPfnAahuI8XgJgaDg=;
	h=Date:To:From:Subject:From;
	b=tXrF83PrbpkwDvH2BtHIex7G915MAqba0S8UvYZM/dFt0kMk/+LbUdTVOYUDMsXVq
	 nkB0st5kP17fOsIlDFQ5Y9JolMryw1ehIbJL5zeW6G59BIYWBqA/jG9BBwxFwylfFg
	 jthjxncv8C9GwSqGU328nOgal68j2NwcbXFZuep8=
Date: Wed, 15 Jan 2025 15:28:42 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-zcomp_stream_put-from-write_incompressible_page.patch added to mm-unstable branch
Message-Id: <20250115232843.98030C4CEE1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: remove zcomp_stream_put() from write_incompressible_page()
has been added to the -mm mm-unstable branch.  Its filename is
     zram-remove-zcomp_stream_put-from-write_incompressible_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-zcomp_stream_put-from-write_incompressible_page.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: remove zcomp_stream_put() from write_incompressible_page()
Date: Wed, 15 Jan 2025 16:19:16 +0900

We cannot and should not put per-CPU compression stream in
write_incompressible_page() because that function never gets any
per-CPU streams in the first place.  It's zram_write_page() that
puts the stream before it calls write_incompressible_page().

Link: https://lkml.kernel.org/r/20250115072003.380567-1-senozhatsky@chromium.org
Fixes: 485d11509d6d ("zram: factor out ZRAM_HUGE write")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-zcomp_stream_put-from-write_incompressible_page
+++ a/drivers/block/zram/zram_drv.c
@@ -1683,7 +1683,6 @@ static int write_incompressible_page(str
 		return PTR_ERR((void *)handle);
 
 	if (!zram_can_store_page(zram)) {
-		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 		zs_free(zram->mem_pool, handle);
 		return -ENOMEM;
 	}
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-remove-zcomp_stream_put-from-write_incompressible_page.patch


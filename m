Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAB939732C
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 20:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779825823; cv=none; b=kAMgZu1gNnBPhfN4dOGvamNn3Yt7lJfmoU2AbnOOjFRDY6XmPIgifO5pRCBy3HQMkimJD0b8jWyGA3s7IdfjcVXexfnbXPuds8oKlY1yCceHFWOcgE83OxanR1epTf4Exm45h6Tbt/ylyJ0bWeVAzO8E9Bqgc9FjMDYguAAYS8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779825823; c=relaxed/simple;
	bh=u27+7IHg6zyDpTEubIG9pJdzpBGFSax6B9KlahBSiV4=;
	h=Date:To:From:Subject:Message-Id; b=lEa/LEPnBMYXbkML7P9VJhCllOMIplvC/YJpT2/iuqqTXPr0u49NtXtglQA19eGAaMDPx3owdk5DHRKtQZWJPXpvgziqfhVe1hPSvVUDgjXqDlkVJVEUql35BSGxAAiN8v6epXeG/ebvHJQtGRzKdomfVzofvvNFVtP1IgDsYPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wuLjZz+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wuLjZz+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5301F00A3A;
	Tue, 26 May 2026 20:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779825821;
	bh=MwvVSZh7Ui/AVUcEIN/izygRdhKZm9t+a0CsKUc55Uc=;
	h=Date:To:From:Subject;
	b=wuLjZz+5fcUJWDIpUbMXaFskxUqyF77xi9+hC+43rIZmQSFj2/QJVZ6+27hAkEC+J
	 n9scVM1cn4NVVHZ7vNA4N8AOxSABa7Erx90IBkyA286Xs0XPjaWKi5HQ9mGT6TOi0D
	 lDA1+KnfpnyqwQzBaSS8na/aHs41FUB9w1nDQ40Y=
Date: Tue, 26 May 2026 13:03:41 -0700
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-clear-trailing-bytes-of-compressed-writeback-pages.patch added to mm-new branch
Message-Id: <20260526200341.BF5301F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: clear trailing bytes of compressed writeback pages
has been added to the -mm mm-new branch.  Its filename is
     zram-clear-trailing-bytes-of-compressed-writeback-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-clear-trailing-bytes-of-compressed-writeback-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: clear trailing bytes of compressed writeback pages
Date: Tue, 26 May 2026 11:27:17 +0900

Patch series "zram: writeback fixes", v2.

Brian (privately) reported a "leak" of writeback bitmap in certain cases,
so that backing device can store less pages; and a theoretical data leak
in the trailing bytes of compressed writeback pages.  Both issues are low
risk.


This patch (of 2):

When compressed writeback is available writtenback pages contain "garbage"
in PAGE_SIZE - obj_size trailing bytes.  That "garbage" is, basically,
whatever data that page held before we got it for writeback.  To get
advantage of it an attacker needs to be able to read from active backing
swap device, which is already catastrophic.  Still, just in case, zero out
those trailing bytes before writeback to a backing device so that we only
store swap-ed out data there.

Link: https://lore.kernel.org/20260526022754.2377730-1-senozhatsky@chromium.org
Link: https://lore.kernel.org/20260526022754.2377730-3-senozhatsky@chromium.org
Fixes: d38fab605c66 ("zram: introduce compressed data writeback")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-clear-trailing-bytes-of-compressed-writeback-pages
+++ a/drivers/block/zram/zram_drv.c
@@ -2134,6 +2134,8 @@ static int read_from_zspool_raw(struct z
 	zs_obj_read_end(zram->mem_pool, handle, size, src);
 	zcomp_stream_put(zstrm);
 
+	memzero_page(page, size, PAGE_SIZE - size);
+
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-do-not-leak-blk-idx-at-the-end-of-writeback.patch
zram-clear-trailing-bytes-of-compressed-writeback-pages.patch


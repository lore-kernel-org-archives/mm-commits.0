Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32C11A680C;
	Wed,  1 Apr 2026 00:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775004725; cv=none; b=A69vYRQiMsMeo+r5Rfu/ArZcUhwYFETzYYKYtMUZrIgkQ+6a7qJsBrV3ZTxGH0UMiH5mILCywWIB0YSOBm+cayAtow/EQmJO1M4BrqGFUk+Lw5iLwZqkOxG2Zspjb2kOmGAImDUygHsMqmmPhDilupedUnmxdO8E7Y2gJI8A3qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775004725; c=relaxed/simple;
	bh=vUrluuoZRhSYpBLjGbEn4sx2TK3GqyhqGROHhUsZQic=;
	h=Date:To:From:Subject:Message-Id; b=PxL9CK6XolKw5Ynk9xWv44ZyRQe8UGJ2AKPZlY6hyc8txkx14m+eCNAvDj0qHQpJuqqhvchpwuiEv5Wk1UR06BFI1IFB+eTg4pnTQSTRVLAPlnhRdqGpl8RU5WcfNDDVSIhVeOd0KQZbQvDjGbbhXHYSO2eWswB80gwY0LdHBwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L9TjWXa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L9TjWXa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C81BC19423;
	Wed,  1 Apr 2026 00:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775004725;
	bh=vUrluuoZRhSYpBLjGbEn4sx2TK3GqyhqGROHhUsZQic=;
	h=Date:To:From:Subject:From;
	b=L9TjWXa1Wx3E3uXBvs4LQnvmws2JfnmOi4YMBlhHJUJL8VyPMt8nkujBJ1yvbOFIX
	 TfEBfu2js9kc9UcI8iyE/1wognBxb2udFt4JmtUGrJZswx0SlWrLISawNJAuRXUO/F
	 au92Y7CDusJCRq1oAA5pEGday1J0wxvDMvNRdwRU=
Date: Tue, 31 Mar 2026 17:52:04 -0700
To: mm-commits@vger.kernel.org,wqu@suse.com,stable@vger.kernel.org,minchan@kernel.org,hch@lst.de,bgeffon@google.com,axboe@kernel.dk,avinesh.kumar@suse.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-forget-to-endio-for-partial-discard-requests.patch added to mm-new branch
Message-Id: <20260401005205.5C81BC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not forget to endio for partial discard requests
has been added to the -mm mm-new branch.  Its filename is
     zram-do-not-forget-to-endio-for-partial-discard-requests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-forget-to-endio-for-partial-discard-requests.patch

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
Subject: zram: do not forget to endio for partial discard requests
Date: Tue, 31 Mar 2026 16:42:44 +0900

As reported by Qu Wenruo and Avinesh Kumar, the following

 getconf PAGESIZE
 65536
 blkdiscard -p 4k /dev/zram0

takes literally forever to complete.  zram doesn't support partial
discards and just returns immediately w/o doing any discard work in such
cases.  The problem is that we forget to endio on our way out, so
blkdiscard sleeps forever in submit_bio_wait().  Fix this by jumping to
end_bio label, which does bio_endio().

Link: https://lkml.kernel.org/r/20260331074255.777019-1-senozhatsky@chromium.org
Fixes: 0120dd6e4e202 ("zram: make zram_bio_discard more self-contained")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Qu Wenruo <wqu@suse.com>
Closes: https://lore.kernel.org/linux-block/92361cd3-fb8b-482e-bc89-15ff1acb9a59@suse.com
Tested-by: Qu Wenruo <wqu@suse.com>
Reported-by: Avinesh Kumar <avinesh.kumar@suse.com>
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1256530
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-forget-to-endio-for-partial-discard-requests
+++ a/drivers/block/zram/zram_drv.c
@@ -2678,7 +2678,7 @@ static void zram_bio_discard(struct zram
 	 */
 	if (offset) {
 		if (n <= (PAGE_SIZE - offset))
-			return;
+			goto end_bio;
 
 		n -= (PAGE_SIZE - offset);
 		index++;
@@ -2693,6 +2693,7 @@ static void zram_bio_discard(struct zram
 		n -= PAGE_SIZE;
 	}
 
+end_bio:
 	bio_endio(bio);
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-do-not-forget-to-endio-for-partial-discard-requests.patch


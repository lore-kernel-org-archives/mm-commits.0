Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AF21A680C;
	Wed,  1 Apr 2026 00:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775004687; cv=none; b=aZe4zUKLrswAe9G0+AQe6SunCMq8Vup0lFww8mLjJqw+sBtkZWtNl9nNH8MvLj2PjXbEQ1I6QICLUBdwbG1q9qYjyaIpzsGzaJkhNRGGFivBh91rFoeguCTXw2kizI369DJW1b/KcrkumbItWSH9jYbW/Uu9NuEqEsPD+sfBZ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775004687; c=relaxed/simple;
	bh=Wgdz3xYKlehHKVBY3fmAzF+m8mJLRi95jqHsmPjUd5s=;
	h=Date:To:From:Subject:Message-Id; b=ShrVt+WwjdTHoTUYkqv44mLbwOS9oZkmpTvhNQsISCU2/ndXQOjZRpYqmaYRan5Mh4wipLGpvPtzceDKUSYProq7o+NZQuJPcRk4/r8Nc+G9xFOgaShKS+C2Uh1Y8eLg0pwDlE2Gj20+1w/lcrEfXu5JXvjMv1RdpDwdcqvZ2f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W+zXSnpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W+zXSnpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C91CC19423;
	Wed,  1 Apr 2026 00:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775004687;
	bh=Wgdz3xYKlehHKVBY3fmAzF+m8mJLRi95jqHsmPjUd5s=;
	h=Date:To:From:Subject:From;
	b=W+zXSnpD4rvQQ0wVs2UCIuE6AtZYvy2kmiMrwUxoQj5j17TWjJWpI2uUnYya5E07p
	 qilmXv42DMjO5ppQ/mpUuzPg7E3ajmMG2km3Dz+9reCKfI4nCn3AfvicJg023l0Gry
	 2syaDpvtZGHh01OqBbuw0/rbkfo9z/1itRSFuqwM=
Date: Tue, 31 Mar 2026 17:51:26 -0700
To: mm-commits@vger.kernel.org,wqu@suse.com,stable@vger.kernel.org,minchan@kernel.org,hch@lst.de,bgeffon@google.com,axboe@kernel.dk,avinesh.kumar@suse.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zram-do-not-forget-to-endio-for-partial-discard-requests.patch removed from -mm tree
Message-Id: <20260401005127.6C91CC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: do not forget to endio for partial discard requests
has been removed from the -mm tree.  Its filename was
     zram-do-not-forget-to-endio-for-partial-discard-requests.patch

This patch was dropped because an updated version will be issued

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



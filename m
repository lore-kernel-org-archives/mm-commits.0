Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C70C36E495;
	Sat, 18 Apr 2026 07:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498951; cv=none; b=XZSgeDcRpk29jqzWO004Vqco6GqW5SVwQ5QCFT39zE0KqzSQNyXMZPApZT0Q2Lz7EzTEsdLj/EIkxv4KextnTYGTrQ4sD8WKOT9hGtnlHVcVCu0ZjnwAG28bTRnNcV94FZTNhNPkYCoOkxXhe26oblpEcFMldC5ZxKYQWYFolqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498951; c=relaxed/simple;
	bh=CjIFqpuaQR9CVgZ5wfCq6g9QYoAo8K3mhIvjlGt4ID4=;
	h=Date:To:From:Subject:Message-Id; b=CqXm8fObAL2XdUDAPQLXVW02aGj8fihOsLt0a3RqQjA5PIs21/XSssxLTAJrlMUwwy31TViF32vO3Eif9MuK3ncg8Untm/f7/AJsdFgoklTjOcA786Uju19p+SdfdP/G491BbfyCkUAYwSNVrqPigalqL+0jqbU7s8B4CT+gfeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aTsiOSoo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aTsiOSoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC26C19424;
	Sat, 18 Apr 2026 07:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498951;
	bh=CjIFqpuaQR9CVgZ5wfCq6g9QYoAo8K3mhIvjlGt4ID4=;
	h=Date:To:From:Subject:From;
	b=aTsiOSooJ6fLPnKVaRhXZWKlkenovCoknEYbcnS5De6T4C0yaqXLal4pVC2tUzp5M
	 xKp1dw9C35jjPsGlTXEwtJBDFuDkWhNIsoi6xZi2Ud7ZPKK3U4HYm3JmE78CkXGeqC
	 AnOxu3cyx18Q4ukuDjxmpm8aquGy0KUzCcKuubVI=
Date: Sat, 18 Apr 2026 00:55:46 -0700
To: mm-commits@vger.kernel.org,wqu@suse.com,stable@vger.kernel.org,minchan@kernel.org,hch@lst.de,bgeffon@google.com,axboe@kernel.dk,avinesh.kumar@suse.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-do-not-forget-to-endio-for-partial-discard-requests.patch removed from -mm tree
Message-Id: <20260418075550.1DC26C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: do not forget to endio for partial discard requests
has been removed from the -mm tree.  Its filename was
     zram-do-not-forget-to-endio-for-partial-discard-requests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260331074255.777019-1-senozhatsky@chromium.org
Fixes: 0120dd6e4e20 ("zram: make zram_bio_discard more self-contained")
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



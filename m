Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64174635;
	Sat, 13 Sep 2025 20:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757794182; cv=none; b=rznhf416i7dxYxlJP16bFeWola32m5rZiJQIKbAQnwvNqFJlqZBOjTlG5Du5xcmfOTk6IzTEdb5nTiwuWvzXGlqCNZ0ahAYDfj4IzVXQK1TEUOz1F7LnhM3KRr4LfoIfVdYxefOgbZTSBVUAQsCAd06koAkhFTXE6gIqeA9IrWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757794182; c=relaxed/simple;
	bh=bNeu1XnseTOb//C/c3M6TwSpSDpWyslTdql7MCOj+5s=;
	h=Date:To:From:Subject:Message-Id; b=lN/CunK7pK/ngeHpGAgc7A5KYAEh4ETLQit3GmqcyZRkDSw9bmYWvmNgyIgYejijPZkH9bpa3Tq+dbYAVqRR1H23qwX8xDIhIMoPAhRSR3cJ7R/E7OrxaTbXkulhdbfJrPIcw7+I2WgS0JsiiYP9szzTqO7e6CspVoZME6IHs0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qEO7MEJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qEO7MEJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A69C4CEEB;
	Sat, 13 Sep 2025 20:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757794182;
	bh=bNeu1XnseTOb//C/c3M6TwSpSDpWyslTdql7MCOj+5s=;
	h=Date:To:From:Subject:From;
	b=qEO7MEJ0Hw5aKzw2EDdVsn2/M3jIXeYSL3mriCoxt3XHZJSK2QpUsnwD5SmkUo91G
	 Vi3JdeDVBEYN9DrNrTGBhuFpoPmgdnaOp/4qs4Cw/EWt9QiY0t6Gx7aPujJEx7r8sd
	 JwcRaUl4xH1WtBMdjjASFdrSGiokcEGyDYJdu4Q8=
Date: Sat, 13 Sep 2025 13:09:41 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,minchan@kernel.org,czhong@redhat.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zram-fix-slot-write-race-condition.patch removed from -mm tree
Message-Id: <20250913200941.E5A69C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: fix slot write race condition
has been removed from the -mm tree.  Its filename was
     zram-fix-slot-write-race-condition.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: fix slot write race condition
Date: Tue, 9 Sep 2025 13:48:35 +0900

Parallel concurrent writes to the same zram index result in leaked
zsmalloc handles.  Schematically we can have something like this:

CPU0                              CPU1
zram_slot_lock()
zs_free(handle)
zram_slot_lock()
				zram_slot_lock()
				zs_free(handle)
				zram_slot_lock()

compress			compress
handle = zs_malloc()		handle = zs_malloc()
zram_slot_lock
zram_set_handle(handle)
zram_slot_lock
				zram_slot_lock
				zram_set_handle(handle)
				zram_slot_lock

Either CPU0 or CPU1 zsmalloc handle will leak because zs_free() is done
too early.  In fact, we need to reset zram entry right before we set its
new handle, all under the same slot lock scope.

Link: https://lkml.kernel.org/r/20250909045150.635345-1-senozhatsky@chromium.org
Fixes: 71268035f5d7 ("zram: free slot memory early during write")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Changhui Zhong <czhong@redhat.com>
Closes: https://lore.kernel.org/all/CAGVVp+UtpGoW5WEdEU7uVTtsSCjPN=ksN6EcvyypAtFDOUf30A@mail.gmail.com/
Tested-by: Changhui Zhong <czhong@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-slot-write-race-condition
+++ a/drivers/block/zram/zram_drv.c
@@ -1795,6 +1795,7 @@ static int write_same_filled_page(struct
 				  u32 index)
 {
 	zram_slot_lock(zram, index);
+	zram_free_page(zram, index);
 	zram_set_flag(zram, index, ZRAM_SAME);
 	zram_set_handle(zram, index, fill);
 	zram_slot_unlock(zram, index);
@@ -1832,6 +1833,7 @@ static int write_incompressible_page(str
 	kunmap_local(src);
 
 	zram_slot_lock(zram, index);
+	zram_free_page(zram, index);
 	zram_set_flag(zram, index, ZRAM_HUGE);
 	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, PAGE_SIZE);
@@ -1855,11 +1857,6 @@ static int zram_write_page(struct zram *
 	unsigned long element;
 	bool same_filled;
 
-	/* First, free memory allocated to this slot (if any) */
-	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
-	zram_slot_unlock(zram, index);
-
 	mem = kmap_local_page(page);
 	same_filled = page_same_filled(mem, &element);
 	kunmap_local(mem);
@@ -1901,6 +1898,7 @@ static int zram_write_page(struct zram *
 	zcomp_stream_put(zstrm);
 
 	zram_slot_lock(zram, index);
+	zram_free_page(zram, index);
 	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, comp_len);
 	zram_slot_unlock(zram, index);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-protect-recomp_algorithm_show-with-init_lock.patch
panic-remove-redundant-panic-cpu-backtrace.patch


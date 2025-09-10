Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B8031D39F;
	Wed, 10 Sep 2025 05:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757481697; cv=none; b=hZFyOBAXYPkclNrD1qY6sefIiMo3vBaRG+8grfTlNQxL/8M9Zn6VjYu9rsI3Nlkb2r9m8nGli0lyurWmDAGh6DXZVrRBssuhag3T2KktkB3UaM2Au1mfGMeiB/29kCg6yJuoX4ttwfHUEzvZ6DX44aPditwB29uGukVu9qi+DyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757481697; c=relaxed/simple;
	bh=Fz6AZ9q22o6YTknitqE7AJ1zoBuxdqIeg6d6j2vOfJo=;
	h=Date:To:From:Subject:Message-Id; b=c+zTssW1oxj4bzVPf3g5+bcKSNJPO4h/K08kTbAv7ueoDpuy40rvgOzNzn21UW+2TbNZr9sBEQirFDpHZSPvoJOAq8rwY/iYVwurPCTZL5NJ3wtp415S6WbJHz6K3DNg6X8GfGnv/BliQUX4lTaeh8JpQE0DN1Jtj32LoKonwQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gV+ij2uD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gV+ij2uD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBED4C4CEF0;
	Wed, 10 Sep 2025 05:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757481696;
	bh=Fz6AZ9q22o6YTknitqE7AJ1zoBuxdqIeg6d6j2vOfJo=;
	h=Date:To:From:Subject:From;
	b=gV+ij2uDHRmXYVX3cE53VNnfz4PsqVx0D9bsHJT+rg0ng4zviW0D1eiOnFFSeBMyd
	 nbUtB1DIA45trl3ydf0JpkOYkeNsP+sXH8PkJE9+adXYZQf5xJeDhu3gesDwgk8QOQ
	 3NnzJOJUPeVLgLdZDcvSRthqIfbPUtX1F2UIqm2c=
Date: Tue, 09 Sep 2025 22:21:36 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,minchan@kernel.org,czhong@redhat.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-slot-write-race-condition.patch added to mm-hotfixes-unstable branch
Message-Id: <20250910052136.DBED4C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fix slot write race condition
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zram-fix-slot-write-race-condition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-slot-write-race-condition.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Fixes: 71268035f5d73 ("zram: free slot memory early during write")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Changhui Zhong <czhong@redhat.com>
Closes: https://lore.kernel.org/all/CAGVVp+UtpGoW5WEdEU7uVTtsSCjPN=ksN6EcvyypAtFDOUf30A@mail.gmail.com/
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

zram-fix-slot-write-race-condition.patch
zram-protect-recomp_algorithm_show-with-init_lock.patch
panic-remove-redundant-panic-cpu-backtrace.patch


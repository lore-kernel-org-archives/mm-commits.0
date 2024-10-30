Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455243C14
	for <mm-commits@vger.kernel.org>; Wed, 30 Oct 2024 01:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730250282; cv=none; b=pxwzy5jgzbvcS5vVd6tGmFgyenpZKOQyWn3I6C5XAFaHfzBr+INn8T2F4UQ3JrqPUMJkGCJUUEnVsSjNmIZRszC81Xau8ybhiFpYTXp7JoBcAEqEgJZhq8yzakSB+TtLmvFCV9f1hHkcWFHCd+xCDU/AOQLEdJmnb+a6f1+Mnnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730250282; c=relaxed/simple;
	bh=+W1xjdtaFcn6Gpwln3WzzKPdK6X4MhV0ah3fr5d7RZ0=;
	h=Date:To:From:Subject:Message-Id; b=HUcMqEwwKeTm2vYYKKx3s3NRWqKIFpB9LCG4JCcTiFSZyNEdRwjQfbb3ysOt3gXXj5K7GyOjf/O0gHb17qJOy4aoglcuNMTd6WeF4NbOy9bDkyyJ9kw74X3k5+Vd2450cUaBpiwNyHQFiQtqyleN6JpesZENw+poHWdj0nxkcEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UC8KyK5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UC8KyK5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1016C4CECD;
	Wed, 30 Oct 2024 01:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730250281;
	bh=+W1xjdtaFcn6Gpwln3WzzKPdK6X4MhV0ah3fr5d7RZ0=;
	h=Date:To:From:Subject:From;
	b=UC8KyK5Gc1k0dNduFXqvGR/gXFJRqo9vR1ozP/J2VrG2LolRt5SQliLfNWM7ziSRN
	 syKjjDUKv2erXV+ET6nd7hh9XLZ8zPzrZe95nqrDeSQTIOcCM+rbMJJ5933Rg8pK/n
	 OQJnXjeF8vUZawsJfCYXiUOMJFAhfmuKl+JSdq2I=
Date: Tue, 29 Oct 2024 18:04:41 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,kawasin@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-clear-idle-flag-in-mark_idle.patch added to mm-unstable branch
Message-Id: <20241030010441.B1016C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: clear IDLE flag in mark_idle()
has been added to the -mm mm-unstable branch.  Its filename is
     zram-clear-idle-flag-in-mark_idle.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-clear-idle-flag-in-mark_idle.patch

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
Subject: zram: clear IDLE flag in mark_idle()
Date: Tue, 29 Oct 2024 00:36:15 +0900

If entry does not fulfill current mark_idle() parameters, e.g.  cutoff
time, then we should clear its ZRAM_IDLE from previous mark_idle()
invocations.

Consider the following case:
- mark_idle() cutoff time 8h
- mark_idle() cutoff time 4h
- writeback() idle - will writeback entries with cutoff time 8h,
  while it should only pick entries with cutoff time 4h

The bug was reported by Shin Kawamura.

Link: https://lkml.kernel.org/r/20241028153629.1479791-3-senozhatsky@chromium.org
Fixes: 755804d16965 ("zram: introduce an aged idle interface")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Shin Kawamura <kawasin@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-clear-idle-flag-in-mark_idle
+++ a/drivers/block/zram/zram_drv.c
@@ -410,6 +410,8 @@ static void mark_idle(struct zram *zram,
 #endif
 		if (is_idle)
 			zram_set_flag(zram, index, ZRAM_IDLE);
+		else
+			zram_clear_flag(zram, index, ZRAM_IDLE);
 		zram_slot_unlock(zram, index);
 	}
 }
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-introduce-zram_pp_slot-flag.patch
zram-permit-only-one-post-processing-operation-at-a-time.patch
zram-rework-recompress-target-selection-strategy.patch
zram-rework-recompress-target-selection-strategy-fix.patch
zram-rework-writeback-target-selection-strategy.patch
zram-do-not-mark-idle-slots-that-cannot-be-idle.patch
zram-reshuffle-zram_free_page-flags-operations.patch
zram-remove-under_wb-and-simplify-writeback.patch
zram-do-not-open-code-comp-priority-0.patch
zram-clear-idle-flag-after-recompression.patch
zram-clear-idle-flag-in-mark_idle.patch


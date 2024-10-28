Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D152117D355
	for <mm-commits@vger.kernel.org>; Mon, 28 Oct 2024 22:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730153421; cv=none; b=Xxvr+9resIX+PgrjeXceJg9WSyUcy2AwqBVWOvMgPYSUBO4ckxGhyvtnGGYb+c0YHn3TcF5NZDWRdnHm//1phq1Fx6+dMRkbUS/PmFL87Hva2pyj8fKj9EWGqyMR0PrXgOPRZOnYo4TdHW0JxFoTkwVYp3fYpVw9TfZTZ13hTsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730153421; c=relaxed/simple;
	bh=gRQB9ZzeZ3roJEvXVvmPJeG4onbu4gPi5KpUzgy/MgM=;
	h=Date:To:From:Subject:Message-Id; b=eSRw1PptVyr1yUWSZQd+kxWLnwbLJ5e8x/Pa0l3tTDPlJd/RQtbyhWJGdtN7sb1uLHbc5K2H2m2GPLspAqnYU7F+DrpS2kBfJOtCbjrSNkxYEDBHRN+yawFnn02TzfEP2DiI2Spzm/tuSWtGppgYOB1gCAVZJyHZei6AWC49EBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HKKVXXcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HKKVXXcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4802BC4CEC3;
	Mon, 28 Oct 2024 22:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730153420;
	bh=gRQB9ZzeZ3roJEvXVvmPJeG4onbu4gPi5KpUzgy/MgM=;
	h=Date:To:From:Subject:From;
	b=HKKVXXcBzR50vig3U30EcRYvlrq8/1/rZb4+hqLszw8db3e+oJeYJFMuqbvskTAG9
	 m7eWRs/xAxE8X6deuBZg22lgJJ9O49yM7hi0mA11jd5dABRAWvLK1uGXEQSuYITiu/
	 TW4d0FBfwLy71uZ5LPqdcSPWhwkCdwTtzNutvds4=
Date: Mon, 28 Oct 2024 15:10:19 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,kawasin@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-clear-idle-flag-in-mark_idle.patch added to mm-unstable branch
Message-Id: <20241028221020.4802BC4CEC3@smtp.kernel.org>
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
Date: Mon, 28 Oct 2024 16:34:58 +0900

If entry does not fulfill current mark_idle() parameters, e.g.  cutoff
time, then we should clear its ZRAM_IDLE from previous mark_idle()
invocations.

Consider the following case:
- mark_idle() cutoff time 8h
- mark_idle() cutoff time 4h
- writeback() idle - will writeback entries with cutoff time 8h,
  while it should only pick entries with cutoff time 4h

Link: https://lkml.kernel.org/r/20241028073529.1383980-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Shin Kawamura <kawasin@google.com>
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


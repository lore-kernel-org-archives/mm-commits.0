Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9F68489
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 00:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733878510; cv=none; b=JUtNdGuDjXnsKVOAJeM/W85Jwb/LH2BXpQl1STvpyILN63etQDWJgAha4hP/kz9CToiQezrE7O96j+y+mAryqXKnK2txZiEoW0RbSQ4gEtJ0abBfj+OFZRtqQhSDJFIZkcfr8lmRq2p1dpBQ7c52JRQIz1ouGn6nWCpzlJQ8Bx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733878510; c=relaxed/simple;
	bh=KPyIfWKBOWLNZPnsZ+uVSkfrS7P6+llFoFyOpjpeOWw=;
	h=Date:To:From:Subject:Message-Id; b=GSvhnsBtcUVlPZSyJOPB1WkL1V+lKU4DaORKeQEcrV00iIRM3jJzWzwz7t0blfIW92qiyPsGVUlC2+7Q41O38cpnkdL6crwb2ch4HnUqZF+UcYwtJYrkzlRtLh8vG5O1eQi/ObRHpY46JsjBo1U4++6o2xjTnxwcAcS87h9OfXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aVJELnU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aVJELnU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842DFC4CED6;
	Wed, 11 Dec 2024 00:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733878510;
	bh=KPyIfWKBOWLNZPnsZ+uVSkfrS7P6+llFoFyOpjpeOWw=;
	h=Date:To:From:Subject:From;
	b=aVJELnU8Si+omxn5P/XascBkkHu2azt4I08f6K6F7XIjiJJOUV+weRScobwr1yY8i
	 u0RTaXd2nxmptcNG3Pf5SJurrNomI9rNqUKIGqxHuOi1iPEhv5c3469W+wy2ONPet6
	 OacUPE58D+HGhfNETfNm5duo8gu7UD+NPzJNwZXM=
Date: Tue, 10 Dec 2024 16:55:09 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-cond_resched-in-writeback-loop.patch added to mm-unstable branch
Message-Id: <20241211005510.842DFC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: cond_resched() in writeback loop
has been added to the -mm mm-unstable branch.  Its filename is
     zram-cond_resched-in-writeback-loop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-cond_resched-in-writeback-loop.patch

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
Subject: zram: cond_resched() in writeback loop
Date: Tue, 10 Dec 2024 19:53:55 +0900

Patch series "zram: split page type read/write handling".

This is a subset of [1] series which contains only fixes and improvements
(no new features, as ZRAM_HUGE split is still under consideration).

The motivation for factoring out is that zram_write_page() gets more and
more complex all the time, because it tries to handle too many scenarios:
ZRAM_SAME store, ZRAM_HUGE store, compress page store with zs_malloc
allocation slowpath and conditional recompression, etc.  Factor those out
and make things easier to handle.

Addition of cond_resched() is simply a fix, I can trigger watchdog from
zram writeback().  And early slot free is just a reasonable thing to do.

[1] https://lore.kernel.org/linux-kernel/20241119072057.3440039-1-senozhatsky@chromium.org


This patch (of 6):

Writeback loop can run for quite a while (depending on wb device
performance, compression algorithm and the number of entries we
writeback), so we need to do cond_resched() there, similarly to what we do
in recompress loop.

Link: https://lkml.kernel.org/r/20241210105420.1888790-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20241210105420.1888790-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-cond_resched-in-writeback-loop
+++ a/drivers/block/zram/zram_drv.c
@@ -889,6 +889,8 @@ static ssize_t writeback_store(struct de
 next:
 		zram_slot_unlock(zram, index);
 		release_pp_slot(zram, pps);
+
+		cond_resched();
 	}
 
 	if (blk_idx)
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-panic-when-use-ext4-over-zram-fix.patch
zram-cond_resched-in-writeback-loop.patch
zram-free-slot-memory-early-during-write.patch
zram-remove-entry-element-member.patch
zram-factor-out-zram_same-write.patch
zram-factor-out-zram_huge-write.patch
zram-factor-out-different-page-types-read.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230591849
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 00:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727225591; cv=none; b=XqHvPa/h9vt+e49JoiIG3OHO9/RiCBIGBTplK05+B0CWlb9z/m7J2Wfmv78K/KLztZyX7c+t7n469EdHggKCtQABpDczoAkuFq8HMBoJearTrYXeSluEuDkJMRSYvFk8IhRCRUwFt/SKAdI09pEtjCi87VbI5mqMAH/MqDfWH0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727225591; c=relaxed/simple;
	bh=aO3/CUv8dfp24Sp9acpxb1i6osgxXl/nZ8OBc9DMngQ=;
	h=Date:To:From:Subject:Message-Id; b=chF9Cw/I1HGmFwWu/Fr9Pta0uUcVTD+Ei/OGfTNx2VDgLldtLGvkptAZP46x+4pOCbEauNTrKqykUkJSF7PoCaH73sBWH4aYzzNUTZOYWJQj+4mstStnXCzzPjE+wkFrwGu3trOdITS2ZR6ksPZrYyix7YykQXYWMdDjZb1Qih4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sj69k9wn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sj69k9wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768EFC4CEC4;
	Wed, 25 Sep 2024 00:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727225590;
	bh=aO3/CUv8dfp24Sp9acpxb1i6osgxXl/nZ8OBc9DMngQ=;
	h=Date:To:From:Subject:From;
	b=Sj69k9wn7CHtOVfs2IGMbiJoQb4LMVsrMOr0qBRmk9+2snINSSPFPJdloVylbtzj9
	 QSPUs3JfO5pAT4VJ4BokqHBtZv5OjCm+XM+/MYj8RaVWIcrRdoIM2DWOfaXaIbpoy2
	 bsuk946FT2l4oWpG6QDeEHrC0dosMxq74pLSEZ7Q=
Date: Tue, 24 Sep 2024 17:53:09 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-introduce-zram_pp_slot-flag.patch added to mm-unstable branch
Message-Id: <20240925005310.768EFC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: introduce ZRAM_PP_SLOT flag
has been added to the -mm mm-unstable branch.  Its filename is
     zram-introduce-zram_pp_slot-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-introduce-zram_pp_slot-flag.patch

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
Subject: zram: introduce ZRAM_PP_SLOT flag
Date: Tue, 17 Sep 2024 11:09:06 +0900

Patch series "zram: optimal post-processing target selection", v5.

Problem:
--------
Both recompression and writeback perform a very simple linear scan of all
zram slots in search for post-processing (writeback or recompress)
candidate slots.  This often means that we pick the worst candidate for pp
(post-processing), e.g.  a 48 bytes object for writeback, which is nearly
useless, because it only releases 48 bytes from zsmalloc pool, but
consumes an entire 4K slot in the backing device.  Similarly,
recompression of an 48 bytes objects is unlikely to save more memory that
recompression of a 3000 bytes object.  Both recompression and writeback
consume constrained resources (CPU time, batter, backing device storage
space) and quite often have a (daily) limit on the number of items they
post-process, so we should utilize those constrained resources in the most
optimal way.

Solution:
---------
This patch reworks the way we select pp targets.  We, quite clearly, want
to sort all the candidates and always pick the largest, be it
recompression or writeback.  Especially for writeback, because the larger
object we writeback the more memory we release.  This series introduces
concept of pp buckets and pp scan/selection.

The scan step is a simple iteration over all zram->table entries, just
like what we currently do, but we don't post-process a candidate slot
immediately.  Instead we assign it to a PP (post-processing) bucket.  PP
bucket is, basically, a list which holds pp candidate slots that belong to
the same size class.  PP buckets are 64 bytes apart, slots are not
strictly sorted within a bucket there is a 64 bytes variance.

The select step simply iterates over pp buckets from highest to lowest and
picks all candidate slots a particular buckets contains.  So this gives us
sorted candidates (in linear time) and allows us to select most optimal
(largest) candidates for post-processing first.


This patch (of 7):

This flag indicates that the slot was selected as a candidate slot for
post-processing (pp) and was assigned to a pp bucket.  It does not
necessarily mean that the slot is currently under post-processing, but may
mean so.  The slot can loose its PP_SLOT flag, while still being in the
pp-bucket, if it's accessed or slot_free-ed.

Link: https://lkml.kernel.org/r/20240917021020.883356-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20240917021020.883356-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 drivers/block/zram/zram_drv.h |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-introduce-zram_pp_slot-flag
+++ a/drivers/block/zram/zram_drv.c
@@ -178,6 +178,7 @@ static inline u32 zram_get_priority(stru
 static void zram_accessed(struct zram *zram, u32 index)
 {
 	zram_clear_flag(zram, index, ZRAM_IDLE);
+	zram_clear_flag(zram, index, ZRAM_PP_SLOT);
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 	zram->table[index].ac_time = ktime_get_boottime();
 #endif
@@ -1354,6 +1355,7 @@ static void zram_free_page(struct zram *
 		zram_clear_flag(zram, index, ZRAM_INCOMPRESSIBLE);
 
 	zram_set_priority(zram, index, 0);
+	zram_clear_flag(zram, index, ZRAM_PP_SLOT);
 
 	if (zram_test_flag(zram, index, ZRAM_WB)) {
 		zram_clear_flag(zram, index, ZRAM_WB);
--- a/drivers/block/zram/zram_drv.h~zram-introduce-zram_pp_slot-flag
+++ a/drivers/block/zram/zram_drv.h
@@ -48,6 +48,7 @@ enum zram_pageflags {
 	ZRAM_SAME = ZRAM_FLAG_SHIFT,	/* Page consists the same element */
 	ZRAM_WB,	/* page is stored on backing_device */
 	ZRAM_UNDER_WB,	/* page is under writeback */
+	ZRAM_PP_SLOT,	/* Selected for post-processing */
 	ZRAM_HUGE,	/* Incompressible page */
 	ZRAM_IDLE,	/* not accessed page since last idle marking */
 	ZRAM_INCOMPRESSIBLE, /* none of the algorithms could compress it */
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-introduce-zram_pp_slot-flag.patch
zram-permit-only-one-post-processing-operation-at-a-time.patch
zram-rework-recompress-target-selection-strategy.patch
zram-rework-writeback-target-selection-strategy.patch
zram-do-not-mark-idle-slots-that-cannot-be-idle.patch
zram-reshuffle-zram_free_page-flags-operations.patch
zram-remove-under_wb-and-simplify-writeback.patch


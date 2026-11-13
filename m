Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794554798;
	b=4//w7jfhQ63h9oEF9SXqa/b8sRS9WTUjV0e2K6DkWmN75VfoQshPncuxzSOlbBtturjp
	 LTpbD5NqGp5GaPGUdMZLtMNtzkrcgerczM09r2afETRaAYAvNJ8qbntzt4dIkVCcGd+C9
	 0wfmWpe6Bkmsa+z9AYbO26l5HDt6kp7A8oCC01B+THVEDTAKjIjNYoJx8n0lJD55NoHgj
	 EZROxLHWVZJwnUyQLBWOL9yoIxbU1EApdUYdh38lkPoWkqn8v4gB2u520URsluAyhSXEM
	 hzLXZJ4TWp16szRzTYsNe+7+plIR09BaTiprQR9+eBH+86gCEk+2n+AyMmhlE4DYeXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794554798;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=p5/U0Sqewnd3rN930kb93fGwswUlLrxZUjGKT81P4Vc=;
	b=OIBgcc04Fx7bv6zntrofxxgQEFcdwULnxv4cvYZB2WGwHoaNthC/8h0j2cCLi0KBpwTM
	 Nm1ivEO1XZ7HTOk5OYRazxMIDOvK3oV5jVrwFtAXwA3zqz4agD4axiLD1ma81tCpfMSUJ
	 g2zjx1ruVSo3UJb1K1FXSJSN9iMHONFd2XZZM+EQSEv8Vch7EzSX/xYgKaKw9S9oeJG2B
	 6+tuNCUAMrLjPGL6hdNzxGkiedg9sUQkZYrIn1a0LHCG/0bK0svGoWBKFhAPdmprC/DvJ
	 dWYyV0ZY/oMb2V2l8vHRDtc6UPtAKsS5uwFVkwKn4jvVxQvhmcXiN/C84g1xhDoVqjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=stGDddi4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A4A606A883
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 07:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=stGDddi4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCCC1F000C6;
	Fri, 13 Nov 2026 07:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794554798;
	bh=p5/U0Sqewnd3rN930kb93fGwswUlLrxZUjGKT81P4Vc=;
	h=Date:To:From:Subject;
	b=stGDddi4SZm2IzNXFdkNq7rYIq30kLWTARFwPYjHopYj+JJ6L5hsYy093zERc+/vs
	 iS1x7UNB3Jy5yryutExQgjjoHUPmAT8VPAu6o90FTcyEa6efYkNDuH69pdCfmtoT+5
	 v8YEsi76eYpyx8+gtoggJ6Dwr00zEJZOQt4wvAi0=
Date: Thu, 12 Nov 2026 23:26:37 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,
	axboe@kernel.dk,raoxu@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-avoid-duplicate-slots-in-batched-writeback.patch added to mm-new branch
Message-Id: <20261113072638.0CCCC1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: avoid duplicate slots in batched writeback
has been added to the -mm mm-new branch.  Its filename is
     zram-avoid-duplicate-slots-in-batched-writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-avoid-duplicate-slots-in-batched-writeback.patch

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
From: Xu Rao <raoxu@uniontech.com>
Subject: zram: avoid duplicate slots in batched writeback
Date: Tue, 10 Nov 2026 14:18:30 +0800

The writeback interface accepts multiple page_index and page_indexes
parameters in one operation.  Their ranges can overlap, but
scan_slots_for_writeback() only excludes slots that are already being
written back or marked as same-filled.

A slot selected by an earlier range is placed on the post-processing list
and marked with ZRAM_PP_SLOT.  Without checking that flag, an overlapping
range can enqueue the same slot again and submit it for writeback more
than once.

Skip slots already marked ZRAM_PP_SLOT while holding the slot lock.  This
keeps each slot in a writeback scan session represented by at most one
post-processing entry and leaves the existing release and reuse paths
unchanged.

Link: https://lore.kernel.org/F24EF6333964B482+20261110061830.272091-1-raoxu@uniontech.com
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---

 drivers/block/zram/zram_drv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-avoid-duplicate-slots-in-batched-writeback
+++ a/drivers/block/zram/zram_drv.c
@@ -1217,6 +1217,9 @@ static void scan_slots_for_writeback(str
 		if (!slot_allocated(zram, index))
 			goto next;
 
+		if (test_slot_flag(zram, index, ZRAM_PP_SLOT))
+			goto next;
+
 		if (test_slot_flag(zram, index, ZRAM_WB) ||
 		    test_slot_flag(zram, index, ZRAM_SAME))
 			goto next;
_

Patches currently in -mm which might be from raoxu@uniontech.com are

zram-avoid-duplicate-slots-in-batched-writeback.patch


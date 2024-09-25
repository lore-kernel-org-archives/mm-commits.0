Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335D31332A1
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 00:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727225600; cv=none; b=l9W3a37IJln1bNRAa6CuX1vhMuD0irJsZzOudS2J5aQinjQ/fg4urTOp9eFVxtRQV08574ExHHWvxiBXcoEUABC2A1eOQJTSecC84T410JoFMTNOFll0RCheSPgZOdpv56rFX5EPVwXEG5K6i6QWzYQhN3xtLQrN8KjZUmrVKDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727225600; c=relaxed/simple;
	bh=U9MK/CoJtjX9SLmu6vNCa/pIlFsCwcbtQYUfvnKiWz0=;
	h=Date:To:From:Subject:Message-Id; b=YE3UWnnVEwUmVaUALNE/6QHSRN6gsqlR4wRJdki5K2Ns7ROHnIsAbXdjkcyANl6AJcqQOSWs08K6Ua8T0J0bv3v2wp2ISMl4GAiwSTKpN56WAetlR+SAD835BPl1N3fIFprNUNFkwHYOeXVCpaTQFYkdlro9QRUzS7ZsHu7vyEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P3p8UBn1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P3p8UBn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCD8C4CEC4;
	Wed, 25 Sep 2024 00:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727225599;
	bh=U9MK/CoJtjX9SLmu6vNCa/pIlFsCwcbtQYUfvnKiWz0=;
	h=Date:To:From:Subject:From;
	b=P3p8UBn1uKE/stGMmpvuwhvAzalqHaHfsExFDJOxdMNbkzCI0AGKrSaRcIfk4Crbh
	 /GhMV83NA3TNF1tWrVgSAwa5PL3lqgamjDvSdvathEJ6oPgQotth5Ty8AqaYT65O12
	 K4eJ9HB7a/cdN0Ire9r09TSVhrux/aRwm1zk8DmY=
Date: Tue, 24 Sep 2024 17:53:19 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-mark-idle-slots-that-cannot-be-idle.patch added to mm-unstable branch
Message-Id: <20240925005319.ABCD8C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not mark idle slots that cannot be idle
has been added to the -mm mm-unstable branch.  Its filename is
     zram-do-not-mark-idle-slots-that-cannot-be-idle.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-mark-idle-slots-that-cannot-be-idle.patch

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
Subject: zram: do not mark idle slots that cannot be idle
Date: Tue, 17 Sep 2024 11:09:10 +0900

ZRAM_SAME slots cannot be post-processed (writeback or recompress) so do
not mark them ZRAM_IDLE.  Same with ZRAM_WB slots, they cannot be
ZRAM_IDLE because they are not in zsmalloc pool anymore.

Link: https://lkml.kernel.org/r/20240917021020.883356-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-mark-idle-slots-that-cannot-be-idle
+++ a/drivers/block/zram/zram_drv.c
@@ -392,17 +392,28 @@ static void mark_idle(struct zram *zram,
 		/*
 		 * Do not mark ZRAM_UNDER_WB slot as ZRAM_IDLE to close race.
 		 * See the comment in writeback_store.
+		 *
+		 * Also do not mark ZRAM_SAME slots as ZRAM_IDLE, because no
+		 * post-processing (recompress, writeback) happens to the
+		 * ZRAM_SAME slot.
+		 *
+		 * And ZRAM_WB slots simply cannot be ZRAM_IDLE.
 		 */
 		zram_slot_lock(zram, index);
-		if (zram_allocated(zram, index) &&
-				!zram_test_flag(zram, index, ZRAM_UNDER_WB)) {
+		if (!zram_allocated(zram, index) ||
+		    zram_test_flag(zram, index, ZRAM_WB) ||
+		    zram_test_flag(zram, index, ZRAM_UNDER_WB) ||
+		    zram_test_flag(zram, index, ZRAM_SAME)) {
+			zram_slot_unlock(zram, index);
+			continue;
+		}
+
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
-			is_idle = !cutoff || ktime_after(cutoff,
-							 zram->table[index].ac_time);
+		is_idle = !cutoff ||
+			ktime_after(cutoff, zram->table[index].ac_time);
 #endif
-			if (is_idle)
-				zram_set_flag(zram, index, ZRAM_IDLE);
-		}
+		if (is_idle)
+			zram_set_flag(zram, index, ZRAM_IDLE);
 		zram_slot_unlock(zram, index);
 	}
 }
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-introduce-zram_pp_slot-flag.patch
zram-permit-only-one-post-processing-operation-at-a-time.patch
zram-rework-recompress-target-selection-strategy.patch
zram-rework-writeback-target-selection-strategy.patch
zram-do-not-mark-idle-slots-that-cannot-be-idle.patch
zram-reshuffle-zram_free_page-flags-operations.patch
zram-remove-under_wb-and-simplify-writeback.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A937F148300
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854708; cv=none; b=r0dInIa1LuU2+HeHRpca/3+FlNFmPRnhdlN98UBieWJYPdsAMjQvcYppFbYlOsN6fC2T88EuC7jjxlQjUbicT1mkiUN6maHhz5kuu5eS9WlBhRmYPtm7IUgvidInICZpxywrqmAwrZTpc+DsuV1V85E1WC4VN8/J5ZCfvnFFr88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854708; c=relaxed/simple;
	bh=PKzVriXs1ftg4geTSDaBlWQmmMaVBPoTENei1fcENTk=;
	h=Date:To:From:Subject:Message-Id; b=ABbx+pN2doptagYDe47al9PDifaUwJ+xxfq69YlUxCEdnQ3+fnSGxpcJo45Vk2OuDu0XRaFk44x9fUpWAcmOhAqBCztIwcdVCkoJGxvJfPmby2tYUKynI3rKYeUzuE+8O3LsZpwTRLKiKL8V+EKeKvVKie6DOb4OdHMfgRheSm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=alMzIKSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="alMzIKSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6742CC4CECF;
	Wed,  6 Nov 2024 00:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854708;
	bh=PKzVriXs1ftg4geTSDaBlWQmmMaVBPoTENei1fcENTk=;
	h=Date:To:From:Subject:From;
	b=alMzIKSqMdmWjH0cWlOHmdWPxFc9gxfNigbc2O8p1A8OzRr5PKFyE3+L8NMDNBa6M
	 iNgB0xnpJjIfhzH85ogT39Xn5d8OQvVY37upp7xhc16qzu3gU91A6JrMQmHiz2LhhF
	 bOWG2swWAeuZFPovVpGhTUCV9Gsguu2lYNzgfz58=
Date: Tue, 05 Nov 2024 16:58:27 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-do-not-mark-idle-slots-that-cannot-be-idle.patch removed from -mm tree
Message-Id: <20241106005828.6742CC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: do not mark idle slots that cannot be idle
has been removed from the -mm tree.  Its filename was
     zram-do-not-mark-idle-slots-that-cannot-be-idle.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

zram-clear-idle-flag-after-recompression.patch
zram-clear-idle-flag-in-mark_idle.patch


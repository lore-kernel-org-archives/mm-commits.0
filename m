Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4B210F9
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sdo4ZCoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDC8C433C8;
	Mon, 11 Dec 2023 00:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702255472;
	bh=Vc2SIYgFTLF6sAa4QmiSrgI1h3aHGzwekuH95Sp15Vg=;
	h=Date:To:From:Subject:From;
	b=sdo4ZCoVcvK30fGdvJ8QCY6cxmnDCJzdmI0xOhQgjMuRJw5H9X3loVQEJjCemyrug
	 v1i5ssohpHer1vfd6XKOA5Hp/KoTy4ObFl4JP+cD9sY3KerawUeRstdW0Goej4WKs/
	 tKhl4UKBPlW0SDL9uxUK5rUsMx2kL2MImywUP3L4=
Date: Sun, 10 Dec 2023 16:44:32 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,dmaluka@chromium.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zram-split-memory-tracking-and-ac-time-tracking-v2.patch removed from -mm tree
Message-Id: <20231211004432.BBDC8C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram-split-memory-tracking-and-ac-time-tracking-v2
has been removed from the -mm tree.  Its filename was
     zram-split-memory-tracking-and-ac-time-tracking-v2.patch

This patch was dropped because it was folded into zram-split-memory-tracking-and-ac-time-tracking.patch

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram-split-memory-tracking-and-ac-time-tracking-v2
Date: Fri, 17 Nov 2023 10:35:20 +0900

ifdef fixup, per Dmytro

Link: https://lkml.kernel.org/r/20231117013543.540280-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Dmytro Maluka <dmaluka@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig    |    2 +-
 drivers/block/zram/zram_drv.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/Kconfig~zram-split-memory-tracking-and-ac-time-tracking-v2
+++ a/drivers/block/zram/Kconfig
@@ -74,7 +74,7 @@ config ZRAM_TRACK_ENTRY_ACTIME
 	depends on ZRAM
 	help
 	  With this feature zram tracks access time of every stored
-	  entry (page), which can be used for a more fine-grained IDLE
+	  entry (page), which can be used for a more fine grained IDLE
 	  pages writeback.
 
 config ZRAM_MEMORY_TRACKING
--- a/drivers/block/zram/zram_drv.c~zram-split-memory-tracking-and-ac-time-tracking-v2
+++ a/drivers/block/zram/zram_drv.c
@@ -301,7 +301,7 @@ static void mark_idle(struct zram *zram,
 		zram_slot_lock(zram, index);
 		if (zram_allocated(zram, index) &&
 				!zram_test_flag(zram, index, ZRAM_UNDER_WB)) {
-#ifdef ZRAM_TRACK_ENTRY_ACTIME
+#ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 			is_idle = !cutoff || ktime_after(cutoff,
 							 zram->table[index].ac_time);
 #endif
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-split-memory-tracking-and-ac-time-tracking.patch
zram-tweak-writeback-config-help.patch
zram-use-kmap_local_page.patch
checkpatch-do-not-require-an-empty-line-before-error-injection.patch


From: akpm@linux-foundation.org
Subject: [folded-merged] compaction-fix-build-error-in-cma-compaction-fix.patch removed from -mm tree
Date: Thu, 20 Dec 2012 14:24:09 -0800
Message-ID: <20121220222409.94B9282004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:52070 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2LTWYK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 17:24:10 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so419405yen.0
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 14:24:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, m.szyprowski@samsung.com, mgorman@suse.de, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: compaction-fix-build-error-in-cma-compaction-fix
has been removed from the -mm tree.  Its filename was
     compaction-fix-build-error-in-cma-compaction-fix.patch

This patch was dropped because it was folded into compaction-fix-build-error-in-cma-compaction.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: compaction-fix-build-error-in-cma-compaction-fix

add "do { } while (0)", per Mel.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~compaction-fix-build-error-in-cma-compaction-fix mm/compaction.c
--- a/mm/compaction.c~compaction-fix-build-error-in-cma-compaction-fix
+++ a/mm/compaction.c
@@ -28,8 +28,8 @@ static inline void count_compact_events(
 	count_vm_events(item, delta);
 }
 #else
-#define count_compact_event(item)
-#define count_compact_events(item, delta)
+#define count_compact_event(item) do { } while (0)
+#define count_compact_events(item, delta) do { } while (0)
 #endif
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
compaction-fix-build-error-in-cma-compaction.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
revert-rtc-recycle-id-when-unloading-a-rtc-driver.patch
sgi-xp-handle-non-fatal-traps-fix.patch
sendfile-allows-bypassing-of-notifier-events.patch


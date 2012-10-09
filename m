From: akpm@linux-foundation.org
Subject: [merged] mm-enable-config_compaction-by-default.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:13:14 -0700
Message-ID: <20121009181315.386EF5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:43996 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab2JISNR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:13:17 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so360523fae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:13:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, aquini@redhat.com, hannes@cmpxchg.org, mel@csn.ul.ie, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: enable CONFIG_COMPACTION by default
has been removed from the -mm tree.  Its filename was
     mm-enable-config_compaction-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: enable CONFIG_COMPACTION by default

Now that lumpy reclaim has been removed, compaction is the only way left
to free up contiguous memory areas.  It is time to just enable
CONFIG_COMPACTION by default.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rafael Aquini <aquini@redhat.com> 
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/Kconfig~mm-enable-config_compaction-by-default mm/Kconfig
--- a/mm/Kconfig~mm-enable-config_compaction-by-default
+++ a/mm/Kconfig
@@ -191,6 +191,7 @@ config SPLIT_PTLOCK_CPUS
 # support for memory compaction
 config COMPACTION
 	bool "Allow for memory compaction"
+	def_bool y
 	select MIGRATION
 	depends on MMU
 	help
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch


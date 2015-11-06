From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-export-tracepoints-zone-names-to-userspace-fix.patch removed
 from -mm tree
Date: Thu, 05 Nov 2015 18:25:00 -0800
Message-ID: <563c0f7c.JSqVNyqae/oLbHWC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFCZB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:25:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, valentinrothberg@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: export tracepoints zone names to userspace-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-export-tracepoints-zone-names-to-userspace-fix.patch

This patch was dropped because it was folded into mm-compaction-export-tracepoints-zone-names-to-userspace.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: export tracepoints zone names to userspace-fix

Through undertaker-checkpatch it was reported that HighMem would be
missing in the tracepoint output due to checking CONFIG_ZONE_HIGHMEM_
instead of CONFIG_HIGHMEM.  Fix it.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Valentin Rothberg <valentinrothberg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/trace/events/compaction.h~mm-compaction-export-tracepoints-zone-names-to-userspace-fix include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-export-tracepoints-zone-names-to-userspace-fix
+++ a/include/trace/events/compaction.h
@@ -30,7 +30,7 @@
 #define IFDEF_ZONE_DMA32(X)
 #endif
 
-#ifdef CONFIG_ZONE_HIGHMEM_
+#ifdef CONFIG_HIGHMEM
 #define IFDEF_ZONE_HIGHMEM(X) X
 #else
 #define IFDEF_ZONE_HIGHMEM(X)
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-migrate-count-pages-failing-all-retries-in-vmstat-and-tracepoint.patch
mm-compaction-export-tracepoints-status-strings-to-userspace.patch
mm-compaction-export-tracepoints-zone-names-to-userspace.patch
mm-compaction-disginguish-contended-status-in-tracepoints.patch


From: akpm@linux-foundation.org
Subject: +
 mm-compaction-export-tracepoints-zone-names-to-userspace-fix.patch added to -mm tree
Date: Wed, 23 Sep 2015 14:12:01 -0700
Message-ID: <560315a1.iqTVb6N7kZrSQQ3O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbbIWVMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Sep 2015 17:12:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, valentinrothberg@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: export tracepoints zone names to userspace-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-export-tracepoints-zone-names-to-userspace-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-export-tracepoints-zone-names-to-userspace-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-export-tracepoints-zone-names-to-userspace-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-compaction-export-tracepoints-zone-names-to-userspace-fix.patch
mm-compaction-disginguish-contended-status-in-tracepoints.patch


From: akpm@linux-foundation.org
Subject: [merged] block-add-missed-trace_block_plug.patch removed from -mm tree
Date: Thu, 17 Nov 2011 12:21:44 -0800
Message-ID: <201111172021.pAHKLiAT005060@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:64444 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab1KQUVp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 15:21:45 -0500
Received: by mail-qy0-f202.google.com with SMTP id 20so387688qyd.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 12:21:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, axboe@kernel.dk, namhyung@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block: add missed trace_block_plug
has been removed from the -mm tree.  Its filename was
     block-add-missed-trace_block_plug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shaohua Li <shaohua.li@intel.com>
Subject: block: add missed trace_block_plug

After flush plug list, the list has no request, so we need to add a
trace_block_plug().

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN block/blk-core.c~block-add-missed-trace_block_plug block/blk-core.c
--- a/block/blk-core.c~block-add-missed-trace_block_plug
+++ a/block/blk-core.c
@@ -1387,8 +1387,10 @@ get_rq:
 				if (__rq->q != q)
 					plug->should_sort = 1;
 			}
-			if (request_count >= BLK_MAX_REQUEST_COUNT)
+			if (request_count >= BLK_MAX_REQUEST_COUNT) {
 				blk_flush_plug_list(plug, false);
+				trace_block_plug(q);
+			}
 		}
 		list_add_tail(&req->queuelist, &plug->list);
 		drive_stat_acct(req, 1);
_

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
x86-tlb-flush-avoid-superflous-leave_mm.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch


From: akpm@google.com
Subject: + block-add-missed-trace_block_plug.patch added to -mm tree
Date: Thu, 06 Oct 2011 14:12:09 -0700
Message-ID: <201110062112.p96LCAe1008554@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:6828 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab1JFVMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2011 17:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, axboe@kernel.dk, namhyung@gmail.com


The patch titled
     Subject: block: add missed trace_block_plug
has been added to the -mm tree.  Its filename is
     block-add-missed-trace_block_plug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shaohua Li <shaohua.li@intel.com>
Subject: block: add missed trace_block_plug

After flush plug list, the list has no request, so we need to add a
trace_block_plug().

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 block/blk-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN block/blk-core.c~block-add-missed-trace_block_plug block/blk-core.c
--- a/block/blk-core.c~block-add-missed-trace_block_plug
+++ a/block/blk-core.c
@@ -1304,8 +1304,10 @@ get_rq:
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
Subject: Subject: block: add missed trace_block_plug

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
x86-tlb-flush-avoid-superflous-leave_mm.patch
block-avoid-unnecessary-plug-list-flush.patch
block-add-missed-trace_block_plug.patch
vmscan-add-block-plug-for-page-reclaim.patch
vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch


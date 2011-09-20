From: akpm@google.com
Subject: [folded] kmemleak-show-where-early_log-issues-come-from-update.patch removed from -mm tree
Date: Tue, 20 Sep 2011 14:05:41 -0700
Message-ID: <201109202105.p8KL5fYe026733@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47984 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1ITVFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2011 17:05:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak-show-where-early_log-issues-come-from-update
has been removed from the -mm tree.  Its filename was
     kmemleak-show-where-early_log-issues-come-from-update.patch

This patch was dropped because it was folded into kmemleak-show-where-early_log-issues-come-from.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: kmemleak-show-where-early_log-issues-come-from-update

We should extend the above to the other early kmemleak API calls (apart
from KMEMLEAK_ALLOC).

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/kmemleak.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN mm/kmemleak.c~kmemleak-show-where-early_log-issues-come-from-update mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-show-where-early_log-issues-come-from-update
+++ a/mm/kmemleak.c
@@ -1718,34 +1718,37 @@ void __init kmemleak_init(void)
 	 */
 	for (i = 0; i < crt_early_log; i++) {
 		struct early_log *log = &early_log[i];
+		int ret = 0;
 
 		switch (log->op_type) {
 		case KMEMLEAK_ALLOC:
 			early_alloc(log);
 			break;
 		case KMEMLEAK_FREE:
-			kmemleak_free(log->ptr);
+			ret = __kmemleak_free(log->ptr);
 			break;
 		case KMEMLEAK_FREE_PART:
-			kmemleak_free_part(log->ptr, log->size);
+			ret = __kmemleak_free_part(log->ptr, log->size);
 			break;
 		case KMEMLEAK_NOT_LEAK:
-			if (__kmemleak_not_leak(log->ptr) < 0)
-				print_log_stack(log);
+			ret = __kmemleak_not_leak(log->ptr);
 			break;
 		case KMEMLEAK_IGNORE:
-			if (__kmemleak_ignore(log->ptr) < 0)
-				print_log_stack(log);
+			ret = __kmemleak_ignore(log->ptr);
 			break;
 		case KMEMLEAK_SCAN_AREA:
-			kmemleak_scan_area(log->ptr, log->size, GFP_KERNEL);
+			ret = __kmemleak_scan_area(log->ptr, log->size,
+						   GFP_KERNEL);
 			break;
 		case KMEMLEAK_NO_SCAN:
-			kmemleak_no_scan(log->ptr);
+			ret = __kmemleak_no_scan(log->ptr);
 			break;
 		default:
 			WARN_ON(1);
 		}
+
+		if (ret < 0)
+			print_log_stack(log);
 	}
 }
 
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
kmemleak-show-where-early_log-issues-come-from.patch


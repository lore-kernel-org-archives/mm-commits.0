From: akpm@linux-foundation.org
Subject: + kmemleak-show-where-early_log-issues-come-from-update.patch added to -mm tree
Date: Fri, 26 Aug 2011 17:14:33 -0700
Message-ID: <201108270014.p7R0EX3P020746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754310Ab1H0AOk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 20:14:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, rostedt@goodmis.org


The patch titled
     kmemleak-show-where-early_log-issues-come-from-update
has been added to the -mm tree.  Its filename is
     kmemleak-show-where-early_log-issues-come-from-update.patch

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
Subject: kmemleak-show-where-early_log-issues-come-from-update
From: Catalin Marinas <catalin.marinas@arm.com>

We should extend the above to the other early kmemleak API calls (apart
from KMEMLEAK_ALLOC).

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

linux-next.patch
kmemleak-show-where-early_log-issues-come-from.patch
kmemleak-show-where-early_log-issues-come-from-update.patch


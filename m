From: akpm@linux-foundation.org
Subject: [merged] ratelimit-annotate-___ratelimit.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:50:19 -0400
Message-ID: <201004071851.o37Ipj6Q001326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960Ab0DGSvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:51:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yong.zhang@windriver.com, hidave.darkstar@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     ratelimit: annotate ___ratelimit()
has been removed from the -mm tree.  Its filename was
     ratelimit-annotate-___ratelimit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ratelimit: annotate ___ratelimit()
From: Yong Zhang <yong.zhang@windriver.com>

To prevent from wrongly using the return value.

[akpm@linux-foundation.org: fix spello]
Signed-off-by: Yong Zhang <yong.zhang@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ratelimit.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN lib/ratelimit.c~ratelimit-annotate-___ratelimit lib/ratelimit.c
--- a/lib/ratelimit.c~ratelimit-annotate-___ratelimit
+++ a/lib/ratelimit.c
@@ -16,9 +16,14 @@
 /*
  * __ratelimit - rate limiting
  * @rs: ratelimit_state data
+ * @func: name of calling function
  *
- * This enforces a rate limit: not more than @rs->ratelimit_burst callbacks
- * in every @rs->ratelimit_jiffies
+ * This enforces a rate limit: not more than @rs->burst callbacks
+ * in every @rs->interval
+ *
+ * RETURNS:
+ * 0 means callbacks will be suppressed.
+ * 1 means go ahead and do it.
  */
 int ___ratelimit(struct ratelimit_state *rs, const char *func)
 {
_

Patches currently in -mm which might be from yong.zhang@windriver.com are

origin.patch


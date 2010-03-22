From: akpm@linux-foundation.org
Subject: + ratelimit-annotate-___ratelimit.patch added to -mm tree
Date: Mon, 22 Mar 2010 13:08:08 -0700
Message-ID: <201003222008.o2MK88Kf024593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754777Ab0CVUIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 16:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yong.zhang@windriver.com, hidave.darkstar@gmail.com, mingo@elte.hu


The patch titled
     ratelimit: annotate ___ratelimit()
has been added to the -mm tree.  Its filename is
     ratelimit-annotate-___ratelimit.patch

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
Subject: ratelimit: annotate ___ratelimit()
From: Yong Zhang <yong.zhang@windriver.com>

To prevent from wrongly using the return value.

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
+ * 0 means callbacks will be suppuressed.
+ * 1 means go ahead and do it.
  */
 int ___ratelimit(struct ratelimit_state *rs, const char *func)
 {
_

Patches currently in -mm which might be from yong.zhang@windriver.com are

ratelimit-annotate-___ratelimit.patch
ratelimit-annotate-___ratelimit-fix.patch
kernelh-fix-wrong-usage-of-__ratelimit.patch
ratelimit-fix-the-return-value-when-__ratelimit-fails-to-acquire-the-lock.patch


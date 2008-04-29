From: akpm@linux-foundation.org
Subject: - isolate-ratelimit-from-printkc-for-other-use-update.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:19:43 -0700
Message-ID: <200804290519.m3T5JhuY002717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753532AbYD2FU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:20:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     isolate-ratelimit-from-printkc-for-other-use update
has been removed from the -mm tree.  Its filename was
     isolate-ratelimit-from-printkc-for-other-use-update.patch

This patch was dropped because it was folded into isolate-ratelimit-from-printkc-for-other-use.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isolate-ratelimit-from-printkc-for-other-use update
From: Dave Young <hidave.darkstar@gmail.com>

On Mon, Mar 10, 2008 at 08:51:32AM -0700, Randy Dunlap wrote:
[snip]
> > +/*
> > + * __ratelimit - rate limiting
> > + * @ratelimit_jiffies: minimum time in jiffies between too callbacks
>
> s/too/two/

will fix

[snip]
> > +		if (lost)
> > +			printk(KERN_WARNING "__ratelimit: %d messages"
> > +				" suppressed.\n", lost);
>
> Would be better not to split the string, e.g.:
>
> 			printk(KERN_WARNING "%s: %d messages suppressed\n",
> 				__func__, lost);
>

Yes, it's better to use __func__

Thanks randy.

Andrew, Could you use the following update? I don't want to bother you,
but...

Thanks.
---

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ratelimit.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/ratelimit.c~isolate-ratelimit-from-printkc-for-other-use-update lib/ratelimit.c
--- a/lib/ratelimit.c~isolate-ratelimit-from-printkc-for-other-use-update
+++ a/lib/ratelimit.c
@@ -13,7 +13,7 @@
 
 /*
  * __ratelimit - rate limiting
- * @ratelimit_jiffies: minimum time in jiffies between too callbacks
+ * @ratelimit_jiffies: minimum time in jiffies between two callbacks
  * @ratelimit_burst: number of callbacks we do before ratelimiting
  *
  * This enforces a rate limit: not more than @ratelimit_burst callbacks
@@ -40,8 +40,8 @@ int __ratelimit(int ratelimit_jiffies, i
 		toks -= ratelimit_jiffies;
 		spin_unlock_irqrestore(&ratelimit_lock, flags);
 		if (lost)
-			printk(KERN_WARNING "__ratelimit: %d messages"
-				" suppressed.\n", lost);
+			printk(KERN_WARNING "%s: %d messages suppressed\n",
+				__func__, lost);
 		return 1;
 	}
 	missed++;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
isolate-ratelimit-from-printkc-for-other-use.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
add-warn_on_secs-macro.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
use-warn_on_secs-in-rcupreempth.patch


From: akpm@linux-foundation.org
Subject: + isolate-ratelimit-from-printkc-for-other-use-update.patch added to -mm tree
Date: Mon, 10 Mar 2008 21:16:17 -0700
Message-ID: <200803110416.m2B4GHGu021697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756428AbYCKEQ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 00:16:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, randy.dunlap@oracle.com


The patch titled
     isolate-ratelimit-from-printkc-for-other-use update
has been added to the -mm tree.  Its filename is
     isolate-ratelimit-from-printkc-for-other-use-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
git-net.patch
isolate-ratelimit-from-printkc-for-other-use.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
add-warn_on_secs-macro.patch
use-warn_on_secs-in-rcupreempth.patch


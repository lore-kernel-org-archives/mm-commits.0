From: akpm@linux-foundation.org
Subject: + clocksource-save-mult_orig-in-clocksource_disable.patch added to -mm tree
Date: Mon, 29 Jun 2009 15:48:22 -0700
Message-ID: <200906292248.n5TMmM71028931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbZF2WtW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 18:49:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@igel.co.jp, johnstul@us.ibm.com, lethal@linux-sh.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     clocksource: save mult_orig in clocksource_disable()
has been added to the -mm tree.  Its filename is
     clocksource-save-mult_orig-in-clocksource_disable.patch

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
Subject: clocksource: save mult_orig in clocksource_disable()
From: Magnus Damm <damm@igel.co.jp>

Save clocksource mult_orig in clocksource_disable().

To fix the common case where ->enable() does not setup mult, make sure
mult_orig is saved in mult on disable.

Also add comments to explain why we do this.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clocksource.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN include/linux/clocksource.h~clocksource-save-mult_orig-in-clocksource_disable include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-save-mult_orig-in-clocksource_disable
+++ a/include/linux/clocksource.h
@@ -293,7 +293,11 @@ static inline int clocksource_enable(str
 	if (cs->enable)
 		ret = cs->enable(cs);
 
-	/* save mult_orig on enable */
+	/* The frequency may have changed while the clocksource
+	 * was disabled. If so the code in ->enable() must update
+	 * the mult value to reflect the new frequency. Make sure
+	 * mult_orig follows this change.
+	 */
 	cs->mult_orig = cs->mult;
 
 	return ret;
@@ -309,6 +313,12 @@ static inline int clocksource_enable(str
  */
 static inline void clocksource_disable(struct clocksource *cs)
 {
+	/* Save mult_orig in mult so clocksource_enable() can
+	 * restore the value regardless if ->enable() updates
+	 * the value of mult or not.
+	 */
+	cs->mult = cs->mult_orig;
+
 	if (cs->disable)
 		cs->disable(cs);
 }
_

Patches currently in -mm which might be from damm@igel.co.jp are

linux-next.patch
clocksource-save-mult_orig-in-clocksource_disable.patch


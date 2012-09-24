From: akpm@linux-foundation.org
Subject: + lib-flex_proportionsc-fix-corruption-of-denominator-in-flexible-proportions.patch added to -mm tree
Date: Mon, 24 Sep 2012 14:21:04 -0700
Message-ID: <20120924212104.B5C2D100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:57628 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2IXVVG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Sep 2012 17:21:06 -0400
Received: by qaea16 with SMTP id a16so182437qae.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Sep 2012 14:21:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, a.p.zijlstra@chello.nl, bp@amd64.org, fengguang.wu@intel.com, srivatsa.bhat@linux.vnet.ibm.com, stable@vger.kernel.org


The patch titled
     Subject: lib/flex_proportions.c: fix corruption of denominator in flexible proportions
has been added to the -mm tree.  Its filename is
     lib-flex_proportionsc-fix-corruption-of-denominator-in-flexible-proportions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: lib/flex_proportions.c: fix corruption of denominator in flexible proportions

When racing with CPU hotplug, percpu_counter_sum() can return negative
values for the number of observed events.  This confuses
fprop_new_period(), which uses unsigned type and as a result number of
events is set to big *positive* number.  From that moment on, things go
pear shaped and can result e.g.  in division by zero as denominator is
later truncated to 32-bits.

Fix the issue by using a signed type in fprop_new_period().  That makes us
bail out from the function without doing anything (mistakenly) thinking
there are no events to age.  That makes aging somewhat inaccurate but
getting accurate data would be rather hard.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Borislav Petkov <bp@amd64.org>
Reported-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/flex_proportions.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/flex_proportions.c~lib-fix-corruption-of-denominator-in-flexible-proportions lib/flex_proportions.c
--- a/lib/flex_proportions.c~lib-fix-corruption-of-denominator-in-flexible-proportions
+++ a/lib/flex_proportions.c
@@ -62,7 +62,7 @@ void fprop_global_destroy(struct fprop_g
  */
 bool fprop_new_period(struct fprop_global *p, int periods)
 {
-	u64 events;
+	s64 events;
 	unsigned long flags;
 
 	local_irq_save(flags);
_

Patches currently in -mm which might be from jack@suse.cz are

lib-flex_proportionsc-fix-corruption-of-denominator-in-flexible-proportions.patch
linux-next.patch


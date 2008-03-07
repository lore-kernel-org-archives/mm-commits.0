From: akpm@linux-foundation.org
Subject: + fix-xt_time_match-never-matches-on-sundays.patch added to -mm tree
Date: Fri, 07 Mar 2008 00:11:51 -0800
Message-ID: <200803070811.m278BpTp012426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453AbYCGIMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 03:12:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrex@alumni.utexas.net, kaber@trash.net


The patch titled
     netfilter: xt_time_match() never matches on Sundays
has been added to the -mm tree.  Its filename is
     fix-xt_time_match-never-matches-on-sundays.patch

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
Subject: netfilter: xt_time_match() never matches on Sundays
From: Andrew Schulman <andrex@alumni.utexas.net>

xt_time_match() in net/netfilter/xt_time.c in kernel 2.6.24 never matches on
Sundays.  On my host I have a rule like

    iptables -A OUTPUT -m time --weekdays Sun -j REJECT

and it never matches.  The problem is in localtime_2(), which uses

    r->weekday = (4 + r->dse) % 7;

to map the epoch day onto a weekday in {0,...,6}.  In particular this gives 0
for Sundays.  But 0 has to be wrong; a weekday of 0 can never match.
xt_time_match() has

    if (!(info->weekdays_match & (1 << current_time.weekday)))
        return false;

and when current_time.weekday = 0, the result of the & is always zero, even when
info->weekdays_match = XT_TIME_ALL_WEEKDAYS = 0xFE.

The solution is to map Sunday onto 7, not 0.

Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/xt_time.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN net/netfilter/xt_time.c~fix-xt_time_match-never-matches-on-sundays net/netfilter/xt_time.c
--- a/net/netfilter/xt_time.c~fix-xt_time_match-never-matches-on-sundays
+++ a/net/netfilter/xt_time.c
@@ -97,6 +97,9 @@ static inline void localtime_2(struct xt
 
 	/* 1970-01-01 (w=0) was a Thursday (4). */
 	r->weekday = (4 + r->dse) % 7;
+	/* Map Sunday onto 7, not 0. */
+	if (r->weekday == 0)
+		r->weekday = 7;
 }
 
 static void localtime_3(struct xtm *r, time_t time)
_

Patches currently in -mm which might be from andrex@alumni.utexas.net are

fix-xt_time_match-never-matches-on-sundays.patch


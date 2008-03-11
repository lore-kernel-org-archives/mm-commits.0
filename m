From: akpm@linux-foundation.org
Subject: - fix-xt_time_match-never-matches-on-sundays.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:22:56 -0700
Message-ID: <200803110322.m2B3Mu2Q019859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717AbYCKDXD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:23:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrex@alumni.utexas.net, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     netfilter: xt_time_match() never matches on Sundays
has been removed from the -mm tree.  Its filename was
     fix-xt_time_match-never-matches-on-sundays.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-net.patch


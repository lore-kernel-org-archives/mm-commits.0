From: akpm@linux-foundation.org
Subject: + rcu-remove-unused-field-struct-rcu_data-rcu_tasklet.patch added to -mm tree
Date: Mon, 19 May 2008 14:57:44 -0700
Message-ID: <200805192157.m4JLvi8f022627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764333AbYESV63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:58:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, paulmck@us.ibm.com


The patch titled
     rcu: remove unused field struct rcu_data::rcu_tasklet
has been added to the -mm tree.  Its filename is
     rcu-remove-unused-field-struct-rcu_data-rcu_tasklet.patch

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
Subject: rcu: remove unused field struct rcu_data::rcu_tasklet
From: Lai Jiangshan <laijs@cn.fujitsu.com>

Since softirq works for rcu reclaimer, rcu_tasklet is unused now.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcupreempt.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/rcupreempt.c~rcu-remove-unused-field-struct-rcu_data-rcu_tasklet kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~rcu-remove-unused-field-struct-rcu_data-rcu_tasklet
+++ a/kernel/rcupreempt.c
@@ -81,7 +81,6 @@ struct rcu_data {
 	spinlock_t	lock;		/* Protect rcu_data fields. */
 	long		completed;	/* Number of last completed batch. */
 	int		waitlistcount;
-	struct tasklet_struct rcu_tasklet;
 	struct rcu_head *nextlist;
 	struct rcu_head **nexttail;
 	struct rcu_head *waitlist[GP_STAGES];
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

rcu-remove-unused-field-struct-rcu_data-rcu_tasklet.patch


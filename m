From: akpm@linux-foundation.org
Subject: - rcu-remove-unused-field-struct-rcu_data-rcu_tasklet.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:02:21 -0700
Message-ID: <200806232102.m5NL2LcI016067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759582AbYFWVC2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:02:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rcu: remove unused field struct rcu_data::rcu_tasklet
has been removed from the -mm tree.  Its filename was
     rcu-remove-unused-field-struct-rcu_data-rcu_tasklet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -82,7 +82,6 @@ struct rcu_data {
 	spinlock_t	lock;		/* Protect rcu_data fields. */
 	long		completed;	/* Number of last completed batch. */
 	int		waitlistcount;
-	struct tasklet_struct rcu_tasklet;
 	struct rcu_head *nextlist;
 	struct rcu_head **nexttail;
 	struct rcu_head *waitlist[GP_STAGES];
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch


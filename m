From: akpm@osdl.org
Subject: - add-sparse-annotations-to-srcu-wrapper-functions-in-rcutorture.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:21 -0800
Message-ID: <200612072316.kB7NGLOB030822@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53678 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163803AbWLGXQv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:16:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@freedesktop.org, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Add Sparse annotations to SRCU wrapper functions in rcutorture
has been removed from the -mm tree.  Its filename was
     add-sparse-annotations-to-srcu-wrapper-functions-in-rcutorture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add Sparse annotations to SRCU wrapper functions in rcutorture
From: Josh Triplett <josh@freedesktop.org>

The SRCU wrapper functions srcu_torture_read_lock and srcu_torture_read_u=
nlock in rcutorture intentionally change the SRCU context; annotate them
accordingly, to avoid a warning.

Signed-off-by: Josh Triplett <josh@freedesktop.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/rcutorture.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/rcutorture.c~add-sparse-annotations-to-srcu-wrapper-functions-in-rcutorture kernel/rcutorture.c
--- a/kernel/rcutorture.c~add-sparse-annotations-to-srcu-wrapper-functions-in-rcutorture
+++ a/kernel/rcutorture.c
@@ -401,7 +401,7 @@ static void srcu_torture_cleanup(void)
 	cleanup_srcu_struct(&srcu_ctl);
 }
 
-static int srcu_torture_read_lock(void)
+static int srcu_torture_read_lock(void) __acquires(&srcu_ctl)
 {
 	return srcu_read_lock(&srcu_ctl);
 }
@@ -419,7 +419,7 @@ static void srcu_read_delay(struct rcu_r
 		schedule_timeout_interruptible(longdelay);
 }
 
-static void srcu_torture_read_unlock(int idx)
+static void srcu_torture_read_unlock(int idx) __releases(&srcu_ctl)
 {
 	srcu_read_unlock(&srcu_ctl, idx);
 }
_

Patches currently in -mm which might be from josh@freedesktop.org are

origin.patch


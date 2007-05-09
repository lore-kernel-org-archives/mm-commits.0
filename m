From: akpm@linux-foundation.org
Subject: - rcutorture-mark-rcu_torture_init-as-__init.patch removed from -mm tree
Date: Tue, 08 May 2007 19:45:39 -0700
Message-ID: <200705090245.l492jdoW008761@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031543AbXEICpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@freedesktop.org, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rcutorture: Mark rcu_torture_init as __init
has been removed from the -mm tree.  Its filename was
     rcutorture-mark-rcu_torture_init-as-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rcutorture: Mark rcu_torture_init as __init
From: Josh Triplett <josh@freedesktop.org>

The corresponding rcu_torture_cleanup cannot get marked as __exit, because
rcu_torture_init uses it to clean up if init fails.

Signed-off-by: Josh Triplett <josh@freedesktop.org>
Acked-by: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/rcutorture.c~rcutorture-mark-rcu_torture_init-as-__init kernel/rcutorture.c
--- a/kernel/rcutorture.c~rcutorture-mark-rcu_torture_init-as-__init
+++ a/kernel/rcutorture.c
@@ -866,7 +866,7 @@ rcu_torture_cleanup(void)
 		rcu_torture_print_module_parms("End of test: SUCCESS");
 }
 
-static int
+static int __init
 rcu_torture_init(void)
 {
 	int i;
_

Patches currently in -mm which might be from josh@freedesktop.org are

origin.patch

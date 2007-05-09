From: akpm@linux-foundation.org
Subject: - rcutorture-use-array_size-macro-when-appropriate.patch removed from -mm tree
Date: Tue, 08 May 2007 19:53:49 -0700
Message-ID: <200705090253.l492rnfF009737@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032231AbXEICxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:53:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rcutorture: Use ARRAY_SIZE macro when appropriate
has been removed from the -mm tree.  Its filename was
     rcutorture-use-array_size-macro-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rcutorture: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/rcutorture.c~rcutorture-use-array_size-macro-when-appropriate kernel/rcutorture.c
--- a/kernel/rcutorture.c~rcutorture-use-array_size-macro-when-appropriate
+++ a/kernel/rcutorture.c
@@ -899,7 +899,7 @@ rcu_torture_init(void)
 	/* Set up the freelist. */
 
 	INIT_LIST_HEAD(&rcu_torture_freelist);
-	for (i = 0; i < sizeof(rcu_tortures) / sizeof(rcu_tortures[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(rcu_tortures); i++) {
 		rcu_tortures[i].rtort_mbtest = 0;
 		list_add_tail(&rcu_tortures[i].rtort_free,
 			      &rcu_torture_freelist);
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-kvm.patch
git-e1000.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch

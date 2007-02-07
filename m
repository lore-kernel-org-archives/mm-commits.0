From: akpm@linux-foundation.org
Subject: + rcutorture-remove-redundant-assignment-to-cur_ops-in.patch added to -mm tree
Date: Wed, 07 Feb 2007 15:18:37 -0800
Message-ID: <200702072318.l17NIbHQ030884@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44824 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422796AbXBGXUS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 18:20:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh@kernel.org, paulmck@us.ibm.com


The patch titled
     rcutorture: Remove redundant assignment to cur_ops in for loop
has been added to the -mm tree.  Its filename is
     rcutorture-remove-redundant-assignment-to-cur_ops-in.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rcutorture: Remove redundant assignment to cur_ops in for loop
From: Josh Triplett <josh@kernel.org>

The for loop in rcutorture_init uses the condition
cur_ops = torture_ops[i], cur_ops
but then makes the same assignment to cur_ops inside the loop.  Remove the
redundant assignment inside the loop, and remove now-unnecessary braces.

Signed-off-by: Josh Triplett <josh@kernel.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff -puN kernel/rcutorture.c~rcutorture-remove-redundant-assignment-to-cur_ops-in kernel/rcutorture.c
--- a/kernel/rcutorture.c~rcutorture-remove-redundant-assignment-to-cur_ops-in
+++ a/kernel/rcutorture.c
@@ -942,12 +942,9 @@ rcu_torture_init(void)
 
 	/* Process args and tell the world that the torturer is on the job. */
 
-	for (i = 0; cur_ops = torture_ops[i], cur_ops; i++) {
-		cur_ops = torture_ops[i];
-		if (strcmp(torture_type, cur_ops->name) == 0) {
+	for (i = 0; cur_ops = torture_ops[i], cur_ops; i++)
+		if (strcmp(torture_type, cur_ops->name) == 0)
 			break;
-		}
-	}
 	if (cur_ops == NULL) {
 		printk(KERN_ALERT "rcutorture: invalid torture type: \"%s\"\n",
 		       torture_type);
_

Patches currently in -mm which might be from josh@kernel.org are

usb-in-init_endpoint_class-use-ptr_err-to-obtain-an-errno-value-not-is_err.patch
rcutorture-style-cleanup-avoid-=-null-in-boolean-tests.patch
rcutorture-remove-redundant-assignment-to-cur_ops-in.patch

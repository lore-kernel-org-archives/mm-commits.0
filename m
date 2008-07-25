From: akpm@linux-foundation.org
Subject: - idr-fix-a-printk-call.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:39 -0700
Message-ID: <200807252300.m6PN0dop003603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352AbYGYXCw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, paulmck@us.ibm.com, peifferp@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     idr: fix a printk call
has been removed from the -mm tree.  Its filename was
     idr-fix-a-printk-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: fix a printk call
From: Nadia Derbey <Nadia.Derbey@bull.net>

Fix the incomplete printk call.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Reviewed-by: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/idr.c~idr-fix-a-printk-call lib/idr.c
--- a/lib/idr.c~idr-fix-a-printk-call
+++ a/lib/idr.c
@@ -326,7 +326,8 @@ EXPORT_SYMBOL(idr_get_new);
 
 static void idr_remove_warning(int id)
 {
-	printk("idr_remove called for id=%d which is not allocated.\n", id);
+	printk(KERN_WARNING
+		"idr_remove called for id=%d which is not allocated.\n", id);
 	dump_stack();
 }
 
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch


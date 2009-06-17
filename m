From: akpm@linux-foundation.org
Subject: [merged] documentation-atomic_opstxt-fix-sample-code.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:49 -0700
Message-ID: <200906171837.n5HIbnLO003795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbZFQSpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: figo1802@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/atomic_ops.txt: fix sample code
has been removed from the -mm tree.  Its filename was
     documentation-atomic_opstxt-fix-sample-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/atomic_ops.txt: fix sample code
From: "Figo.zhang" <figo1802@gmail.com>

list_add() lost a parameter in sample code.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/atomic_ops.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/atomic_ops.txt~documentation-atomic_opstxt-fix-sample-code Documentation/atomic_ops.txt
--- a/Documentation/atomic_ops.txt~documentation-atomic_opstxt-fix-sample-code
+++ a/Documentation/atomic_ops.txt
@@ -229,10 +229,10 @@ kernel.  It is the use of atomic counter
 counting, and it works such that once the counter falls to zero it can
 be guaranteed that no other entity can be accessing the object:
 
-static void obj_list_add(struct obj *obj)
+static void obj_list_add(struct obj *obj, struct list_head *head)
 {
 	obj->active = 1;
-	list_add(&obj->list);
+	list_add(&obj->list, head);
 }
 
 static void obj_list_del(struct obj *obj)
_

Patches currently in -mm which might be from figo1802@gmail.com are

origin.patch
linux-next.patch


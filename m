From: akpm@linux-foundation.org
Subject: + documentation-atomic_opstxt-fix-sample-code.patch added to -mm tree
Date: Mon, 01 Jun 2009 21:19:21 -0700
Message-ID: <200906020419.n524JLC4029943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbZFBETV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 00:19:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: figo1802@gmail.com


The patch titled
     Documentation/atomic_ops.txt: fix sample code
has been added to the -mm tree.  Its filename is
     documentation-atomic_opstxt-fix-sample-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

documentation-atomic_opstxt-fix-sample-code.patch


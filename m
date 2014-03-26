From: akpm@linux-foundation.org
Subject: + lib-idrc-use-rcu_init_pointerx-null.patch added to -mm tree
Date: Wed, 26 Mar 2014 15:56:10 -0700
Message-ID: <53335b0a.su4RnzuDQysccxs1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaCZW4L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Mar 2014 18:56:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, monamagarwal123@gmail.com

Subject: + lib-idrc-use-rcu_init_pointerx-null.patch added to -mm tree
To: monamagarwal123@gmail.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 26 Mar 2014 15:56:10 -0700


The patch titled
     Subject: lib/idr.c: use RCU_INIT_POINTER(x, NULL)
has been added to the -mm tree.  Its filename is
     lib-idrc-use-rcu_init_pointerx-null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-idrc-use-rcu_init_pointerx-null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-idrc-use-rcu_init_pointerx-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Monam Agarwal <monamagarwal123@gmail.com>
Subject: lib/idr.c: use RCU_INIT_POINTER(x, NULL)

Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure is
carried out before storing a pointer to that structure.  And in the case
of the NULL pointer, there is no structure to initialize.  So,
rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p,
NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/idr.c~lib-idrc-use-rcu_init_pointerx-null lib/idr.c
--- a/lib/idr.c~lib-idrc-use-rcu_init_pointerx-null
+++ a/lib/idr.c
@@ -533,7 +533,7 @@ static void sub_remove(struct idr *idp,
 	n = id & IDR_MASK;
 	if (likely(p != NULL && test_bit(n, p->bitmap))) {
 		__clear_bit(n, p->bitmap);
-		rcu_assign_pointer(p->ary[n], NULL);
+		RCU_INIT_POINTER(p->ary[n], NULL);
 		to_free = NULL;
 		while(*paa && ! --((**paa)->count)){
 			if (to_free)
@@ -602,7 +602,7 @@ static void __idr_remove_all(struct idr
 
 	n = idp->layers * IDR_BITS;
 	p = idp->top;
-	rcu_assign_pointer(idp->top, NULL);
+	RCU_INIT_POINTER(idp->top, NULL);
 	max = idr_max(idp->layers);
 
 	id = 0;
_

Patches currently in -mm which might be from monamagarwal123@gmail.com are

checkpatch-make-return-is-not-a-function-test-quieter.patch
lib-idrc-use-rcu_init_pointerx-null.patch
linux-next.patch


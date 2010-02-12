From: akpm@linux-foundation.org
Subject: + idr-fix-a-critical-misallocation-bug-take2.patch added to -mm tree
Date: Fri, 12 Feb 2010 11:59:07 -0800
Message-ID: <201002121959.o1CJx8kK023581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757511Ab0BLUAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 15:00:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, eparis@redhat.com, s.l-h@gmx.de, serue@us.ibm.com


The patch titled
     From: Tejun Heo <tj@kernel.org>
has been added to the -mm tree.  Its filename is
     idr-fix-a-critical-misallocation-bug-take2.patch

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
Subject: From: Tejun Heo <tj@kernel.org>


This is retry of reverted 859ddf09743a8cc680af33f7259ccd0fd36bfe9d ("idr:
fix a critical misallocation bug") which contained two bugs.

* pa[idp->layers] should be cleared even if it's not used by
  sub_alloc() because it's used by mark idr_mark_full().

* The original condition check also assigned pa[l] to p which the new
  code didn't do thus leaving p pointing at the wrong layer.

Both problems have been fixed and the idr code has received good amount
testing using userland testing setup where simple bitmap allocator is run
parallel to verify the result of idr allocation.

The bug this patch fixes is caused by sub_alloc() optimization path
bypassing out-of-room condition check and restarting allocation loop with
starting value higher than maximum allowed value.  For detailed
description, please read commit message of 859ddf09.

Signed-off-by: Tejun Heo <tj@kernel.org>
Based-on-patch-from: Eric Paris <eparis@redhat.com>
Reported-by: Eric Paris <eparis@redhat.com>
Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Tested-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN lib/idr.c~idr-fix-a-critical-misallocation-bug-take2 lib/idr.c
--- a/lib/idr.c~idr-fix-a-critical-misallocation-bug-take2
+++ a/lib/idr.c
@@ -156,10 +156,12 @@ static int sub_alloc(struct idr *idp, in
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
 
 			/* if already at the top layer, we need to grow */
-			if (!(p = pa[l])) {
+			if (id >= 1 << (idp->layers * IDR_BITS)) {
 				*starting_id = id;
 				return IDR_NEED_TO_GROW;
 			}
+			p = pa[l];
+			BUG_ON(!p);
 
 			/* If we need to go up one layer, continue the
 			 * loop; otherwise, restart from the top.
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
idr-fix-a-critical-misallocation-bug-take2.patch
driver-core-fix-race-condition-in-get_device_parent.patch
core-workqueue-return-on-workqueue-recursion.patch


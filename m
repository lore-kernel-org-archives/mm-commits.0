From: akpm@linux-foundation.org
Subject: + idr-reduce-the-unneeded-check-in-free_layer.patch added to -mm
 tree
Date: Tue, 22 Apr 2014 12:40:48 -0700
Message-ID: <5356c5c0.9EskdFx9UGIkN9yc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbaDVTkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 15:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: + idr-reduce-the-unneeded-check-in-free_layer.patch added to -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 12:40:48 -0700


The patch titled
     Subject: idr: reduce the unneeded check in free_layer()
has been added to the -mm tree.  Its filename is
     idr-reduce-the-unneeded-check-in-free_layer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/idr-reduce-the-unneeded-check-in-free_layer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/idr-reduce-the-unneeded-check-in-free_layer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: idr: reduce the unneeded check in free_layer()

If "idr->hint == p" is true, it also implies "idr->hint" is true(not NULL).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/idr.c~idr-reduce-the-unneeded-check-in-free_layer lib/idr.c
--- a/lib/idr.c~idr-reduce-the-unneeded-check-in-free_layer
+++ a/lib/idr.c
@@ -145,7 +145,7 @@ static void idr_layer_rcu_free(struct rc
 
 static inline void free_layer(struct idr *idr, struct idr_layer *p)
 {
-	if (idr->hint && idr->hint == p)
+	if (idr->hint == p)
 		RCU_INIT_POINTER(idr->hint, NULL);
 	call_rcu(&p->rcu_head, idr_layer_rcu_free);
 }
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
idr-fix-overflow-bug-during-maximum-id-calculation-at-maximum-height.patch
idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch
idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch
idr-fix-idr_replaces-returned-error-code.patch
idr-dont-need-to-shink-the-free-list-when-idr_remove.patch
idr-reduce-the-unneeded-check-in-free_layer.patch
linux-next.patch


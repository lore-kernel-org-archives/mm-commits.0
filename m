From: akpm@linux-foundation.org
Subject: + idr-fix-idr_replaces-returned-error-code.patch added to -mm
 tree
Date: Tue, 22 Apr 2014 12:40:46 -0700
Message-ID: <5356c5be.OFnkhT7+0LsF7YVh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbaDVTkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 15:40:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: + idr-fix-idr_replaces-returned-error-code.patch added to -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 12:40:46 -0700


The patch titled
     Subject: idr: fix idr_replace()'s returned error code
has been added to the -mm tree.  Its filename is
     idr-fix-idr_replaces-returned-error-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/idr-fix-idr_replaces-returned-error-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/idr-fix-idr_replaces-returned-error-code.patch

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
Subject: idr: fix idr_replace()'s returned error code

When the smaller id is not found, idr_replace() returns -ENOENT.  But when
the id is bigger enough, idr_replace() returns -EINVAL, actually there is
no difference between these two kinds of ids.

These are all unallocated id, the return values of the idr_replace() for
these ids should be the same: -ENOENT.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/idr.c~idr-fix-idr_replaces-returned-error-code lib/idr.c
--- a/lib/idr.c~idr-fix-idr_replaces-returned-error-code
+++ a/lib/idr.c
@@ -814,10 +814,10 @@ void *idr_replace(struct idr *idp, void
 
 	p = idp->top;
 	if (!p)
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR(-ENOENT);
 
 	if (id > idr_max(p->layer + 1))
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR(-ENOENT);
 
 	n = p->layer * IDR_BITS;
 	while ((n > 0) && p) {
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


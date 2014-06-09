From: akpm@linux-foundation.org
Subject: [merged] idr-fix-idr_replaces-returned-error-code.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:35:12 -0700
Message-ID: <53960c70.jkOaMx71xCQEk/6E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaFITfM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:35:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: [merged] idr-fix-idr_replaces-returned-error-code.patch removed from -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:35:12 -0700


The patch titled
     Subject: idr: fix idr_replace()'s returned error code
has been removed from the -mm tree.  Its filename was
     idr-fix-idr_replaces-returned-error-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch


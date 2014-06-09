From: akpm@linux-foundation.org
Subject: [merged] idr-reduce-the-unneeded-check-in-free_layer.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:35:22 -0700
Message-ID: <53960c7a.xoxAUzPiJkMHsw+9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaFITfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:35:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: [merged] idr-reduce-the-unneeded-check-in-free_layer.patch removed from -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:35:22 -0700


The patch titled
     Subject: idr: reduce the unneeded check in free_layer()
has been removed from the -mm tree.  Its filename was
     idr-reduce-the-unneeded-check-in-free_layer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch


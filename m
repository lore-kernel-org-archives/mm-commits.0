From: akpm@linux-foundation.org
Subject: [merged]
 frontswap-enable-call-to-invalidate-area-on-swapoff.patch removed from -mm
 tree
Date: Wed, 13 Nov 2013 12:38:42 -0800
Message-ID: <5283e352.JxOY8YcchQ0OEShG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3KMUin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, shli@fusionio.com, minchan@kernel.org, konrad.wilk@oracle.com, k.kozlowski@samsung.com

Subject: [merged] frontswap-enable-call-to-invalidate-area-on-swapoff.patch removed from -mm tree
To: k.kozlowski@samsung.com,konrad.wilk@oracle.com,minchan@kernel.org,shli@fusionio.com,sjenning@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:42 -0800


The patch titled
     Subject: frontswap: enable call to invalidate area on swapoff
has been removed from the -mm tree.  Its filename was
     frontswap-enable-call-to-invalidate-area-on-swapoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: frontswap: enable call to invalidate area on swapoff

During swapoff the frontswap_map was NULL-ified before calling
frontswap_invalidate_area().  However the frontswap_invalidate_area()
exits early if frontswap_map is NULL.  Invalidate was never called during
swapoff.

This patch moves frontswap_map_set() in swapoff just after calling
frontswap_invalidate_area() so outside of locks (swap_lock and
swap_info_struct->lock).  This shouldn't be a problem as during swapon the
frontswap_map_set() is called also outside of any locks.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~frontswap-enable-call-to-invalidate-area-on-swapoff mm/swapfile.c
--- a/mm/swapfile.c~frontswap-enable-call-to-invalidate-area-on-swapoff
+++ a/mm/swapfile.c
@@ -1924,10 +1924,10 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	p->cluster_info = NULL;
 	p->flags = 0;
 	frontswap_map = frontswap_map_get(p);
-	frontswap_map_set(p, NULL);
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	frontswap_invalidate_area(type);
+	frontswap_map_set(p, NULL);
 	mutex_unlock(&swapon_mutex);
 	free_percpu(p->percpu_cluster);
 	p->percpu_cluster = NULL;
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

origin.patch
swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch


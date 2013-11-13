From: akpm@linux-foundation.org
Subject: [merged]
 revert-mm-vmallocc-emit-the-failure-message-before-return.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:38:20 -0800
Message-ID: <5283e33c.bNliBLDaAfm2C75E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3KMUiV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, rientjes@google.com, mitsuo.hayasaka.hu@hitachi.com, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, liwanp@linux.vnet.ibm.com

Subject: [merged] revert-mm-vmallocc-emit-the-failure-message-before-return.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,mitsuo.hayasaka.hu@hitachi.com,rientjes@google.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:20 -0800


The patch titled
     Subject: revert mm/vmalloc.c: emit the failure message before return
has been removed from the -mm tree.  Its filename was
     revert-mm-vmallocc-emit-the-failure-message-before-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: revert mm/vmalloc.c: emit the failure message before return

Don't warn twice in __vmalloc_area_node and __vmalloc_node_range if
__vmalloc_area_node allocation failure.  This patch reverts commit
46c001a2 ("mm/vmalloc.c: emit the failure message before return").

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~revert-mm-vmallocc-emit-the-failure-message-before-return mm/vmalloc.c
--- a/mm/vmalloc.c~revert-mm-vmallocc-emit-the-failure-message-before-return
+++ a/mm/vmalloc.c
@@ -1635,7 +1635,7 @@ void *__vmalloc_node_range(unsigned long
 
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node);
 	if (!addr)
-		goto fail;
+		return NULL;
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch


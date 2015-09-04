From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-kthreadc-kthread_create_on_node-clarify-documentation-fix.patch
 removed from -mm tree
Date: Fri, 04 Sep 2015 15:23:17 -0700
Message-ID: <55ea19d5.lXFJR1tSAlX/R91q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760578AbbIDWXS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:23:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, edumazet@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-kthreadc-kthread_create_on_node-clarify-documentation-fix
has been removed from the -mm tree.  Its filename was
     kernel-kthreadc-kthread_create_on_node-clarify-documentation-fix.patch

This patch was dropped because it was folded into kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: kernel-kthreadc-kthread_create_on_node-clarify-documentation-fix

use NUMA_NO_NODE in kthread_create() also

Cc: Tejun Heo <tj@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kthread.h~kernel-kthreadc-kthread_create_on_node-clarify-documentation-fix include/linux/kthread.h
--- a/include/linux/kthread.h~kernel-kthreadc-kthread_create_on_node-clarify-documentation-fix
+++ a/include/linux/kthread.h
@@ -11,7 +11,7 @@ struct task_struct *kthread_create_on_no
 					   const char namefmt[], ...);
 
 #define kthread_create(threadfn, data, namefmt, arg...) \
-	kthread_create_on_node(threadfn, data, -1, namefmt, ##arg)
+	kthread_create_on_node(threadfn, data, NUMA_NO_NODE, namefmt, ##arg)
 
 
 struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
_

Patches currently in -mm which might be from nzimmer@sgi.com are

kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch


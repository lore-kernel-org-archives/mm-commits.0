From: akpm@linux-foundation.org
Subject: +
 kernel-kthreadc-kthread_create_on_node-clarify-documentation-fix.patch
 added to -mm tree
Date: Fri, 10 Jul 2015 14:20:24 -0700
Message-ID: <55a03718.JoA2Cp2O/UsGR6QC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579AbbGJVUZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jul 2015 17:20:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, edumazet@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-kthreadc-kthread_create_on_node-clarify-documentation-fix
has been added to the -mm tree.  Its filename is
     kernel-kthreadc-kthread_create_on_node-clarify-documentation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-kthreadc-kthread_create_on_node-clarify-documentation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-kthreadc-kthread_create_on_node-clarify-documentation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
kernel-kthreadc-kthread_create_on_node-clarify-documentation-fix.patch


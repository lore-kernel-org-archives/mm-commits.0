From: akpm@linux-foundation.org
Subject: [merged] kthread-add-kerneldoc-for-kthread_create.patch removed
 from -mm tree
Date: Wed, 12 Oct 2016 12:26:33 -0700
Message-ID: <57fe8e69.kKkFkNxrCtw1XI4l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755896AbcJLT1k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, mchehab@s-opensource.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: add kerneldoc for kthread_create()
has been removed from the -mm tree.  Its filename was
     kthread-add-kerneldoc-for-kthread_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jonathan Corbet <corbet@lwn.net>
Subject: kthread: add kerneldoc for kthread_create()

This macro is referenced in other kerneldoc comments, but lacks one of its
own; fix that.

Link: http://lkml.kernel.org/r/20160826072313.726a3485@lwn.net
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Reported-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN include/linux/kthread.h~kthread-add-kerneldoc-for-kthread_create include/linux/kthread.h
--- a/include/linux/kthread.h~kthread-add-kerneldoc-for-kthread_create
+++ a/include/linux/kthread.h
@@ -10,6 +10,17 @@ struct task_struct *kthread_create_on_no
 					   int node,
 					   const char namefmt[], ...);
 
+/**
+ * kthread_create - create a kthread on the current node
+ * @threadfn: the function to run in the thread
+ * @data: data pointer for @threadfn()
+ * @namefmt: printf-style format string for the thread name
+ * @...: arguments for @namefmt.
+ *
+ * This macro will create a kthread on the current node, leaving it in
+ * the stopped state.  This is just a helper for kthread_create_on_node();
+ * see the documentation there for more details.
+ */
 #define kthread_create(threadfn, data, namefmt, arg...) \
 	kthread_create_on_node(threadfn, data, NUMA_NO_NODE, namefmt, ##arg)
 
_

Patches currently in -mm which might be from corbet@lwn.net are



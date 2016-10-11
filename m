From: akpm@linux-foundation.org
Subject: [patch 098/102] kthread: add kerneldoc for kthread_create()
Date: Tue, 11 Oct 2016 13:55:53 -0700
Message-ID: <57fd51d9.uZ+Q1BmGH7jjaQFE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38494 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752909AbcJKU5Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:57:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, mchehab@s-opensource.com

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

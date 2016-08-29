From: akpm@linux-foundation.org
Subject: + kthread-add-kerneldoc-for-kthread_create.patch added to -mm
 tree
Date: Mon, 29 Aug 2016 14:55:04 -0700
Message-ID: <57c4af38.sa6kNhniGP/tc7fa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38188 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754688AbcH2WCE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 18:02:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, mchehab@s-opensource.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: add kerneldoc for kthread_create()
has been added to the -mm tree.  Its filename is
     kthread-add-kerneldoc-for-kthread_create.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kthread-add-kerneldoc-for-kthread_create.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kthread-add-kerneldoc-for-kthread_create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kthread-add-kerneldoc-for-kthread_create.patch


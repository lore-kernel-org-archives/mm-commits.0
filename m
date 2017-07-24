From: akpm@linux-foundation.org
Subject: + kthread-fix-documentation-build-warning.patch added to -mm tree
Date: Mon, 24 Jul 2017 15:34:48 -0700
Message-ID: <59767608.auMOrzY0lNJLEUOB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752785AbdGXWet (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2017 18:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: fix documentation build warning
has been added to the -mm tree.  Its filename is
     kthread-fix-documentation-build-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kthread-fix-documentation-build-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kthread-fix-documentation-build-warning.patch

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
Subject: kthread: fix documentation build warning

The kerneldoc comment for kthread_create() had an incorrect argument name,
leading to a warning in the docs build.  Correct it, and make one more
small step toward a warning-free build.

Link: http://lkml.kernel.org/r/20170724135916.7f486c6f@lwn.net
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kthread.h~kthread-fix-documentation-build-warning include/linux/kthread.h
--- a/include/linux/kthread.h~kthread-fix-documentation-build-warning
+++ a/include/linux/kthread.h
@@ -15,7 +15,7 @@ struct task_struct *kthread_create_on_no
  * @threadfn: the function to run in the thread
  * @data: data pointer for @threadfn()
  * @namefmt: printf-style format string for the thread name
- * @...: arguments for @namefmt.
+ * @arg...: arguments for @namefmt.
  *
  * This macro will create a kthread on the current node, leaving it in
  * the stopped state.  This is just a helper for kthread_create_on_node();
_

Patches currently in -mm which might be from corbet@lwn.net are

kthread-fix-documentation-build-warning.patch


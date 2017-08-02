From: akpm@linux-foundation.org
Subject: [patch 06/16] kthread: fix documentation build warning
Date: Wed, 02 Aug 2017 13:32:01 -0700
Message-ID: <598236c1.N9XKmuDzCEkf4/J6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45974 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752986AbdHBUcC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:32:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, rdunlap@infradead.org

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

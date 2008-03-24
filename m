From: akpm@linux-foundation.org
Subject: + in_atomic-document-why-it-is-unsuitable-for-general-use.patch added to -mm tree
Date: Mon, 24 Mar 2008 16:35:48 -0700
Message-ID: <200803242335.m2ONZmvw031071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482AbYCXXgX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 19:36:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: corbet@lwn.net


The patch titled
     in_atomic(): document why it is unsuitable for general use
has been added to the -mm tree.  Its filename is
     in_atomic-document-why-it-is-unsuitable-for-general-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: in_atomic(): document why it is unsuitable for general use
From: Jonathan Corbet <corbet@lwn.net>

Discourage people from inappropriately using in_atomic()

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hardirq.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/hardirq.h~in_atomic-document-why-it-is-unsuitable-for-general-use include/linux/hardirq.h
--- a/include/linux/hardirq.h~in_atomic-document-why-it-is-unsuitable-for-general-use
+++ a/include/linux/hardirq.h
@@ -72,6 +72,13 @@
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
 
+/*
+ * Are we running in atomic context?  WARNING: this macro cannot
+ * always detect atomic context; in particular, it cannot know about
+ * held spinlocks in non-preemptible kernels.  Thus it should not be
+ * used in the general case to determine whether sleeping is possible.
+ * Do not use in_atomic() in driver code.
+ */
 #define in_atomic()		((preempt_count() & ~PREEMPT_ACTIVE) != 0)
 
 #ifdef CONFIG_PREEMPT
_

Patches currently in -mm which might be from corbet@lwn.net are

smackfs-remove-redundant-lock-fix-openo_rdwr.patch
documentation-patch-tags-one-more-time.patch
in_atomic-document-why-it-is-unsuitable-for-general-use.patch


From: akpm@linux-foundation.org
Subject: + documentation-connector-cn_testc-comment-unused-cn_test_want_notify.patch added to -mm tree
Date: Wed, 27 May 2009 16:04:58 -0700
Message-ID: <200905272304.n4RN4wEb018888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752469AbZE0XGU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 19:06:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, jaswinderrajput@gmail.com, zbr@ioremap.net


The patch titled
     Documentation/connector/cn_test.c comment unused cn_test_want_notify()
has been added to the -mm tree.  Its filename is
     documentation-connector-cn_testc-comment-unused-cn_test_want_notify.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/connector/cn_test.c comment unused cn_test_want_notify()
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Currently cn_test_want_notify() has no user.

So add an ifdef and a comment which tells us to not remove it.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/connector/cn_test.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/connector/cn_test.c~documentation-connector-cn_testc-comment-unused-cn_test_want_notify Documentation/connector/cn_test.c
--- a/Documentation/connector/cn_test.c~documentation-connector-cn_testc-comment-unused-cn_test_want_notify
+++ a/Documentation/connector/cn_test.c
@@ -41,6 +41,12 @@ void cn_test_callback(void *data)
 	       msg->seq, msg->ack, msg->len, (char *)msg->data);
 }
 
+/*
+ * Do not remove this function even if no one is using it as
+ * this is an example of how to get notifications about new
+ * connector user registration
+ */
+#if 0
 static int cn_test_want_notify(void)
 {
 	struct cn_ctl_msg *ctl;
@@ -117,6 +123,7 @@ nlmsg_failure:
 	kfree_skb(skb);
 	return -EINVAL;
 }
+#endif
 
 static u32 cn_test_timer_counter;
 static void cn_test_timer_func(unsigned long __data)
_

Patches currently in -mm which might be from jaswinder@kernel.org are

linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
documentation-accounting-getdelaysc-intialize-the-variable-before-using-it.patch
documentation-connector-cn_testc-comment-unused-cn_test_want_notify.patch
sysctlc-remove-unused-variable.patch


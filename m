From: akpm@linux-foundation.org
Subject: [merged] documentation-connector-cn_testc-comment-unused-cn_test_want_notify.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:45:13 -0700
Message-ID: <200906182245.n5IMjDHM004279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758230AbZFRW6t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, jaswinderrajput@gmail.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Documentation/connector/cn_test.c comment unused cn_test_want_notify()
has been removed from the -mm tree.  Its filename was
     documentation-connector-cn_testc-comment-unused-cn_test_want_notify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
x86-apic-io_apicc-dmar_msi_type-should-be-static.patch


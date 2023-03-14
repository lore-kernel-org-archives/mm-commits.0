Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 902FAC6FD1F
	for <mm-commits@archiver.kernel.org>; Tue, 14 Mar 2023 20:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjCNUuc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Mar 2023 16:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjCNUub (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2023 16:50:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A6C244B8
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 13:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF80D619D7
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 20:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C774C433D2;
        Tue, 14 Mar 2023 20:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678827029;
        bh=Auvx/W0VDy6PNe/+IVLd3O8NI8QlK2rnJoctTjQLjeI=;
        h=Date:To:From:Subject:From;
        b=xNaRAcyAj4blz3z2s9gw2jH61QBV/JcatJD/qnX+IwWES8cEcWuQWxV4vAbKq0/Lj
         5f1+xLnXG0n6l3M6fVfQRrddUej+ExroxeOLTtmGYDITGSr8qLbcZNwOkPJKg4r3vm
         LrNSsOEwv29M8Xq1MifGI4WNEGTIluUrvOUnD+Tg=
Date:   Tue, 14 Mar 2023 13:50:28 -0700
To:     mm-commits@vger.kernel.org, xiyou.wangcong@gmail.com,
        valentin.schneider@arm.com, rostedt@goodmis.org,
        rafael.j.wysocki@intel.com, pmladek@suse.com,
        nixiaoming@huawei.com, mikelley@microsoft.com, kernel@gpiccoli.net,
        dmitry.osipenko@collabora.com, bigeasy@linutronix.de,
        bhe@redhat.com, arjan@linux.intel.com, gpiccoli@igalia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + notifiers-add-tracepoints-to-the-notifiers-infrastructure.patch added to mm-nonmm-unstable branch
Message-Id: <20230314205029.0C774C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: notifiers: add tracepoints to the notifiers infrastructure
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     notifiers-add-tracepoints-to-the-notifiers-infrastructure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/notifiers-add-tracepoints-to-the-notifiers-infrastructure.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: notifiers: add tracepoints to the notifiers infrastructure
Date: Tue, 14 Mar 2023 17:00:58 -0300

Currently there is no way to show the callback names for registered,
unregistered or executed notifiers. This is very useful for debug
purposes, hence add this functionality here in the form of notifiers'
tracepoints, one per operation.

Link: https://lkml.kernel.org/r/20230314200058.1326909-1-gpiccoli@igalia.com
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: Guilherme G. Piccoli <kernel@gpiccoli.net>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- /dev/null
+++ a/include/trace/events/notifiers.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM notifiers
+
+#if !defined(_TRACE_NOTIFIERS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_NOTIFIERS_H
+
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(notifiers_info,
+
+	TP_PROTO(void *cb),
+
+	TP_ARGS(cb),
+
+	TP_STRUCT__entry(
+		__field(void *, cb)
+	),
+
+	TP_fast_assign(
+		__entry->cb = cb;
+	),
+
+	TP_printk("%ps", __entry->cb)
+);
+
+/*
+ * notifiers_register - called upon notifier callback registration
+ *
+ * @cb:		callback pointer
+ *
+ */
+DEFINE_EVENT(notifiers_info, notifiers_register,
+
+	TP_PROTO(void *cb),
+
+	TP_ARGS(cb)
+);
+
+/*
+ * notifiers_unregister - called upon notifier callback unregistration
+ *
+ * @cb:		callback pointer
+ *
+ */
+DEFINE_EVENT(notifiers_info, notifiers_unregister,
+
+	TP_PROTO(void *cb),
+
+	TP_ARGS(cb)
+);
+
+/*
+ * notifiers_run - called upon notifier callback execution
+ *
+ * @cb:		callback pointer
+ *
+ */
+DEFINE_EVENT(notifiers_info, notifiers_run,
+
+	TP_PROTO(void *cb),
+
+	TP_ARGS(cb)
+);
+
+#endif /* _TRACE_NOTIFIERS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- a/kernel/notifier.c~notifiers-add-tracepoints-to-the-notifiers-infrastructure
+++ a/kernel/notifier.c
@@ -7,6 +7,9 @@
 #include <linux/vmalloc.h>
 #include <linux/reboot.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/notifiers.h>
+
 /*
  *	Notifier list for kernel code which wants to be called
  *	at shutdown. This is used to stop any idling DMA operations
@@ -37,6 +40,7 @@ static int notifier_chain_register(struc
 	}
 	n->next = *nl;
 	rcu_assign_pointer(*nl, n);
+	trace_notifiers_register((void*)n->notifier_call);
 	return 0;
 }
 
@@ -46,6 +50,7 @@ static int notifier_chain_unregister(str
 	while ((*nl) != NULL) {
 		if ((*nl) == n) {
 			rcu_assign_pointer(*nl, n->next);
+			trace_notifiers_unregister((void*)n->notifier_call);
 			return 0;
 		}
 		nl = &((*nl)->next);
@@ -84,6 +89,7 @@ static int notifier_call_chain(struct no
 			continue;
 		}
 #endif
+		trace_notifiers_run((void*)nb->notifier_call);
 		ret = nb->notifier_call(nb, val, v);
 
 		if (nr_calls)
_

Patches currently in -mm which might be from gpiccoli@igalia.com are

notifiers-add-tracepoints-to-the-notifiers-infrastructure.patch


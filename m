Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DC1ECAAD8
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiIMVpC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiIMVpB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:45:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40C1357DC
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:44:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B859CE1349
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B71C433D6;
        Tue, 13 Sep 2022 21:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663105495;
        bh=X7y3cADeM5zkU4MLJlxDYMSlDQUbMC9y8WpQMasXfsg=;
        h=Date:To:From:Subject:From;
        b=gP6HbiA8s68nQmkEuwjw87D3g0BSzaea4qJ18VxZLUrHFR8hQ71N3VC8fiUBSFJCX
         o4Y0vviiVwJoyck6In5lOb5649qQM+yePR7+GdVfFUKh0H42fB/REXfd7loCVA3dW6
         g5b2y7rSE49OYZuuf45TWFHsYT1OVv3/5qVepABo=
Date:   Tue, 13 Sep 2022 14:44:54 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tj@kernel.org,
        tim.c.chen@linux.intel.com, shakeelb@google.com,
        manfred@colorfullife.com, legion@kernel.org, ebiederm@xmission.com,
        dennis@kernel.org, dave@stgolabs.net, cl@linux.com,
        alexander.mikhalitsyn@virtuozzo.com, jiebin.sun@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-add-percpu_counter_add_local-and-percpu_counter_sub_local.patch added to mm-nonmm-unstable branch
Message-Id: <20220913214455.C5B71C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: Add percpu_counter_add_local and percpu_counter_sub_local
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     percpu-add-percpu_counter_add_local-and-percpu_counter_sub_local.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-add-percpu_counter_add_local-and-percpu_counter_sub_local.patch

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
From: Jiebin Sun <jiebin.sun@intel.com>
Subject: percpu: Add percpu_counter_add_local and percpu_counter_sub_local
Date: Wed, 14 Sep 2022 03:25:37 +0800

Patch series "/msg: mitigate the lock contention in ipc/msg", v6.

Here are two patches to mitigate the lock contention in ipc/msg.

The 1st patch is to add the new interface percpu_counter_add_local and
percpu_counter_sub_local.  The batch size in percpu_counter_add_batch
should be very large in heavy writing and rare reading case.  Add the
"_local" version, and mostly it will do local adding, reduce the global
updating and mitigate lock contention in writing.

The 2nd patch is to use percpu_counter instead of atomic update in
ipc/msg.  The msg_bytes and msg_hdrs atomic counters are frequently
updated when IPC msg queue is in heavy use, causing heavy cache bounce and
overhead.  Change them to percpu_counter greatly improve the performance. 
Since there is one percpu struct per namespace, additional memory cost is
minimal.  Reading of the count done in msgctl call, which is infrequent. 
So the need to sum up the counts in each CPU is infrequent.


This patch (of 2):

The batch size in percpu_counter_add_batch should be very large in
heavy writing and rare reading case. Add the "_local" version, and
mostly it will do local adding, reduce the global updating and
mitigate lock contention in writing.

Link: https://lkml.kernel.org/r/20220913192538.3023708-1-jiebin.sun@intel.com
Link: https://lkml.kernel.org/r/20220913192538.3023708-2-jiebin.sun@intel.com
Signed-off-by: Jiebin Sun <jiebin.sun@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasily Averin <vasily.averin@linux.dev>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |   32 +++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/include/linux/percpu_counter.h~percpu-add-percpu_counter_add_local-and-percpu_counter_sub_local
+++ a/include/linux/percpu_counter.h
@@ -15,6 +15,9 @@
 #include <linux/types.h>
 #include <linux/gfp.h>
 
+/* percpu_counter batch for local add or sub */
+#define PERCPU_COUNTER_LOCAL_BATCH	INT_MAX
+
 #ifdef CONFIG_SMP
 
 struct percpu_counter {
@@ -56,6 +59,22 @@ static inline void percpu_counter_add(st
 	percpu_counter_add_batch(fbc, amount, percpu_counter_batch);
 }
 
+/*
+ * With percpu_counter_add_local() and percpu_counter_sub_local(), counts
+ * are accumulated in local per cpu counter and not in fbc->count until
+ * local count overflows PERCPU_COUNTER_LOCAL_BATCH. This makes counter
+ * write efficient.
+ * But percpu_counter_sum(), instead of percpu_counter_read(), needs to be
+ * used to add up the counts from each CPU to account for all the local
+ * counts. So percpu_counter_add_local() and percpu_counter_sub_local()
+ * should be used when a counter is updated frequently and read rarely.
+ */
+static inline void
+percpu_counter_add_local(struct percpu_counter *fbc, s64 amount)
+{
+	percpu_counter_add_batch(fbc, amount, PERCPU_COUNTER_LOCAL_BATCH);
+}
+
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
 {
 	s64 ret = __percpu_counter_sum(fbc);
@@ -138,6 +157,13 @@ percpu_counter_add(struct percpu_counter
 	preempt_enable();
 }
 
+/* non-SMP percpu_counter_add_local is the same with percpu_counter_add */
+static inline void
+percpu_counter_add_local(struct percpu_counter *fbc, s64 amount)
+{
+	percpu_counter_add(fbc, amount);
+}
+
 static inline void
 percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
@@ -193,4 +219,10 @@ static inline void percpu_counter_sub(st
 	percpu_counter_add(fbc, -amount);
 }
 
+static inline void
+percpu_counter_sub_local(struct percpu_counter *fbc, s64 amount)
+{
+	percpu_counter_add_local(fbc, -amount);
+}
+
 #endif /* _LINUX_PERCPU_COUNTER_H */
_

Patches currently in -mm which might be from jiebin.sun@intel.com are

percpu-add-percpu_counter_add_local-and-percpu_counter_sub_local.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter.patch


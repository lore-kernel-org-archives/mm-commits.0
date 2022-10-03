Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B721C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiJCVaZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiJCV3y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2300D578BE
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3B47610D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043B2C433D7;
        Mon,  3 Oct 2022 21:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832160;
        bh=tSNjLYe/He7UUuNr5AUe9BQV9mVK6kUQpl5TDNPhudw=;
        h=Date:To:From:Subject:From;
        b=zT1H6taCRvDAD2CGnKNsX/zXpA2IJDDS7FtZs/5zOd/WPpgebzOYMWpCADdzSIPLX
         YAbxhJ6uafp5a901flc/3/HHPS9R5M9Rne9d7qoq3I1ZLHALijx6hCsP1PsRebEz4D
         ILGxj5b7gCcsaWQQANRkSUVjJ/NQ+n30cAkP7BV4=
Date:   Mon, 03 Oct 2022 14:22:39 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tj@kernel.org,
        tim.c.chen@linux.intel.com, shakeelb@google.com,
        manfred@colorfullife.com, legion@kernel.org, ebiederm@xmission.com,
        dennis@kernel.org, dave@stgolabs.net, cl@linux.com,
        alexander.mikhalitsyn@virtuozzo.com, jiebin.sun@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] percpu-add-percpu_counter_add_local-and-percpu_counter_sub_local.patch removed from -mm tree
Message-Id: <20221003212240.043B2C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: percpu: add percpu_counter_add_local and percpu_counter_sub_local
has been removed from the -mm tree.  Its filename was
     percpu-add-percpu_counter_add_local-and-percpu_counter_sub_local.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiebin Sun <jiebin.sun@intel.com>
Subject: percpu: add percpu_counter_add_local and percpu_counter_sub_local
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



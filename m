Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBBDC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CEE261260
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238276AbhIWWGO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 18:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235859AbhIWWGN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 18:06:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFB136124E;
        Thu, 23 Sep 2021 22:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632434681;
        bh=evz79SLF5o8qcIKkGUpa2gf1fmjnyOUnWVc4Ic7wc9c=;
        h=Date:From:To:Subject:From;
        b=CxaxFLaZR4iE2sbXjAaKQrvRuZpxxC7xDJY43IZRVC+dwJS+X5tY6nqqNQl7pfkEL
         /tNNHk+Zs+mxtk7fNPrVBsLCf4tLsE0gKFov+eIP/JiQaMY6AUydaxH6u8XHRKm+mM
         WS5uMgHaIJ0PLgDmjTEXCy1UqJKK4CTIMcdjnnsY=
Date:   Thu, 23 Sep 2021 15:04:40 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, mm-commits@vger.kernel.org, rostedt@goodmis.org,
        williams@redhat.com
Subject:  + kcov-replace-local_irq_save-with-a-local_lock_t.patch
 added to -mm tree
Message-ID: <20210923220440.HUji6Fe5g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: replace local_irq_save() with a local_lock_t
has been added to the -mm tree.  Its filename is
     kcov-replace-local_irq_save-with-a-local_lock_t.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kcov-replace-local_irq_save-with-a-local_lock_t.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kcov-replace-local_irq_save-with-a-local_lock_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: kcov: replace local_irq_save() with a local_lock_t

The kcov code mixes local_irq_save() and spin_lock() in
kcov_remote_{start|end}().  This creates a warning on PREEMPT_RT because
local_irq_save() disables interrupts and spin_lock_t is turned into a
sleeping lock which can not be acquired in a section with disabled
interrupts.

The kcov_remote_lock is used to synchronize the access to the hash-list
kcov_remote_map.  The local_irq_save() block protects access to the
per-CPU data kcov_percpu_data.

There is no compelling reason to change the lock type to raw_spin_lock_t
to make it work with local_irq_save().  Changing it would require to move
memory allocation (in kcov_remote_add()) and deallocation outside of the
locked section.

Adding an unlimited amount of entries to the hashlist will increase the
IRQ-off time during lookup.  It could be argued that this is debug code
and the latency does not matter.  There is however no need to do so and it
would allow to use this facility in an RT enabled build.

Using a local_lock_t instead of local_irq_save() has the befit of adding a
protection scope within the source which makes it obvious what is
protected.  On a !PREEMPT_RT && !LOCKDEP build the local_lock_irqsave()
maps directly to local_irq_save() so there is overhead at runtime.

Replace the local_irq_save() section with a local_lock_t.

Link: https://lkml.kernel.org/r/20210923164741.1859522-6-bigeasy@linutronix.de
Link: https://lore.kernel.org/r/20210830172627.267989-6-bigeasy@linutronix.de
Reported-by: Clark Williams <williams@redhat.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/kernel/kcov.c~kcov-replace-local_irq_save-with-a-local_lock_t
+++ a/kernel/kcov.c
@@ -88,6 +88,7 @@ static struct list_head kcov_remote_area
 
 struct kcov_percpu_data {
 	void			*irq_area;
+	local_lock_t		lock;
 
 	unsigned int		saved_mode;
 	unsigned int		saved_size;
@@ -96,7 +97,9 @@ struct kcov_percpu_data {
 	int			saved_sequence;
 };
 
-static DEFINE_PER_CPU(struct kcov_percpu_data, kcov_percpu_data);
+static DEFINE_PER_CPU(struct kcov_percpu_data, kcov_percpu_data) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+};
 
 /* Must be called with kcov_remote_lock locked. */
 static struct kcov_remote *kcov_remote_find(u64 handle)
@@ -824,7 +827,7 @@ void kcov_remote_start(u64 handle)
 	if (!in_task() && !in_serving_softirq())
 		return;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&kcov_percpu_data.lock, flags);
 
 	/*
 	 * Check that kcov_remote_start() is not called twice in background
@@ -832,7 +835,7 @@ void kcov_remote_start(u64 handle)
 	 */
 	mode = READ_ONCE(t->kcov_mode);
 	if (WARN_ON(in_task() && kcov_mode_enabled(mode))) {
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 		return;
 	}
 	/*
@@ -841,14 +844,15 @@ void kcov_remote_start(u64 handle)
 	 * happened while collecting coverage from a background thread.
 	 */
 	if (WARN_ON(in_serving_softirq() && t->kcov_softirq)) {
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 		return;
 	}
 
 	spin_lock(&kcov_remote_lock);
 	remote = kcov_remote_find(handle);
 	if (!remote) {
-		spin_unlock_irqrestore(&kcov_remote_lock, flags);
+		spin_unlock(&kcov_remote_lock);
+		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 		return;
 	}
 	kcov_debug("handle = %llx, context: %s\n", handle,
@@ -873,13 +877,13 @@ void kcov_remote_start(u64 handle)
 
 	/* Can only happen when in_task(). */
 	if (!area) {
-		local_irqrestore(flags);
+		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 		area = vmalloc(size * sizeof(unsigned long));
 		if (!area) {
 			kcov_put(kcov);
 			return;
 		}
-		local_irq_save(flags);
+		local_lock_irqsave(&kcov_percpu_data.lock, flags);
 	}
 
 	/* Reset coverage size. */
@@ -891,7 +895,7 @@ void kcov_remote_start(u64 handle)
 	}
 	kcov_start(t, kcov, size, area, mode, sequence);
 
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 
 }
 EXPORT_SYMBOL(kcov_remote_start);
@@ -965,12 +969,12 @@ void kcov_remote_stop(void)
 	if (!in_task() && !in_serving_softirq())
 		return;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&kcov_percpu_data.lock, flags);
 
 	mode = READ_ONCE(t->kcov_mode);
 	barrier();
 	if (!kcov_mode_enabled(mode)) {
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 		return;
 	}
 	/*
@@ -978,12 +982,12 @@ void kcov_remote_stop(void)
 	 * actually found the remote handle and started collecting coverage.
 	 */
 	if (in_serving_softirq() && !t->kcov_softirq) {
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 		return;
 	}
 	/* Make sure that kcov_softirq is only set when in softirq. */
 	if (WARN_ON(!in_serving_softirq() && t->kcov_softirq)) {
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 		return;
 	}
 
@@ -1013,7 +1017,7 @@ void kcov_remote_stop(void)
 		spin_unlock(&kcov_remote_lock);
 	}
 
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 
 	/* Get in kcov_remote_start(). */
 	kcov_put(kcov);
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-disable-zsmalloc-on-preempt_rt.patch
documentation-kcov-include-typesh-in-the-example.patch
documentation-kcov-define-ip-in-the-example.patch
kcov-allocate-per-cpu-memory-on-the-relevant-node.patch
kcov-avoid-enabledisable-interrupts-if-in_task.patch
kcov-replace-local_irq_save-with-a-local_lock_t.patch


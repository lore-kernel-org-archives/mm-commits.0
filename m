Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAD1C433E0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 20:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D06D022241
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 20:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbhADUPF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 15:15:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728165AbhADUPF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 15:15:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 840E6221F8;
        Mon,  4 Jan 2021 20:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609791263;
        bh=F6aHs68/GMS4x8nkCwlljWWB7oJUZqAinB66b60Mz5c=;
        h=Date:From:To:Subject:From;
        b=DVqpIBmnKAzp6T4nhSc/VjkTLHGmNffyUw7dHDZA45dCvGARMViMhkHQ6KjLGGbm0
         OUBmurJZUgugWEsf37o4OFGKBDScwiVnZzLMIrIi7bp7cjTw0D50BKLvVtrvDSjGRS
         fGmsCaaz1SYTPK3lIVE6q//59oeDf1BYOYaXpudw=
Date:   Mon, 04 Jan 2021 12:14:22 -0800
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        hdanton@sina.com, jannh@google.com, mark.rutland@arm.com,
        mm-commits@vger.kernel.org
Subject:  + mm-add-kernel-electric-fence-infrastructure-fix-3.patch
 added to -mm tree
Message-ID: <20210104201422.mMtUd_gSk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: fix potential deadlock due to wake_up()
has been added to the -mm tree.  Its filename is
     mm-add-kernel-electric-fence-infrastructure-fix-3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-kernel-electric-fence-infrastructure-fix-3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-kernel-electric-fence-infrastructure-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: fix potential deadlock due to wake_up()

Lockdep reports that we may deadlock when calling wake_up() in
__kfence_alloc(), because we may already hold base->lock.  This can happen
if debug objects are enabled:

    ...
    __kfence_alloc+0xa0/0xbc0 mm/kfence/core.c:710
    kfence_alloc include/linux/kfence.h:108 [inline]
    ...
    kmem_cache_zalloc include/linux/slab.h:672 [inline]
    fill_pool+0x264/0x5c0 lib/debugobjects.c:171
    __debug_object_init+0x7a/0xd10 lib/debugobjects.c:560
    debug_object_init lib/debugobjects.c:615 [inline]
    debug_object_activate+0x32c/0x3e0 lib/debugobjects.c:701
    debug_timer_activate kernel/time/timer.c:727 [inline]
    __mod_timer+0x77d/0xe30 kernel/time/timer.c:1048
    ...

Therefore, switch to an open-coded wait loop.  The difference to before is
that the waiter wakes up and rechecks the condition after 1 jiffy;
however, given the infrequency of kfence allocations, the difference is
insignificant.

Link: https://lkml.kernel.org/r/000000000000c0645805b7f982e4@google.com
Link: https://lkml.kernel.org/r/20210104130749.1768991-1-elver@google.com
Reported-by: syzbot+8983d6d4f7df556be565@syzkaller.appspotmail.com
Signed-off-by: Marco Elver <elver@google.com>
Suggested-by: Hillf Danton <hdanton@sina.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/kfence/core.c~mm-add-kernel-electric-fence-infrastructure-fix-3
+++ a/mm/kfence/core.c
@@ -94,9 +94,6 @@ DEFINE_STATIC_KEY_FALSE(kfence_allocatio
 /* Gates the allocation, ensuring only one succeeds in a given period. */
 static atomic_t allocation_gate = ATOMIC_INIT(1);
 
-/* Wait queue to wake up allocation-gate timer task. */
-static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
-
 /* Statistics counters for debugfs. */
 enum kfence_counter_id {
 	KFENCE_COUNTER_ALLOCATED,
@@ -582,6 +579,8 @@ late_initcall(kfence_debugfs_init);
 static struct delayed_work kfence_timer;
 static void toggle_allocation_gate(struct work_struct *work)
 {
+	unsigned long end_wait;
+
 	if (!READ_ONCE(kfence_enabled))
 		return;
 
@@ -592,7 +591,14 @@ static void toggle_allocation_gate(struc
 	 * Await an allocation. Timeout after 1 second, in case the kernel stops
 	 * doing allocations, to avoid stalling this worker task for too long.
 	 */
-	wait_event_timeout(allocation_wait, atomic_read(&allocation_gate) != 0, HZ);
+	end_wait = jiffies + HZ;
+	do {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (atomic_read(&allocation_gate) != 0)
+			break;
+		schedule_timeout(1);
+	} while (time_before(jiffies, end_wait));
+	__set_current_state(TASK_RUNNING);
 
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
@@ -703,7 +709,6 @@ void *__kfence_alloc(struct kmem_cache *
 	 */
 	if (atomic_read(&allocation_gate) || atomic_inc_return(&allocation_gate) > 1)
 		return NULL;
-	wake_up(&allocation_wait);
 
 	if (!READ_ONCE(kfence_enabled))
 		return NULL;
_

Patches currently in -mm which might be from elver@google.com are

mm-add-kernel-electric-fence-infrastructure-fix.patch
mm-add-kernel-electric-fence-infrastructure-fix-2.patch
mm-add-kernel-electric-fence-infrastructure-fix-3.patch
arm64-kfence-enable-kfence-for-arm64.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-add-test-suite.patch
kfence-add-test-suite-fix.patch
maintainers-add-entry-for-kfence.patch


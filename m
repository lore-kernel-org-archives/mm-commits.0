Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC396C43334
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 19:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243639AbiFMTkP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243812AbiFMTkD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 15:40:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067EA71A26
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 11:06:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87CAD61180
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 18:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCBAC34114;
        Mon, 13 Jun 2022 18:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655143589;
        bh=r3+Q/MaRtebq674izsweqVWsi50qFp0CdBxDnkUJ0k0=;
        h=Date:To:From:Subject:From;
        b=avJAX0d0/VYUXQmHpOtO8lrjfD14Bbk3ss0QZXByXlnGHvxalsoIRV/49K6lyfLgn
         MZo8+/7/kwUpcmOYNsl50VEYr51Q7k8we2k06HtPi5IjU4ih1tHTkAmJXPR7rCcKPN
         TQRa8eN7yeqn3fqU7ZWGZGwizfWUYDnx6db4IM+I=
Date:   Mon, 13 Jun 2022 11:06:28 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        catalin.marinas@arm.com, longman@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-use-_irq-lock-unlock-variants-in-kmemleak_scan-_clear.patch added to mm-unstable branch
Message-Id: <20220613180628.DDCBAC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: use _irq lock/unlock variants in kmemleak_scan/_clear()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-use-_irq-lock-unlock-variants-in-kmemleak_scan-_clear.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-use-_irq-lock-unlock-variants-in-kmemleak_scan-_clear.patch

This patch will later appear in the mm-unstable branch at
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
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: use _irq lock/unlock variants in kmemleak_scan/_clear()
Date: Sun, 12 Jun 2022 14:32:59 -0400

Patch series "mm/kmemleak: Avoid soft lockup in kmemleak_scan()".

There are 3 RCU-based object iteration loops in kmemleak_scan().  Because
of the need to take RCU read lock, we can't insert cond_resched() into the
loop like other parts of the function.  As there can be millions of
objects to be scanned, it takes a while to iterate all of them.  The
kmemleak functionality is usually enabled in a debug kernel which is much
slower than a non-debug kernel.  With sufficient number of kmemleak
objects, the time to iterate them all may exceed 22s causing soft lockup.

  watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [kmemleak:625]

This patch series make changes to the 3 object iteration loops in
kmemleak_scan() to prevent them from causing soft lockup.


This patch (of 3);

kmemleak_scan() is called only from the kmemleak scan thread or from write
to the kmemleak debugfs file.  Both are in task context and so we can
directly use the simpler _irq() lock/unlock calls instead of the more
complex _irqsave/_irqrestore variants.

Similarly, kmemleak_clear() is called only from write to the kmemleak
debugfs file.  The same change can be applied.

Link: https://lkml.kernel.org/r/20220612183301.981616-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20220612183301.981616-2-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-use-_irq-lock-unlock-variants-in-kmemleak_scan-_clear
+++ a/mm/kmemleak.c
@@ -1470,7 +1470,6 @@ static void scan_gray_list(void)
  */
 static void kmemleak_scan(void)
 {
-	unsigned long flags;
 	struct kmemleak_object *object;
 	struct zone *zone;
 	int __maybe_unused i;
@@ -1481,7 +1480,7 @@ static void kmemleak_scan(void)
 	/* prepare the kmemleak_object's */
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
-		raw_spin_lock_irqsave(&object->lock, flags);
+		raw_spin_lock_irq(&object->lock);
 #ifdef DEBUG
 		/*
 		 * With a few exceptions there should be a maximum of
@@ -1509,7 +1508,7 @@ static void kmemleak_scan(void)
 		if (color_gray(object) && get_object(object))
 			list_add_tail(&object->gray_list, &gray_list);
 
-		raw_spin_unlock_irqrestore(&object->lock, flags);
+		raw_spin_unlock_irq(&object->lock);
 	}
 	rcu_read_unlock();
 
@@ -1577,14 +1576,14 @@ static void kmemleak_scan(void)
 	 */
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
-		raw_spin_lock_irqsave(&object->lock, flags);
+		raw_spin_lock_irq(&object->lock);
 		if (color_white(object) && (object->flags & OBJECT_ALLOCATED)
 		    && update_checksum(object) && get_object(object)) {
 			/* color it gray temporarily */
 			object->count = object->min_count;
 			list_add_tail(&object->gray_list, &gray_list);
 		}
-		raw_spin_unlock_irqrestore(&object->lock, flags);
+		raw_spin_unlock_irq(&object->lock);
 	}
 	rcu_read_unlock();
 
@@ -1604,7 +1603,7 @@ static void kmemleak_scan(void)
 	 */
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
-		raw_spin_lock_irqsave(&object->lock, flags);
+		raw_spin_lock_irq(&object->lock);
 		if (unreferenced_object(object) &&
 		    !(object->flags & OBJECT_REPORTED)) {
 			object->flags |= OBJECT_REPORTED;
@@ -1614,7 +1613,7 @@ static void kmemleak_scan(void)
 
 			new_leaks++;
 		}
-		raw_spin_unlock_irqrestore(&object->lock, flags);
+		raw_spin_unlock_irq(&object->lock);
 	}
 	rcu_read_unlock();
 
@@ -1816,15 +1815,14 @@ static int dump_str_object_info(const ch
 static void kmemleak_clear(void)
 {
 	struct kmemleak_object *object;
-	unsigned long flags;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
-		raw_spin_lock_irqsave(&object->lock, flags);
+		raw_spin_lock_irq(&object->lock);
 		if ((object->flags & OBJECT_REPORTED) &&
 		    unreferenced_object(object))
 			__paint_it(object, KMEMLEAK_GREY);
-		raw_spin_unlock_irqrestore(&object->lock, flags);
+		raw_spin_unlock_irq(&object->lock);
 	}
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from longman@redhat.com are

mm-kmemleak-use-_irq-lock-unlock-variants-in-kmemleak_scan-_clear.patch
mm-kmemleak-skip-unlikely-objects-in-kmemleak_scan-without-taking-lock.patch
mm-kmemleak-prevent-soft-lockup-in-first-object-iteration-loop-of-kmemleak_scan.patch


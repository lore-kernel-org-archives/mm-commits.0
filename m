Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D89CC32793
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjARXXx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjARXXm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:23:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83F0676F9
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:23:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6D16B81F8E
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5073CC433D2;
        Wed, 18 Jan 2023 23:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674084185;
        bh=jVYymR/q2Gjz4txXXB0uSbs5qer+epYGFmYYsbX1Mjo=;
        h=Date:To:From:Subject:From;
        b=KIKXiuryI1pgK4oijFMq3wC/cPTSoqLMPdsigG2ro5d6KqIgxlVsWLp7sZgthD83c
         7U+xw5fhFPJMO39Y2X+1r3gd7yIt6Ve9nRMHcqNX4oqs9AFWzlfJr7ef7JdmkJWFR8
         t0yQGXC1XOyDQIrUa44W9PDgBXYOxhviINgv3dcM=
Date:   Wed, 18 Jan 2023 15:23:04 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        catalin.marinas@arm.com, longman@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-kmemleak-simplify-kmemleak_cond_resched-usage.patch removed from -mm tree
Message-Id: <20230118232305.5073CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kmemleak: simplify kmemleak_cond_resched() usage
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-simplify-kmemleak_cond_resched-usage.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: simplify kmemleak_cond_resched() usage
Date: Thu, 15 Dec 2022 11:02:58 -0500

Patch series "mm/kmemleak: Simplify kmemleak_cond_resched() & fix UAF",
v2.

It was found that a KASAN use-after-free error was reported in
kmemleak_scan().  After further examination, it is believed that even
though a reference is taken from the current object, it does not prevent
the object pointed to by the next pointer from going away after a
cond_resched().

To fix that, additional flags are added to make sure that the current
object won't be removed from the object_list during the duration of
the cond_resched() to ensure the validity of the next pointer.

While making the change, I also simplified the current usage of
kmemleak_cond_resched() to make it easier to understand.



The presence of a pinned argument and the 64k loop count make
kmemleak_cond_resched() a bit more complex to read.  The pinned argument
is used only by first kmemleak_scan() loop.

Simplify the usage of kmemleak_cond_resched() by removing the pinned
argument and always do a get_object()/put_object() sequence.  In addition,
the 64k loop is removed by using need_resched() to decide if
kmemleak_cond_resched() should be called.

Link: https://lkml.kernel.org/r/20221215160259.261136-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20221215160259.261136-2-longman@redhat.com
Fixes: 6edda04ccc7c ("mm/kmemleak: prevent soft lockup in first object iteration loop of kmemleak_scan()")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kmemleak.c~mm-kmemleak-simplify-kmemleak_cond_resched-usage
+++ a/mm/kmemleak.c
@@ -1472,22 +1472,17 @@ static void scan_gray_list(void)
 /*
  * Conditionally call resched() in an object iteration loop while making sure
  * that the given object won't go away without RCU read lock by performing a
- * get_object() if !pinned.
- *
- * Return: false if can't do a cond_resched() due to get_object() failure
- *	   true otherwise
+ * get_object() if necessaary.
  */
-static bool kmemleak_cond_resched(struct kmemleak_object *object, bool pinned)
+static void kmemleak_cond_resched(struct kmemleak_object *object)
 {
-	if (!pinned && !get_object(object))
-		return false;
+	if (!get_object(object))
+		return;	/* Try next object */
 
 	rcu_read_unlock();
 	cond_resched();
 	rcu_read_lock();
-	if (!pinned)
-		put_object(object);
-	return true;
+	put_object(object);
 }
 
 /*
@@ -1501,15 +1496,12 @@ static void kmemleak_scan(void)
 	struct zone *zone;
 	int __maybe_unused i;
 	int new_leaks = 0;
-	int loop_cnt = 0;
 
 	jiffies_last_scan = jiffies;
 
 	/* prepare the kmemleak_object's */
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
-		bool obj_pinned = false;
-
 		raw_spin_lock_irq(&object->lock);
 #ifdef DEBUG
 		/*
@@ -1535,19 +1527,13 @@ static void kmemleak_scan(void)
 
 		/* reset the reference count (whiten the object) */
 		object->count = 0;
-		if (color_gray(object) && get_object(object)) {
+		if (color_gray(object) && get_object(object))
 			list_add_tail(&object->gray_list, &gray_list);
-			obj_pinned = true;
-		}
 
 		raw_spin_unlock_irq(&object->lock);
 
-		/*
-		 * Do a cond_resched() every 64k objects to avoid soft lockup.
-		 */
-		if (!(++loop_cnt & 0xffff) &&
-		    !kmemleak_cond_resched(object, obj_pinned))
-			loop_cnt--; /* Try again on next object */
+		if (need_resched())
+			kmemleak_cond_resched(object);
 	}
 	rcu_read_unlock();
 
@@ -1614,14 +1600,9 @@ static void kmemleak_scan(void)
 	 * scan and color them gray until the next scan.
 	 */
 	rcu_read_lock();
-	loop_cnt = 0;
 	list_for_each_entry_rcu(object, &object_list, object_list) {
-		/*
-		 * Do a cond_resched() every 64k objects to avoid soft lockup.
-		 */
-		if (!(++loop_cnt & 0xffff) &&
-		    !kmemleak_cond_resched(object, false))
-			loop_cnt--;	/* Try again on next object */
+		if (need_resched())
+			kmemleak_cond_resched(object);
 
 		/*
 		 * This is racy but we can save the overhead of lock/unlock
@@ -1656,14 +1637,9 @@ static void kmemleak_scan(void)
 	 * Scanning result reporting.
 	 */
 	rcu_read_lock();
-	loop_cnt = 0;
 	list_for_each_entry_rcu(object, &object_list, object_list) {
-		/*
-		 * Do a cond_resched() every 64k objects to avoid soft lockup.
-		 */
-		if (!(++loop_cnt & 0xffff) &&
-		    !kmemleak_cond_resched(object, false))
-			loop_cnt--;	/* Try again on next object */
+		if (need_resched())
+			kmemleak_cond_resched(object);
 
 		/*
 		 * This is racy but we can save the overhead of lock/unlock
_

Patches currently in -mm which might be from longman@redhat.com are

mm-kmemleak-fix-uaf-bug-in-kmemleak_scan.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D5EC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jun 2022 18:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbiFNS1t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Jun 2022 14:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245128AbiFNS1s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2022 14:27:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295392F673
        for <mm-commits@vger.kernel.org>; Tue, 14 Jun 2022 11:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA6B1B8186A
        for <mm-commits@vger.kernel.org>; Tue, 14 Jun 2022 18:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8753BC3411B;
        Tue, 14 Jun 2022 18:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655231264;
        bh=I1B2AIrRhC+YNDYEQ90llCupOyNPm14SGnJJvuRmJ68=;
        h=Date:To:From:Subject:From;
        b=PzzOYogjI77S0rBGcw4X5aGuXdqJxSZUkP8UFKE0v9u2wEVJElfPjfegp+Y0HAN2v
         KQ9LEbEvdYjW0xdWZGAX8o8r+PMw4yeYShPVIcjCxzYkWEEcFudsMIGqh24k4Srnxy
         B+tstxDuFGqC7ZrR/y9irDzWU+Z586XaLyhiOys8=
Date:   Tue, 14 Jun 2022 11:27:43 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        catalin.marinas@arm.com, longman@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-kmemleak-prevent-soft-lockup-in-first-object-iteration-loop-of-kmemleak_scan.patch removed from -mm tree
Message-Id: <20220614182744.8753BC3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kmemleak: prevent soft lockup in first object iteration loop of kmemleak_scan()
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-prevent-soft-lockup-in-first-object-iteration-loop-of-kmemleak_scan.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: prevent soft lockup in first object iteration loop of kmemleak_scan()
Date: Sun, 12 Jun 2022 14:33:01 -0400

The first RCU-based object iteration loop has to put almost all the
objects into the gray list and so cannot skip taking the object lock.

One way to avoid soft lockup is to insert occasional cond_resched() into
the loop.  This cannot be done while holding the RCU read lock which is to
protect objects from removal.  However, putting an object into the gray
list means getting a reference to the object.  That will prevent the
object from removal as well without the need to hold the RCU read lock. 
So insert a cond_resched() call after every 64k objects are put into the
gray list.

Link: https://lkml.kernel.org/r/20220612183301.981616-4-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-prevent-soft-lockup-in-first-object-iteration-loop-of-kmemleak_scan
+++ a/mm/kmemleak.c
@@ -1474,12 +1474,15 @@ static void kmemleak_scan(void)
 	struct zone *zone;
 	int __maybe_unused i;
 	int new_leaks = 0;
+	int gray_list_cnt = 0;
 
 	jiffies_last_scan = jiffies;
 
 	/* prepare the kmemleak_object's */
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
+		bool object_pinned = false;
+
 		raw_spin_lock_irq(&object->lock);
 #ifdef DEBUG
 		/*
@@ -1505,10 +1508,25 @@ static void kmemleak_scan(void)
 
 		/* reset the reference count (whiten the object) */
 		object->count = 0;
-		if (color_gray(object) && get_object(object))
+		if (color_gray(object) && get_object(object)) {
 			list_add_tail(&object->gray_list, &gray_list);
+			gray_list_cnt++;
+			object_pinned = true;
+		}
 
 		raw_spin_unlock_irq(&object->lock);
+
+		/*
+		 * With object pinned by a positive reference count, it
+		 * won't go away and we can safely release the RCU read
+		 * lock and do a cond_resched() to avoid soft lockup every
+		 * 64k objects.
+		 */
+		if (object_pinned && !(gray_list_cnt & 0xffff)) {
+			rcu_read_unlock();
+			cond_resched();
+			rcu_read_lock();
+		}
 	}
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from longman@redhat.com are



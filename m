Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B57BC43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379847AbiFQCuo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379822AbiFQCtw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0C465432
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92A59B826F5
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5695FC34114;
        Fri, 17 Jun 2022 02:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434186;
        bh=aDLbNBNUTTjtHQmSQ2f4HJN+Wt7rSz8kUmF22gTO2m0=;
        h=Date:To:From:Subject:From;
        b=Bw+vQbuU/12DC1H1NFHNbI9SokowZxkimqM1ORsop/z7oR9LFNe/WJdyYfqATd/CK
         I69j6O9pqmwShRP0dkRpS4If0k1JzoIAemQsYaipbNjl81NispC7C7cXdHiNGiAnPf
         Q9aVDixsIA4AO2ebj6YRK5gRrdJxnTf3YdUsE5Cc=
Date:   Thu, 16 Jun 2022 19:49:45 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        catalin.marinas@arm.com, longman@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-prevent-soft-lockup-in-first-object-iteration-loop-of-kmemleak_scan.patch removed from -mm tree
Message-Id: <20220617024946.5695FC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kmemleak: prevent soft lockup in first object iteration loop of kmemleak_scan()
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-prevent-soft-lockup-in-first-object-iteration-loop-of-kmemleak_scan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: prevent soft lockup in first object iteration loop of kmemleak_scan()
Date: Tue, 14 Jun 2022 18:03:59 -0400

The first RCU-based object iteration loop has to modify the object count. 
So we cannot skip taking the object lock.

One way to avoid soft lockup is to insert occasional cond_resched() call
into the loop.  This cannot be done while holding the RCU read lock which
is to protect objects from being freed.  However, taking a reference to
the object will prevent it from being freed.  We can then do a
cond_resched() call after every 64k objects safely.

Link: https://lkml.kernel.org/r/20220614220359.59282-4-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-prevent-soft-lockup-in-first-object-iteration-loop-of-kmemleak_scan
+++ a/mm/kmemleak.c
@@ -1474,12 +1474,16 @@ static void kmemleak_scan(void)
 	struct zone *zone;
 	int __maybe_unused i;
 	int new_leaks = 0;
+	int loop1_cnt = 0;
 
 	jiffies_last_scan = jiffies;
 
 	/* prepare the kmemleak_object's */
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
+		bool obj_pinned = false;
+
+		loop1_cnt++;
 		raw_spin_lock_irq(&object->lock);
 #ifdef DEBUG
 		/*
@@ -1505,10 +1509,32 @@ static void kmemleak_scan(void)
 
 		/* reset the reference count (whiten the object) */
 		object->count = 0;
-		if (color_gray(object) && get_object(object))
+		if (color_gray(object) && get_object(object)) {
 			list_add_tail(&object->gray_list, &gray_list);
+			obj_pinned = true;
+		}
 
 		raw_spin_unlock_irq(&object->lock);
+
+		/*
+		 * Do a cond_resched() to avoid soft lockup every 64k objects.
+		 * Make sure a reference has been taken so that the object
+		 * won't go away without RCU read lock.
+		 */
+		if (!(loop1_cnt & 0xffff)) {
+			if (!obj_pinned && !get_object(object)) {
+				/* Try the next object instead */
+				loop1_cnt--;
+				continue;
+			}
+
+			rcu_read_unlock();
+			cond_resched();
+			rcu_read_lock();
+
+			if (!obj_pinned)
+				put_object(object);
+		}
 	}
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from longman@redhat.com are



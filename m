Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46655CCA473
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jun 2022 21:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349421AbiFOVsu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jun 2022 17:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348984AbiFOVsp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2022 17:48:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D9C3BBCB
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 14:48:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E65E9617ED
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 21:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B98C3411A;
        Wed, 15 Jun 2022 21:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655329723;
        bh=TM8h05fhYacrZaXVfzqor4CxjXiibTWR/SRbR4khf8Y=;
        h=Date:To:From:Subject:From;
        b=s+OFgBP4q6iXuH3F0FoyTVKBexbWJI8DUcNZon8VrFj+ChVF17Xa167uBv2BwXcmA
         sxSJWC8BXxJBOj9OWfQIO6FE91FOyPxLUw4cx0Am5FnUfdHKBbvK9mmQi6HI8i2dis
         3zaJ1hjHxnikqi57kXJnRNvz8LICxXAyTvdWiOIE=
Date:   Wed, 15 Jun 2022 14:48:42 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        catalin.marinas@arm.com, longman@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-skip-unlikely-objects-in-kmemleak_scan-without-taking-lock.patch added to mm-unstable branch
Message-Id: <20220615214843.44B98C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: skip unlikely objects in kmemleak_scan() without taking lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-skip-unlikely-objects-in-kmemleak_scan-without-taking-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-skip-unlikely-objects-in-kmemleak_scan-without-taking-lock.patch

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
Subject: mm/kmemleak: skip unlikely objects in kmemleak_scan() without taking lock
Date: Tue, 14 Jun 2022 18:03:58 -0400

There are 3 RCU-based object iteration loops in kmemleak_scan().  Because
of the need to take RCU read lock, we can't insert cond_resched() into the
loop like other parts of the function.  As there can be millions of
objects to be scanned, it takes a while to iterate all of them.  The
kmemleak functionality is usually enabled in a debug kernel which is much
slower than a non-debug kernel.  With sufficient number of kmemleak
objects, the time to iterate them all may exceed 22s causing soft lockup.

  watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [kmemleak:625]

In this particular bug report, the soft lockup happen in the 2nd iteration
loop.

In the 2nd and 3rd loops, most of the objects are checked and then skipped
under the object lock.  Only a selected fews are modified.  Those objects
certainly need lock protection.  However, the lock/unlock operation is
slow especially with interrupt disabling and enabling included.

We can actually do some basic check like color_white() without taking the
lock and skip the object accordingly.  Of course, this kind of check is
racy and may miss objects that are being modified concurrently.  The cost
of missed objects, however, is just that they will be discovered in the
next scan instead.  The advantage of doing so is that iteration can be
done much faster especially with LOCKDEP enabled in a debug kernel.

With a debug kernel running on a 2-socket 96-thread x86-64 system
(HZ=1000), the 2nd and 3rd iteration loops speedup with this patch on the
first kmemleak_scan() call after bootup is shown in the table below.

                   Before patch                    After patch
  Loop #    # of objects  Elapsed time     # of objects  Elapsed time
  ------    ------------  ------------     ------------  ------------
    2        2,599,850      2.392s          2,596,364       0.266s
    3        2,600,176      2.171s          2,597,061       0.260s

This patch reduces loop iteration times by about 88%.  This will greatly
reduce the chance of a soft lockup happening in the 2nd or 3rd iteration
loops.

Even though the first loop runs a little bit faster, it can still be
problematic if many kmemleak objects are there.  As the object count has
to be modified in every object, we cannot avoid taking the object lock. 
So other way to prevent soft lockup will be needed.

Link: https://lkml.kernel.org/r/20220614220359.59282-3-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/kmemleak.c~mm-kmemleak-skip-unlikely-objects-in-kmemleak_scan-without-taking-lock
+++ a/mm/kmemleak.c
@@ -1576,6 +1576,13 @@ static void kmemleak_scan(void)
 	 */
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
+		/*
+		 * This is racy but we can save the overhead of lock/unlock
+		 * calls. The missed objects, if any, should be caught in
+		 * the next scan.
+		 */
+		if (!color_white(object))
+			continue;
 		raw_spin_lock_irq(&object->lock);
 		if (color_white(object) && (object->flags & OBJECT_ALLOCATED)
 		    && update_checksum(object) && get_object(object)) {
@@ -1603,6 +1610,13 @@ static void kmemleak_scan(void)
 	 */
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
+		/*
+		 * This is racy but we can save the overhead of lock/unlock
+		 * calls. The missed objects, if any, should be caught in
+		 * the next scan.
+		 */
+		if (!color_white(object))
+			continue;
 		raw_spin_lock_irq(&object->lock);
 		if (unreferenced_object(object) &&
 		    !(object->flags & OBJECT_REPORTED)) {
_

Patches currently in -mm which might be from longman@redhat.com are

mm-kmemleak-use-_irq-lock-unlock-variants-in-kmemleak_scan-_clear.patch
mm-kmemleak-skip-unlikely-objects-in-kmemleak_scan-without-taking-lock.patch
mm-kmemleak-prevent-soft-lockup-in-first-object-iteration-loop-of-kmemleak_scan.patch


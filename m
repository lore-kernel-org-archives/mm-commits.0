Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FF9C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 22:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238272AbiDTWP7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 18:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349935AbiDTWP6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 18:15:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4B2205FF
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 15:13:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 15CE2CE1FDF
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 22:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2811CC385A1;
        Wed, 20 Apr 2022 22:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650492786;
        bh=8eS2qAhok3PN6lSDxrEvkLp/k9OyFrjG25d+3RQ7qT0=;
        h=Date:To:From:Subject:From;
        b=Fet42B+3iz66tr9NEUR9iiEA2BDEt3VwEiK56+dD4kAEWuXYJTR4Eg4SdRPS/dq7+
         NFLJ52+ZxXSU1I/MumGY22xxQC4CzGKKgrKorqiHrTUNuB6rMUe0TLVZUvW1ZK0gqP
         Kw4aNMX3UfQS+vSgysMeEbzo51pdpE8kj0e3x+CE=
Date:   Wed, 20 Apr 2022 15:13:05 -0700
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        jhubbard@nvidia.com, jgg@nvidia.com, christian.koenig@amd.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_notifierc-fix-race-in-mmu_interval_notifier_remove.patch added to -mm tree
Message-Id: <20220420221306.2811CC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmu_notifier.c: fix race in mmu_interval_notifier_remove()
has been added to the -mm tree.  Its filename is
     mm-mmu_notifierc-fix-race-in-mmu_interval_notifier_remove.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmu_notifierc-fix-race-in-mmu_interval_notifier_remove.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmu_notifierc-fix-race-in-mmu_interval_notifier_remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/mmu_notifier.c: fix race in mmu_interval_notifier_remove()

In some cases it is possible for mmu_interval_notifier_remove() to race
with mn_tree_inv_end() allowing it to return while the notifier data
structure is still in use.  Consider the following sequence:

CPU0 - mn_tree_inv_end()            CPU1 - mmu_interval_notifier_remove()
----------------------------------- ------------------------------------
                                    spin_lock(subscriptions->lock);
                                    seq = subscriptions->invalidate_seq;
spin_lock(subscriptions->lock);     spin_unlock(subscriptions->lock);
subscriptions->invalidate_seq++;
                                    wait_event(invalidate_seq != seq);
                                    return;
interval_tree_remove(interval_sub); kfree(interval_sub);
spin_unlock(subscriptions->lock);
wake_up_all();

As the wait_event() condition is true it will return immediately.  This
can lead to use-after-free type errors if the caller frees the data
structure containing the interval notifier subscription while it is still
on a deferred list.  Fix this by taking the appropriate lock when reading
invalidate_seq to ensure proper synchronisation.

Link: https://lkml.kernel.org/r/20220420043734.476348-1-apopple@nvidia.com
Fixes: 99cb252f5e68 ("mm/mmu_notifier: add an interval tree notifier")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/mmu_notifier.c~mm-mmu_notifierc-fix-race-in-mmu_interval_notifier_remove
+++ a/mm/mmu_notifier.c
@@ -1036,6 +1036,18 @@ int mmu_interval_notifier_insert_locked(
 }
 EXPORT_SYMBOL_GPL(mmu_interval_notifier_insert_locked);
 
+static bool
+mmu_interval_seq_released(struct mmu_notifier_subscriptions *subscriptions,
+			  unsigned long seq)
+{
+	bool ret;
+
+	spin_lock(&subscriptions->lock);
+	ret = subscriptions->invalidate_seq != seq;
+	spin_unlock(&subscriptions->lock);
+	return ret;
+}
+
 /**
  * mmu_interval_notifier_remove - Remove a interval notifier
  * @interval_sub: Interval subscription to unregister
@@ -1083,7 +1095,7 @@ void mmu_interval_notifier_remove(struct
 	lock_map_release(&__mmu_notifier_invalidate_range_start_map);
 	if (seq)
 		wait_event(subscriptions->wq,
-			   READ_ONCE(subscriptions->invalidate_seq) != seq);
+			   mmu_interval_seq_released(subscriptions, seq));
 
 	/* pairs with mmgrab in mmu_interval_notifier_insert() */
 	mmdrop(mm);
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-mmu_notifierc-fix-race-in-mmu_interval_notifier_remove.patch
mm-add-selftests-for-migration-entries.patch


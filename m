Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E48F8C7EE2E
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 18:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjFISoi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 14:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjFISoe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 14:44:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1D1359C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 11:44:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 242F065AD5
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 18:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A130C433D2;
        Fri,  9 Jun 2023 18:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686336272;
        bh=Wrrp70c+ard+mZJFQfahbEoNRk/4VLey7yyY9Y6d5F4=;
        h=Date:To:From:Subject:From;
        b=K2cY/qE5iml8MKeES5otPeKLh7q75Uo4G6f1E2kV2x1tk3EqiOIGVSZR1OHYyX3O2
         BLznt2UEk8NppmsKMDRUMbXtu2Rp+aUnf2vZqv2UnkexXX2WYoe7mxfbKrr46b9ESG
         qEUUte1lsl3bX/UeXuZthx942kbLPDK+OzkGLeOE=
Date:   Fri, 09 Jun 2023 11:44:31 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
        tkhai@ya.ru, roman.gushchin@linux.dev, muchun.song@linux.dev,
        david@fromorbit.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch added to mm-hotfixes-unstable branch
Message-Id: <20230609184432.7A130C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: vmscan: remove shrinker_rwsem from synchronize_shrinkers()"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Revert "mm: vmscan: remove shrinker_rwsem from synchronize_shrinkers()"
Date: Fri, 9 Jun 2023 08:15:13 +0000

This reverts commit 1643db98d9b314e0a592d152603094fbf7ab906e.

Kernel test robot reports -88.8% regression in stress-ng.ramfs.ops_per_sec
test case [1], which is caused by commit f95bdb700bc6 ("mm: vmscan: make
global slab shrink lockless").  The root cause is that SRCU has to be
careful to not frequently check for SRCU read-side critical section exits.
Therefore, even if no one is currently in the SRCU read-side critical
section, synchronize_srcu() cannot return quickly.  That's why
unregister_shrinker() has become slower.

We will try to use the refcount+RCU method [2] proposed by Dave Chinner to
continue to re-implement the lockless slab shrink.  So we still need
shrinker_rwsem in synchronize_shrinkers() after reverting the
shrinker_srcu related changes.

[1]. https://lore.kernel.org/lkml/202305230837.db2c233f-yujie.liu@intel.com/
[2]. https://lore.kernel.org/lkml/ZIJhou1d55d4H1s0@dread.disaster.area/

Link: https://lkml.kernel.org/r/20230609081518.3039120-3-qi.zheng@linux.dev
Reported-by: kernel test robot <yujie.liu@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202305230837.db2c233f-yujie.liu@intel.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~revert-mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers
+++ a/mm/vmscan.c
@@ -831,11 +831,15 @@ EXPORT_SYMBOL(unregister_shrinker);
 /**
  * synchronize_shrinkers - Wait for all running shrinkers to complete.
  *
- * This is useful to guarantee that all shrinker invocations have seen an
- * update, before freeing memory.
+ * This is equivalent to calling unregister_shrink() and register_shrinker(),
+ * but atomically and with less overhead. This is useful to guarantee that all
+ * shrinker invocations have seen an update, before freeing memory, similar to
+ * rcu.
  */
 void synchronize_shrinkers(void)
 {
+	down_write(&shrinker_rwsem);
+	up_write(&shrinker_rwsem);
 	atomic_inc(&shrinker_srcu_generation);
 	synchronize_srcu(&shrinker_srcu);
 }
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

revert-mm-shrinkers-convert-shrinker_rwsem-to-mutex.patch
revert-mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch
revert-mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred.patch
revert-mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless.patch
revert-mm-vmscan-add-shrinker_srcu_generation.patch
revert-mm-vmscan-make-memcg-slab-shrink-lockless.patch
revert-mm-vmscan-make-global-slab-shrink-lockless.patch
mm-vmscan-move-shrinker_debugfs_remove-before-synchronize_srcu.patch


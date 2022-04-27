Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FA8C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 03:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348105AbiD0DMD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 23:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242711AbiD0DMC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 23:12:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870F7106DDC
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 20:08:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22A6361CAA
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 03:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7532BC385A0;
        Wed, 27 Apr 2022 03:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651028932;
        bh=y8EW9AluwSLlx7TCNq2cba4A9zOShmBo24rKNp9Gk5w=;
        h=Date:To:From:Subject:From;
        b=pgF5RQj/7lbCtBoGVGoRzsKcnn9WxH7R/X2args8Y+UHqQ+fAvkXyGkghtYibvMHH
         1Y0rjJ7bHUEkrhyCnM9U3VaPRi8BwP233wlEwhD5km/84oqr+zqoDiWH91xP36HPGf
         VTBWAMSI/LGXxwSMnoeBhNX3oBJVyKd4vckzjzyo=
Date:   Tue, 26 Apr 2022 20:08:51 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-fix-comment-for-current_may_throttle-fix.patch removed from -mm tree
Message-Id: <20220427030852.7532BC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-fix-comment-for-current_may_throttle-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-comment-for-current_may_throttle-fix.patch

This patch was dropped because it was folded into mm-vmscan-fix-comment-for-current_may_throttle.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-fix-comment-for-current_may_throttle-fix

tweak grammar

Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-comment-for-current_may_throttle-fix
+++ a/mm/vmscan.c
@@ -2314,9 +2314,9 @@ static unsigned int move_pages_to_lru(st
 }
 
 /*
- * If a kernel thread (such as nfsd for loop-back mounts) services
- * a backing device by writing to the page cache it sets PF_LOCAL_THROTTLE.
- * In that case we should not throttle it otherwise it is safe to do so.
+ * If a kernel thread (such as nfsd for loop-back mounts) services a backing
+ * device by writing to the page cache it sets PF_LOCAL_THROTTLE. In this case
+ * we should not throttle.  Otherwise it is safe to do so.
  */
 static int current_may_throttle(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time-fix.patch
mm.patch
mm-vmscan-fix-comment-for-current_may_throttle.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mapletree-vs-khugepaged.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


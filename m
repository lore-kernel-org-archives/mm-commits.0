Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6416FC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 23:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbiDYXZ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 19:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbiDYXZ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 19:25:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB872A712
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 16:22:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46FBF615B0
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 23:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B127C385A4;
        Mon, 25 Apr 2022 23:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650928939;
        bh=oTGrdltRxusuKSgKYhyIZxjX9H4welb3zUtNtkJBGic=;
        h=Date:To:From:Subject:From;
        b=n747D0Q9B12Wqbi4WFaZwYHW8m1Q2+BzkwFjmOWpsRV2q7VUo+CWO9O65m8M5aAU9
         hn0PLvlaVlDB1+xp1I452/YSfTFhQ2QhzwylB8GUgE+KAH9zqONUjo8qmAgRmTNSTG
         I5hso1m/T/FhCM+mVfR31+UCZ3aVcUadZZEDXbts=
Date:   Mon, 25 Apr 2022 16:22:18 -0700
To:     mm-commits@vger.kernel.org, wangqing@vivo.com, snitzer@kernel.org,
        agk@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + md-use-time_is_before_eq_jiffies-instead-of-open-coding-it-fix.patch added to -mm tree
Message-Id: <20220425232219.8B127C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: md-use-time_is_before_eq_jiffies-instead-of-open-coding-it-fix
has been added to the -mm tree.  Its filename is
     md-use-time_is_before_eq_jiffies-instead-of-open-coding-it-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/md-use-time_is_before_eq_jiffies-instead-of-open-coding-it-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/md-use-time_is_before_eq_jiffies-instead-of-open-coding-it-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: md-use-time_is_before_eq_jiffies-instead-of-open-coding-it-fix

add missed parenthesis

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-writecache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-writecache.c~md-use-time_is_before_eq_jiffies-instead-of-open-coding-it-fix
+++ a/drivers/md/dm-writecache.c
@@ -1973,7 +1973,7 @@ restart:
 	       (wc->writeback_all ||
 		wc->freelist_size + wc->writeback_size <= wc->freelist_low_watermark ||
 		time_is_before_eq_jiffies(container_of(wc->lru.prev, struct wc_entry,
-		lru)->age + wc->max_age - wc->max_age / MAX_AGE_DIV)) {
+		lru)->age + wc->max_age - wc->max_age / MAX_AGE_DIV))) {
 
 		n_walked++;
 		if (unlikely(n_walked > WRITEBACK_LATENCY) &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time-fix.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
md-use-time_is_before_eq_jiffies-instead-of-open-coding-it-fix.patch


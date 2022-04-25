Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3E1C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 23:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiDZACi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 20:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbiDZAC0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 20:02:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C436411114D
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 16:59:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62EC061616
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 23:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5804C385A7;
        Mon, 25 Apr 2022 23:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650931159;
        bh=5Ubg8nku1LTzJofRFtshDHfGwVinKXHcd2Y6OeUzptE=;
        h=Date:To:From:Subject:From;
        b=T1cOK6FfccWkwo2lZ7+gFqMwSObm39Slllw63my4uOWc0FlIdO0zJb92GurrbJKl0
         8VM/yQ8klPNUZCb4pg30QqeN5bldm7IwfmZVJmmyWJDbYj3opQGtOmE9geiFX1YTH2
         tFqELyVUJZTR0kMptED7yefOpKPFu/lgPMRZJmaM=
Date:   Mon, 25 Apr 2022 16:59:19 -0700
To:     mm-commits@vger.kernel.org, wangqing@vivo.com, snitzer@kernel.org,
        agk@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] md-use-time_is_before_eq_jiffies-instead-of-open-coding-it-fix.patch removed from -mm tree
Message-Id: <20220425235919.B5804C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: md-use-time_is_before_eq_jiffies-instead-of-open-coding-it-fix
has been removed from the -mm tree.  Its filename was
     md-use-time_is_before_eq_jiffies-instead-of-open-coding-it-fix.patch

This patch was dropped because it had testing failures

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


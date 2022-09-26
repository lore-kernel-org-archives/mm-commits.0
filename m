Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 314B1C32771
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 18:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiIZS3C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 14:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIZS3A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 14:29:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A22B2AF
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 11:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D78CB80D38
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 18:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA96C433C1;
        Mon, 26 Sep 2022 18:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664216936;
        bh=bgM3g+UGocDHNbL5nhIoKD3Ud0LMe3n8xZIf69aLeiw=;
        h=Date:To:From:Subject:From;
        b=zcxHPhLgcaSxoN5/f7x0cpVu1yPw0ITTPbS+CT8rgj2I2t3u5VEvS66egV+A4zIjr
         kSToygkO3k1bT4qWLI1AOohRr2hD0A2BWK80xI+G8iVfbNujYdxVWGY6uoLKPsxbuV
         /zvmd5HasJS7XBkD0X9lHzqIWN0oZOUW9Ah6US+Q=
Date:   Mon, 26 Sep 2022 11:28:55 -0700
To:     mm-commits@vger.kernel.org, xueshuai@linux.alibaba.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mmhwpoison-check-mm-when-killing-accessing-process-fix.patch removed from -mm tree
Message-Id: <20220926182856.BEA96C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmhwpoison-check-mm-when-killing-accessing-process-fix
has been removed from the -mm tree.  Its filename was
     mmhwpoison-check-mm-when-killing-accessing-process-fix.patch

This patch was dropped because it was folded into mmhwpoison-check-mm-when-killing-accessing-process.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmhwpoison-check-mm-when-killing-accessing-process-fix
Date: Wed Sep 14 03:46:51 PM PDT 2022

remove unrelated whitespace alteration

Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory-failure.c~mmhwpoison-check-mm-when-killing-accessing-process-fix
+++ a/mm/memory-failure.c
@@ -756,7 +756,6 @@ static int kill_accessing_process(struct
 	else
 		ret = 0;
 	mmap_read_unlock(p->mm);
-
 	return ret > 0 ? -EHWPOISON : -EFAULT;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmhwpoison-check-mm-when-killing-accessing-process.patch
x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch
mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch


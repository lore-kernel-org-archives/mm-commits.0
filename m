Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57043C6FA82
	for <mm-commits@archiver.kernel.org>; Wed, 14 Sep 2022 22:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiINWsA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Sep 2022 18:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiINWr6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2022 18:47:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D2857895
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 15:47:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0CB561F46
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 22:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16212C433C1;
        Wed, 14 Sep 2022 22:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663195677;
        bh=LW5fYVv+cKElqsK5P7eODWbjVF2hUfJn3c+g5Y85eSg=;
        h=Date:To:From:Subject:From;
        b=J9ssGK9yxsm2mEqAkxciY3hVBpAg/lZupb63pzhG8w64JgMoRqp0jg72fsQd/bgqO
         wO7kAHo8fR7sT7BBFW2dQZjUwwq/SggBXTMicsnaGj0L4k+rWnKeKznYPnmGRbwhUk
         CA92a3iyWxpnOS3EhTb7EWt6TdEht6iCW5FAIBNw=
Date:   Wed, 14 Sep 2022 15:47:56 -0700
To:     mm-commits@vger.kernel.org, xueshuai@linux.alibaba.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhwpoison-check-mm-when-killing-accessing-process-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20220914224757.16212C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmhwpoison-check-mm-when-killing-accessing-process-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmhwpoison-check-mm-when-killing-accessing-process-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmhwpoison-check-mm-when-killing-accessing-process-fix.patch

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

mmhwpoison-check-mm-when-killing-accessing-process-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
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


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBCBECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiJ1VHQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJ1VHP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:07:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3842498BC
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:07:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB87062A77
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A5FC433D7;
        Fri, 28 Oct 2022 21:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991230;
        bh=ieUbF/ma8upmlRe5IEufmWVnDdPQXtsy94Wa80llfJ4=;
        h=Date:To:From:Subject:From;
        b=swm/nf+iYTuevipQDTpqXOs9VgkJPPHEmS9dvXjXJigCAnmba4cvQVTxWYLKwd0Ro
         zNV5ndtUFulFIi3AqY8/JqV7DjDWfCEnXUPecYRiSw5twtBll/R8tfU8cmRmrVXGc/
         FCTHQMvAFK5WvFQKe0o252FFDpzyTciSo2YkW7/g=
Date:   Fri, 28 Oct 2022 14:07:09 -0700
To:     mm-commits@vger.kernel.org, mark.rutland@arm.com,
        jiebin.sun@intel.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ipc-msgc-fix-percpu_counter-use-after-free.patch removed from -mm tree
Message-Id: <20221028210710.09A5FC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ipc/msg.c: fix percpu_counter use after free
has been removed from the -mm tree.  Its filename was
     ipc-msgc-fix-percpu_counter-use-after-free.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc/msg.c: fix percpu_counter use after free
Date: Thu Oct 20 09:19:22 PM PDT 2022

These percpu counters are referenced in free_ipcs->freeque, so destroy
them later.

Fixes: 72d1e611082e ("ipc/msg: mitigate the lock contention with percpu counter")
Reported-by: syzbot+96e659d35b9d6b541152@syzkaller.appspotmail.com
Tested-by: Mark Rutland <mark.rutland@arm.com>
Cc: Jiebin Sun <jiebin.sun@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/ipc/msg.c~ipc-msgc-fix-percpu_counter-use-after-free
+++ a/ipc/msg.c
@@ -1329,11 +1329,11 @@ fail_msg_bytes:
 #ifdef CONFIG_IPC_NS
 void msg_exit_ns(struct ipc_namespace *ns)
 {
-	percpu_counter_destroy(&ns->percpu_msg_bytes);
-	percpu_counter_destroy(&ns->percpu_msg_hdrs);
 	free_ipcs(ns, &msg_ids(ns), freeque);
 	idr_destroy(&ns->ids[IPC_MSG_IDS].ipcs_idr);
 	rhashtable_destroy(&ns->ids[IPC_MSG_IDS].key_ht);
+	percpu_counter_destroy(&ns->percpu_msg_bytes);
+	percpu_counter_destroy(&ns->percpu_msg_hdrs);
 }
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-gup-remove-foll_migration-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch


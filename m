Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B04DC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 20:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344602AbiC1U0u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 16:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344822AbiC1U0t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 16:26:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7F24C7B7
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 13:24:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C94CB81106
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 20:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A90DC34100;
        Mon, 28 Mar 2022 20:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648499097;
        bh=zzRjbOYTI5UJ3DtkRYXlWu7SU/wuW+gPT/FFgbJsAW4=;
        h=Date:To:From:Subject:From;
        b=bZmSlXXCI3IQIXXRDtlccdiL1mbjkt0ceCkakWrccQJ67WzTLhLDadH6JFJc2dQ1C
         smABiKjzj+clGKESdGXUzSZ1HnSNe/Avh0DxNTP6TXu7xJsPbU/SdGMsT33Kj9DPDw
         vMZl7Vyd2i6jDUp2PxIAt9U5FZ51zZEeUiEeBO5Y=
Date:   Mon, 28 Mar 2022 13:24:56 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        linmiaohe@huawei.com, hughd@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-make-shmem_init-return-void-fix.patch added to -mm tree
Message-Id: <20220328202457.1A90DC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shmem-make-shmem_init-return-void-fix
has been added to the -mm tree.  Its filename is
     mm-shmem-make-shmem_init-return-void-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-make-shmem_init-return-void-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-make-shmem_init-return-void-fix.patch

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
Subject: mm-shmem-make-shmem_init-return-void-fix

remove `return;' from void-returning function, per Muchun Song

Cc: Hugh Dickins <hughd@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-make-shmem_init-return-void-fix
+++ a/mm/shmem.c
@@ -3994,8 +3994,6 @@ void __init shmem_init(void)
 
 	shm_mnt = kern_mount(&shmem_fs_type);
 	BUG_ON(IS_ERR(shm_mnt));
-
-	return;
 }
 
 int shmem_unuse(unsigned int type)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-shmem-make-shmem_init-return-void-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E62CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 20:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346641AbiDNUqZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 16:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344952AbiDNUqY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 16:46:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1683CEA346
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 13:43:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF3AEB8277E
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 20:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DDDC385A5;
        Thu, 14 Apr 2022 20:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649969035;
        bh=z69N2fv1r5JPRLBVcKfnFhOOFEJcKc4JSzr8rhefXbE=;
        h=Date:To:From:Subject:From;
        b=FhAZKzlK4M8YzMSDOAecU+d+Ef4LnZt3cUR5v4hUqGIoCC/hfuZykyvOq6dfZbwB4
         RRVAikNpbKilcQPngnI0b2Ebe+gJSN8q28i/KX6/pBnMNAezfhmNCVMQIj7XIjmoIM
         hyGDFdplhoanUHjmvRuJg5iPCsVwUcSjsMDRk2Js=
Date:   Thu, 14 Apr 2022 13:43:54 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-comment-for-current_may_throttle-fix.patch added to -mm tree
Message-Id: <20220414204355.57DDDC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-fix-comment-for-current_may_throttle-fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-comment-for-current_may_throttle-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-comment-for-current_may_throttle-fix.patch

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
Subject: mm-vmscan-fix-comment-for-current_may_throttle-fix

tweak grammar

Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmscan.c~mm-vmscan-fix-comment-for-current_may_throttle-fix
+++ a/mm/vmscan.c
@@ -2332,9 +2332,9 @@ static unsigned int move_pages_to_lru(st
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

revert-fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch
revert-fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper-vs-maple-tree.patch
mglru-vs-maple-tree.patch
mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


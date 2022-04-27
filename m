Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB24AC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 01:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357026AbiD0CCk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 22:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357028AbiD0CCj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 22:02:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B37175F8E
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 18:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0579161BF0
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 01:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52295C385AC;
        Wed, 27 Apr 2022 01:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651024768;
        bh=zb5xzW59Qwm9xAolwJ5nAPhwieCNgALFShfxeIIELew=;
        h=Date:To:From:Subject:From;
        b=k5tcpB8NUmhOjVaX1ixKUw/+FTBfphiCd86TxyRUfaN1iUkDN4RrC+UbtFr70DCO+
         fWcueim1Sqyts/H1yWNoRydVEUaJFiNKrGHkA5ukjARtSfWkydgxIhloBiovjQOpks
         uX3Cpqitr8RTFXQamkCuouLnly3FBDUnZD95hPoo=
Date:   Tue, 26 Apr 2022 18:59:27 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mapletree-vs-khugepaged.patch added to -mm tree
Message-Id: <20220427015928.52295C385AC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mapletree-vs-khugepaged
has been added to the -mm tree.  Its filename is
     mapletree-vs-khugepaged.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mapletree-vs-khugepaged.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mapletree-vs-khugepaged.patch

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
Subject: mapletree-vs-khugepaged

Fix mapletree for patch series "Make khugepaged collapse readonly FS THP
more consistent", v3.

Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mapletree-vs-khugepaged
+++ a/mm/mmap.c
@@ -2587,7 +2587,7 @@ unsigned long mmap_region(struct file *f
 	/* Actually expand, if possible */
 	if (vma &&
 	    !vma_expand(&mas, vma, merge_start, merge_end, vm_pgoff, next)) {
-		khugepaged_enter_vma_merge(vma, vm_flags);
+		khugepaged_enter_vma(vma, vm_flags);
 		goto expanded;
 	}
 
@@ -3008,7 +3008,7 @@ static int do_brk_flags(struct ma_state
 			anon_vma_interval_tree_post_update_vma(vma);
 			anon_vma_unlock_write(vma->anon_vma);
 		}
-		khugepaged_enter_vma_merge(vma, flags);
+		khugepaged_enter_vma(vma, flags);
 		goto out;
 	}
 
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
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mapletree-vs-khugepaged.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


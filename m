Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26412C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Apr 2022 02:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiDMCpd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 22:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiDMCpc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 22:45:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5FD3E0E2
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 19:43:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99EF861946
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 02:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B35C385A5;
        Wed, 13 Apr 2022 02:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649817789;
        bh=PYtylcW2sICq0q752o3KtypQ0YabUDBnMxhsMnfkUKo=;
        h=Date:To:From:Subject:From;
        b=eur8hPwDyR/WjKMJZv08szbtQ3TJQRLagQbOi38Wd2w+AVK9Y2FOKWcfR4O826c5v
         VYirtUyGdNUL8FasW+l6Mt+O3Zovc9MazQGz5+Cq2kgnZTJkIsgRpnVjDJj1yhz22y
         rQcd3hK6hce6fUsldIOPV+fTYaB4zBbhNa7lB0Go=
Date:   Tue, 12 Apr 2022 19:43:08 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-next-git-rejects.patch added to -mm tree
Message-Id: <20220413024308.E2B35C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/x86.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/arch/x86/kvm/x86.c~linux-next-git-rejects
+++ a/arch/x86/kvm/x86.c
@@ -3101,16 +3101,6 @@ static int kvm_guest_time_update(struct
 
 	vcpu->hv_clock.flags = pvclock_flags;
 
-<<<<<<< HEAD
-	if (vcpu->pv_time_enabled)
-		kvm_setup_pvclock_page(v, &vcpu->pv_time, 0);
-	if (vcpu->xen.vcpu_info_set)
-		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_info_cache,
-				       offsetof(struct compat_vcpu_info, time));
-	if (vcpu->xen.vcpu_time_info_set)
-		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
-	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
-=======
 	if (vcpu->pv_time.active)
 		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0);
 	if (vcpu->xen.vcpu_info_cache.active)
@@ -3120,7 +3110,6 @@ static int kvm_guest_time_update(struct
 		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
 	if (!v->vcpu_idx)
 		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
->>>>>>> linux-next/akpm-base
 	return 0;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch
revert-fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch
mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist-fix.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


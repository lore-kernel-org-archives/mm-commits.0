Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DF0C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 20:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbiDNUCt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 16:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346061AbiDNUCi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 16:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39D4DBD37
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 13:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 345D261E4A
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 20:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BC0C385A5;
        Thu, 14 Apr 2022 20:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649966410;
        bh=abOu9d0MHflidEC436FD63M8AyB/4gzrLqZ9ce3gqMY=;
        h=Date:To:From:Subject:From;
        b=V2jP59fCogRiaJ6PXXBu2t3tlyc5YDYF1sm2Z3jySvD8mfmMSNl7lEzN2U26E8q3H
         PHUWMEEFRU+Nm12lBmOrbfqwIJnnuz9h6FNr/+REUTeM4KpcNEsRmYufs+HV2cuPD+
         y/F1ZkXH+uulLRlShov8s9ecBWOCptAGwDzcU3TM=
Date:   Thu, 14 Apr 2022 13:00:09 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Message-Id: <20220414200010.75BC0C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/x86/kvm/x86.c~linux-next-git-rejects
+++ a/arch/x86/kvm/x86.c
@@ -3101,15 +3101,6 @@ static int kvm_guest_time_update(struct
 
 	vcpu->hv_clock.flags = pvclock_flags;
 
-<<<<<<< HEAD
-	if (vcpu->pv_time_enabled)
-		kvm_setup_pvclock_page(v, &vcpu->pv_time, 0);
-	if (vcpu->xen.vcpu_info_set)
-		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_info_cache,
-				       offsetof(struct compat_vcpu_info, time));
-	if (vcpu->xen.vcpu_time_info_set)
-		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
-=======
 	if (vcpu->pv_time.active)
 		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0);
 	if (vcpu->xen.vcpu_info_cache.active)
@@ -3117,7 +3108,6 @@ static int kvm_guest_time_update(struct
 					offsetof(struct compat_vcpu_info, time));
 	if (vcpu->xen.vcpu_time_info_cache.active)
 		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
->>>>>>> linux-next/akpm-base
 	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch
revert-fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper-vs-maple-tree.patch
mglru-vs-maple-tree.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5459DC678D4
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjARXvb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjARXvF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:51:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F974995A
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:49:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7A38B81F15
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53000C433D2;
        Wed, 18 Jan 2023 23:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674085794;
        bh=kUS5ac9XeletWxD/7efqEazftmbZf/OI7n602JcWJJ8=;
        h=Date:To:From:Subject:From;
        b=wn5vBmAWSUOtPWhM3qqAtR/8HMs0GyEpb8xkptaD62Xy+zDVKKBImaQEkkKnfzcUe
         Wq5GzaP5CuZnI6VRu2OHBcuID68R32ct15vdcMAxi014i14Y++anwcUTEUVbUk5YXy
         D4oq1O+EAApo5WmOVw8aEcb5VO+Xu6i2SViIwwRk=
Date:   Wed, 18 Jan 2023 15:49:53 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        jeffxu@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch removed from -mm tree
Message-Id: <20230118234954.53000C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix
has been removed from the -mm tree.  Its filename was
     mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch

This patch was dropped because it was folded into mm-memfd-add-mfd_noexec_seal-and-mfd_exec.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix
Date: Thu Dec 15 06:58:24 PM PST 2022

add stub functions to fix build

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jeff Xu <jeffxu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/kernel/pid_sysctl.h~mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix
+++ a/kernel/pid_sysctl.h
@@ -52,8 +52,10 @@ static inline void register_pid_ns_sysct
 	register_sysctl_paths(vm_path, pid_ns_ctl_table_vm);
 }
 #else
+static inline void initialize_memfd_noexec_scope(struct pid_namespace *ns) {}
 static inline void set_memfd_noexec_scope(struct pid_namespace *ns) {}
 static inline void register_pid_ns_ctl_table_vm(void) {}
+static inline void register_pid_ns_sysctl_table_vm(void) {}
 #endif
 
 #endif /* LINUX_PID_SYSCTL_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch
mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBFBDC677F1
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjARXv3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjARXvG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:51:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C304A238
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:50:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5324CB81F15
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E46C433F0;
        Wed, 18 Jan 2023 23:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674085798;
        bh=4FB7G2KcZLX8Lr06LaQM9V+CBXXotk2FZY4KL2jlJnY=;
        h=Date:To:From:Subject:From;
        b=bbUtkYL79qUyche+0DFH73yYRFaTG9D43MhoXR97xu7wfoBpauSaMQOPyHy7vtL0f
         uUBaeM8vVbWKl7XRZVZFgckxscO5nqmRT2V/v8dBgUdpAb7lkjV+kAP3V+Y923+/ap
         PGmklYMADBH8P760SpHB1AJNy+B8JxvxKF5XdqnI=
Date:   Wed, 18 Jan 2023 15:49:57 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, jeffxu@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch removed from -mm tree
Message-Id: <20230118234958.08E46C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix
has been removed from the -mm tree.  Its filename was
     mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch

This patch was dropped because it was folded into mm-memfd-add-mfd_noexec_seal-and-mfd_exec.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix
Date: Tue Dec 20 02:06:58 PM PST 2022

fix CONFIG_SYSCTL=n warning

Reported-by: kernel test robot <lkp@intel.com>
Cc: Jeff Xu <jeffxu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memfd.c~mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix
+++ a/mm/memfd.c
@@ -271,7 +271,6 @@ SYSCALL_DEFINE2(memfd_create,
 		unsigned int, flags)
 {
 	char comm[TASK_COMM_LEN];
-	struct pid_namespace *ns;
 	unsigned int *file_seals;
 	struct file *file;
 	int fd, error;
@@ -295,6 +294,7 @@ SYSCALL_DEFINE2(memfd_create,
 	if (!(flags & (MFD_EXEC | MFD_NOEXEC_SEAL))) {
 #ifdef CONFIG_SYSCTL
 		int sysctl = MEMFD_NOEXEC_SCOPE_EXEC;
+		struct pid_namespace *ns;
 
 		ns = task_active_pid_ns(current);
 		if (ns)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch
mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CF5C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 30 Nov 2021 02:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhK3C7x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 21:59:53 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45020 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhK3C7x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 21:59:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8370CE16EC
        for <mm-commits@vger.kernel.org>; Tue, 30 Nov 2021 02:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44CCC53FAD;
        Tue, 30 Nov 2021 02:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638240992;
        bh=kB2x1p0AaTcVI8zmXZ5Z3vGXHfdp2sl6mD9haVHs3WI=;
        h=Date:From:To:Subject:From;
        b=roaTxZ/DMVwYXN+T8aL+8/PEy7rBuRTR+PQMqnc9lqhz2UaXXtNEVKm/UEhGlvDcT
         D7+K2CcKqZNJ2yPrSgQqVKtuGgtH1opx8BTuZM+0xqCHPhH6tRN2U+onTPpIlhBmZA
         TEHA0qwzPUcnhyhcfS2eRlsOxFhd5bXq0jEV51Qk=
Date:   Mon, 29 Nov 2021 18:56:31 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mcgrof@kernel.org,
        mm-commits@vger.kernel.org
Subject:  +
 sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch added to -mm
 tree
Message-ID: <20211130025631.WXL4bc542%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl-add-helper-to-register-a-sysctl-mount-point-fix
has been added to the -mm tree.  Its filename is
     sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch

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
Subject: sysctl-add-helper-to-register-a-sysctl-mount-point-fix

export register_sysctl_mount_point() to modules

ERROR: modpost: "register_sysctl_mount_point" [fs/binfmt_misc.ko] undefined!

Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/proc_sysctl.c~sysctl-add-helper-to-register-a-sysctl-mount-point-fix
+++ a/fs/proc/proc_sysctl.c
@@ -47,6 +47,7 @@ struct ctl_table_header *register_sysctl
 {
 	return register_sysctl(path, sysctl_mount_point);
 }
+EXPORT_SYMBOL(register_sysctl_mount_point);
 
 static bool is_empty_dir(struct ctl_table_header *head)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-page-table-check-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


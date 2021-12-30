Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A445C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 30 Dec 2021 00:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbhL3Aqg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Dec 2021 19:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbhL3Aqf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Dec 2021 19:46:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B3EC061574
        for <mm-commits@vger.kernel.org>; Wed, 29 Dec 2021 16:46:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2D81615BB;
        Thu, 30 Dec 2021 00:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F0CC36AEA;
        Thu, 30 Dec 2021 00:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640825194;
        bh=e40FWKrLLzAnMnQ++a1k/z8r46O/YYAOawW1g44s9zU=;
        h=Date:From:To:Subject:From;
        b=UgNarDPMt7+4n95R3ygGwEPif0OZMRILvqaEe3271cR5Scg6NXCskEPJ6nQjw10vu
         Nr5ZZc7tdboB+XNlchMzmEETnidXlItHDUpttX3lraRPcO/PPm27AbGpNAs84u+VuF
         7VRf6SLfAD/MtQm04dBCkHNmJBHOGHDMaWHw+04U=
Date:   Wed, 29 Dec 2021 16:46:33 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        viro@zeniv.linux.org.uk, steve@sk2.org, nixiaoming@huawei.com,
        mic@digikonet, mcgrof@kernel.org, kernel@tuxforce.de,
        keescook@chromium.org, jlayton@kernel.org, ebiederm@xmission.com,
        crope@iki.fi, bfields@fieldses.org,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
Subject:  +
 sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch added to -mm tree
Message-ID: <20211230004633.A1QYu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl-move-maxolduid-as-a-sysctl-specific-const-fix
has been added to the -mm tree.  Its filename is
     sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-move-maxolduid-as-a-sy=
sctl-specific-const-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-move-maxolduid-as-a-sy=
sctl-specific-const-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sysctl-move-maxolduid-as-a-sysctl-specific-const-fix

fix sysctl_vals[], per Micka=C3=ABl.

Cc: Micka=C3=ABl Sala=C3=BCn <mic@digikonet>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/proc_sysctl.c~sysctl-move-maxolduid-as-a-sysctl-specific-cons=
t-fix
+++ a/fs/proc/proc_sysctl.c
@@ -26,7 +26,7 @@ static const struct file_operations proc
 static const struct inode_operations proc_sys_dir_operations;
=20
 /* shared constants to be used in various sysctls */
-const int sysctl_vals[] =3D { -1, 0, 1, 2, 4, 100, 200, 1000, 65535, INT_M=
AX };
+const int sysctl_vals[] =3D { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MA=
X, 65535 };
 EXPORT_SYMBOL(sysctl_vals);
=20
 const unsigned long sysctl_long_vals[] =3D { 0, 1, LONG_MAX };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-che=
ckpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-=
fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
memcg-add-per-memcg-vmalloc-stat-v2-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes=
.patch
mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.pa=
tch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-=
fixes.patch
hashh-remove-unused-define-directive-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2F5C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 00:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhK1AJr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 19:09:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44572 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbhK1AHr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 19:07:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32C12B80916
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 00:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2709C53FAD;
        Sun, 28 Nov 2021 00:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638057869;
        bh=OxnJlJTRNsyIAtoq5h2r8YgCRFaRdKo9tEaC5O/uSgk=;
        h=Date:From:To:Subject:From;
        b=b9x/F1kFGnFhwIiWqrnDAONiRzSgTZrjOMM/sYHBSHWScPiBw/cKRRrHj1uFApv3e
         xKS0vCL6+jro+PFd8EM7kAJCAFEaMfHPGdMo+dPXOt+GfKakQ+OSRNvypLVmjZM46W
         ORrIWIzZUtz345RmDaJE2OCe9hkGT1dz6rYzuYTc=
Date:   Sat, 27 Nov 2021 16:04:29 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        zhengqi.arch@bytedance.com
Subject:  +
 mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch added
 to -mm tree
Message-ID: <20211128000429.LFwblaBMG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix
has been added to the -mm tree.  Its filename is
     mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch

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
Subject: mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix

fix layout

Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-internal.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/percpu-internal.h~mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix
+++ a/mm/percpu-internal.h
@@ -123,8 +123,9 @@ static inline int pcpu_chunk_map_bits(st
  */
 static inline size_t pcpu_obj_full_size(size_t size)
 {
-	size_t extra_size =
-		size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
+	size_t extra_size;
+
+	extra_size = size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
 
 	return size * num_possible_cpus() + extra_size;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-page-table-check-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-git-rejects.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


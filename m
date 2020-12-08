Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1354FC1B0E3
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 01:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D38B5235F9
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 01:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgLHBft (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 20:35:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbgLHBft (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Dec 2020 20:35:49 -0500
Date:   Mon, 07 Dec 2020 17:35:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607391308;
        bh=wTJSWq2FvU3FECmb/iK7VFGFJSr/sIWz6XNB3KXazbo=;
        h=From:To:Subject:From;
        b=G0S3LVy9iiWBAgYo/hWR+WLJECyxTJPwWZYA3D8SH2AXHyM2HoiShE6LTmXyW0Z7u
         M3GF59lRIkYiJngW+uyn91NTU+LQW8cljY8ypC4B2fPtiyAlAi/Qq+5zMuvZy71rj2
         wmFGx1rq2yoD+FVDTwm20lzGQTO1salyZRgo46T4=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rppt@linux.ibm.com, rppt@kernel.org, akpm@linux-foundation.org
Subject:  +
 arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch added to -mm
 tree
Message-ID: <20201208013507.im9Fw%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix
has been added to the -mm tree.  Its filename is
     arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch

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
Subject: arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix

Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Rapoport <rppt@kernel.org>,
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/asm-generic/unistd.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/uapi/asm-generic/unistd.h~arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix
+++ a/include/uapi/asm-generic/unistd.h
@@ -863,9 +863,13 @@ __SYSCALL(__NR_process_madvise, sys_proc
 __SYSCALL(__NR_watch_mount, sys_watch_mount)
 #define __NR_epoll_pwait2 442
 __SC_COMP(__NR_epoll_pwait2, sys_epoll_pwait2, compat_sys_epoll_pwait2)
+#ifdef __ARCH_WANT_MEMFD_SECRET
+#define __NR_memfd_secret 443
+__SYSCALL(__NR_memfd_secret, sys_memfd_secret)
+#endif
 
 #undef __NR_syscalls
-#define __NR_syscalls 443
+#define __NR_syscalls 444
 
 /*
  * 32 bit systems traditionally used different
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


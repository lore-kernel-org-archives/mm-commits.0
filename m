Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50A4C4361B
	for <mm-commits@archiver.kernel.org>; Mon, 14 Dec 2020 22:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 695EF221EF
	for <mm-commits@archiver.kernel.org>; Mon, 14 Dec 2020 22:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388836AbgLNWug (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 17:50:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440767AbgLNWu3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 17:50:29 -0500
Date:   Mon, 14 Dec 2020 14:49:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607986187;
        bh=0VnojKlGdwNqBLlkBkyj7wLYxWb3xkpTXS6Syq+MqyI=;
        h=From:To:Subject:From;
        b=Vkv5Dc5Svs4W7oiHI6VyVfpAsY96F9yitDaX0354KfxQhcEAe28wgMw2aMK5cYzqa
         GZDAwZhuLV9pY97xyoPyGSGxwPKxFNiXrWS8GP/lhQpSUAoZBsisWzczzE7jTQwCFL
         1SfoWcgA8MpxBoNv+Pm1ez6pSOt0Q/frT+n+8eZo=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willemb@google.com, willy@infradead.org
Subject:  + epoll-wire-up-syscall-epoll_pwait2-fix.patch added to
 -mm tree
Message-ID: <20201214224947.S_Oze2Was%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll-wire-up-syscall-epoll_pwait2-fix
has been added to the -mm tree.  Its filename is
     epoll-wire-up-syscall-epoll_pwait2-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/epoll-wire-up-syscall-epoll_pwait2-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/epoll-wire-up-syscall-epoll_pwait2-fix.patch

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
Subject: epoll-wire-up-syscall-epoll_pwait2-fix

fix syscall numbers

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/syscalls/syscall.tbl      |    2 +-
 arch/arm/tools/syscall.tbl                  |    2 +-
 arch/ia64/kernel/syscalls/syscall.tbl       |    2 +-
 arch/m68k/kernel/syscalls/syscall.tbl       |    2 +-
 arch/microblaze/kernel/syscalls/syscall.tbl |    2 +-
 arch/mips/kernel/syscalls/syscall_n32.tbl   |    2 +-
 arch/mips/kernel/syscalls/syscall_n64.tbl   |    2 +-
 arch/mips/kernel/syscalls/syscall_o32.tbl   |    2 +-
 arch/parisc/kernel/syscalls/syscall.tbl     |    2 +-
 arch/powerpc/kernel/syscalls/syscall.tbl    |    2 +-
 arch/s390/kernel/syscalls/syscall.tbl       |    2 +-
 arch/sh/kernel/syscalls/syscall.tbl         |    2 +-
 arch/sparc/kernel/syscalls/syscall.tbl      |    2 +-
 arch/xtensa/kernel/syscalls/syscall.tbl     |    2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

--- a/arch/alpha/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2-fix
+++ a/arch/alpha/kernel/syscalls/syscall.tbl
@@ -481,4 +481,4 @@
 549	common	faccessat2			sys_faccessat2
 550	common	process_madvise			sys_process_madvise
 551	common	watch_mount			sys_watch_mount
-553	common	epoll_pwait2			sys_epoll_pwait2
+552	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/arm/tools/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2-fix
+++ a/arch/arm/tools/syscall.tbl
@@ -455,4 +455,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
-443	common	epoll_pwait2			sys_epoll_pwait2
+442	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/ia64/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2-fix
+++ a/arch/ia64/kernel/syscalls/syscall.tbl
@@ -362,4 +362,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
-443	common	epoll_pwait2			sys_epoll_pwait2
+442	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/m68k/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2-fix
+++ a/arch/m68k/kernel/syscalls/syscall.tbl
@@ -441,4 +441,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
-443	common	epoll_pwait2			sys_epoll_pwait2
+442	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/microblaze/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2-fix
+++ a/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -447,4 +447,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
-443	common	epoll_pwait2			sys_epoll_pwait2
+442	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl~epoll-wire-up-syscall-epoll_pwait2-fix
+++ a/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -380,4 +380,4 @@
 439	n32	faccessat2			sys_faccessat2
 440	n32	process_madvise			sys_process_madvise
 441	n32	watch_mount			sys_watch_mount
-443	n32	epoll_pwait2			sys_epoll_pwait2
+442	n32	epoll_pwait2			sys_epoll_pwait2
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl~epoll-wire-up-syscall-epoll_pwait2-fix
+++ a/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -356,4 +356,4 @@
 439	n64	faccessat2			sys_faccessat2
 440	n64	process_madvise			sys_process_madvise
 441	n64	watch_mount			sys_watch_mount
-443	n64	epoll_pwait2			sys_epoll_pwait2
+442	n64	epoll_pwait2			sys_epoll_pwait2
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl~epoll-wire-up-syscall-epoll_pwait2-fix
+++ a/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -429,4 +429,4 @@
 439	o32	faccessat2			sys_faccessat2
 440	o32	process_madvise			sys_process_madvise
 441	o32	watch_mount			sys_watch_mount
-443	o32	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
+442	o32	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
--- a/arch/parisc/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2-fix
+++ a/arch/parisc/kernel/syscalls/syscall.tbl
@@ -439,4 +439,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
-443	common	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
+442	common	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
--- a/arch/powerpc/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2-fix
+++ a/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -531,4 +531,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
-443	common	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
+442	common	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
--- a/arch/s390/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2-fix
+++ a/arch/s390/kernel/syscalls/syscall.tbl
@@ -444,4 +444,4 @@
 439  common	faccessat2		sys_faccessat2			sys_faccessat2
 440  common	process_madvise		sys_process_madvise		sys_process_madvise
 441	common	watch_mount		sys_watch_mount			sys_watch_mount
-443  common	epoll_pwait2		sys_epoll_pwait2		sys_epoll_pwait2
+442  common	epoll_pwait2		sys_epoll_pwait2		sys_epoll_pwait2
--- a/arch/sh/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2-fix
+++ a/arch/sh/kernel/syscalls/syscall.tbl
@@ -444,4 +444,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
-443	common	epoll_pwait2			sys_epoll_pwait2
+442	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/sparc/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2-fix
+++ a/arch/sparc/kernel/syscalls/syscall.tbl
@@ -487,4 +487,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
-443	common	epoll_pwait2			sys_epoll_pwait2
+442	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/xtensa/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2-fix
+++ a/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -412,4 +412,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
-443	common	epoll_pwait2			sys_epoll_pwait2
+442	common	epoll_pwait2			sys_epoll_pwait2
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-memcontrol-account-pagetables-per-node-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
epoll-wire-up-syscall-epoll_pwait2-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


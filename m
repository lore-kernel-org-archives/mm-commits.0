Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CD4C77B7A
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 21:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjEQVFO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 17:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjEQVFJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 17:05:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD637D91
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 14:05:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94DD064AF7
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 21:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D88C433D2;
        Wed, 17 May 2023 21:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684357505;
        bh=hL1q3qEVjxOGwtKIQ0sxCqIS3Ti8easGXCqswBZ8Egk=;
        h=Date:To:From:Subject:From;
        b=O0pkl5iwYuROEAmLFVnYJpLlWCbu3Rn2UmB9eRhsFJl5fmJvSwtwih54NKxVBNNe+
         US94f38Eg/ISAMYXBdoecIgQG5lbIPG8ka2MopW8Bj6pIHQUq53UeJimWZIm005lPm
         GejC17JSRXh7GbVXM3t3LZ9OtcFS9Wmbr7bypF4s=
Date:   Wed, 17 May 2023 14:05:04 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        tsbogend@alpha.franken.de, tj@kernel.org, tglx@linutronix.de,
        rafael@kernel.org, peterz@infradead.org, pavel@ucw.cz,
        paul@paul-moore.com, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mingo@redhat.com, longman@redhat.com,
        linux@armlinux.org.uk, hca@linux.ibm.com, eparis@redhat.com,
        dennis@kernel.org, deller@gmx.de, cl@linux.com,
        catalin.marinas@arm.com, boqun.feng@gmail.com, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + thread_info-move-function-declarations-to-linux-thread_infoh.patch added to mm-nonmm-unstable branch
Message-Id: <20230517210504.E5D88C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: thread_info: move function declarations to linux/thread_info.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     thread_info-move-function-declarations-to-linux-thread_infoh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/thread_info-move-function-declarations-to-linux-thread_infoh.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: thread_info: move function declarations to linux/thread_info.h
Date: Wed, 17 May 2023 15:11:01 +0200

There are a few __weak functions in kernel/fork.c, which architectures
can override. If there is no prototype, the compiler warns about them:

kernel/fork.c:164:13: error: no previous prototype for 'arch_release_task_struct' [-Werror=missing-prototypes]
kernel/fork.c:991:20: error: no previous prototype for 'arch_task_cache_init' [-Werror=missing-prototypes]
kernel/fork.c:1086:12: error: no previous prototype for 'arch_dup_task_struct' [-Werror=missing-prototypes]

There are already prototypes in a number of architecture specific headers
that have addressed those warnings before, but it's much better to have
these in a single place so the warning no longer shows up anywhere.

Link: https://lkml.kernel.org/r/20230517131102.934196-14-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/thread_info.h |    4 ----
 arch/s390/include/asm/thread_info.h  |    3 ---
 arch/sh/include/asm/thread_info.h    |    3 ---
 arch/x86/include/asm/thread_info.h   |    3 ---
 include/linux/thread_info.h          |    5 +++++
 5 files changed, 5 insertions(+), 13 deletions(-)

--- a/arch/arm64/include/asm/thread_info.h~thread_info-move-function-declarations-to-linux-thread_infoh
+++ a/arch/arm64/include/asm/thread_info.h
@@ -55,10 +55,6 @@ struct thread_info {
 void arch_setup_new_exec(void);
 #define arch_setup_new_exec     arch_setup_new_exec
 
-void arch_release_task_struct(struct task_struct *tsk);
-int arch_dup_task_struct(struct task_struct *dst,
-				struct task_struct *src);
-
 #endif
 
 #define TIF_SIGPENDING		0	/* signal pending */
--- a/arch/s390/include/asm/thread_info.h~thread_info-move-function-declarations-to-linux-thread_infoh
+++ a/arch/s390/include/asm/thread_info.h
@@ -52,9 +52,6 @@ struct thread_info {
 
 struct task_struct;
 
-void arch_release_task_struct(struct task_struct *tsk);
-int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
-
 void arch_setup_new_exec(void);
 #define arch_setup_new_exec arch_setup_new_exec
 
--- a/arch/sh/include/asm/thread_info.h~thread_info-move-function-declarations-to-linux-thread_infoh
+++ a/arch/sh/include/asm/thread_info.h
@@ -84,9 +84,6 @@ static inline struct thread_info *curren
 
 #define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
 
-extern void arch_task_cache_init(void);
-extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
-extern void arch_release_task_struct(struct task_struct *tsk);
 extern void init_thread_xstate(void);
 
 #endif /* __ASSEMBLY__ */
--- a/arch/x86/include/asm/thread_info.h~thread_info-move-function-declarations-to-linux-thread_infoh
+++ a/arch/x86/include/asm/thread_info.h
@@ -232,9 +232,6 @@ static inline int arch_within_stack_fram
 			   current_thread_info()->status & TS_COMPAT)
 #endif
 
-extern void arch_task_cache_init(void);
-extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
-extern void arch_release_task_struct(struct task_struct *tsk);
 extern void arch_setup_new_exec(void);
 #define arch_setup_new_exec arch_setup_new_exec
 #endif	/* !__ASSEMBLY__ */
--- a/include/linux/thread_info.h~thread_info-move-function-declarations-to-linux-thread_infoh
+++ a/include/linux/thread_info.h
@@ -256,6 +256,11 @@ check_copy_size(const void *addr, size_t
 static inline void arch_setup_new_exec(void) { }
 #endif
 
+void arch_task_cache_init(void); /* for CONFIG_SH */
+void arch_release_task_struct(struct task_struct *tsk);
+int arch_dup_task_struct(struct task_struct *dst,
+				struct task_struct *src);
+
 #endif	/* __KERNEL__ */
 
 #endif /* _LINUX_THREAD_INFO_H */
_

Patches currently in -mm which might be from arnd@arndb.de are

radix-tree-move-declarations-to-header.patch
decompressor-provide-missing-prototypes.patch
kasan-add-kasan_tag_mismatch-prototype.patch
kasan-use-internal-prototypes-matching-gcc-13-builtins.patch
mm-percpu-unhide-pcpu_embed_first_chunk-prototype.patch
mm-page_poison-always-declare-__kernel_map_pages-function.patch
mm-sparse-mark-populate_section_memmap-static.patch
lib-devmem_is_allowed-include-linux-ioh.patch
locking-add-lockevent_read-prototype.patch
panic-hide-unused-global-functions.patch
panic-make-function-declarations-visible.patch
kunit-include-debugfs-header-file.patch
init-consolidate-prototypes-in-linux-inith.patch
init-move-cifs_root_data-prototype-into-linux-mounth.patch
thread_info-move-function-declarations-to-linux-thread_infoh.patch
time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A581C61D97
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 17:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjKXRpL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 12:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjKXRpK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 12:45:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E633319A2
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 09:45:16 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77485C433C7;
        Fri, 24 Nov 2023 17:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700847916;
        bh=ibhCsWshgULE4ouU49UMa4weH9C1AdBDeb0scH3Nw+8=;
        h=Date:To:From:Subject:From;
        b=g+zushrampH9vgnM4kPOFtiWmbeaKKZIaNChddEd+xg6SqwT8+/QPlOAWPgnSm497
         Wizo9GHo9ZMdLsQbE2kCi/Jle0slDJ3mGtlL5MOc8loITXu/83kvSaIc10AJGUzstK
         5Z+33PWKWBO6EZhcupfTQFERktTo2FN6z9SfiHWM=
Date:   Fri, 24 Nov 2023 09:45:15 -0800
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        tudor.ambarus@linaro.org, tsbogend@alpha.franken.de,
        sfr@canb.auug.org.au, richard@nod.at, richard.henderson@linaro.org,
        peterz@infradead.org, palmer@rivosinc.com, nicolas@fjasle.eu,
        nathan@kernel.org, mpe@ellerman.id.au, mattst88@gmail.com,
        masahiroy@kernel.org, keescook@chromium.org,
        ink@jurassic.park.msu.ru, gregkh@linuxfoundation.org,
        glaubitz@physik.fu-berlin.de, dwmw2@infradead.org,
        dinguyen@kernel.org, davem@davemloft.net, dalias@libc.org,
        chengzhihao1@huawei.com, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-fair-move-unused-stub-functions-to-header.patch added to mm-nonmm-unstable branch
Message-Id: <20231124174516.77485C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sched: fair: move unused stub functions to header
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     sched-fair-move-unused-stub-functions-to-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-fair-move-unused-stub-functions-to-header.patch

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
Subject: sched: fair: move unused stub functions to header
Date: Thu, 23 Nov 2023 12:05:03 +0100

These four functions have a normal definition for CONFIG_FAIR_GROUP_SCHED,
and empty one that is only referenced when FAIR_GROUP_SCHED is disabled
but CGROUP_SCHED is still enabled.  If both are turned off, the functions
are still defined but the misisng prototype causes a W=1 warning:

kernel/sched/fair.c:12544:6: error: no previous prototype for 'free_fair_sched_group'
kernel/sched/fair.c:12546:5: error: no previous prototype for 'alloc_fair_sched_group'
kernel/sched/fair.c:12553:6: error: no previous prototype for 'online_fair_sched_group'
kernel/sched/fair.c:12555:6: error: no previous prototype for 'unregister_fair_sched_group'

Move the alternatives into the header as static inline functions with the
correct combination of #ifdef checks to avoid the warning without adding
even more complexity.

[A different patch with the same description got applied by accident
 and was later reverted, but the original patch is still missing]

Link: https://lkml.kernel.org/r/20231123110506.707903-4-arnd@kernel.org
Fixes: 7aa55f2a5902 ("sched/fair: Move unused stub functions to header")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c  |   13 -------------
 kernel/sched/sched.h |   11 +++++++++++
 2 files changed, 11 insertions(+), 13 deletions(-)

--- a/kernel/sched/fair.c~sched-fair-move-unused-stub-functions-to-header
+++ a/kernel/sched/fair.c
@@ -12927,19 +12927,6 @@ next_cpu:
 	return 0;
 }
 
-#else /* CONFIG_FAIR_GROUP_SCHED */
-
-void free_fair_sched_group(struct task_group *tg) { }
-
-int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	return 1;
-}
-
-void online_fair_sched_group(struct task_group *tg) { }
-
-void unregister_fair_sched_group(struct task_group *tg) { }
-
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 
--- a/kernel/sched/sched.h~sched-fair-move-unused-stub-functions-to-header
+++ a/kernel/sched/sched.h
@@ -436,10 +436,21 @@ static inline int walk_tg_tree(tg_visito
 
 extern int tg_nop(struct task_group *tg, void *data);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 extern void free_fair_sched_group(struct task_group *tg);
 extern int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent);
 extern void online_fair_sched_group(struct task_group *tg);
 extern void unregister_fair_sched_group(struct task_group *tg);
+#else
+static inline void free_fair_sched_group(struct task_group *tg) { }
+static inline int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
+{
+       return 1;
+}
+static inline void online_fair_sched_group(struct task_group *tg) { }
+static inline void unregister_fair_sched_group(struct task_group *tg) { }
+#endif
+
 extern void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 			struct sched_entity *se, int cpu,
 			struct sched_entity *parent);
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
kexec-fix-kexec_file-dependencies-fix.patch
ida-make-ida_dump-static.patch
jffs2-mark-__jffs2_dbg_superblock_counts-static.patch
sched-fair-move-unused-stub-functions-to-header.patch
x86-sta2x11-include-header-for-sta2x11_get_instance-prototype.patch
usb-fsl-mph-dr-of-mark-fsl_usb2_mpc5121_init-static.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch


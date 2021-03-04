Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8BDC433DB
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFA15654BC
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243076AbhCDBZF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:25:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241893AbhCDBZB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 20:25:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E96A964F41;
        Thu,  4 Mar 2021 01:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614821061;
        bh=w1kQRLQox8mrXjqHBWlkCfIfBRSpbR131oejX65uO9k=;
        h=Date:From:To:Subject:From;
        b=lPbOKFrWa/7qd3BmPJpaWsDWNNOSHSDz7vsqMza9mkb69wRVO30l25bZ02j22qRTy
         r10+OnxFTZ53Qo2QBwKeXaH039g9CJyUNxSBJ8cOHp5JFHDTPGCKC3GXoUdS3MTSEs
         fIWyTU20XZG23STo84stnDfJkT8j165MxaGXbsgc=
Date:   Wed, 03 Mar 2021 17:24:20 -0800
From:   akpm@linux-foundation.org
To:     glaubitz@physik.fu-berlin.de, ldv@altlinux.org,
        mm-commits@vger.kernel.org, oleg@redhat.com, slyfox@gentoo.org
Subject:  +
 ia64-fix-ia64_syscall_get_set_arguments-for-break-based-syscalls.patch
 added to -mm tree
Message-ID: <20210304012420.e0cIi7IF1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: fix ia64_syscall_get_set_arguments() for break-based syscalls
has been added to the -mm tree.  Its filename is
     ia64-fix-ia64_syscall_get_set_arguments-for-break-based-syscalls.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-fix-ia64_syscall_get_set_arguments-for-break-based-syscalls.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-fix-ia64_syscall_get_set_arguments-for-break-based-syscalls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: ia64: fix ia64_syscall_get_set_arguments() for break-based syscalls

In https://bugs.gentoo.org/769614 Dmitry noticed that
`ptrace(PTRACE_GET_SYSCALL_INFO)` does not work for syscalls called via
glibc's syscall() wrapper.

ia64 has two ways to call syscalls from userspace: via `break` and via
`eps` instructions.

The difference is in stack layout:

1. `eps` creates simple stack frame: no locals, in{0..7} == out{0..8}
2. `break` uses userspace stack frame: may be locals (glibc provides
   one), in{0..7} == out{0..8}.

Both work fine in syscall handling cde itself.

But `ptrace(PTRACE_GET_SYSCALL_INFO)` uses unwind mechanism to
re-extract syscall arguments but it does not account for locals.

The change always skips locals registers. It should not change `eps`
path as kernel's handler already enforces locals=0 and fixes `break`.

Tested on v5.10 on rx3600 machine (ia64 9040 CPU).

Link: https://lkml.kernel.org/r/20210221002554.333076-1-slyfox@gentoo.org
Link: https://bugs.gentoo.org/769614
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Reported-by: Dmitry V. Levin <ldv@altlinux.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/ptrace.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/arch/ia64/kernel/ptrace.c~ia64-fix-ia64_syscall_get_set_arguments-for-break-based-syscalls
+++ a/arch/ia64/kernel/ptrace.c
@@ -2013,27 +2013,39 @@ static void syscall_get_set_args_cb(stru
 {
 	struct syscall_get_set_args *args = data;
 	struct pt_regs *pt = args->regs;
-	unsigned long *krbs, cfm, ndirty;
+	unsigned long *krbs, cfm, ndirty, nlocals, nouts;
 	int i, count;
 
 	if (unw_unwind_to_user(info) < 0)
 		return;
 
+	/*
+	 * We get here via a few paths:
+	 * - break instruction: cfm is shared with caller.
+	 *   syscall args are in out= regs, locals are non-empty.
+	 * - epsinstruction: cfm is set by br.call
+	 *   locals don't exist.
+	 *
+	 * For both cases argguments are reachable in cfm.sof - cfm.sol.
+	 * CFM: [ ... | sor: 17..14 | sol : 13..7 | sof : 6..0 ]
+	 */
 	cfm = pt->cr_ifs;
+	nlocals = (cfm >> 7) & 0x7f; /* aka sol */
+	nouts = (cfm & 0x7f) - nlocals; /* aka sof - sol */
 	krbs = (unsigned long *)info->task + IA64_RBS_OFFSET/8;
 	ndirty = ia64_rse_num_regs(krbs, krbs + (pt->loadrs >> 19));
 
 	count = 0;
 	if (in_syscall(pt))
-		count = min_t(int, args->n, cfm & 0x7f);
+		count = min_t(int, args->n, nouts);
 
+	/* Iterate over outs. */
 	for (i = 0; i < count; i++) {
+		int j = ndirty + nlocals + i + args->i;
 		if (args->rw)
-			*ia64_rse_skip_regs(krbs, ndirty + i + args->i) =
-				args->args[i];
+			*ia64_rse_skip_regs(krbs, j) = args->args[i];
 		else
-			args->args[i] = *ia64_rse_skip_regs(krbs,
-				ndirty + i + args->i);
+			args->args[i] = *ia64_rse_skip_regs(krbs, j);
 	}
 
 	if (!args->rw) {
_

Patches currently in -mm which might be from slyfox@gentoo.org are

ia64-fix-ia64_syscall_get_set_arguments-for-break-based-syscalls.patch
ia64-fix-ptraceptrace_syscall_info_exit-sign.patch


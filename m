Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3387C43331
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADCC564FB9
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbhCMFIp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Mar 2021 00:08:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232331AbhCMFIY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 13 Mar 2021 00:08:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C12664F9E;
        Sat, 13 Mar 2021 05:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612104;
        bh=5mLHUU9b2YImANmGuzLvSfnLAlNoOpLVKTjxeBWkygA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ldHctswqieBy9UCrKL6oUmz18kKtpKtytw50j4StHuFm1vN8smxF1qborlMb/zLDN
         Z1FlGszaNHEjNEy31X1f5nPKc8VjsKDa9YRQ7AI8RhOf2Ld1e8RwER/cCUlGkUCa1x
         QeNyCQ2hy8jnkzTZX7BBQO5sLqrRs7pXdptxgo9w=
Date:   Fri, 12 Mar 2021 21:08:23 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, glaubitz@physik.fu-berlin.de,
        ldv@altlinux.org, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        oleg@redhat.com, slyfox@gentoo.org, torvalds@linux-foundation.org
Subject:  [patch 24/29] ia64: fix ia64_syscall_get_set_arguments()
 for break-based syscalls
Message-ID: <20210313050823.BBn7BJYnY%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

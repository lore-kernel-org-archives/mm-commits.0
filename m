Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1786C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DA606514B
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243711AbhCDBZI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:25:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242932AbhCDBZF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 20:25:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6331864F10;
        Thu,  4 Mar 2021 01:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614821064;
        bh=imEfzvzkY2E3JqaJ7QttOeVA4QgPVu12TDDYXqlhzdI=;
        h=Date:From:To:Subject:From;
        b=a68NBmp7sfIGB7FsaPfxwC0tN4gJDtzJHE/NNt90OdhQZYoBKZPallNQUKsFAZGK/
         lZAqtN8hM8YLCSJxsI+I4E38DtwgtbLkwkRK5sFop7oiideQA6EkAxJnSPV1QupwEy
         33XAlTZ+fv8OKdf2xQpzFt7y41l8ylusY8OXuTzs=
Date:   Wed, 03 Mar 2021 17:24:23 -0800
From:   akpm@linux-foundation.org
To:     glaubitz@physik.fu-berlin.de, ldv@altlinux.org,
        mm-commits@vger.kernel.org, oleg@redhat.com, slyfox@gentoo.org
Subject:  + ia64-fix-ptraceptrace_syscall_info_exit-sign.patch
 added to -mm tree
Message-ID: <20210304012423.4nfoZeYv-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: fix ptrace(PTRACE_SYSCALL_INFO_EXIT) sign
has been added to the -mm tree.  Its filename is
     ia64-fix-ptraceptrace_syscall_info_exit-sign.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-fix-ptraceptrace_syscall_info_exit-sign.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-fix-ptraceptrace_syscall_info_exit-sign.patch

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
Subject: ia64: fix ptrace(PTRACE_SYSCALL_INFO_EXIT) sign

In https://bugs.gentoo.org/769614 Dmitry noticed that
`ptrace(PTRACE_GET_SYSCALL_INFO)` does not return error sign properly.

The bug is in mismatch between get/set errors:

static inline long syscall_get_error(struct task_struct *task,
                                     struct pt_regs *regs)
{
        return regs->r10 == -1 ? regs->r8:0;
}

static inline long syscall_get_return_value(struct task_struct *task,
                                            struct pt_regs *regs)
{
        return regs->r8;
}

static inline void syscall_set_return_value(struct task_struct *task,
                                            struct pt_regs *regs,
                                            int error, long val)
{
        if (error) {
                /* error < 0, but ia64 uses > 0 return value */
                regs->r8 = -error;
                regs->r10 = -1;
        } else {
                regs->r8 = val;
                regs->r10 = 0;
        }
}

Tested on v5.10 on rx3600 machine (ia64 9040 CPU).

Link: https://lkml.kernel.org/r/20210221002554.333076-2-slyfox@gentoo.org
Link: https://bugs.gentoo.org/769614
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Reported-by: Dmitry V. Levin <ldv@altlinux.org>
Reviewed-by: Dmitry V. Levin <ldv@altlinux.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/syscall.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/include/asm/syscall.h~ia64-fix-ptraceptrace_syscall_info_exit-sign
+++ a/arch/ia64/include/asm/syscall.h
@@ -32,7 +32,7 @@ static inline void syscall_rollback(stru
 static inline long syscall_get_error(struct task_struct *task,
 				     struct pt_regs *regs)
 {
-	return regs->r10 == -1 ? regs->r8:0;
+	return regs->r10 == -1 ? -regs->r8:0;
 }
 
 static inline long syscall_get_return_value(struct task_struct *task,
_

Patches currently in -mm which might be from slyfox@gentoo.org are

ia64-fix-ia64_syscall_get_set_arguments-for-break-based-syscalls.patch
ia64-fix-ptraceptrace_syscall_info_exit-sign.patch


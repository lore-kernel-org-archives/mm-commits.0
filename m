Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627F6C4161F
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3672664F07
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhCORtL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 13:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236830AbhCORsq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A401764E27;
        Mon, 15 Mar 2021 17:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830525;
        bh=9Xf+ZOoz3nny5gxfpeLt0x1N6VQAWoxxIv/hCUA8fcw=;
        h=Date:From:To:Subject:From;
        b=O1hj7eiY8sDoE27h3OexyyEf63JPxepFJ9pWnlP3iyBj1aI0li14pShYsXhZxn099
         MqJ9T9AcBjho1/zsCVWHW5NRgzM7gNyhHXhBFq7ca40xAdmqjEuSySZuXD2QWlJ/Gd
         BN2bFMgNoCoxW/VFa3ZnDBbRMmDX6r/xftoGZto8=
Date:   Mon, 15 Mar 2021 10:48:45 -0700
From:   akpm@linux-foundation.org
To:     glaubitz@physik.fu-berlin.de, ldv@altlinux.org,
        mm-commits@vger.kernel.org, oleg@redhat.com, slyfox@gentoo.org
Subject:  [merged]
 ia64-fix-ptraceptrace_syscall_info_exit-sign.patch removed from -mm tree
Message-ID: <20210315174845.jcA8s8_wA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: fix ptrace(PTRACE_SYSCALL_INFO_EXIT) sign
has been removed from the -mm tree.  Its filename was
     ia64-fix-ptraceptrace_syscall_info_exit-sign.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



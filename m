Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76344C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiKOWbr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiKOWbi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:31:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE5F180
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:31:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B8B461A66
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE5DC433C1;
        Tue, 15 Nov 2022 22:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551496;
        bh=RajomzkP2DMTQUJ3UQ7yAQ8+KUNv9b8vsQOjTuX6nuQ=;
        h=Date:To:From:Subject:From;
        b=FJMmvMrnf2uZkWE4dNoVhm7JdLRvIAwyZg9wYjJb33Yy0IVWjYkpCMPy2F4OCVqSj
         YXCkc8faFJc6c90SN2zGGaxp5SK0upwb80apTlABHWR5johfV1TYKaXAiU1jODOGeY
         XQzDXAaxEveouY9Nuh6/iZx7k5sKOpVuavAfbquE=
Date:   Tue, 15 Nov 2022 14:31:36 -0800
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        tsbogend@alpha.franken.de, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, oleg@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, linux@armlinux.org.uk, jonas@southpole.se,
        James.Bottomley@HansenPartnership.com, dinguyen@kernel.org,
        deller@gmx.de, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        bcain@quicinc.com, s.shtylyov@omp.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-ptrace-user_regset_copyin_ignore-always-returns-0.patch removed from -mm tree
Message-Id: <20221115223136.ACE5DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: ptrace: user_regset_copyin_ignore() always returns 0
has been removed from the -mm tree.  Its filename was
     ia64-ptrace-user_regset_copyin_ignore-always-returns-0.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: ia64: ptrace: user_regset_copyin_ignore() always returns 0
Date: Sat, 15 Oct 2022 00:22:27 +0300

user_regset_copyin_ignore() always returns 0, so checking its result seems
pointless -- don't do this anymore...

Link: https://lkml.kernel.org/r/20221014212235.10770-6-s.shtylyov@omp.ru
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/ptrace.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/arch/ia64/kernel/ptrace.c~ia64-ptrace-user_regset_copyin_ignore-always-returns-0
+++ a/arch/ia64/kernel/ptrace.c
@@ -1481,12 +1481,10 @@ static void do_gpregs_set(struct unw_fra
 		return;
 	/* Skip r0 */
 	if (dst->pos < ELF_GR_OFFSET(1)) {
-		dst->ret = user_regset_copyin_ignore(&dst->pos, &dst->count,
-						       &dst->u.set.kbuf,
-						       &dst->u.set.ubuf,
-						       0, ELF_GR_OFFSET(1));
-		if (dst->ret)
-			return;
+		user_regset_copyin_ignore(&dst->pos, &dst->count,
+					  &dst->u.set.kbuf, &dst->u.set.ubuf,
+					  0, ELF_GR_OFFSET(1));
+		dst->ret = 0;
 	}
 
 	while (dst->count && dst->pos < ELF_AR_END_OFFSET) {
@@ -1560,11 +1558,11 @@ static void do_fpregs_set(struct unw_fra
 
 	/* Skip pos 0 and 1 */
 	if (dst->count > 0 && dst->pos < ELF_FP_OFFSET(2)) {
-		dst->ret = user_regset_copyin_ignore(&dst->pos, &dst->count,
-						       &dst->u.set.kbuf,
-						       &dst->u.set.ubuf,
-						       0, ELF_FP_OFFSET(2));
-		if (dst->count == 0 || dst->ret)
+		user_regset_copyin_ignore(&dst->pos, &dst->count,
+					  &dst->u.set.kbuf, &dst->u.set.ubuf,
+					  0, ELF_FP_OFFSET(2));
+		dst->ret = 0;
+		if (dst->count == 0)
 			return;
 	}
 
_

Patches currently in -mm which might be from s.shtylyov@omp.ru are



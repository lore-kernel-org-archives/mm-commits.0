Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482DDC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJQAYZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiJQAYY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:24:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078CFB58
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:24:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9824460ECB
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1759C433C1;
        Mon, 17 Oct 2022 00:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665966261;
        bh=nXoJ1xn+jYYVTCoMd6sDOTvdfJlXnXfpp1QHgac9Y5A=;
        h=Date:To:From:Subject:From;
        b=M7xyZXw2vQ8K3tgtzBvbmNFKZQNBeONwmNw/sumY6GT75Oi5cyHOBSvO9XdEm99sr
         CDTlkpStjh3B6UHb8uekImOEotoA4gxr8w8SG42QTtLER1/iSAeheGnAlndJPOhnCW
         fkqp+xBLN2rf8yAE6qsTSiQlRfSdXQtRRe2SMLRg=
Date:   Sun, 16 Oct 2022 17:24:20 -0700
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        tsbogend@alpha.franken.de, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, oleg@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, linux@armlinux.org.uk, jonas@southpole.se,
        James.Bottomley@HansenPartnership.com, dinguyen@kernel.org,
        deller@gmx.de, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        bcain@quicinc.com, s.shtylyov@omp.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-ptrace-user_regset_copyin_ignore-always-returns-0.patch added to mm-nonmm-unstable branch
Message-Id: <20221017002420.F1759C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: ptrace: user_regset_copyin_ignore() always returns 0
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm64-ptrace-user_regset_copyin_ignore-always-returns-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-ptrace-user_regset_copyin_ignore-always-returns-0.patch

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
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: arm64: ptrace: user_regset_copyin_ignore() always returns 0
Date: Sat, 15 Oct 2022 00:22:25 +0300

user_regset_copyin_ignore() always returns 0, so checking its result seems
pointless -- don't do this anymore...

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Link: https://lkml.kernel.org/r/20221014212235.10770-4-s.shtylyov@omp.ru
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

 arch/arm64/kernel/ptrace.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/arch/arm64/kernel/ptrace.c~arm64-ptrace-user_regset_copyin_ignore-always-returns-0
+++ a/arch/arm64/kernel/ptrace.c
@@ -514,9 +514,7 @@ static int hw_break_set(struct task_stru
 
 	/* Resource info and pad */
 	offset = offsetof(struct user_hwdebug_state, dbg_regs);
-	ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf, 0, offset);
-	if (ret)
-		return ret;
+	user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf, 0, offset);
 
 	/* (address, ctrl) registers */
 	limit = regset->n * regset->size;
@@ -543,11 +541,8 @@ static int hw_break_set(struct task_stru
 			return ret;
 		offset += PTRACE_HBP_CTRL_SZ;
 
-		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-						offset,
-						offset + PTRACE_HBP_PAD_SZ);
-		if (ret)
-			return ret;
+		user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					  offset, offset + PTRACE_HBP_PAD_SZ);
 		offset += PTRACE_HBP_PAD_SZ;
 		idx++;
 	}
@@ -954,10 +949,7 @@ static int sve_set_common(struct task_st
 
 	start = end;
 	end = SVE_PT_SVE_FPSR_OFFSET(vq);
-	ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-					start, end);
-	if (ret)
-		goto out;
+	user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf, start, end);
 
 	/*
 	 * Copy fpsr, and fpcr which must follow contiguously in
_

Patches currently in -mm which might be from s.shtylyov@omp.ru are

arc-ptrace-user_regset_copyin_ignore-always-returns-0.patch
arm-ptrace-user_regset_copyin_ignore-always-returns-0.patch
arm64-ptrace-user_regset_copyin_ignore-always-returns-0.patch
hexagon-ptrace-user_regset_copyin_ignore-always-returns-0.patch
ia64-ptrace-user_regset_copyin_ignore-always-returns-0.patch
mips-ptrace-user_regset_copyin_ignore-always-returns-0.patch
nios2-ptrace-user_regset_copyin_ignore-always-returns-0.patch
openrisc-ptrace-user_regset_copyin_ignore-always-returns-0.patch
parisc-ptrace-user_regset_copyin_ignore-always-returns-0.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0.patch
sh-ptrace-user_regset_copyin_ignore-always-returns-0.patch
sparc-ptrace-user_regset_copyin_ignore-always-returns-0.patch
regset-make-user_regset_copyin_ignore-void.patch


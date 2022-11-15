Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEA6C43217
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiKOWbe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiKOWbe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:31:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1F9C19
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:31:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 079CA61A5F
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8EFC433B5;
        Tue, 15 Nov 2022 22:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551492;
        bh=jcd4rN4atBpsSJPe08pOxX35mLfyBsLxySyHanrTVd0=;
        h=Date:To:From:Subject:From;
        b=iZbZG/vJWk58OqCJaotxFhkYHUefFLrTESWNV5MKHCP5ua4NQSwEsKcwXXmZfqnSy
         p5Co2PLvbMtnhAq/kVJakVFuf/ox7YoLlwJi2mS9OGbhVpXps9CuEHDK4k9gM5M0iS
         x97td7ZY5PWOpq2hwkMCxJvt8UAE7uCJ8GsW9cfE=
Date:   Tue, 15 Nov 2022 14:31:31 -0800
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        tsbogend@alpha.franken.de, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, oleg@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, linux@armlinux.org.uk, jonas@southpole.se,
        James.Bottomley@HansenPartnership.com, dinguyen@kernel.org,
        deller@gmx.de, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        bcain@quicinc.com, s.shtylyov@omp.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arm-ptrace-user_regset_copyin_ignore-always-returns-0.patch removed from -mm tree
Message-Id: <20221115223132.5C8EFC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm: ptrace: user_regset_copyin_ignore() always returns 0
has been removed from the -mm tree.  Its filename was
     arm-ptrace-user_regset_copyin_ignore-always-returns-0.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: arm: ptrace: user_regset_copyin_ignore() always returns 0
Date: Sat, 15 Oct 2022 00:22:24 +0300

user_regset_copyin_ignore() always returns 0, so checking its result seems
pointless -- don't do this anymore...

Link: https://lkml.kernel.org/r/20221014212235.10770-3-s.shtylyov@omp.ru
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

 arch/arm/kernel/ptrace.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/arm/kernel/ptrace.c~arm-ptrace-user_regset_copyin_ignore-always-returns-0
+++ a/arch/arm/kernel/ptrace.c
@@ -651,11 +651,9 @@ static int vfp_set(struct task_struct *t
 	if (ret)
 		return ret;
 
-	ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-				user_fpregs_offset + sizeof(new_vfp.fpregs),
-				user_fpscr_offset);
-	if (ret)
-		return ret;
+	user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+				  user_fpregs_offset + sizeof(new_vfp.fpregs),
+				  user_fpscr_offset);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				 &new_vfp.fpscr,
_

Patches currently in -mm which might be from s.shtylyov@omp.ru are



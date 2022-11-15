Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527D9C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiKOWcQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbiKOWbr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:31:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81178271D
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:31:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B29461A5C
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733C6C433D6;
        Tue, 15 Nov 2022 22:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551503;
        bh=iTS/2lKDE01mE+Zcrp3Ub7fT32OPw3vZ5mWfTc4VR2Y=;
        h=Date:To:From:Subject:From;
        b=na+tLnfi7CaFyCwENLPAQbSQYkc99RAqccN48yInZrnrIPWA9FonenUX1ilIgusmX
         p4ozfO+pCLsj5G6wGSeFRVY6byPCVZoX4KmCjpObVXIEW/Tt6HJSHHwYYBZqHX0t+N
         Il3LtpAM8Zad+UqpZjb+j+LIGiLIe2Nd+p4laeDg=
Date:   Tue, 15 Nov 2022 14:31:42 -0800
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        tsbogend@alpha.franken.de, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, oleg@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, linux@armlinux.org.uk, jonas@southpole.se,
        James.Bottomley@HansenPartnership.com, dinguyen@kernel.org,
        deller@gmx.de, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        bcain@quicinc.com, s.shtylyov@omp.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] powerpc-ptrace-user_regset_copyin_ignore-always-returns-0.patch removed from -mm tree
Message-Id: <20221115223143.733C6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc: ptrace: user_regset_copyin_ignore() always returns 0
has been removed from the -mm tree.  Its filename was
     powerpc-ptrace-user_regset_copyin_ignore-always-returns-0.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: powerpc: ptrace: user_regset_copyin_ignore() always returns 0
Date: Sat, 15 Oct 2022 00:22:32 +0300

user_regset_copyin_ignore() always returns 0, so checking its result seems
pointless -- don't do this anymore...

[akpm@linux-foundation.org: fix gpr32_set_common()]
Link: https://lkml.kernel.org/r/20221014212235.10770-11-s.shtylyov@omp.ru
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

 arch/powerpc/kernel/ptrace/ptrace-tm.c   |   10 +++++-----
 arch/powerpc/kernel/ptrace/ptrace-view.c |   15 ++++++++-------
 2 files changed, 13 insertions(+), 12 deletions(-)

--- a/arch/powerpc/kernel/ptrace/ptrace-tm.c~powerpc-ptrace-user_regset_copyin_ignore-always-returns-0
+++ a/arch/powerpc/kernel/ptrace/ptrace-tm.c
@@ -170,9 +170,9 @@ int tm_cgpr_set(struct task_struct *targ
 					 (PT_MAX_PUT_REG + 1) * sizeof(reg));
 
 	if (PT_MAX_PUT_REG + 1 < PT_TRAP && !ret)
-		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-						(PT_MAX_PUT_REG + 1) * sizeof(reg),
-						PT_TRAP * sizeof(reg));
+		user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					  (PT_MAX_PUT_REG + 1) * sizeof(reg),
+					  PT_TRAP * sizeof(reg));
 
 	if (!ret && count > 0) {
 		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &reg,
@@ -183,8 +183,8 @@ int tm_cgpr_set(struct task_struct *targ
 	}
 
 	if (!ret)
-		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-						(PT_TRAP + 1) * sizeof(reg), -1);
+		user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					  (PT_TRAP + 1) * sizeof(reg), -1);
 
 	return ret;
 }
--- a/arch/powerpc/kernel/ptrace/ptrace-view.c~powerpc-ptrace-user_regset_copyin_ignore-always-returns-0
+++ a/arch/powerpc/kernel/ptrace/ptrace-view.c
@@ -267,9 +267,9 @@ static int gpr_set(struct task_struct *t
 					 (PT_MAX_PUT_REG + 1) * sizeof(reg));
 
 	if (PT_MAX_PUT_REG + 1 < PT_TRAP && !ret)
-		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-						(PT_MAX_PUT_REG + 1) * sizeof(reg),
-						PT_TRAP * sizeof(reg));
+		user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					  (PT_MAX_PUT_REG + 1) * sizeof(reg),
+					  PT_TRAP * sizeof(reg));
 
 	if (!ret && count > 0) {
 		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &reg,
@@ -280,8 +280,8 @@ static int gpr_set(struct task_struct *t
 	}
 
 	if (!ret)
-		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-						(PT_TRAP + 1) * sizeof(reg), -1);
+		user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					  (PT_TRAP + 1) * sizeof(reg), -1);
 
 	return ret;
 }
@@ -706,8 +706,9 @@ int gpr32_set_common(struct task_struct
 	ubuf = u;
 	pos *= sizeof(reg);
 	count *= sizeof(reg);
-	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-					 (PT_TRAP + 1) * sizeof(reg), -1);
+	user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+				  (PT_TRAP + 1) * sizeof(reg), -1);
+	return 0;
 
 Efault:
 	user_read_access_end();
_

Patches currently in -mm which might be from s.shtylyov@omp.ru are



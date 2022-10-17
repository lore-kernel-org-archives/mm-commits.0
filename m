Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D5FC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiJQAYk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiJQAYg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:24:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5529B1263E
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:24:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83CAA60ECB
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B83C433C1;
        Mon, 17 Oct 2022 00:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665966273;
        bh=1TIvl+ESp+6R9Dj/VuAud33d3LD4tyuxQO12/H+xsFc=;
        h=Date:To:From:Subject:From;
        b=J8UiBx744xY5PQyjWzzaQeUWoo5oNo+gT2XcrrbJmYmWFviQJuv6JpkfOQqOM/wjt
         B7Yln6yjELNcayYURmw3YVyUpgLPv0lh/4a6YJoxCgzQb7BpF0StxNSZhRqkPmSlnx
         XfiAB7668kMoBjFr5s8vyq2HDHXL1OrjcE/XnyMQ=
Date:   Sun, 16 Oct 2022 17:24:33 -0700
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        tsbogend@alpha.franken.de, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, oleg@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, linux@armlinux.org.uk, jonas@southpole.se,
        James.Bottomley@HansenPartnership.com, dinguyen@kernel.org,
        deller@gmx.de, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        bcain@quicinc.com, s.shtylyov@omp.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + parisc-ptrace-user_regset_copyin_ignore-always-returns-0.patch added to mm-nonmm-unstable branch
Message-Id: <20221017002433.D5B83C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: ptrace: user_regset_copyin_ignore() always returns 0
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     parisc-ptrace-user_regset_copyin_ignore-always-returns-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/parisc-ptrace-user_regset_copyin_ignore-always-returns-0.patch

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
Subject: parisc: ptrace: user_regset_copyin_ignore() always returns 0
Date: Sat, 15 Oct 2022 00:22:31 +0300

user_regset_copyin_ignore() always returns 0, so checking its result seems
pointless -- don't do this anymore...

Link: https://lkml.kernel.org/r/20221014212235.10770-10-s.shtylyov@omp.ru
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

 arch/parisc/kernel/ptrace.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/arch/parisc/kernel/ptrace.c~parisc-ptrace-user_regset_copyin_ignore-always-returns-0
+++ a/arch/parisc/kernel/ptrace.c
@@ -424,8 +424,9 @@ static int fpr_set(struct task_struct *t
 	ubuf = u;
 	pos *= sizeof(reg);
 	count *= sizeof(reg);
-	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-					 ELF_NFPREG * sizeof(reg), -1);
+	user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+				  ELF_NFPREG * sizeof(reg), -1);
+	return 0;
 }
 
 #define RI(reg) (offsetof(struct user_regs_struct,reg) / sizeof(long))
@@ -543,8 +544,9 @@ static int gpr_set(struct task_struct *t
 	ubuf = u;
 	pos *= sizeof(reg);
 	count *= sizeof(reg);
-	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-					 ELF_NGREG * sizeof(reg), -1);
+	user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+				  ELF_NGREG * sizeof(reg), -1);
+	return 0;
 }
 
 static const struct user_regset native_regsets[] = {
@@ -606,8 +608,9 @@ static int gpr32_set(struct task_struct
 	ubuf = u;
 	pos *= sizeof(reg);
 	count *= sizeof(reg);
-	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-					 ELF_NGREG * sizeof(reg), -1);
+	user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+				  ELF_NGREG * sizeof(reg), -1);
+	return 0;
 }
 
 /*
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


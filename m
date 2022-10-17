Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B55C43217
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJQAYf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiJQAYd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:24:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4828BFD09
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 08288CE0F88
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F514C433D6;
        Mon, 17 Oct 2022 00:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665966265;
        bh=rLuojYueA4pptv51eN45AZXtnKIhvLVmiBpQsXgwcMw=;
        h=Date:To:From:Subject:From;
        b=dNnbW1oIsS8ykN6jokdAZrsmA5zI9TaUoNncT9Mmx9dDSE+Vo7bFJy3S5ObGFic52
         F477b3hCliZpnhOvZg1eV1v0Eo3djYR9J26DJpXdyeeTINVKozBi+Y2qUEIrpYG6bd
         m3jdwKTL7MkKEGciAndWpVijUBqgluf/UargpwhE=
Date:   Sun, 16 Oct 2022 17:24:24 -0700
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        tsbogend@alpha.franken.de, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, oleg@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, linux@armlinux.org.uk, jonas@southpole.se,
        James.Bottomley@HansenPartnership.com, dinguyen@kernel.org,
        deller@gmx.de, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        bcain@quicinc.com, s.shtylyov@omp.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-ptrace-user_regset_copyin_ignore-always-returns-0.patch added to mm-nonmm-unstable branch
Message-Id: <20221017002425.3F514C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: ptrace: user_regset_copyin_ignore() always returns 0
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-ptrace-user_regset_copyin_ignore-always-returns-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-ptrace-user_regset_copyin_ignore-always-returns-0.patch

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


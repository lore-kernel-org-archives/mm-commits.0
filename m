Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00168C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiKOWbs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbiKOWbl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:31:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC43E9F
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:31:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 810D6B81B79
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276E7C433C1;
        Tue, 15 Nov 2022 22:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551498;
        bh=obo14jqKP80hcnKSsSRg3Wg0bghBw0CH2dh6tMK1t7k=;
        h=Date:To:From:Subject:From;
        b=Jip5EJgCsXfcu1+7FXncADWESbLAmPRMp59HzgoDlElQ9/sbVqjD5Zy3uk1J1DDB1
         R6ZcOiY0s11e8DvxwIiWOAcUbdSHci3W9XtBL4uCw8crY4+7PRts7UgQ/uOi1YGfQC
         UxnavYCc5nu3D2qwoCSMaZPctH7xP/XMzIh+ScVg=
Date:   Tue, 15 Nov 2022 14:31:37 -0800
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        tsbogend@alpha.franken.de, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, oleg@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, linux@armlinux.org.uk, jonas@southpole.se,
        James.Bottomley@HansenPartnership.com, dinguyen@kernel.org,
        deller@gmx.de, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        bcain@quicinc.com, s.shtylyov@omp.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-ptrace-user_regset_copyin_ignore-always-returns-0.patch removed from -mm tree
Message-Id: <20221115223138.276E7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mips: ptrace: user_regset_copyin_ignore() always returns 0
has been removed from the -mm tree.  Its filename was
     mips-ptrace-user_regset_copyin_ignore-always-returns-0.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: mips: ptrace: user_regset_copyin_ignore() always returns 0
Date: Sat, 15 Oct 2022 00:22:28 +0300

user_regset_copyin_ignore() always returns 0, so checking its result seems
pointless -- don't do this anymore...

Link: https://lkml.kernel.org/r/20221014212235.10770-7-s.shtylyov@omp.ru
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

 arch/mips/kernel/ptrace.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/mips/kernel/ptrace.c~mips-ptrace-user_regset_copyin_ignore-always-returns-0
+++ a/arch/mips/kernel/ptrace.c
@@ -531,10 +531,11 @@ static int fpr_set(struct task_struct *t
 		ptrace_setfcr31(target, fcr31);
 	}
 
-	if (count > 0)
-		err = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-						fir_pos,
-						fir_pos + sizeof(u32));
+	if (count > 0) {
+		user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					  fir_pos, fir_pos + sizeof(u32));
+		return 0;
+	}
 
 	return err;
 }
_

Patches currently in -mm which might be from s.shtylyov@omp.ru are



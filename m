Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8408BC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiKOWcO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiKOWbq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:31:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C86A2656
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:31:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E74B9B81B87
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FBFC433D6;
        Tue, 15 Nov 2022 22:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551499;
        bh=AGCMcWx053veFzS1I/tgek8zzqQTCokx6pD0i7XlrmY=;
        h=Date:To:From:Subject:From;
        b=ZuFQSXyXozaaPFOmXygKCdjDYijbSrY71MmuNxkJ7FI5KxbVv555Iq/RSJF8tvDKO
         F4+sdbIIjJJ9+SjPXIDqEzBSBEnKZUZ5N8sMloa9MMWIDexukBvaBAGi0MjlngRxKJ
         1/nAPa+HHI5fh6M2O4RRu6SrJCOhcKowU6ykwbWE=
Date:   Tue, 15 Nov 2022 14:31:39 -0800
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        tsbogend@alpha.franken.de, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, oleg@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, linux@armlinux.org.uk, jonas@southpole.se,
        James.Bottomley@HansenPartnership.com, dinguyen@kernel.org,
        deller@gmx.de, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        bcain@quicinc.com, s.shtylyov@omp.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nios2-ptrace-user_regset_copyin_ignore-always-returns-0.patch removed from -mm tree
Message-Id: <20221115223139.80FBFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nios2: ptrace: user_regset_copyin_ignore() always returns 0
has been removed from the -mm tree.  Its filename was
     nios2-ptrace-user_regset_copyin_ignore-always-returns-0.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: nios2: ptrace: user_regset_copyin_ignore() always returns 0
Date: Sat, 15 Oct 2022 00:22:29 +0300

user_regset_copyin_ignore() always returns 0, so checking its result seems
pointless -- don't do this anymore...

Link: https://lkml.kernel.org/r/20221014212235.10770-8-s.shtylyov@omp.ru
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

 arch/nios2/kernel/ptrace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/nios2/kernel/ptrace.c~nios2-ptrace-user_regset_copyin_ignore-always-returns-0
+++ a/arch/nios2/kernel/ptrace.c
@@ -54,7 +54,7 @@ static int genregs_set(struct task_struc
 
 #define REG_IGNORE_RANGE(START, END)		\
 	if (!ret)					\
-		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf, \
+		user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf, \
 			START * 4, (END * 4) + 4);
 
 #define REG_IN_ONE(PTR, LOC)	\
@@ -80,8 +80,8 @@ static int genregs_set(struct task_struc
 	REG_IN_ONE(&regs->ra, PTR_RA);
 	REG_IN_ONE(&regs->ea, PTR_PC); /* use ea for PC */
 	if (!ret)
-		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-					 PTR_STATUS * 4, -1);
+		user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					  PTR_STATUS * 4, -1);
 
 	return ret;
 }
_

Patches currently in -mm which might be from s.shtylyov@omp.ru are



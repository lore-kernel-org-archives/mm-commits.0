Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB34C43219
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiJQAZD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiJQAY7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:24:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED241BEAA
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:24:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D86D760E9A
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1BBC433B5;
        Mon, 17 Oct 2022 00:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665966283;
        bh=H/O50WoELBzPef2bbNp183belT6qSCoHo/97lrQMGjk=;
        h=Date:To:From:Subject:From;
        b=LD7WyL9gS78mjXMrURrqOrgjbFADupSy7TKDHN6ZtRfc0g1VrKYY0HALKU/A88Ng5
         cg/xioR0F6mu4AHoUarJ4Tnn8FKxMGmFE7HdxXrzEKsZ1iQtgFWA1VvkX+55dvAeFn
         +byFkYo1zW9W41p+OusKsbG7GFXauodbWQ24ZGI4=
Date:   Sun, 16 Oct 2022 17:24:42 -0700
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        tsbogend@alpha.franken.de, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, oleg@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, linux@armlinux.org.uk, jonas@southpole.se,
        James.Bottomley@HansenPartnership.com, dinguyen@kernel.org,
        deller@gmx.de, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        bcain@quicinc.com, s.shtylyov@omp.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + regset-make-user_regset_copyin_ignore-void.patch added to mm-nonmm-unstable branch
Message-Id: <20221017002443.3F1BBC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: regset: make user_regset_copyin_ignore() *void*
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     regset-make-user_regset_copyin_ignore-void.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/regset-make-user_regset_copyin_ignore-void.patch

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
Subject: regset: make user_regset_copyin_ignore() *void*
Date: Sat, 15 Oct 2022 00:22:35 +0300

user_regset_copyin_ignore() apparently cannot fail and so always returns 0.
Let's make this function return *void* instead of *int*...

Link: https://lkml.kernel.org/r/20221014212235.10770-14-s.shtylyov@omp.ru
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

 include/linux/regset.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/include/linux/regset.h~regset-make-user_regset_copyin_ignore-void
+++ a/include/linux/regset.h
@@ -275,15 +275,15 @@ static inline int user_regset_copyin(uns
 	return 0;
 }
 
-static inline int user_regset_copyin_ignore(unsigned int *pos,
-					    unsigned int *count,
-					    const void **kbuf,
-					    const void __user **ubuf,
-					    const int start_pos,
-					    const int end_pos)
+static inline void user_regset_copyin_ignore(unsigned int *pos,
+					     unsigned int *count,
+					     const void **kbuf,
+					     const void __user **ubuf,
+					     const int start_pos,
+					     const int end_pos)
 {
 	if (*count == 0)
-		return 0;
+		return;
 	BUG_ON(*pos < start_pos);
 	if (end_pos < 0 || *pos < end_pos) {
 		unsigned int copy = (end_pos < 0 ? *count
@@ -295,7 +295,6 @@ static inline int user_regset_copyin_ign
 		*pos += copy;
 		*count -= copy;
 	}
-	return 0;
 }
 
 extern int regset_get(struct task_struct *target,
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


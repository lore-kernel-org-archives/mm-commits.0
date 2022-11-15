Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0A4C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbiKOWcU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbiKOWbw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:31:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166805FA2
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:31:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCE4FB81B79
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0EEC433B5;
        Tue, 15 Nov 2022 22:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551508;
        bh=HZRE6go7whONryHieJP0TTjQQ4ZqvRiU2t96dFBj10Y=;
        h=Date:To:From:Subject:From;
        b=k+fa6obWb3aTEa86b1GoBMOAHVgM/YGNrcFuMffw3T8R3ljo2ob2imggrC3dy4vJW
         dYcmSVl4bSJoOvpoI2T6gzxE7idqmj/0mFmLcPb0ByhRQlTlA1EFLRkz+CU7KpATuA
         VV7x3GUG9p1UKzW7Au3j5/gTo/YGCJGUP0uBbgk8=
Date:   Tue, 15 Nov 2022 14:31:47 -0800
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        tsbogend@alpha.franken.de, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, oleg@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, linux@armlinux.org.uk, jonas@southpole.se,
        James.Bottomley@HansenPartnership.com, dinguyen@kernel.org,
        deller@gmx.de, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        bcain@quicinc.com, s.shtylyov@omp.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] regset-make-user_regset_copyin_ignore-void.patch removed from -mm tree
Message-Id: <20221115223148.5A0EEC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: regset: make user_regset_copyin_ignore() *void*
has been removed from the -mm tree.  Its filename was
     regset-make-user_regset_copyin_ignore-void.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



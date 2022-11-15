Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2A5C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiKOWcy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiKOWbs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:31:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01644E9F
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:31:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9291161A4D
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9693C433C1;
        Tue, 15 Nov 2022 22:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551507;
        bh=jj4F7eZL/DfJITmPly8GKjwwFaAljqAq2bwgwMeXtP4=;
        h=Date:To:From:Subject:From;
        b=2btbxI2Rw6ahZxXmqfpNFoPjZ76HA01Fz9qrR1VaCOEbbYIUOTJpnWyozRpudKdOC
         si8dpD71L99uE/B6fzVkiS6FDQis1XzKPGOuYTd4XWydVadPzsDl+UvA3+5QQSylKI
         I8nFLzKu54ckRntf57YaCNlfvtzgUw+VZbuqHlHc=
Date:   Tue, 15 Nov 2022 14:31:46 -0800
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        tsbogend@alpha.franken.de, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, oleg@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, linux@armlinux.org.uk, jonas@southpole.se,
        James.Bottomley@HansenPartnership.com, dinguyen@kernel.org,
        deller@gmx.de, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        bcain@quicinc.com, s.shtylyov@omp.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] sparc-ptrace-user_regset_copyin_ignore-always-returns-0.patch removed from -mm tree
Message-Id: <20221115223146.E9693C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sparc: ptrace: user_regset_copyin_ignore() always returns 0
has been removed from the -mm tree.  Its filename was
     sparc-ptrace-user_regset_copyin_ignore-always-returns-0.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: sparc: ptrace: user_regset_copyin_ignore() always returns 0
Date: Sat, 15 Oct 2022 00:22:34 +0300

user_regset_copyin_ignore() always returns 0, so checking its result seems
pointless -- don't do this anymore...

Link: https://lkml.kernel.org/r/20221014212235.10770-13-s.shtylyov@omp.ru
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

 arch/sparc/kernel/ptrace_32.c |    9 +++++----
 arch/sparc/kernel/ptrace_64.c |   23 +++++++++++------------
 2 files changed, 16 insertions(+), 16 deletions(-)

--- a/arch/sparc/kernel/ptrace_32.c~sparc-ptrace-user_regset_copyin_ignore-always-returns-0
+++ a/arch/sparc/kernel/ptrace_32.c
@@ -158,8 +158,9 @@ static int genregs32_set(struct task_str
 				 35 * sizeof(u32), 36 * sizeof(u32));
 	if (ret || !count)
 		return ret;
-	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-					 36 * sizeof(u32), 38 * sizeof(u32));
+	user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf, 36 * sizeof(u32),
+				  38 * sizeof(u32));
+	return 0;
 }
 
 static int fpregs32_get(struct task_struct *target,
@@ -203,8 +204,8 @@ static int fpregs32_set(struct task_stru
 					 33 * sizeof(u32),
 					 34 * sizeof(u32));
 	if (!ret)
-		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-						34 * sizeof(u32), -1);
+		user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					  34 * sizeof(u32), -1);
 	return ret;
 }
 
--- a/arch/sparc/kernel/ptrace_64.c~sparc-ptrace-user_regset_copyin_ignore-always-returns-0
+++ a/arch/sparc/kernel/ptrace_64.c
@@ -332,8 +332,8 @@ static int genregs64_set(struct task_str
 	}
 
 	if (!ret)
-		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-						36 * sizeof(u64), -1);
+		user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					  36 * sizeof(u64), -1);
 
 	return ret;
 }
@@ -406,8 +406,8 @@ static int fpregs64_set(struct task_stru
 	task_thread_info(target)->fpsaved[0] = fprs;
 
 	if (!ret)
-		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-						35 * sizeof(u64), -1);
+		user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					  35 * sizeof(u64), -1);
 	return ret;
 }
 
@@ -473,10 +473,8 @@ static int setregs64_set(struct task_str
 				 15 * sizeof(u64));
 	if (ret)
 		return ret;
-	ret =user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-				 15 * sizeof(u64), 16 * sizeof(u64));
-	if (ret)
-		return ret;
+	user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+				  15 * sizeof(u64), 16 * sizeof(u64));
 	/* TSTATE */
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				 &tstate,
@@ -670,8 +668,9 @@ finish:
 	pos *= sizeof(reg);
 	count *= sizeof(reg);
 
-	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-					 38 * sizeof(reg), -1);
+	user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+				  38 * sizeof(reg), -1);
+	return 0;
 }
 
 static int fpregs32_get(struct task_struct *target,
@@ -737,8 +736,8 @@ static int fpregs32_set(struct task_stru
 	task_thread_info(target)->fpsaved[0] = fprs;
 
 	if (!ret)
-		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-						34 * sizeof(u32), -1);
+		user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					  34 * sizeof(u32), -1);
 	return ret;
 }
 
_

Patches currently in -mm which might be from s.shtylyov@omp.ru are



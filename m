Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7C2C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 21:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiJQVoU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 17:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJQVoT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 17:44:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B34362AA6
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 14:36:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F5C2612CA
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 21:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF751C433D6;
        Mon, 17 Oct 2022 21:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666042574;
        bh=1mdFWHb6LedhFoE3LaX2NPhsv5J7ETbmBugtEka+L20=;
        h=Date:To:From:Subject:From;
        b=yzcSODJcwx8tudbQHWYADGDF7/dRpvxzSsOF8u7Ismm1FERJ5vPzTsEXFTwc/UMUm
         g9jIi0c5yWZAZFPneOmMOElyqgET1Wi8uMSB3Gxiq6gzJZ/wD7dNIXPQb0sWqZTYsF
         o8riD7zxCcpinsdIbq5nbsqur/8+VBJ4RVSUqLG4=
Date:   Mon, 17 Oct 2022 14:36:13 -0700
To:     mm-commits@vger.kernel.org, s.shtylyov@omp.ru, mpe@ellerman.id.au,
        lkp@intel.com, christophe.leroy@csgroup.eu,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20221017213613.DF751C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix
Date: Mon Oct 17 02:33:53 PM PDT 2022

fix gpr32_set_common()

Reported-by: kernel test robot <lkp@intel.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/ptrace/ptrace-view.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/ptrace/ptrace-view.c~powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix
+++ a/arch/powerpc/kernel/ptrace/ptrace-view.c
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch


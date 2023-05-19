Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B6DC77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 02:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjESCvz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 May 2023 22:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjESCvy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2023 22:51:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87A0E7
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 19:51:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77770653A1
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 02:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B37C433EF;
        Fri, 19 May 2023 02:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684464712;
        bh=bwZ3+xUQQXFrIH+AhXcpP1nupDvQsuvUv8CxGjsYFmQ=;
        h=Date:To:From:Subject:From;
        b=MlaUDpRKq6mJqaD41SqeMA6XDfsmHPtE2xoy6DGUeEyIt64TQ7+NZV4vyOj5Apv7e
         Mo6lQ8Eg749umw6s1n5vUpZdmwTXOfz2NyKBNjjPF+EyjQ2aFpVQ2XRzTSGfjrf30y
         R1ReePX4fuNreS1T/+R27xgKxW+zUzLyOp+ynEcw=
Date:   Thu, 18 May 2023 19:51:52 -0700
To:     mm-commits@vger.kernel.org, arnd@arndb.de, sfr@canb.auug.org.au,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + init-consolidate-prototypes-in-linux-inith-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230519025152.C3B37C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Date: Fri, 19 May 2023 12:35:26 +1000
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-consolidate-prototypes-in-linux-inith-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-consolidate-prototypes-in-linux-inith-fix.patch

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
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 19 May 2023 12:35:26 +1000
Subject: fix up for "init: consolidate prototypes in linux/init.h"

Link: https://lkml.kernel.org/r/20230519124311.5167221c@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/kernel.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/sparc/kernel/kernel.h~init-consolidate-prototypes-in-linux-inith-fix
+++ a/arch/sparc/kernel/kernel.h
@@ -62,6 +62,9 @@ asmlinkage void do_rt_sigreturn32(struct
 void do_signal32(struct pt_regs * regs);
 asmlinkage int do_sys32_sigstack(u32 u_ssptr, u32 u_ossptr, unsigned long sp);
 
+/* time_64.c */
+void __init time_init_early(void);
+
 /* compat_audit.c */
 extern unsigned int sparc32_dir_class[];
 extern unsigned int sparc32_chattr_class[];
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

init-consolidate-prototypes-in-linux-inith-fix.patch


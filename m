Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4297FC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 03:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiBQDJe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 22:09:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbiBQDJd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 22:09:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B733C158E9D
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 19:09:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5296F61D27
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 03:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E45EC340E9;
        Thu, 17 Feb 2022 03:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645067358;
        bh=xYft1fLTKnbdRdyXmsQLsbHzrPVQ/Mkw/lE/72mherw=;
        h=Date:To:From:Subject:From;
        b=k84nnFLPGnyx+0s9WhR+jFg0Mj3355SdaW70wQF1uc898+A/iYidpEW5VvrjNC21O
         7pkoZv+8WQGWenrUMkYhC2Lv/4Qa42mxJtZEFeHhYIhXsrdt8eersA+rYYhoiX74Xq
         iogdheDUezzCg6+bKsdOFLKh0A43gUzKq9unihyA=
Date:   Wed, 16 Feb 2022 19:09:18 -0800
To:     mm-commits@vger.kernel.org, sujiaxun@uniontech.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-oom_kill-sysctls-to-their-own-file-fix.patch added to -mm tree
Message-Id: <20220217030918.9E45EC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix up for "mm: move oom_kill sysctls to their own file"
has been added to the -mm tree.  Its filename is
     mm-move-oom_kill-sysctls-to-their-own-file-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-oom_kill-sysctls-to-their-own-file-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-oom_kill-sysctls-to-their-own-file-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fix up for "mm: move oom_kill sysctls to their own file"

Link: https://lkml.kernel.org/r/20220216193202.28838626@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: sujiaxun <sujiaxun@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/oom_kill.c~mm-move-oom_kill-sysctls-to-their-own-file-fix
+++ a/mm/oom_kill.c
@@ -80,7 +80,8 @@ static struct ctl_table vm_oom_kill_tabl
 		.maxlen		= sizeof(sysctl_oom_dump_tasks),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
-	}
+	},
+	{}
 };
 #endif
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kasan-improve-vmalloc-tests-fix.patch
mm-move-oom_kill-sysctls-to-their-own-file-fix.patch
mm-dont-include-linux-memremaph-in-linux-mmh-fix-2.patch


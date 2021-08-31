Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1D8C432BE
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9095610A1
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhHaWxN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Aug 2021 18:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230400AbhHaWxL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Aug 2021 18:53:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 008156108B;
        Tue, 31 Aug 2021 22:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630450335;
        bh=kddXdq4O7PKwWK5COv7V1/gzDnYSCk56mdwLiWe6FC0=;
        h=Date:From:To:Subject:From;
        b=WzURPci/zEqlnOgIjYwnI4ozOr/Peo2NgNZu+qVo2HMuViZjNtStmGQ4OJMyV6DnC
         cI4/ERJiEEBFpNiwrXfEtoGxggOc4XIMjCrDXXqOjVwqobTjZf8r3LTtqtLkrg0obB
         rsysuRVf0VEP4HABufJhEoynODzhZFq7wXAzCz3Y=
Date:   Tue, 31 Aug 2021 15:52:14 -0700
From:   akpm@linux-foundation.org
To:     frowand.list@gmail.com, geert+renesas@glider.be,
        horms@verge.net.au, jlan@sgi.com, magnus.damm@gmail.com,
        mm-commits@vger.kernel.org, robh+dt@kernel.org,
        rppt@linux.vnet.ibm.com, tony.luck@intel.com
Subject:  + ia64-fix-endif-comment-for-reserve_elfcorehdr.patch
 added to -mm tree
Message-ID: <20210831225214.8yM47GuEx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: fix #endif comment for reserve_elfcorehdr()
has been added to the -mm tree.  Its filename is
     ia64-fix-endif-comment-for-reserve_elfcorehdr.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-fix-endif-comment-for-reserve_elfcorehdr.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-fix-endif-comment-for-reserve_elfcorehdr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: ia64: fix #endif comment for reserve_elfcorehdr()

Patch series "ia64: Miscellaneous fixes and cleanups".

This patch series contains some miscellaneous fixes and cleanups for ia64.
The second patch fixes a naming conflict triggered by a patch for the FDT
code.


This patch (of 3):

The definition of reserve_elfcorehdr() depends on CONFIG_CRASH_DUMP, not
CONFIG_PROC_VMCORE.

Link: https://lkml.kernel.org/r/cover.1629884459.git.geert+renesas@glider.be
Link: https://lkml.kernel.org/r/77b4c0648f200cab7e1c2c5171c06763e09362aa.1629884459.git.geert+renesas@glider.be
Fixes: d9a9855d0b06ca6d ("always reserve elfcore header memory in crash kernel")
Fixes: 17c1f07ed70afa4f ("[IA64] Reserve elfcorehdr memory in CONFIG_CRASH_DUMP")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Simon Horman <horms@verge.net.au>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Jay Lan <jlan@sgi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/setup.c~ia64-fix-endif-comment-for-reserve_elfcorehdr
+++ a/arch/ia64/kernel/setup.c
@@ -546,7 +546,7 @@ int __init reserve_elfcorehdr(u64 *start
 	return 0;
 }
 
-#endif /* CONFIG_PROC_VMCORE */
+#endif /* CONFIG_CRASH_DUMP */
 
 void __init
 setup_arch (char **cmdline_p)
_

Patches currently in -mm which might be from geert+renesas@glider.be are

ia64-fix-endif-comment-for-reserve_elfcorehdr.patch
ia64-make-reserve_elfcorehdr-static.patch
ia64-make-num_rsvd_regions-static.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D20C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4DC96195F
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbhC1WMs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhC1WMe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:12:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4DDB60233;
        Sun, 28 Mar 2021 22:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616969553;
        bh=GLGtryFtA8YiwJj3j8d2S0gjJjdPya2T76itjZiX3cc=;
        h=Date:From:To:Subject:From;
        b=JzRmUOqRHjis879zxHR6gsdO4h0g0nePDriVeyhK0AnqIOGFDxmQkQedB4jippp9v
         MNc3v9FwVSE1lKo874VuwgnfZ4J9WjwMBO508V8JxTAoUwysIoteNX46PjRvNFCND2
         IGOBjRCCFEypCfRdJ8E0QDLZY4ZirejPbe3grXVY=
Date:   Sun, 28 Mar 2021 15:12:33 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        unixbhaskar@gmail.com
Subject:  + ia64-trivial-spelling-fixes.patch added to -mm tree
Message-ID: <20210328221233.DxqGWs1PQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: trivial spelling fixes
has been added to the -mm tree.  Its filename is
     ia64-trivial-spelling-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-trivial-spelling-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-trivial-spelling-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: ia64: trivial spelling fixes

s/seralize/serialize/ .....three different places

Link: https://lkml.kernel.org/r/YFY+9uwvNLeb/3Ab@Gentoo
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/pal.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/ia64/kernel/pal.S~ia64-trivial-spelling-fixes
+++ a/arch/ia64/kernel/pal.S
@@ -86,7 +86,7 @@ GLOBAL_ENTRY(ia64_pal_call_static)
 	mov ar.pfs = loc1
 	mov rp = loc0
 	;;
-	srlz.d				// seralize restoration of psr.l
+	srlz.d				// serialize restoration of psr.l
 	br.ret.sptk.many b0
 END(ia64_pal_call_static)
 EXPORT_SYMBOL(ia64_pal_call_static)
@@ -194,7 +194,7 @@ GLOBAL_ENTRY(ia64_pal_call_phys_static)
 	mov rp = loc0
 	;;
 	mov ar.rsc=loc4			// restore RSE configuration
-	srlz.d				// seralize restoration of psr.l
+	srlz.d				// serialize restoration of psr.l
 	br.ret.sptk.many b0
 END(ia64_pal_call_phys_static)
 EXPORT_SYMBOL(ia64_pal_call_phys_static)
@@ -252,7 +252,7 @@ GLOBAL_ENTRY(ia64_pal_call_phys_stacked)
 	mov rp = loc0
 	;;
 	mov ar.rsc=loc4			// restore RSE configuration
-	srlz.d				// seralize restoration of psr.l
+	srlz.d				// serialize restoration of psr.l
 	br.ret.sptk.many b0
 END(ia64_pal_call_phys_stacked)
 EXPORT_SYMBOL(ia64_pal_call_phys_stacked)
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are

ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch
ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch
ia64-trivial-spelling-fixes.patch
ocfs2-fix-a-typo.patch
mm-slubc-trivial-typo-fixes.patch
mm-kmemleak-fix-a-typo.patch
mm-typo-fix-in-the-file-utilc.patch
lib-fix-a-typo-in-the-file-bchc.patch
lib-genallocc-fix-a-typo.patch
ipc-semc-mundane-typo-fixes.patch
mm-few-spelling-fixes.patch
kernel-fix-a-typo-in-the-file-upc.patch
ipc-semc-couple-of-spelling-fixes.patch


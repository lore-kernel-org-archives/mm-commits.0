Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A4BC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADEBA61421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhEHWkJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEHWkJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C18C6141D;
        Sat,  8 May 2021 22:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513547;
        bh=Mi7C6hxj5kzjOpej3V2kCWjqbVOBvT/GZegEnuWI2/4=;
        h=Date:From:To:Subject:From;
        b=StaFFQij0Q+hd8dF3XUXZq2vXfQ3fmcOvpQvyymu4RnqwyrElzKYSJbVkRUysZwTO
         5yHleqx4UbsyOASFvk+/JON9qOFgjRSuS83mkl1hF/31IGYn8P6qp2olO/FoAe2MLd
         LxFPvKt5Y0DAEervowjvJqfBIlZ0ceGXDBFR3DMw=
Date:   Sat, 08 May 2021 15:39:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        unixbhaskar@gmail.com
Subject:  [merged] ia64-trivial-spelling-fixes.patch removed from
 -mm tree
Message-ID: <20210508223907.yArO0zjTW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: trivial spelling fixes
has been removed from the -mm tree.  Its filename was
     ia64-trivial-spelling-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



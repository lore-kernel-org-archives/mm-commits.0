Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1653C43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB07761424
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhD3Fy1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhD3FyY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:54:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAAD461456;
        Fri, 30 Apr 2021 05:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762017;
        bh=I5MGvxsDLWYbOXP+hFOkxmwA+7GmVy9BzpepXkdVhF4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nOprsM3Tm811i8WDKCCzJD4c5apSUvNpYEc3eygG3iZ0qJMGfRbKbDaCA++prjk6o
         h+7cwQgQlPqRXjOnAWC367YK7z8pO8DUTMuSEIXEkXqohuQrG0H+BtdYylCDwIgXao
         ImWVRZCzZlgal6E5VM78JKJ1ngyVHQHwmWyztHdY=
Date:   Thu, 29 Apr 2021 22:53:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, unixbhaskar@gmail.com
Subject:  [patch 007/178] ia64: trivial spelling fixes
Message-ID: <20210430055336.Q1xwVMlPs%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

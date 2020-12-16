Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D246C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E1212311B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgLPEJm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:09:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPEJm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:09:42 -0500
Date:   Tue, 15 Dec 2020 20:09:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608091742;
        bh=tFqkZRTaEu4YLqP4LTBUXTARFgYHUIGrxY5tpEv7N6U=;
        h=From:To:Subject:From;
        b=TrjaVCKh6oCI/x9WJoOtIXroq+Q1ArRwq4SIGg8AwucljYXt6UFlcl7FnuGUuOeLa
         /TQ/YIiOJkur5ckqgDD6cAoaPrl+nF2QeMKdXh2z1sRsT5PfHxDR8vPXdox5BukBr7
         vUk79XkmiCP4o/kIoe9bmTnriWoSyu/KSjcBvC8M=
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 kernelh-split-out-mathematical-helpers-fix.patch removed from -mm tree
Message-ID: <20201216040901.kwU-4PeTI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: split out mathematical helpers fix
has been removed from the -mm tree.  Its filename was
     kernelh-split-out-mathematical-helpers-fix.patch

This patch was dropped because it was folded into kernelh-split-out-mathematical-helpers.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: kernel.h: split out mathematical helpers fix

fix powerpc build

Link: https://lkml.kernel.org/r/20201029150809.13059608@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/div64.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/math/div64.c~kernelh-split-out-mathematical-helpers-fix
+++ a/lib/math/div64.c
@@ -22,6 +22,7 @@
 #include <linux/export.h>
 #include <linux/math.h>
 #include <linux/math64.h>
+#include <linux/log2.h>
 
 /* Not needed on 64bit architectures */
 #if BITS_PER_LONG == 32
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kernelh-split-out-mathematical-helpers.patch
ubsan-enable-for-allconfig-builds-fix.patch
mm-simplify-follow_ptepmd-fix.patch


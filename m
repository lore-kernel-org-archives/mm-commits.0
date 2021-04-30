Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DB0C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9783561459
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhD3FyK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3FyJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:54:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28ECD6144D;
        Fri, 30 Apr 2021 05:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762002;
        bh=fP7RnWHQ4KycU1vQ2rrEIJXw7H1datWJtJSJEXcB42A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Mkp33MiimzQ0oaESz6GwIpESSpxy9tLp1zLFejMvtWrzPz9XDt0JkUIxLSzhlFuZU
         pdH0h7HQD5/hzrgZYPf1UIg/EXps1TWUSPYhGmOsrWXgF6gocTOChitIkWDgmsy7TB
         vNbvGFf3LNqAyJYMMQGP42p4bwPQE19E9IMhNvRQ=
Date:   Thu, 29 Apr 2021 22:53:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, glaubitz@physik.fu-berlin.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org,
        unixbhaskar@gmail.com
Subject:  [patch 002/178] arch/ia64/kernel/fsys.S: fix typos
Message-ID: <20210430055321.qepZduuYx%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: arch/ia64/kernel/fsys.S: fix typos

Mundane spelling fixes.

Link: https://lkml.kernel.org/r/20210311061058.29492-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/fsys.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/ia64/kernel/fsys.S~ia64-kernel-few-typos-fixed-in-the-file-fsyss
+++ a/arch/ia64/kernel/fsys.S
@@ -172,7 +172,7 @@ ENTRY(fsys_gettimeofday)
 	// r25 = itc_lastcycle value
 	// r26 = address clocksource cycle_last
 	// r27 = (not used)
-	// r28 = sequence number at the beginning of critcal section
+	// r28 = sequence number at the beginning of critical section
 	// r29 = address of itc_jitter
 	// r30 = time processing flags / memory address
 	// r31 = pointer to result
@@ -432,7 +432,7 @@ GLOBAL_ENTRY(fsys_bubble_down)
 	 *	- r29: psr
 	 *
 	 * We used to clear some PSR bits here but that requires slow
-	 * serialization.  Fortuntely, that isn't really necessary.
+	 * serialization.  Fortunately, that isn't really necessary.
 	 * The rationale is as follows: we used to clear bits
 	 * ~PSR_PRESERVED_BITS in PSR.L.  Since
 	 * PSR_PRESERVED_BITS==PSR.{UP,MFL,MFH,PK,DT,PP,SP,RT,IC}, we
_

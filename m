Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE9EC433E9
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 21:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5620764F8F
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 21:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhCKVt4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 16:49:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231248AbhCKVto (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 16:49:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1CAB64DBA;
        Thu, 11 Mar 2021 21:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615499384;
        bh=ZHN9Dgp5hLwYNPhw+ImTg2rOfDXtXiSRKK5+SBRQEPs=;
        h=Date:From:To:Subject:From;
        b=spSfavfkg061IOg0Zp10ei0ugJ5wujHx2nDI/5+pgk8sJwKWwI1b+Tob+vxzg/EC2
         t9JlTMBHybe0FGxN/FolYpbk4MoxtEzcXaQqzSf9+sQd7y6vTNd/FHP1dLJNJwG078
         97j913KQ78OVbTH9Ie6BSRgrsqEKcaCjK9/oTXow=
Date:   Thu, 11 Mar 2021 13:49:43 -0800
From:   akpm@linux-foundation.org
To:     glaubitz@physik.fu-berlin.de, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, unixbhaskar@gmail.com
Subject:  + ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch
 added to -mm tree
Message-ID: <20210311214943.u2Efa22w7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/ia64/kernel/fsys.S: fix typos
has been added to the -mm tree.  Its filename is
     ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch

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

Patches currently in -mm which might be from unixbhaskar@gmail.com are

ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch
lib-fix-a-typo-in-the-file-bchc.patch


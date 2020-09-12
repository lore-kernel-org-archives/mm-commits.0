Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA89AC43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 18:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75AD821D6C
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 18:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599936155;
	bh=xC8eWUZJJZHbaTOjQfe+dRxLOHKKv+6gaoGsTadHJ60=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vwfTUnKkZk3TfFOR7XPOtExB/Ru/AUxxKbTsp45uX6sQAjh9nkcL4UhRgI2G4Y6uv
	 hTASI6RRGhP7p49LR8PisOPdc/ZdApc9AmKAeTpNO/mkCoSTNo2kxvLcBq/m8ouei+
	 q31T7+bHVLHTqz5CPwv0ogntCrLn+kd8ANgLhLIs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbgILSme (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 14:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgILSmd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 14:42:33 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 016A12184D;
        Sat, 12 Sep 2020 18:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599936153;
        bh=xC8eWUZJJZHbaTOjQfe+dRxLOHKKv+6gaoGsTadHJ60=;
        h=Date:From:To:Subject:From;
        b=HTZ4IgdnaVZ5pTyIRGKW62qQLVrcqsKEgpgeleeh5+fxrwSKegM3WC7/so4byQTwf
         bbqI5xKN0X6UNfzHyxFIhzcSo8yDJyvUl2AgmCGZnh2JsP0FR3A5tlfUU42yeXs7Ax
         3Th1SoFffUn379+6XUobr5bKeGGQK6Me7zowbk6c=
Date:   Sat, 12 Sep 2020 11:42:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        sfr@canb.auug.org.au
Subject:  +
 =?us-ascii?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?us-ascii?Q?memory-hinting-api-fix-fix-fix-fix.patch?= added to -mm tree
Message-ID: <20200912184232.EovPL%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix for "mm/madvise: introduce process_madvise() syscall: an external memory hinting API"
has been added to the -mm tree.  Its filename is
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix.patch

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
Subject: fix for "mm/madvise: introduce process_madvise() syscall: an external memory hinting API"

Link: https://lkml.kernel.org/r/20200908204547.285646b4@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/madvise.c~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix
+++ a/mm/madvise.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/mman.h>
+#include <linux/compat.h>
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/mempolicy.h>
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-memremap_pages-convert-to-struct-range-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix.patch


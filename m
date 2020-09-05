Return-Path: <SRS0=50af=CO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72029C43461
	for <mm-commits@archiver.kernel.org>; Sat,  5 Sep 2020 20:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D0352074B
	for <mm-commits@archiver.kernel.org>; Sat,  5 Sep 2020 20:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599337934;
	bh=kIMRa9ZohKp611u7j7OEGMBximYVkZl16EWgAzUzce0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wsB2Dp9pjsLztddzq3djbI88uBUSB80VrbcWRhXv+4Y/JuUD9zg+UEVQSZBCjUBAc
	 pPEoW8GZwv6soF5vT231ALvCmDu7k/jTYv4ZIlAbWiYydn/nB0Lh58tsDo2xIV41J/
	 rxOZW7GtuWNF6Alo75Wgi7LrjrLTu/pSrAr8MLpQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgIEUcN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 5 Sep 2020 16:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727875AbgIEUcN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 5 Sep 2020 16:32:13 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D104520738;
        Sat,  5 Sep 2020 20:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599337932;
        bh=kIMRa9ZohKp611u7j7OEGMBximYVkZl16EWgAzUzce0=;
        h=Date:From:To:Subject:From;
        b=nnsOrRal1TmtkePnHxXLOxtxurUFLkLgdNtPeXACDE46l43T48MxiK611pqih6UCe
         22m+Tm50xwPGix9u0zP7MHwmPyIrYgoiWs1n23qi8CEE0XXKuSuw1F6/iAVZHho4dX
         u9yWGOLXU28ySeKpPvx6U2zkrXQ/eW7vtexZ6SWs=
Date:   Sat, 05 Sep 2020 13:32:12 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        sfr@canb.auug.org.au
Subject:  +
 =?us-ascii?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?us-ascii?Q?memory-hinting-api-fix-fix-fix.patch?= added to -mm tree
Message-ID: <20200905203212.zeCap%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject:  mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix
has been added to the -mm tree.  Its filename is
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix.patch

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
Subject:  mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix

Link: https://lkml.kernel.org/r/20200905142639.49fc3f1a@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/unistd32.h |    2 +-
 include/uapi/asm-generic/unistd.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/unistd32.h~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix
+++ a/arch/arm64/include/asm/unistd32.h
@@ -889,7 +889,7 @@ __SYSCALL(__NR_pidfd_getfd, sys_pidfd_ge
 __SYSCALL(__NR_faccessat2, sys_faccessat2)
 #define __NR_watch_mount 440
 __SYSCALL(__NR_watch_mount, sys_watch_mount)
-#define __NR_watch_mount 441
+#define __NR_process_madvise 441
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
 
 /*
--- a/include/uapi/asm-generic/unistd.h~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix
+++ a/include/uapi/asm-generic/unistd.h
@@ -861,7 +861,7 @@ __SYSCALL(__NR_pidfd_getfd, sys_pidfd_ge
 __SYSCALL(__NR_faccessat2, sys_faccessat2)
 #define __NR_watch_mount 440
 __SYSCALL(__NR_watch_mount, sys_watch_mount)
-#define __NR_watch_mount 441
+#define __NR_process_madvise 441
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
 
 #undef __NR_syscalls
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix.patch


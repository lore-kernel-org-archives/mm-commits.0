Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC66C433E7
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4008F208B6
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602975861;
	bh=D/ibTWib0vdLBDmPXhmpga9g3BbEvP7Ny0l0QUrX8rE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=H0dJIIFvrNfRiho2v2ezWHXxkozS0gQtFOFI1m4IYtjMfMoyvbu2852EyURUr9nN4
	 IPpctf1W78xstjEnhG13/aS25ExQWCyR36WFup1xB7LM7O771Dt6s2LN+qUou189Ea
	 6PZcdgwg0zNc6S8/U5pqJXoBLFLG4G/+iKigAxcw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439839AbgJQXEU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438235AbgJQXEU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:04:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95E5D20878;
        Sat, 17 Oct 2020 23:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602975859;
        bh=D/ibTWib0vdLBDmPXhmpga9g3BbEvP7Ny0l0QUrX8rE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=C3auOzRY3kSgUXPpRCivY4+SwajA7n/z6DheKSFobPJskEUw63B4uwga6fxIO1UCA
         YzCeBFXqiRl5w4dm4niyaIhJAOzjTq6JY7xgjF38ydRorJGOPv81lZqwm9nhL9z+tJ
         DVWR5vqLEXAKkH895pcrzxvEIZAv+icK/cyjU6Lw=
Date:   Sat, 17 Oct 2020 16:04:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     minchan@kernel.org, mm-commits@vger.kernel.org,
        yuehaibing@huawei.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?US-ASCII?Q?memory-hinting-api-fix-fix-fix-fix-fix-fix.patch?= removed
 from -mm tree
Message-ID: <20201017230419.RiG8LTyHO%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: remove duplicate include
has been removed from the -mm tree.  Its filename was
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix.patch

This patch was dropped because it was folded into mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: mm/madvise: remove duplicate include

Remove duplicate header which is included twice.

Link: https://lkml.kernel.org/r/20200915121550.30584-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix
+++ a/mm/madvise.c
@@ -30,7 +30,6 @@
 #include <linux/swapops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
-#include <linux/sched/mm.h>
 
 #include <asm/tlb.h>
 
_

Patches currently in -mm which might be from yuehaibing@huawei.com are

mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch


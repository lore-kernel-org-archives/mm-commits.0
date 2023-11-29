Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DC0C4167B
	for <mm-commits@archiver.kernel.org>; Wed, 29 Nov 2023 21:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbjK2VfY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Nov 2023 16:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjK2VfX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2023 16:35:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAAE10FE
        for <mm-commits@vger.kernel.org>; Wed, 29 Nov 2023 13:35:29 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6FCC433C7;
        Wed, 29 Nov 2023 21:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701293728;
        bh=32XlynT/XhDaZXozkoGbzc32AbXenMO5RRm2Bhg8jFg=;
        h=Date:To:From:Subject:From;
        b=2GLN8HpXCBhtYyY1UHH1Nu/jjKBzK6vnFWDdOg5Pgf/6xPDPLPKzYV2hV+yp0JDWk
         AO3fJyeePRExb0s34PXWmMhM6/ekiH16//CqsMURhTRHgyV9kDbrqYKewfJglplg+Z
         xm0pbpOl7zDRoC8UEAzSwEVg8iSq8cl49hw5WfVY=
Date:   Wed, 29 Nov 2023 13:35:28 -0800
To:     mm-commits@vger.kernel.org, nphamcs@gmail.com,
        cerasuolodomenico@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-make-shrinking-memcg-aware-fix.patch added to mm-unstable branch
Message-Id: <20231129213528.BC6FCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap-make-shrinking-memcg-aware-fix
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-make-shrinking-memcg-aware-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-make-shrinking-memcg-aware-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zswap-make-shrinking-memcg-aware-fix
Date: Wed Nov 29 01:24:16 PM PST 2023

zswap.c needs memcontrol.h

Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zswap.c~zswap-make-shrinking-memcg-aware-fix
+++ a/mm/zswap.c
@@ -29,6 +29,7 @@
 #include <linux/zpool.h>
 #include <crypto/acompress.h>
 #include <linux/zswap.h>
+#include <linux/memcontrol.h>
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
 #include <linux/swapops.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-andrew-morton-for-lib.patch
mm-memoryc-zap_pte_range-print-bad-swap-entry.patch
mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch
mm-add-folio_fill_tail-and-use-it-in-iomap-fix.patch
zswap-make-shrinking-memcg-aware-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5167FC00140
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 18:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239657AbiHXSTD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 14:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239596AbiHXSTC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 14:19:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DB87960E
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 11:19:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 835FE616A7
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 18:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7220C433D6;
        Wed, 24 Aug 2022 18:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661365140;
        bh=R/ghpLly4defpqbrwCEfx5z1CfxlBbib3SMwoEkmMIo=;
        h=Date:To:From:Subject:From;
        b=SLzmk0r52BN8VAsSdHwyz9T1OqEpqYSY3JyzCM8dTE1p/kI40XM///ypKcJJyInsS
         yWF0RErh7/6SM7LIv8PuSNwTNJD8gV+sBQIwwpvsA7yDBxzB6FourDYqLsZRXIABzz
         l2N08Ze4F+QM8M5bj3DUmjrZSRxgrFU8kwFlHlkU=
Date:   Wed, 24 Aug 2022 11:19:00 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        song.bao.hua@hisilicon.com, sjenning@redhat.com, ddstreet@ieee.org,
        dan.carpenter@oracle.com, bigeasy@linutronix.de, david@ixit.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-experimental-flag-for-zswap.patch added to mm-unstable branch
Message-Id: <20220824181900.D7220C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove EXPERIMENTAL flag for zswap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-experimental-flag-for-zswap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-experimental-flag-for-zswap.patch

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
From: David Heidelberg <david@ixit.cz>
Subject: mm: remove EXPERIMENTAL flag for zswap
Date: Tue, 23 Aug 2022 17:20:33 +0200

zswap has been with us since 2013, and it's widely used in many products.

Link: https://lkml.kernel.org/r/20220823152033.66682-1-david@ixit.cz
Signed-off-by: David Heidelberg <david@ixit.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/Kconfig~mm-remove-experimental-flag-for-zswap
+++ a/mm/Kconfig
@@ -23,7 +23,7 @@ menuconfig SWAP
 	  in your computer.  If unsure say Y.
 
 config ZSWAP
-	bool "Compressed cache for swap pages (EXPERIMENTAL)"
+	bool "Compressed cache for swap pages"
 	depends on SWAP
 	select FRONTSWAP
 	select CRYPTO
@@ -36,12 +36,6 @@ config ZSWAP
 	  in the case where decompressing from RAM is faster than swap device
 	  reads, can also improve workload performance.
 
-	  This is marked experimental because it is a new feature (as of
-	  v3.11) that interacts heavily with memory reclaim.  While these
-	  interactions don't cause any known issues on simple memory setups,
-	  they have not be fully explored on the large set of potential
-	  configurations and workloads that exist.
-
 config ZSWAP_DEFAULT_ON
 	bool "Enable the compressed cache for swap pages by default"
 	depends on ZSWAP
_

Patches currently in -mm which might be from david@ixit.cz are

mm-remove-experimental-flag-for-zswap.patch


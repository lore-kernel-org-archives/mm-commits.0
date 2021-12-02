Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93ED1C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 04:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhLBEuV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 23:50:21 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:44108 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbhLBEuV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 23:50:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0CFA4CE21AE
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 04:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE2FC00446;
        Thu,  2 Dec 2021 04:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638420416;
        bh=gJ47RYACRtygH0zfkBcoS/5j2Xrvp/voJ8H/5+wjiPs=;
        h=Date:From:To:Subject:From;
        b=B0RKA6vtGnT4wPgTVAtF+bUlmyVKDuVnHI7r0B7ywxCJemCeOuBJ96SRiSwo0q+2O
         e48XJGy/V4uAKGP6maoOxtzkx+UT9Tzvli+SESKueimnBReHJyZ69QjLg3NLYrJf/n
         p9B3gjemZsGT62i4nidTBqJX03Hdda2dAhUM/yAQ=
Date:   Wed, 01 Dec 2021 20:46:55 -0800
From:   akpm@linux-foundation.org
To:     clm@fb.com, dsterba@suse.com, josef@toxicpanda.com, lkp@intel.com,
        mcgrof@kernel.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Subject:  +
 btrfs-use-generic-kconfig-option-for-256kb-page-size-limit.patch added to
 -mm tree
Message-ID: <20211202044655._6vo19g7Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: use generic Kconfig option for 256kB page size limit
has been added to the -mm tree.  Its filename is
     btrfs-use-generic-kconfig-option-for-256kb-page-size-limit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/btrfs-use-generic-kconfig-option-for-256kb-page-size-limit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/btrfs-use-generic-kconfig-option-for-256kb-page-size-limit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: btrfs: use generic Kconfig option for 256kB page size limit

Use the newly introduced CONFIG_PAGE_SIZE_LESS_THAN_256KB to describe the
dependency introduced by commit b05fbcc36be1 ("btrfs: disable build on
platforms having page size 256K").

Link: https://lkml.kernel.org/r/20211129230141.228085-3-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: David Sterba <dsterba@suse.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/Kconfig~btrfs-use-generic-kconfig-option-for-256kb-page-size-limit
+++ a/fs/btrfs/Kconfig
@@ -18,8 +18,7 @@ config BTRFS_FS
 	select RAID6_PQ
 	select XOR_BLOCKS
 	select SRCU
-	depends on !PPC_256K_PAGES	# powerpc
-	depends on !PAGE_SIZE_256KB	# hexagon
+	depends on PAGE_SIZE_LESS_THAN_256KB
 
 	help
 	  Btrfs is a general purpose copy-on-write filesystem with extents,
_

Patches currently in -mm which might be from nathan@kernel.org are

arch-kconfig-split-page_size_less_than_256kb-from-page_size_less_than_64kb.patch
btrfs-use-generic-kconfig-option-for-256kb-page-size-limit.patch
lib-kconfigdebug-make-test_kmod-depend-on-page_size_less_than_256kb.patch


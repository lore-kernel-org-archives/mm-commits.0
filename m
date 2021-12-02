Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FFA9C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 04:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbhLBEuX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 23:50:23 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:44128 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236424AbhLBEuX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 23:50:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 266A1CE21AF
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 04:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A44C53FCD;
        Thu,  2 Dec 2021 04:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638420418;
        bh=wiHdr6na/QOynVQ+GPsNmteNFFoHdoHN5zSLNFvx8I8=;
        h=Date:From:To:Subject:From;
        b=I/xD9ZUiU2kEnbFakWiHIN5fHNJ077+YfZXIwVSR2Jb9NqlQHoLapd4tUpuZWHpku
         2dYbw8Wl69H+SAuY1Dze/5VCTw3TNNaEhKfOIwW2FLyRV61occseitWMBX+b6VqkJs
         y8vWuPn7+liYaYFyiB6mox/+mr25ZcHz4v3NPq5o=
Date:   Wed, 01 Dec 2021 20:46:57 -0800
From:   akpm@linux-foundation.org
To:     clm@fb.com, dsterba@suse.com, josef@toxicpanda.com, lkp@intel.com,
        mcgrof@kernel.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Subject:  +
 lib-kconfigdebug-make-test_kmod-depend-on-page_size_less_than_256kb.patch
 added to -mm tree
Message-ID: <20211202044657.mgDrqM7WQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: make TEST_KMOD depend on PAGE_SIZE_LESS_THAN_256KB
has been added to the -mm tree.  Its filename is
     lib-kconfigdebug-make-test_kmod-depend-on-page_size_less_than_256kb.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-kconfigdebug-make-test_kmod-depend-on-page_size_less_than_256kb.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-kconfigdebug-make-test_kmod-depend-on-page_size_less_than_256kb.patch

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
Subject: lib/Kconfig.debug: make TEST_KMOD depend on PAGE_SIZE_LESS_THAN_256KB

Commit b05fbcc36be1 ("btrfs: disable build on platforms having page size
256K") disabled btrfs for configurations that used a 256kB page size. 
However, it did not fully solve the problem because CONFIG_TEST_KMOD
selects CONFIG_BTRFS, which does not account for the dependency.  This
results in a Kconfig warning and the failed BUILD_BUG_ON error returning.

WARNING: unmet direct dependencies detected for BTRFS_FS
  Depends on [n]: BLOCK [=y] && !PPC_256K_PAGES && !PAGE_SIZE_256KB [=y]
  Selected by [m]:
  - TEST_KMOD [=m] && RUNTIME_TESTING_MENU [=y] && m && MODULES [=y] && NETDEVICES [=y] && NET_CORE [=y] && INET [=y] && BLOCK [=y]

To resolve this, add CONFIG_PAGE_SIZE_LESS_THAN_256KB as a dependency of
CONFIG_TEST_KMOD so there is no more invalid configuration or build
errors.

Link: https://lkml.kernel.org/r/20211129230141.228085-4-nathan@kernel.org
Fixes: b05fbcc36be1 ("btrfs: disable build on platforms having page size 256K")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug~lib-kconfigdebug-make-test_kmod-depend-on-page_size_less_than_256kb
+++ a/lib/Kconfig.debug
@@ -2492,6 +2492,7 @@ config TEST_KMOD
 	depends on m
 	depends on NETDEVICES && NET_CORE && INET # for TUN
 	depends on BLOCK
+	depends on PAGE_SIZE_LESS_THAN_256KB # for BTRFS
 	select TEST_LKM
 	select XFS_FS
 	select TUN
_

Patches currently in -mm which might be from nathan@kernel.org are

arch-kconfig-split-page_size_less_than_256kb-from-page_size_less_than_64kb.patch
btrfs-use-generic-kconfig-option-for-256kb-page-size-limit.patch
lib-kconfigdebug-make-test_kmod-depend-on-page_size_less_than_256kb.patch


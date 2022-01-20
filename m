Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A443AC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbiATCKc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:10:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51510 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiATCKb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:10:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAA89B81CA0
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBAAC340E3;
        Thu, 20 Jan 2022 02:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644629;
        bh=+MTmsCO2WlC8HIrFcSKbv71HdaUq+AHojXsubR/d5dY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SheJBtsGZ0uUS3gHmvnuF1V9p1BlPo//jCCHCC8YRqOBydW3OMo1ycRzEtaTCgtjj
         4BO9/TFKsebC6LWBw15TC42xWZC0rxgPiILVw15clJuXnuL7mInPHs2z3fhivT6bWX
         RKBnb3pYfxI1OUUhNh01Y21Udx/zOKiHiT+JYLWs=
Date:   Wed, 19 Jan 2022 18:10:28 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, clm@fb.com, dsterba@suse.com,
        josef@toxicpanda.com, linux-mm@kvack.org, lkp@intel.com,
        mcgrof@kernel.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, torvalds@linux-foundation.org
Subject:  [patch 52/55] lib/Kconfig.debug: make TEST_KMOD depend on
 PAGE_SIZE_LESS_THAN_256KB
Message-ID: <20220120021028.4n6F60o75%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -2505,6 +2505,7 @@ config TEST_KMOD
 	depends on m
 	depends on NETDEVICES && NET_CORE && INET # for TUN
 	depends on BLOCK
+	depends on PAGE_SIZE_LESS_THAN_256KB # for BTRFS
 	select TEST_LKM
 	select XFS_FS
 	select TUN
_

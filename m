Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D543C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377953AbiATVb4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40514 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348034AbiATVbz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EDAD6188C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ADFC340E0;
        Thu, 20 Jan 2022 21:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714314;
        bh=y4Ru9+wgR7yhRurvbrkKMeOOoaEsth47qN3HM/lUEHs=;
        h=Date:From:To:Subject:From;
        b=luspKLMdJGLLJgyL88D2xZn6W2Jjwhuj2Ld5zwyykmXxzdkISkoUkH972J9ZbIJc3
         sj/+HMxr97qyfH/ArKvF3fIXGLwoNMPt5nB5qG+kU4EbUt5534Sd5DkQUSSu+V79hf
         Jj/7aNt6Go1J/JdFh7WGQdxDJAITLocxIUoQMUgw=
Date:   Thu, 20 Jan 2022 13:31:54 -0800
From:   akpm@linux-foundation.org
To:     clm@fb.com, dsterba@suse.com, josef@toxicpanda.com, lkp@intel.com,
        mcgrof@kernel.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Subject:  [merged]
 lib-kconfigdebug-make-test_kmod-depend-on-page_size_less_than_256kb.patch
 removed from -mm tree
Message-ID: <20220120213154.z1yEWbxze%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: make TEST_KMOD depend on PAGE_SIZE_LESS_THAN_256KB
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-make-test_kmod-depend-on-page_size_less_than_256kb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2511,6 +2511,7 @@ config TEST_KMOD
 	depends on m
 	depends on NETDEVICES && NET_CORE && INET # for TUN
 	depends on BLOCK
+	depends on PAGE_SIZE_LESS_THAN_256KB # for BTRFS
 	select TEST_LKM
 	select XFS_FS
 	select TUN
_

Patches currently in -mm which might be from nathan@kernel.org are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A489DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377950AbiATVbw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348034AbiATVbv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D133C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:31:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B2E1B81E6B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A604CC340E0;
        Thu, 20 Jan 2022 21:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714308;
        bh=fsWJjOk68f+F0QSemOxyjnk0i9xkem1p/Wlry/ET09A=;
        h=Date:From:To:Subject:From;
        b=Cg+wuznQYEzDhuOPvnttgrsQTfn0mmTgBHnTF1SJxzeMI6fVcEcqz4uT4BJALDg64
         wdlbKu/39qydclooASzAvtzTSEzl0X6LMe3w8ZaVqczgxi7cdWAXgnA4IOGYEkZAbv
         YYrStgLyYM4quoEj+IR1kyj+aerJCUuMN9K0QJFU=
Date:   Thu, 20 Jan 2022 13:31:48 -0800
From:   akpm@linux-foundation.org
To:     clm@fb.com, dsterba@suse.com, josef@toxicpanda.com,
        mcgrof@kernel.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Subject:  [merged]
 =?US-ASCII?Q?arch-kconfig-split-page=5Fsize=5Fless=5Fthan=5F256kb-from-pa?=
 =?US-ASCII?Q?ge=5Fsize=5Fless=5Fthan=5F64kb.patch?= removed from -mm tree
Message-ID: <20220120213148.cvuZYtHqa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/Kconfig: split PAGE_SIZE_LESS_THAN_256KB from PAGE_SIZE_LESS_THAN_64KB
has been removed from the -mm tree.  Its filename was
     arch-kconfig-split-page_size_less_than_256kb-from-page_size_less_than_64kb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: arch/Kconfig: split PAGE_SIZE_LESS_THAN_256KB from PAGE_SIZE_LESS_THAN_64KB

Patch series "Fix CONFIG_TEST_KMOD with 256kB page size".

The kernel test robot reported a build error [1] from a failed assertion
in fs/btrfs/inode.c with a hexagon randconfig that includes
CONFIG_PAGE_SIZE_256KB.  This error is the same one that was addressed by
commit b05fbcc36be1 ("btrfs: disable build on platforms having page size
256K") but CONFIG_TEST_KMOD selects CONFIG_BTRFS without having the "page
size less than 256kB dependency", which results in the error reappearing.

The first patch introduces CONFIG_PAGE_SIZE_LESS_THAN_256KB by splitting
it off from CONFIG_PAGE_SIZE_LESS_THAN_64KB, which was introduced in
commit 1f0e290cc5fd ("arch: Add generic Kconfig option indicating page
size smaller than 64k") for a similar reason in 5.16-rc3.

The second patch uses that configuration option for CONFIG_BTRFS to reduce
duplication.

The third patch resolves the build error by adding
CONFIG_PAGE_SIZE_LESS_THAN_256KB as a dependency to CONFIG_TEST_KMOD so
that CONFIG_BTRFS does not get enabled under that invalid configuration.

[1]: https://lore.kernel.org/r/202111270255.UYOoN5VN-lkp@intel.com/


This patch (of 3):

btrfs requires a page size smaller than 256kB.  To use that dependency in
other places, introduce CONFIG_PAGE_SIZE_LESS_THAN_256KB and reuse that
dependency in CONFIG_PAGE_SIZE_LESS_THAN_64KB.

Link: https://lkml.kernel.org/r/20211129230141.228085-1-nathan@kernel.org
Link: https://lkml.kernel.org/r/20211129230141.228085-2-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/Kconfig~arch-kconfig-split-page_size_less_than_256kb-from-page_size_less_than_64kb
+++ a/arch/Kconfig
@@ -1005,6 +1005,10 @@ config PAGE_SIZE_LESS_THAN_64KB
 	depends on !PAGE_SIZE_64KB
 	depends on !PARISC_PAGE_SIZE_64KB
 	depends on !PPC_64K_PAGES
+	depends on PAGE_SIZE_LESS_THAN_256KB
+
+config PAGE_SIZE_LESS_THAN_256KB
+	def_bool y
 	depends on !PPC_256K_PAGES
 	depends on !PAGE_SIZE_256KB
 
_

Patches currently in -mm which might be from nathan@kernel.org are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32956C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbiATCK2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:10:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51480 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiATCK2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:10:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C8ACB81C9B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C221BC340E3;
        Thu, 20 Jan 2022 02:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644626;
        bh=9898CPybZFKOL/ZsSS7lbJWoMK1O5yrkbiG1FbqKvUE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GdKUJsMoUcQ1rPyEmH6gXQDbjDIWCdxxBP5Q2SWfhlIrQPPxs+iRBQI+A1qLY8XxY
         gobUpIefRB5jtFrNvzygYnTCvRJ4mmgZfM/pRIrfwgvhm3bKj9qQeHzB3KsxqHq9Fv
         9BZViO4cN3ULHtXBn1sZxIh51+9vstv2PERS/Mis=
Date:   Wed, 19 Jan 2022 18:10:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, clm@fb.com, dsterba@suse.com,
        josef@toxicpanda.com, linux-mm@kvack.org, lkp@intel.com,
        mcgrof@kernel.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, torvalds@linux-foundation.org
Subject:  [patch 51/55] btrfs: use generic Kconfig option for 256kB
 page size limit
Message-ID: <20220120021025.nvxcChPmO%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

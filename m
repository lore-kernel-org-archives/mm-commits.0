Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D878BC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377952AbiATVbx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348034AbiATVbw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB76C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:31:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A814618A0
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86879C340E0;
        Thu, 20 Jan 2022 21:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714311;
        bh=Ri7RNVCkL0wJxiBSBSSi92n7YKZClVD2HYSo2VB5BlA=;
        h=Date:From:To:Subject:From;
        b=uw8zVNWEQiNhp6kj/CC7C5jFXcI4OB4dqSnzi6XePI7QB5F7gjs2h+hEWlvuXpXvv
         BPryZ9b9ECMnvJ730e4ktDWpR4dni5Z4sbFpn1gpcYxD1alZ7ejyGpDkz8I+K61I2G
         bR4umOSSJxy3luTEytS1h1f30OeUXBEzRApvuRqs=
Date:   Thu, 20 Jan 2022 13:31:51 -0800
From:   akpm@linux-foundation.org
To:     clm@fb.com, dsterba@suse.com, josef@toxicpanda.com, lkp@intel.com,
        mcgrof@kernel.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Subject:  [merged]
 btrfs-use-generic-kconfig-option-for-256kb-page-size-limit.patch removed
 from -mm tree
Message-ID: <20220120213151.vjY-T9Pf0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: use generic Kconfig option for 256kB page size limit
has been removed from the -mm tree.  Its filename was
     btrfs-use-generic-kconfig-option-for-256kb-page-size-limit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



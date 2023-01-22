Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE14C27C76
	for <mm-commits@archiver.kernel.org>; Sun, 22 Jan 2023 00:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjAVA6o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 Jan 2023 19:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjAVA6o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 Jan 2023 19:58:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2392D22A2E
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 16:58:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 308CA60918
        for <mm-commits@vger.kernel.org>; Sun, 22 Jan 2023 00:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815A2C4339B;
        Sun, 22 Jan 2023 00:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674349121;
        bh=++Vst4ZGMSG3G1jyfiPP0n8ksBruVtxrqzMxsHoCg/o=;
        h=Date:To:From:Subject:From;
        b=yXNZ00VYsudT81XV2akoYk4Yy38cEsu9Kx4XfDa8rWcOjWrBHQAIs2iRSLLCf0YgJ
         Y4eRG4nGjxmA5wcmztN7kceIU/8d2v2gJ5IJ5mN6rpD17t05sRst/LFtOd6b9bEYrb
         jzjp89ur2TXEQfTrsogmsd6dspK2h0ditbjQ8PAM=
Date:   Sat, 21 Jan 2023 16:58:40 -0800
To:     mm-commits@vger.kernel.org, miles.chen@mediatek.com, lkp@intel.com,
        rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-fix-unused-function-pgdat_to_phys-warning.patch added to mm-unstable branch
Message-Id: <20230122005841.815A2C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: fix "unused function 'pgdat_to_phys'" warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-fix-unused-function-pgdat_to_phys-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-fix-unused-function-pgdat_to_phys-warning.patch

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
From: Mike Rapoport <rppt@kernel.org>
Subject: mm/sparse: fix "unused function 'pgdat_to_phys'" warning
Date: Sat, 21 Jan 2023 12:11:51 +0200

W=1 build with clangs complains:

mm/sparse.c:347:27: warning: unused function 'pgdat_to_phys' [-Wunused-function]
static inline phys_addr_t pgdat_to_phys(struct pglist_data *pgdat)
                             ^
1 warning generated.

pgdat_to_phys() is only used by functions defined when
CONFIG_MEMORY_HOTREMOVE=y.

Move pgdat_to_phys() under #ifdef CONFIG_MEMORY_HOTREMOVE
to make clang happy.

Link: https://lkml.kernel.org/r/20230121101151.1703292-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lore.kernel.org/all/202301210155.1E5zABb5-lkp@intel.com
Cc: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/sparse.c~mm-sparse-fix-unused-function-pgdat_to_phys-warning
+++ a/mm/sparse.c
@@ -318,6 +318,7 @@ size_t mem_section_usage_size(void)
 	return sizeof(struct mem_section_usage) + usemap_size();
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 static inline phys_addr_t pgdat_to_phys(struct pglist_data *pgdat)
 {
 #ifndef CONFIG_NUMA
@@ -328,7 +329,6 @@ static inline phys_addr_t pgdat_to_phys(
 #endif
 }
 
-#ifdef CONFIG_MEMORY_HOTREMOVE
 static struct mem_section_usage * __init
 sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
 					 unsigned long size)
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-sparse-fix-unused-function-pgdat_to_phys-warning.patch


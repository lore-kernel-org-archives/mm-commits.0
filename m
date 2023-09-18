Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28FBC46CA1
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 16:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjIRQlc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjIRQlA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 12:41:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FC130D7
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 09:37:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E80C43140;
        Mon, 18 Sep 2023 15:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695050349;
        bh=lWp5tXrpyp36KrhfsChdb33XTsBgWURBqoeeHvFIUkU=;
        h=Date:To:From:Subject:From;
        b=zzHgX7BSAGhXqNeaVWFhpqxFObPcwITQPa/FAJYIJ2k1cjz512VIC2D5Pdwayxucx
         2IgEp/pEKAWWPNhjCcRlMgJhFs+LpkPZvSq1GjlhNniqc/qw6+ol/Grtuvsf9g/PiZ
         q2Q9TLrCNc1YHi8xgg2X7D/YrP+2q7iGWjTK7x98=
Date:   Mon, 18 Sep 2023 08:19:08 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        usama.arif@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memblock-pass-memblock_type-to-memblock_setclr_flag-fix.patch added to mm-unstable branch
Message-Id: <20230918151909.56E80C43140@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: add missing argument definition
has been added to the -mm mm-unstable branch.  Its filename is
     memblock-pass-memblock_type-to-memblock_setclr_flag-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memblock-pass-memblock_type-to-memblock_setclr_flag-fix.patch

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
From: Usama Arif <usama.arif@bytedance.com>
Subject: memblock: add missing argument definition
Date: Mon, 18 Sep 2023 10:06:57 +0100

Description of argument memblock_type was missing in the commit that
introduced it.

Link: https://lkml.kernel.org/r/20230918090657.220463-1-usama.arif@bytedance.com
Fixes: 70083e1c8ab4 ("memblock: pass memblock_type to memblock_setclr_flag")
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memblock.c~memblock-pass-memblock_type-to-memblock_setclr_flag-fix
+++ a/mm/memblock.c
@@ -892,6 +892,7 @@ int __init_memblock memblock_physmem_add
 
 /**
  * memblock_setclr_flag - set or clear flag for a memory region
+ * @type: memblock type to set/clear flag for
  * @base: base address of the region
  * @size: size of the region
  * @set: set or clear the flag
_

Patches currently in -mm which might be from usama.arif@bytedance.com are

mm-hugetlb_vmemmap-use-nid-of-the-head-page-to-reallocate-it.patch
memblock-pass-memblock_type-to-memblock_setclr_flag.patch
memblock-pass-memblock_type-to-memblock_setclr_flag-fix.patch
memblock-introduce-memblock_rsrv_noinit-flag.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo.patch


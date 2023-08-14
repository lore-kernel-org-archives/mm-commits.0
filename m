Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C8BC04A94
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 20:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjHNUSG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 16:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbjHNUSE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 16:18:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828C2BC
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 13:18:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2120061708
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 20:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BD4C433C7;
        Mon, 14 Aug 2023 20:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692044282;
        bh=4YnTo0TVHuZuIWmGuHK925C/ytyBJaH2PH7fcnZ7BVI=;
        h=Date:To:From:Subject:From;
        b=nHHBRLJWHmlC/FIf2cmIET+qCUMq9TCwVr2b4XDjEToyc7qD0q9B2vJSd3wD5zCNH
         DusYHpMhcHHffkLPmfAehbF1okHlvpietkYi/NV2a8TNRrZKegDpL5Qft4XhLY2Hmi
         CQ05hFEH5OoMZ2dFEYk9I+e3CTI/vAWidLaornqM=
Date:   Mon, 14 Aug 2023 13:18:01 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmthp-no-space-after-colon-in-mem-info-fields.patch added to mm-unstable branch
Message-Id: <20230814201802.75BD4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp: no space after colon in Mem-Info fields
has been added to the -mm mm-unstable branch.  Its filename is
     mmthp-no-space-after-colon-in-mem-info-fields.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmthp-no-space-after-colon-in-mem-info-fields.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm,thp: no space after colon in Mem-Info fields
Date: Mon, 14 Aug 2023 13:00:18 -0700 (PDT)

Patch series "mm,thp: fix sloppy text output".

Three independent trivial patches, fixing sloppy text output which has
annoyed me; but might risk surprising a parser, so any can be dropped.


This patch (of 3):

The SysRq-m or OOM Mem-Info dmesg showed (long lines containing) ... 
shmem:NkB shmem_thp: NkB shmem_pmdmapped: NkB anon_thp: NkB ...

Delete the space after the colon after shmem_thp, shmem_pmdmapped,
anon_thp: as the shmem example shows, no other fields have a space after
the colon in this output.

Link: https://lkml.kernel.org/r/dc264fd6-40bb-6510-db36-9340a5f01d94@google.com
Link: https://lkml.kernel.org/r/c1edd7da-5493-c542-6feb-92452b4dab3b@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/show_mem.c~mmthp-no-space-after-colon-in-mem-info-fields
+++ a/mm/show_mem.c
@@ -251,9 +251,9 @@ static void show_free_areas(unsigned int
 			" writeback:%lukB"
 			" shmem:%lukB"
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			" shmem_thp: %lukB"
-			" shmem_pmdmapped: %lukB"
-			" anon_thp: %lukB"
+			" shmem_thp:%lukB"
+			" shmem_pmdmapped:%lukB"
+			" anon_thp:%lukB"
 #endif
 			" writeback_tmp:%lukB"
 			" kernel_stack:%lukB"
_

Patches currently in -mm which might be from hughd@google.com are

arm-include-asm-cacheflushh-in-asm-hugetlbh.patch
arm64-include-asm-cacheflushh-in-asm-hugetlbh.patch
riscv-include-asm-cacheflushh-in-asm-hugetlbh.patch
mmthp-no-space-after-colon-in-mem-info-fields.patch
mmthp-fix-noden-meminfo-output-alignment.patch
mmthp-fix-smaps-thpeligible-output-alignment.patch


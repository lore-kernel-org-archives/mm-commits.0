Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A804CC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 21:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbiGYVU4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 17:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbiGYVUz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 17:20:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A271D0F8
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 14:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CAF2B8110B
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 21:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F6AC341C6;
        Mon, 25 Jul 2022 21:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658784052;
        bh=cR4Zox7PvUobtRv8hujo0pqrPdSUDh1saQFsRsYx/VY=;
        h=Date:To:From:Subject:From;
        b=Nshsxx0lKZHfLqCPE9lZVjx9GIVFYY/nzMiaTG9l3G7eNZkgQ9MktR5mthYfT4RGX
         fxEOaNhMxd/hGHo3saOOSsPmjq0gsT+EfyVHkyYahHniHMonNYVI6M0qxa3vXaSChR
         fYHApTYogkNAIElw9INlk+toueKNCwrR6RVtQvI4=
Date:   Mon, 25 Jul 2022 14:20:51 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-add-struct-collapse_control-fix-fix.patch added to mm-unstable branch
Message-Id: <20220725212052.14F6AC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-khugepaged-add-struct-collapse_control-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-add-struct-collapse_control-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-add-struct-collapse_control-fix-fix.patch

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
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm-khugepaged-add-struct-collapse_control-fix-fix

fix build

Link: https://lkml.kernel.org/r/20220721195508.15f1e07a@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-add-struct-collapse_control-fix-fix
+++ a/mm/khugepaged.c
@@ -87,7 +87,9 @@ static struct kmem_cache *mm_slot_cache
 
 struct collapse_control {
 	/* Num pages scanned per node */
-#if HPAGE_PMD_ORDER < 16
+#if defined(CONFIG_PPC64)
+	u32 node_load[MAX_NUMNODES];
+#elif HPAGE_PMD_ORDER < 16
 	u16 node_load[MAX_NUMNODES];
 #else
 	u32 node_load[MAX_NUMNODES];
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-khugepaged-add-struct-collapse_control-fix-fix.patch


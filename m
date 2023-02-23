Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0D1C61DA4
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 19:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBWTt0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 14:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjBWTtW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 14:49:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305565DCF3
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 11:49:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F39061784
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 19:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63ACC4339C;
        Thu, 23 Feb 2023 19:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677181755;
        bh=8I+K7WYNEpMeW9TX0DIhHItT0/EH9+ngP9MLPGB1S3I=;
        h=Date:To:From:Subject:From;
        b=mbX/FCZRsa71MwlFBy/GZoiKKLuhwxu4mZct384pEHflcvuxnjOQITYeKhDPkSbpK
         xGvFE/Uq0saiSPsbLZSq759u74W92JgROTJU25GfNwss24zdr51TgaciC5huZHZ32N
         BmFqRUJnEylOdzDARU745SSXxw8JsGzek54Dpi0g=
Date:   Thu, 23 Feb 2023 11:49:14 -0800
To:     mm-commits@vger.kernel.org, hch@lst.de, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-mm-contig-fix-section-mismatch-warning-error.patch added to mm-nonmm-unstable branch
Message-Id: <20230223194914.E63ACC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: mm/contig: fix section mismatch warning/error
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-mm-contig-fix-section-mismatch-warning-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-mm-contig-fix-section-mismatch-warning-error.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: ia64: mm/contig: fix section mismatch warning/error
Date: Wed, 22 Feb 2023 19:42:58 -0800

alloc_per_cpu_data() is called by find_memory(), which is marked as
__init.  Therefore alloc_per_cpu_data() can also be marked as __init to
remedy this modpost problem.

WARNING: modpost: vmlinux.o: section mismatch in reference: alloc_per_cpu_data (section: .text) -> memblock_alloc_try_nid (section: .init.text)

Link: https://lkml.kernel.org/r/20230223034258.12917-1-rdunlap@infradead.org
Fixes: 4b9ddc7cf272 ("[IA64] Fix section mismatch in contig.c version of per_cpu_init()")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/contig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/mm/contig.c~ia64-mm-contig-fix-section-mismatch-warning-error
+++ a/arch/ia64/mm/contig.c
@@ -77,7 +77,7 @@ skip:
 	return __per_cpu_start + __per_cpu_offset[smp_processor_id()];
 }
 
-static inline void
+static inline __init void
 alloc_per_cpu_data(void)
 {
 	size_t size = PERCPU_PAGE_SIZE * num_possible_cpus();
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ia64-mm-contig-fix-section-mismatch-warning-error.patch
ia64-salinfo-placate-defined-but-not-used-warning.patch


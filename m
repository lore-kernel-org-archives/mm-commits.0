Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B27C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbjDFCru (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234840AbjDFCq0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:46:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F306D9779
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F242642AA
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EDBC433D2;
        Thu,  6 Apr 2023 02:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749124;
        bh=noSPIbY6wJuwprCqM9cf7iJ3FLeFr5tPqFfgvUJQNwQ=;
        h=Date:To:From:Subject:From;
        b=iQQCk6jBlNrOi+HSLFCip0PYrHtCNLRcqGF3t7sPJT+wnLJDS0UvoAFEfP5ovzBVA
         ZaLAw0pdOARLXXhql8xm63yHF6X74zHPtNf5jFxznHIIpYVew06+LgtQ4cLOt1L0vP
         BrlDCpNqfGx1kSke8dskTbMP1bSbQGgs3Oi348M4=
Date:   Wed, 05 Apr 2023 19:45:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-extend-memblock-entry-to-include-mm-initialization.patch removed from -mm tree
Message-Id: <20230406024524.D9EDBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: extend memblock entry to include MM initialization
has been removed from the -mm tree.  Its filename was
     maintainers-extend-memblock-entry-to-include-mm-initialization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: MAINTAINERS: extend memblock entry to include MM initialization
Date: Tue, 21 Mar 2023 19:05:13 +0200

and add mm/mm_init.c to memblock entry in MAINTAINERS

Link: https://lkml.kernel.org/r/20230321170513.2401534-15-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-extend-memblock-entry-to-include-mm-initialization
+++ a/MAINTAINERS
@@ -13368,13 +13368,14 @@ F:	arch/powerpc/include/asm/membarrier.h
 F:	include/uapi/linux/membarrier.h
 F:	kernel/sched/membarrier.c
 
-MEMBLOCK
+MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/core-api/boot-time-mm.rst
 F:	include/linux/memblock.h
 F:	mm/memblock.c
+F:	mm/mm_init.c
 F:	tools/testing/memblock/
 
 MEMORY CONTROLLER DRIVERS
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-drop-ranges-in-definition-of-arch_force_max_order.patch
arm64-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-reword-arch_force_max_order-prompt-and-help-text-v3.patch
csky-drop-arch_force_max_order.patch
ia64-dont-allow-users-to-override-arch_force_max_order.patch
m68k-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-drop-ranges-for-definition-of-arch_force_max_order.patch
powerpc-reword-arch_force_max_order-prompt-and-help-text.patch
powerpc-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-reword-arch_force_max_order-prompt-and-help-text.patch
sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch
sh-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-drop-ranges-for-definition-of-arch_force_max_order-v3.patch
sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch
mm-move-free_area_empty-to-mm-internalh.patch


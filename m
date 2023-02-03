Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4757CC63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbjBCGno (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbjBCGmJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2ED31A961
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1ECE61DAC
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CE8C433D2;
        Fri,  3 Feb 2023 06:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406301;
        bh=I5W55p2yWglC7JSii54KNCvtq9hubDjH2nnW6oZG3Q0=;
        h=Date:To:From:Subject:From;
        b=aLKiDCGlwZVh76O8B9RtepSqZszfkW01LISGVCAvjKLnoaX6MckjOypURVl1Tvnlm
         zgh6SPp1668XQqlfSJSZ4+2+WbVMDqHLnGFrVRwq+58OniNWEd+McSQQXJjDBAoE28
         AAUGiaLmZgux15vQfT7J6LML+aYrc2RUCgJ341aY=
Date:   Thu, 02 Feb 2023 22:38:20 -0800
To:     mm-commits@vger.kernel.org, miles.chen@mediatek.com, lkp@intel.com,
        rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-fix-unused-function-pgdat_to_phys-warning.patch removed from -mm tree
Message-Id: <20230203063821.04CE8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/sparse: fix "unused function 'pgdat_to_phys'" warning
has been removed from the -mm tree.  Its filename was
     mm-sparse-fix-unused-function-pgdat_to_phys-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

arm-include-asm-generic-memory_modelh-from-pageh-rather-than-memoryh.patch
m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu.patch
mips-drop-definition-of-pfn_valid-for-discontigmem.patch
mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem.patch
mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem-fix.patch


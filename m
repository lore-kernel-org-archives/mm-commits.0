Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14CFC001DE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 18:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjHDSIm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjHDSIg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 14:08:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E54B49F3
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 11:08:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFD72620D7
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 18:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06464C433C9;
        Fri,  4 Aug 2023 18:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691172498;
        bh=YUwuRoR6q0KTc4D6CL1oGYg4VBZZ62qXC55IjxSk0YI=;
        h=Date:To:From:Subject:From;
        b=U64XKZWZYuKTMOs4MGWuUxp0IGcM5y6tXhODCyqulvgs45X6FmtaqL4ivM36+joUD
         cyektWrT/G3bHtx+41RY+23uDBi5v2oU1g5Vv4XNiyKZ5DcQ/fhVgBol8Ao8Uw1wCO
         laE6UXylgfxqe0st8hBeM0yy4yrwdMAXJfGZdiHc=
Date:   Fri, 04 Aug 2023 11:08:17 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        rppt@kernel.org, ppbuk5246@gmail.com, mawupeng1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-disable-kernelcore=mirror-when-no-mirror-memory.patch added to mm-unstable branch
Message-Id: <20230804180818.06464C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: disable kernelcore=mirror when no mirror memory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-disable-kernelcore=mirror-when-no-mirror-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-disable-kernelcore=mirror-when-no-mirror-memory.patch

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
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: mm: disable kernelcore=mirror when no mirror memory
Date: Wed, 2 Aug 2023 15:23:28 +0800

For system with kernelcore=mirror enabled while no mirrored memory is
reported by efi.  This could lead to kernel OOM during startup since all
memory beside zone DMA are in the movable zone and this prevents the
kernel to use it.

Zone DMA/DMA32 initialization is independent of mirrored memory and their
max pfn is set in zone_sizes_init().  Since kernel can fallback to zone
DMA/DMA32 if there is no memory in zone Normal, these zones are seen as
mirrored memory no mather their memory attributes are.

To solve this problem, disable kernelcore=mirror when there is no real
mirrored memory exists.

Link: https://lkml.kernel.org/r/20230802072328.2107981-1-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Levi Yun <ppbuk5246@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 +
 mm/memblock.c |    5 +++++
 mm/mm_init.c  |    5 +++++
 3 files changed, 11 insertions(+)

--- a/mm/internal.h~mm-disable-kernelcore=mirror-when-no-mirror-memory
+++ a/mm/internal.h
@@ -1022,6 +1022,7 @@ static inline bool gup_must_unshare(stru
 }
 
 extern bool mirrored_kernelcore;
+extern bool memblock_has_mirror(void);
 
 static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
 {
--- a/mm/memblock.c~mm-disable-kernelcore=mirror-when-no-mirror-memory
+++ a/mm/memblock.c
@@ -161,6 +161,11 @@ static int memblock_can_resize __initdat
 static int memblock_memory_in_slab __initdata_memblock;
 static int memblock_reserved_in_slab __initdata_memblock;
 
+bool __init_memblock memblock_has_mirror(void)
+{
+	return system_has_some_mirror;
+}
+
 static enum memblock_flags __init_memblock choose_memblock_flags(void)
 {
 	return system_has_some_mirror ? MEMBLOCK_MIRROR : MEMBLOCK_NONE;
--- a/mm/mm_init.c~mm-disable-kernelcore=mirror-when-no-mirror-memory
+++ a/mm/mm_init.c
@@ -376,6 +376,11 @@ static void __init find_zone_movable_pfn
 	if (mirrored_kernelcore) {
 		bool mem_below_4gb_not_mirrored = false;
 
+		if (!memblock_has_mirror()) {
+			pr_warn("The system has no mirror memory, ignore kernelcore=mirror.\n");
+			goto out;
+		}
+
 		for_each_mem_region(r) {
 			if (memblock_is_mirror(r))
 				continue;
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

swap-cleanup-duplicated-warn_on-in-add_to_avail_list.patch
swap-stop-add-to-avail-list-is-swap-is-full.patch
doc-update-params-of-memhp_default_state=.patch
mm-disable-kernelcore=mirror-when-no-mirror-memory.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8DBEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjHUUlb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbjHUUkn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F241CC7
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 506DF6193B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E3BC433C7;
        Mon, 21 Aug 2023 20:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650424;
        bh=UjLyAovvC6bRatRAbsic7soo+P8uHidiUtUXYsFFyFY=;
        h=Date:To:From:Subject:From;
        b=DM1bVYPSGJCJcbmSN5q2UHQykCdneVVVxycYEtfpYLsP9qYhguM/8HeLBa/SLiXB4
         iXo7IyoJFx2uyWgHFjS3u8NUwrlWyyDAVN/Y2Pn9Nls6I+Pd+BxzZmkKezqQ8e7GPy
         i3butBo43QKntmDaK3Ck7jX7FZqq1VLX2clRpxq4=
Date:   Mon, 21 Aug 2023 13:40:24 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        rppt@kernel.org, ppbuk5246@gmail.com, mawupeng1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-disable-kernelcore=mirror-when-no-mirror-memory.patch removed from -mm tree
Message-Id: <20230821204024.96E3BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: disable kernelcore=mirror when no mirror memory
has been removed from the -mm tree.  Its filename was
     mm-disable-kernelcore=mirror-when-no-mirror-memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



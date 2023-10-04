Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F784E784A9
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244633AbjJDUXJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245014AbjJDUWc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C14DC
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0EFC433C7;
        Wed,  4 Oct 2023 20:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450938;
        bh=kCBYRejvcJ62K2Q++IUO9EFD9fll+ZTjAMMiBFtl4Kg=;
        h=Date:To:From:Subject:From;
        b=jV6wW39pibLJ6xcNpGmBieKh4hlVhQQukt4X3Xiy4q+GRYc9itK/44H1xjV4HzERL
         7wqKwhgMzN/3mIhq3ATsH+KZoJuW9mZMC9hmGeEn/Nm1F3WFuJERn8i+nhgT7kxfD3
         R/qFwzMAKKh3owcEaGQP0pyc2zLWsoNyG4eQKB9o=
Date:   Wed, 04 Oct 2023 13:22:17 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        rppt@kernel.org, punit.agrawal@bytedance.com,
        mike.kravetz@oracle.com, fam.zheng@bytedance.com,
        usama.arif@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memblock-pass-memblock_type-to-memblock_setclr_flag.patch removed from -mm tree
Message-Id: <20231004202218.8A0EFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memblock: pass memblock_type to memblock_setclr_flag
has been removed from the -mm tree.  Its filename was
     memblock-pass-memblock_type-to-memblock_setclr_flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@bytedance.com>
Subject: memblock: pass memblock_type to memblock_setclr_flag
Date: Wed, 13 Sep 2023 11:53:59 +0100

This allows setting flags to both memblock types and is in preparation for
setting flags (for e.g.  to not initialize struct pages) on reserved
memory region.

[usama.arif@bytedance.com: add missing argument definition]
  Link: https://lkml.kernel.org/r/20230918090657.220463-1-usama.arif@bytedance.com
Link: https://lkml.kernel.org/r/20230913105401.519709-3-usama.arif@bytedance.com
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/memblock.c~memblock-pass-memblock_type-to-memblock_setclr_flag
+++ a/mm/memblock.c
@@ -892,6 +892,7 @@ int __init_memblock memblock_physmem_add
 
 /**
  * memblock_setclr_flag - set or clear flag for a memory region
+ * @type: memblock type to set/clear flag for
  * @base: base address of the region
  * @size: size of the region
  * @set: set or clear the flag
@@ -901,10 +902,9 @@ int __init_memblock memblock_physmem_add
  *
  * Return: 0 on success, -errno on failure.
  */
-static int __init_memblock memblock_setclr_flag(phys_addr_t base,
-				phys_addr_t size, int set, int flag)
+static int __init_memblock memblock_setclr_flag(struct memblock_type *type,
+				phys_addr_t base, phys_addr_t size, int set, int flag)
 {
-	struct memblock_type *type = &memblock.memory;
 	int i, ret, start_rgn, end_rgn;
 
 	ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
@@ -933,7 +933,7 @@ static int __init_memblock memblock_setc
  */
 int __init_memblock memblock_mark_hotplug(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_setclr_flag(base, size, 1, MEMBLOCK_HOTPLUG);
+	return memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLOCK_HOTPLUG);
 }
 
 /**
@@ -945,7 +945,7 @@ int __init_memblock memblock_mark_hotplu
  */
 int __init_memblock memblock_clear_hotplug(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_setclr_flag(base, size, 0, MEMBLOCK_HOTPLUG);
+	return memblock_setclr_flag(&memblock.memory, base, size, 0, MEMBLOCK_HOTPLUG);
 }
 
 /**
@@ -962,7 +962,7 @@ int __init_memblock memblock_mark_mirror
 
 	system_has_some_mirror = true;
 
-	return memblock_setclr_flag(base, size, 1, MEMBLOCK_MIRROR);
+	return memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLOCK_MIRROR);
 }
 
 /**
@@ -982,7 +982,7 @@ int __init_memblock memblock_mark_mirror
  */
 int __init_memblock memblock_mark_nomap(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_setclr_flag(base, size, 1, MEMBLOCK_NOMAP);
+	return memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLOCK_NOMAP);
 }
 
 /**
@@ -994,7 +994,7 @@ int __init_memblock memblock_mark_nomap(
  */
 int __init_memblock memblock_clear_nomap(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_setclr_flag(base, size, 0, MEMBLOCK_NOMAP);
+	return memblock_setclr_flag(&memblock.memory, base, size, 0, MEMBLOCK_NOMAP);
 }
 
 static bool should_skip_region(struct memblock_type *type,
_

Patches currently in -mm which might be from usama.arif@bytedance.com are



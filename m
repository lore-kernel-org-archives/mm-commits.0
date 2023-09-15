Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 885D6CD37AE
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 22:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjIOWtd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 18:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238191AbjIOWt1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 18:49:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E9C35A2
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 15:47:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98217C433C7;
        Fri, 15 Sep 2023 22:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694818058;
        bh=8L0kML7wLah4oRbmTxMjIqc4BY56jOP+6ZR0KhbbyeQ=;
        h=Date:To:From:Subject:From;
        b=YyCjOFxw4wRj24VTxZczVe9JMksV0xo98TyoCv0/BwhC6O5DbTsXgosZQ0EUgalED
         nr2PqNI6Sw0sd4euPiW2Zy+DC/eZ04jeztIs2B9/ppvYE3znSKwb9/dM1hx+MTr83a
         pwhG2/S2dU8q5V9DN+Y88dbphvBGijIWZeWHNs/A=
Date:   Fri, 15 Sep 2023 15:47:38 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        rppt@kernel.org, punit.agrawal@bytedance.com,
        mike.kravetz@oracle.com, fam.zheng@bytedance.com,
        usama.arif@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memblock-pass-memblock_type-to-memblock_setclr_flag.patch added to mm-unstable branch
Message-Id: <20230915224738.98217C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: pass memblock_type to memblock_setclr_flag
has been added to the -mm mm-unstable branch.  Its filename is
     memblock-pass-memblock_type-to-memblock_setclr_flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memblock-pass-memblock_type-to-memblock_setclr_flag.patch

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
Subject: memblock: pass memblock_type to memblock_setclr_flag
Date: Wed, 13 Sep 2023 11:53:59 +0100

This allows setting flags to both memblock types and is in preparation for
setting flags (for e.g.  to not initialize struct pages) on reserved
memory region.

Link: https://lkml.kernel.org/r/20230913105401.519709-3-usama.arif@bytedance.com
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/memblock.c~memblock-pass-memblock_type-to-memblock_setclr_flag
+++ a/mm/memblock.c
@@ -901,10 +901,9 @@ int __init_memblock memblock_physmem_add
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
@@ -933,7 +932,7 @@ static int __init_memblock memblock_setc
  */
 int __init_memblock memblock_mark_hotplug(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_setclr_flag(base, size, 1, MEMBLOCK_HOTPLUG);
+	return memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLOCK_HOTPLUG);
 }
 
 /**
@@ -945,7 +944,7 @@ int __init_memblock memblock_mark_hotplu
  */
 int __init_memblock memblock_clear_hotplug(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_setclr_flag(base, size, 0, MEMBLOCK_HOTPLUG);
+	return memblock_setclr_flag(&memblock.memory, base, size, 0, MEMBLOCK_HOTPLUG);
 }
 
 /**
@@ -962,7 +961,7 @@ int __init_memblock memblock_mark_mirror
 
 	system_has_some_mirror = true;
 
-	return memblock_setclr_flag(base, size, 1, MEMBLOCK_MIRROR);
+	return memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLOCK_MIRROR);
 }
 
 /**
@@ -982,7 +981,7 @@ int __init_memblock memblock_mark_mirror
  */
 int __init_memblock memblock_mark_nomap(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_setclr_flag(base, size, 1, MEMBLOCK_NOMAP);
+	return memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLOCK_NOMAP);
 }
 
 /**
@@ -994,7 +993,7 @@ int __init_memblock memblock_mark_nomap(
  */
 int __init_memblock memblock_clear_nomap(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_setclr_flag(base, size, 0, MEMBLOCK_NOMAP);
+	return memblock_setclr_flag(&memblock.memory, base, size, 0, MEMBLOCK_NOMAP);
 }
 
 static bool should_skip_region(struct memblock_type *type,
_

Patches currently in -mm which might be from usama.arif@bytedance.com are

mm-hugetlb_vmemmap-use-nid-of-the-head-page-to-reallocate-it.patch
memblock-pass-memblock_type-to-memblock_setclr_flag.patch
memblock-introduce-memblock_rsrv_noinit-flag.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo.patch


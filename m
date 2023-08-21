Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCB5EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjHUUmV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbjHUUl2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D10E52
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 272B164526
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B565C433C8;
        Mon, 21 Aug 2023 20:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650449;
        bh=FMbHhY9i3lRds+oPkDjtE37EMaertnClx0fpjt+8nrc=;
        h=Date:To:From:Subject:From;
        b=PTaLIub6RK707AFihQShyZPpSY0HQ0CkA1mWUXGB1Xq150WXequcxkPXjLr3/D6Iw
         LevsGXq6bsrmb3s+LWAGQJVVAci+Kl2v58eYkM95ZGn1WpMKFIvgWhTBfTOOKhsVCi
         +YWbhTvh4xLl4Y88JzfrzVmNswG29F0F2X1EuD14=
Date:   Mon, 21 Aug 2023 13:40:49 -0700
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        osalvador@suse.de, npiggin@gmail.com, mpe@ellerman.id.au,
        mhocko@suse.com, david@redhat.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch removed from -mm tree
Message-Id: <20230821204049.7B565C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory_hotplug: allow architecture to override memmap on memory support check
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/memory_hotplug: allow architecture to override memmap on memory support check
Date: Tue, 8 Aug 2023 14:44:58 +0530

Some architectures would want different restrictions. Hence add an
architecture-specific override.

The PMD_SIZE check is moved there.

Link: https://lkml.kernel.org/r/20230808091501.287660-4-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check
+++ a/mm/memory_hotplug.c
@@ -1247,10 +1247,26 @@ static int online_memory_block(struct me
 	return device_online(&mem->dev);
 }
 
+static inline unsigned long memory_block_memmap_size(void)
+{
+	return PHYS_PFN(memory_block_size_bytes()) * sizeof(struct page);
+}
+
+#ifndef arch_supports_memmap_on_memory
+static inline bool arch_supports_memmap_on_memory(unsigned long vmemmap_size)
+{
+	/*
+	 * As default, we want the vmemmap to span a complete PMD such that we
+	 * can map the vmemmap using a single PMD if supported by the
+	 * architecture.
+	 */
+	return IS_ALIGNED(vmemmap_size, PMD_SIZE);
+}
+#endif
+
 static bool mhp_supports_memmap_on_memory(unsigned long size)
 {
-	unsigned long nr_vmemmap_pages = size / PAGE_SIZE;
-	unsigned long vmemmap_size = nr_vmemmap_pages * sizeof(struct page);
+	unsigned long vmemmap_size = memory_block_memmap_size();
 	unsigned long remaining_size = size - vmemmap_size;
 
 	/*
@@ -1281,8 +1297,8 @@ static bool mhp_supports_memmap_on_memor
 	 */
 	return mhp_memmap_on_memory() &&
 	       size == memory_block_size_bytes() &&
-	       IS_ALIGNED(vmemmap_size, PMD_SIZE) &&
-	       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT));
+	       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT)) &&
+	       arch_supports_memmap_on_memory(vmemmap_size);
 }
 
 /*
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are



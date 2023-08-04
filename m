Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61325C001DE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 18:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjHDSF6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjHDSF5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 14:05:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F178746A3
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 11:05:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 853B8620A7
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 18:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E6AC433C7;
        Fri,  4 Aug 2023 18:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691172356;
        bh=Ka+F7fgcbCPvcQUXQXu5DTjOdWJ7W1MvFMH4DIOnivc=;
        h=Date:To:From:Subject:From;
        b=FpNErBk+kyyN/I8vV//I/UJDKcaxxMhKqc9PSInBEn7OUqNyGxltVoCYzACMlVMaA
         HlnBbKseywR5F2Zyk4da7OiPasT7cTGd+T5OF8iFBKfP+IctGBAFWlfaXpzQOVth9K
         QV9Ym+++XL1ZrELXRL1qMGbHe/qW0eezHTTp6d2w=
Date:   Fri, 04 Aug 2023 11:05:55 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, ppbuk5246@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents.patch removed from -mm tree
Message-Id: <20230804180555.D5E6AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mm_init: ignore kernelcore=mirror boot option when no mirror memory present
has been removed from the -mm tree.  Its filename was
     mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Levi Yun <ppbuk5246@gmail.com>
Subject: mm/mm_init: ignore kernelcore=mirror boot option when no mirror memory present
Date: Wed, 2 Aug 2023 19:36:14 +0100

In a machine where no mirror memory is set, All memory region in
ZONE_NORMAL is used as ZONE_MOVABLE when kernelcore=mirror boot option is
used.  So, ZONE_NORMAL couldn't be populated properly because all of
ZONE_NORMAL pages is absent.

To avoid this abnormal situation,
ignore disable kernelcore=mirror option when no mirror memory is found.

[akpm@linux-foundation.org: fix printk grammar]
Link: https://lkml.kernel.org/r/20230802183614.15520-1-ppbuk5246@gmail.com
Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents
+++ a/mm/mm_init.c
@@ -376,10 +376,13 @@ static void __init find_zone_movable_pfn
 	 */
 	if (mirrored_kernelcore) {
 		bool mem_below_4gb_not_mirrored = false;
+		bool no_mirror_mem = true;
 
 		for_each_mem_region(r) {
-			if (memblock_is_mirror(r))
+			if (memblock_is_mirror(r)) {
+				no_mirror_mem = false;
 				continue;
+			}
 
 			nid = memblock_get_region_node(r);
 
@@ -398,6 +401,12 @@ static void __init find_zone_movable_pfn
 		if (mem_below_4gb_not_mirrored)
 			pr_warn("This configuration results in unmirrored kernel memory.\n");
 
+		if (no_mirror_mem) {
+			pr_warn("There is no mirrored memory. Ignoring kernelcore=mirror.\n");
+			mirrored_kernelcore = false;
+			memset(zone_movable_pfn, 0x00, sizeof(zone_movable_pfn));
+		}
+
 		goto out2;
 	}
 
_

Patches currently in -mm which might be from ppbuk5246@gmail.com are

damon-use-pmdp_get-instead-of-drectly-dereferencing-pmd.patch


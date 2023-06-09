Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33621C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbjFIXdg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbjFIXcs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD5849D3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43E6165CAF
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97861C433D2;
        Fri,  9 Jun 2023 23:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353399;
        bh=Vq+at+ov7ty01epEi15Qq8Yapoh/qn7UNgfVamy4Iik=;
        h=Date:To:From:Subject:From;
        b=XlXCOoCDWZXDUUnBUBxyTv6iTgXAebdZetUmWl5BHcXTep68TDlHmvUqbJJwTovYX
         Va8M8co0PEx3aIjqhvJSzUnKdnoSGirGSlJjc3xAgQQDuoAvxrR46ki1+ZYDpnUf/v
         mJNAbYX7mDwVLb6roV0kOtQPizg9lVE8BaW8V4zw=
Date:   Fri, 09 Jun 2023 16:29:59 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, mhocko@suse.com,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-remove-free_area_init_memoryless_node.patch removed from -mm tree
Message-Id: <20230609232959.97861C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mm_init.c: remove free_area_init_memoryless_node()
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-remove-free_area_init_memoryless_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/mm_init.c: remove free_area_init_memoryless_node()
Date: Sun, 28 May 2023 04:57:20 +0000

free_area_init_memoryless_node() is just a wrapper of
free_area_init_node(), remove it to clean up.

Link: https://lkml.kernel.org/r/20230528045720.4835-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-remove-free_area_init_memoryless_node
+++ a/mm/mm_init.c
@@ -1754,11 +1754,6 @@ void __init setup_nr_node_ids(void)
 }
 #endif
 
-static void __init free_area_init_memoryless_node(int nid)
-{
-	free_area_init_node(nid);
-}
-
 /*
  * Some architectures, e.g. ARC may have ZONE_HIGHMEM below ZONE_NORMAL. For
  * such cases we allow max_zone_pfn sorted in the descending order
@@ -1869,7 +1864,7 @@ void __init free_area_init(unsigned long
 				panic("Cannot allocate %zuB for node %d.\n",
 				       sizeof(*pgdat), nid);
 			arch_refresh_nodedata(nid, pgdat);
-			free_area_init_memoryless_node(nid);
+			free_area_init_node(nid);
 
 			/*
 			 * We do not want to confuse userspace by sysfs
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch
mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch
mm-mm_initc-remove-reset_node_present_pages.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch


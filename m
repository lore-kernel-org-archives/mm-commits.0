Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F33AE7C4F4
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244030AbjJDUSo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244022AbjJDUSo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01CFBF
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7D6C433CA;
        Wed,  4 Oct 2023 20:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450719;
        bh=9ehjaqV92zpF3rLJcHKMYj7F7mIykvUZr1PIpSG0LCQ=;
        h=Date:To:From:Subject:From;
        b=caCeXo6XQTTDDrswhCVKQKlnw0ZXalb8bX4qjp6UFQLwnm0joXQUoIAGbl74GxPBR
         XKcz8eqA+9VFZRqAqwbP0fPX+An99I+L7Oyn5rt6FTNDG4yvLFzAstTrktwGt+KYyy
         h64xSJO1FbYmkN6LFwsoiAA3zsUBWY3/hnNkuJ4E=
Date:   Wed, 04 Oct 2023 13:18:38 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, david@redhat.com,
        yajun.deng@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-remove-redundant-pr_info-when-node-is-memoryless.patch removed from -mm tree
Message-Id: <20231004201839.4F7D6C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mm_init.c: remove redundant pr_info when node is memoryless
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-remove-redundant-pr_info-when-node-is-memoryless.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/mm_init.c: remove redundant pr_info when node is memoryless
Date: Wed, 6 Sep 2023 17:11:13 +0800

There is a similar pr_info in free_area_init_node(), so remove the
redundant pr_info.

before:
[    0.006314] Initializing node 0 as memoryless
[    0.006445] Initmem setup node 0 as memoryless
[    0.006450] Initmem setup node 1 [mem 0x0000000000001000-0x000000003fffffff]
[    0.006453] Initmem setup node 2 [mem 0x0000000040000000-0x000000007ffd7fff]
[    0.006454] Initializing node 3 as memoryless
[    0.006584] Initmem setup node 3 as memoryless
[    0.006585] Initmem setup node 4 [mem 0x0000000100000000-0x00000001bfffffff]
[    0.006586] Initmem setup node 5 [mem 0x00000001c0000000-0x00000001ffffffff]
[    0.006587] Initmem setup node 6 [mem 0x0000000200000000-0x000000023fffffff]

after:
[    0.004147] Initmem setup node 0 as memoryless
[    0.004148] Initmem setup node 1 [mem 0x0000000000001000-0x000000003fffffff]
[    0.004150] Initmem setup node 2 [mem 0x0000000040000000-0x000000007ffd7fff]
[    0.004154] Initmem setup node 3 as memoryless
[    0.004155] Initmem setup node 4 [mem 0x0000000100000000-0x00000001bfffffff]
[    0.004156] Initmem setup node 5 [mem 0x00000001c0000000-0x00000001ffffffff]
[    0.004157] Initmem setup node 6 [mem 0x0000000200000000-0x000000023fffffff]

Link: https://lkml.kernel.org/r/20230906091113.4029983-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-remove-redundant-pr_info-when-node-is-memoryless
+++ a/mm/mm_init.c
@@ -1871,8 +1871,6 @@ void __init free_area_init(unsigned long
 		pg_data_t *pgdat;
 
 		if (!node_online(nid)) {
-			pr_info("Initializing node %d as memoryless\n", nid);
-
 			/* Allocator not initialized yet */
 			pgdat = arch_alloc_nodedata(nid);
 			if (!pgdat)
_

Patches currently in -mm which might be from yajun.deng@linux.dev are



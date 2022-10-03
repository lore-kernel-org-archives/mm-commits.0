Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A693FC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiJCVPp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiJCVOG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7986C112F
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B57C3611EC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B33C433C1;
        Mon,  3 Oct 2022 21:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831376;
        bh=r6isQ/5LMwJAyjrLe6Yy3DPPemOFmrtNl7LQSGP3Qxw=;
        h=Date:To:From:Subject:From;
        b=wXleROk5plSYLk+SFsRdA59kPuSft/bvqG2IaAJw1IFS1VUUdOJ1ABeUspImnD6/E
         NIIU3q3hK4k/+xpAGfjexsBH9vpscWdhhpxwikEeX268oW+eA/p1BsN3MW1/PtAL0X
         cneDRMzFbv79dnFa7kfA2aagYYha8soqeSKThNuk=
Date:   Mon, 03 Oct 2022 14:09:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-use-local-variable-zone_idx-directly.patch removed from -mm tree
Message-Id: <20221003210936.11B33C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: use local variable zone_idx directly
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-local-variable-zone_idx-directly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: use local variable zone_idx directly
Date: Fri, 16 Sep 2022 15:22:50 +0800

Use local variable zone_idx directly since it holds the exact value of
zone_idx().  No functional change intended.

Link: https://lkml.kernel.org/r/20220916072257.9639-10-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-local-variable-zone_idx-directly
+++ a/mm/page_alloc.c
@@ -6881,7 +6881,7 @@ void __ref memmap_init_zone_device(struc
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
 
-	if (WARN_ON_ONCE(!pgmap || zone_idx(zone) != ZONE_DEVICE))
+	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
 		return;
 
 	/*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are



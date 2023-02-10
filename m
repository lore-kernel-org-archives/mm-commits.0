Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A530C636D3
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjBJA40 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjBJAzB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D226074304
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9FB261BA2
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB5AC4339B;
        Fri, 10 Feb 2023 00:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990447;
        bh=TmnXGDy9Mv8cmmrxp69BEMJUFWEiSsEdAN+L6rTGU8E=;
        h=Date:To:From:Subject:From;
        b=gNAS7IJ2EJqQqfR1mFIqiee13b0lbz3zD7sJQhnF/U1Lsl3/i1Kc39RII4N8xuBXP
         vO1AgnOU+/InLQ8SI2/Hs+ASeEevT8TYGrEl2UspKP6vNgXFj/93AOaYROS7L/c+iC
         9Uh9L0eDMhUTxuZjSVHpHGvXIpWk0oY25jhE8o2c=
Date:   Thu, 09 Feb 2023 16:54:06 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        sangyun.kim@snu.ac.kr, rppt@kernel.org, gwan-gyeong.mun@intel.com,
        christophe.leroy@csgroup.eu, casionwoo@gmail.com,
        42.hyeyoo@gmail.com, hn.min.lee@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-replace-bug_on-to-a-simple-if-statement.patch removed from -mm tree
Message-Id: <20230210005407.2AB5AC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: replace BUG_ON with a simple if statement
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-replace-bug_on-to-a-simple-if-statement.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyunmin Lee <hn.min.lee@gmail.com>
Subject: mm/vmalloc: replace BUG_ON with a simple if statement
Date: Wed, 1 Feb 2023 20:51:42 +0900

As per the coding standards, in the event of an abnormal condition that
should not occur under normal circumstances, the kernel should attempt
recovery and proceed with execution, rather than halting the machine.

Specifically, in the alloc_vmap_area() function, use a simple if()
instead of using BUG_ON() halting the machine.

Link: https://lkml.kernel.org/r/20230201115142.GA7772@min-iamroot
Co-developed-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Signed-off-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Co-developed-by: Jeungwoo Yoo <casionwoo@gmail.com>
Signed-off-by: Jeungwoo Yoo <casionwoo@gmail.com>
Co-developed-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Signed-off-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Signed-off-by: Hyunmin Lee <hn.min.lee@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-replace-bug_on-to-a-simple-if-statement
+++ a/mm/vmalloc.c
@@ -1586,9 +1586,8 @@ static struct vmap_area *alloc_vmap_area
 	int purged = 0;
 	int ret;
 
-	BUG_ON(!size);
-	BUG_ON(offset_in_page(size));
-	BUG_ON(!is_power_of_2(align));
+	if (unlikely(!size || offset_in_page(size) || !is_power_of_2(align)))
+		return ERR_PTR(-EINVAL);
 
 	if (unlikely(!vmap_initialized))
 		return ERR_PTR(-EBUSY);
_

Patches currently in -mm which might be from hn.min.lee@gmail.com are



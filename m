Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B48BCCA485
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbiGRAV6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbiGRAUg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7765EB93
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3108EB80EF2
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEFBC341CA;
        Mon, 18 Jul 2022 00:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103522;
        bh=0ljUkXN2UFWRAB+e+vDeyy1NcBpXOgOz/y6k3OvUahs=;
        h=Date:To:From:Subject:From;
        b=L/0pPfMffGYxp/uqNHY5//XBf9tgvBd36Nzidsqv5owR2SiN6y3IRqBMwDr2+JzRI
         /ffC7WxV9HTioVuSTf8227Y28OxOMbKAYEkPeagKp9dRGmzdaLYFRbXzReTdV2/LzN
         oXw5uwAgpW0pGwYg2ZxAVIjq+WdMOkl9r76xzVQo=
Date:   Sun, 17 Jul 2022 17:18:42 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, dennis@kernel.org,
        cl@linux.com, catalin.marinas@arm.com, patrick.wang.shcn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-percpu-use-kmemleak_ignore_phys-instead-of-kmemleak_free.patch removed from -mm tree
Message-Id: <20220718001842.CFEFBC341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: percpu: use kmemleak_ignore_phys() instead of kmemleak_free()
has been removed from the -mm tree.  Its filename was
     mm-percpu-use-kmemleak_ignore_phys-instead-of-kmemleak_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Patrick Wang <patrick.wang.shcn@gmail.com>
Subject: mm: percpu: use kmemleak_ignore_phys() instead of kmemleak_free()
Date: Tue, 5 Jul 2022 19:31:58 +0800

Kmemleak recently added a rbtree to store the objects allocted with
physical address.  Those objects can't be freed with kmemleak_free().

According to the comments, percpu allocations are tracked by kmemleak
separately.  Kmemleak_free() was used to avoid the unnecessary
tracking.  If kmemleak_free() fails, those objects would be scanned by
kmemleak, which is unnecessary but shouldn't lead to other effects.

Use kmemleak_ignore_phys() instead of kmemleak_free() for those
objects.

Link: https://lkml.kernel.org/r/20220705113158.127600-1-patrick.wang.shcn@gmail.com
Fixes: 0c24e061196c ("mm: kmemleak: add rbtree and store physical address for objects allocated with PA")
Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/percpu.c~mm-percpu-use-kmemleak_ignore_phys-instead-of-kmemleak_free
+++ a/mm/percpu.c
@@ -3104,7 +3104,7 @@ int __init pcpu_embed_first_chunk(size_t
 			goto out_free_areas;
 		}
 		/* kmemleak tracks the percpu allocations separately */
-		kmemleak_free(ptr);
+		kmemleak_ignore_phys(__pa(ptr));
 		areas[group] = ptr;
 
 		base = min(ptr, base);
@@ -3304,7 +3304,7 @@ int __init pcpu_page_first_chunk(size_t
 				goto enomem;
 			}
 			/* kmemleak tracks the percpu allocations separately */
-			kmemleak_free(ptr);
+			kmemleak_ignore_phys(__pa(ptr));
 			pages[j++] = virt_to_page(ptr);
 		}
 	}
@@ -3417,7 +3417,7 @@ void __init setup_per_cpu_areas(void)
 	if (!ai || !fc)
 		panic("Failed to allocate memory for percpu areas.");
 	/* kmemleak tracks the percpu allocations separately */
-	kmemleak_free(fc);
+	kmemleak_ignore_phys(__pa(fc));
 
 	ai->dyn_size = unit_size;
 	ai->unit_size = unit_size;
_

Patches currently in -mm which might be from patrick.wang.shcn@gmail.com are



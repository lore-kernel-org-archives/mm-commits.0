Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B7CC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjBJArW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjBJArV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:47:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF606ADC8
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:47:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26412B82399
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0250C433D2;
        Fri, 10 Feb 2023 00:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990037;
        bh=FGh4QaQVYV1/yqScBn5iEuVDeYw2LI5sBsoXoN354ow=;
        h=Date:To:From:Subject:From;
        b=oJeh3dGnqziGC18wwayUfmjCUOPBMPR7JD1vEKtZK67UcRgEMoxefviS0HhoKUsGO
         Ye3EhnF9suSb3TSekxrzrZX+8XZFwwjIlWkWMaeiYsDkQ2jHZYjFcuhyH8spxPylc+
         4JpYX7Of8AzAj7W39V+GiSOOhslJsZTUjPWJmMGM=
Date:   Thu, 09 Feb 2023 16:47:17 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        Kuan-Ying.Lee@mediatek.com, glider@google.com,
        andreyknvl@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-infer-allocation-size-by-scanning-metadata-fix.patch removed from -mm tree
Message-Id: <20230210004717.C0250C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan-infer-allocation-size-by-scanning-metadata-fix
has been removed from the -mm tree.  Its filename was
     kasan-infer-allocation-size-by-scanning-metadata-fix.patch

This patch was dropped because it was folded into kasan-infer-allocation-size-by-scanning-metadata.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-infer-allocation-size-by-scanning-metadata-fix
Date: Thu Feb  2 02:43:48 PM PST 2023

fix printk warning

Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lkml.kernel.org/r/202302021325.700zGa0M-lkp@intel.com
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kasan/report.c~kasan-infer-allocation-size-by-scanning-metadata-fix
+++ a/mm/kasan/report.c
@@ -268,7 +268,7 @@ static void describe_object_addr(const v
 	}
 
 	pr_err("The buggy address is located %d bytes %s of\n"
-	       " %s%lu-byte region [%px, %px)\n",
+	       " %s%zu-byte region [%px, %px)\n",
 	       rel_bytes, rel_type, region_state, info->alloc_size,
 	       (void *)object_addr, (void *)(object_addr + info->alloc_size));
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-infer-allocation-size-by-scanning-metadata.patch
shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch


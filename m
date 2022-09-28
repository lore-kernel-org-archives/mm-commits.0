Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 964E2C32771
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 14:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiI1Omr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 10:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbiI1Omi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 10:42:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C40AF4A4
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 07:42:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B422B61D22
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 14:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB53C433C1;
        Wed, 28 Sep 2022 14:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664376153;
        bh=0299TnwdtHeAWEnnTsm7k+LWqsnkY0fjrAhDkKMxRKw=;
        h=Date:To:From:Subject:From;
        b=Hy3h2id+LS0QoIlJCqfu3ksENBZXkWb96MFZqn1gZF9G1O1aQv5XBdVakP+C78TpL
         +vOGwtfZMZCaAZFzmxtbJHGLnLcZrPEpSIQAlYrmGpeovBT2tgSzIns3nTkq3JLMlJ
         SxC5ag+jkfLo1rW3sqkTBU6//1TFjZaaVuqibnVI=
Date:   Wed, 28 Sep 2022 07:42:26 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        naoya.horiguchi@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hwpoison-introduce-per-memory_block-hwpoison-counter-fix.patch removed from -mm tree
Message-Id: <20220928144232.EEB53C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hwpoison-introduce-per-memory_block-hwpoison-counter-fix
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-introduce-per-memory_block-hwpoison-counter-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Subject: mm-hwpoison-introduce-per-memory_block-hwpoison-counter-fix
Date: Fri, 23 Sep 2022 17:18:27 +0900

>
> All errors (new ones prefixed by >>):
>
>    drivers/base/memory.c: In function 'memory_block_online':
> >> drivers/base/memory.c:186:34: error: 'struct memory_block' has no member named 'nr_hwpoison'
>      186 |         if (atomic_long_read(&mem->nr_hwpoison))
>          |                                  ^~
>    drivers/base/memory.c: In function 'remove_memory_block_devices':
>    drivers/base/memory.c:870:61: error: 'struct memory_block' has no member named 'nr_hwpoison'
>      870 |                 clear_hwpoisoned_pages(atomic_long_read(&mem->nr_hwpoison));
>          |                                                             ^~
>

I should've used the accessor memblk_nr_poison() to acccess to
->nr_hwpoison.

Link: https://lkml.kernel.org/r/20220923081827.GA1357512@ik1-406-35019.vs.sakura.ne.jp
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    9 +++++++--
 include/linux/mm.h    |    2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/base/memory.c~mm-hwpoison-introduce-per-memory_block-hwpoison-counter-fix
+++ a/drivers/base/memory.c
@@ -183,7 +183,7 @@ static int memory_block_online(struct me
 	struct zone *zone;
 	int ret;
 
-	if (atomic_long_read(&mem->nr_hwpoison))
+	if (memblk_nr_poison(start_pfn))
 		return -EHWPOISON;
 
 	zone = zone_for_pfn_range(mem->online_type, mem->nid, mem->group,
@@ -867,7 +867,7 @@ void remove_memory_block_devices(unsigne
 		mem = find_memory_block_by_id(block_id);
 		if (WARN_ON_ONCE(!mem))
 			continue;
-		clear_hwpoisoned_pages(atomic_long_read(&mem->nr_hwpoison));
+		clear_hwpoisoned_pages(memblk_nr_poison(start));
 		unregister_memory_block_under_nodes(mem);
 		remove_memory_block(mem);
 	}
@@ -1199,4 +1199,9 @@ unsigned long memblk_nr_poison(unsigned
 	return 0;
 }
 
+#else
+unsigned long memblk_nr_poison(unsigned long pfn)
+{
+	return 0;
+}
 #endif
--- a/include/linux/mm.h~mm-hwpoison-introduce-per-memory_block-hwpoison-counter-fix
+++ a/include/linux/mm.h
@@ -3282,7 +3282,6 @@ extern int __get_huge_page_for_hwpoison(
 extern void num_poisoned_pages_inc(unsigned long pfn);
 extern void memblk_nr_poison_inc(unsigned long pfn);
 extern void memblk_nr_poison_sub(unsigned long pfn, long i);
-extern unsigned long memblk_nr_poison(unsigned long pfn);
 extern void clear_hwpoisoned_pages(long nr_poison);
 #else
 static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags)
@@ -3298,6 +3297,7 @@ static inline void clear_hwpoisoned_page
 {
 }
 #endif
+extern unsigned long memblk_nr_poison(unsigned long pfn);
 
 #ifndef arch_memory_failure
 static inline int arch_memory_failure(unsigned long pfn, int flags)
_

Patches currently in -mm which might be from naoya.horiguchi@linux.dev are



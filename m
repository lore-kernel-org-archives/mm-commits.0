Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC9CCCA47F
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379793AbiFQCtm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379804AbiFQCt3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B4365411
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C95E561D19
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C4AC34114;
        Fri, 17 Jun 2022 02:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434164;
        bh=UVUNB2xYXYdgYr1OBeDypsq5JV7zmwzaZFl/lZJOwcE=;
        h=Date:To:From:Subject:From;
        b=ZLvxZMOAZ2+UnyhjPzJCO8eoN9MG4JZVnCaT5yLvSirxKPMXD7sjDLZGj+yyVjF/b
         ABbgA6rbe4rDvSsBKlDKu4g54NlTDKcLkURdziRObvaZmGh1Mz0QGgH4pAYPuv1bQv
         QFywPwXsbj49HzK12AeEPUWvBM6OW0okwPrvHdmM=
Date:   Thu, 16 Jun 2022 19:49:23 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, hch@infradead.org,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-fix-typo-in-local-variable-name.patch removed from -mm tree
Message-Id: <20220617024924.28C4AC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: fix typo in local variable name
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-typo-in-local-variable-name.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc: fix typo in local variable name
Date: Tue, 7 Jun 2022 18:59:57 +0800

In __purge_vmap_area_lazy(), rename local_pure_list to local_purge_list.

Link: https://lkml.kernel.org/r/20220607105958.382076-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-typo-in-local-variable-name
+++ a/mm/vmalloc.c
@@ -1669,32 +1669,32 @@ static void purge_fragmented_blocks_allc
 static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end)
 {
 	unsigned long resched_threshold;
-	struct list_head local_pure_list;
+	struct list_head local_purge_list;
 	struct vmap_area *va, *n_va;
 
 	lockdep_assert_held(&vmap_purge_lock);
 
 	spin_lock(&purge_vmap_area_lock);
 	purge_vmap_area_root = RB_ROOT;
-	list_replace_init(&purge_vmap_area_list, &local_pure_list);
+	list_replace_init(&purge_vmap_area_list, &local_purge_list);
 	spin_unlock(&purge_vmap_area_lock);
 
-	if (unlikely(list_empty(&local_pure_list)))
+	if (unlikely(list_empty(&local_purge_list)))
 		return false;
 
 	start = min(start,
-		list_first_entry(&local_pure_list,
+		list_first_entry(&local_purge_list,
 			struct vmap_area, list)->va_start);
 
 	end = max(end,
-		list_last_entry(&local_pure_list,
+		list_last_entry(&local_purge_list,
 			struct vmap_area, list)->va_end);
 
 	flush_tlb_kernel_range(start, end);
 	resched_threshold = lazy_max_pages() << 1;
 
 	spin_lock(&free_vmap_area_lock);
-	list_for_each_entry_safe(va, n_va, &local_pure_list, list) {
+	list_for_each_entry_safe(va, n_va, &local_purge_list, list) {
 		unsigned long nr = (va->va_end - va->va_start) >> PAGE_SHIFT;
 		unsigned long orig_start = va->va_start;
 		unsigned long orig_end = va->va_end;
_

Patches currently in -mm which might be from bhe@redhat.com are



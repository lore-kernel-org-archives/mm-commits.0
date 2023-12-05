Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4661C4167B
	for <mm-commits@archiver.kernel.org>; Tue,  5 Dec 2023 19:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbjLET6C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Dec 2023 14:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235126AbjLET55 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2023 14:57:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C66194
        for <mm-commits@vger.kernel.org>; Tue,  5 Dec 2023 11:58:01 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F330C433CA;
        Tue,  5 Dec 2023 19:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701806281;
        bh=dYnBfDP5ZibaqDAAwpjNO1wWmrh9orjwFkm9WUgKGkA=;
        h=Date:To:From:Subject:From;
        b=ibj9LmON9kYzfcIkSVqkXU44Fjvwalm1nI/4CKURFjfiY5vn8kcc7iYlNyKmt6vIc
         io1BtEb3qL8Wv+L8Xlx3uiVfik442svWUFMQNwZhNNKTk4Vr8/r/QAiSC5257NgNM/
         ejWMm2a/ZEoyuSZUG/WpyW3GF6oATAQ04p5/1p0Y=
Date:   Tue, 05 Dec 2023 11:58:00 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-move-mmap-lock-to-vmemmap_remap_range.patch added to mm-unstable branch
Message-Id: <20231205195801.1F330C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: move mmap lock to vmemmap_remap_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-move-mmap-lock-to-vmemmap_remap_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-move-mmap-lock-to-vmemmap_remap_range.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: move mmap lock to vmemmap_remap_range()
Date: Tue, 5 Dec 2023 11:08:53 +0800

All the users of vmemmap_remap_range() will hold the mmap lock and release
it once it returns, it is naturally to move the lock to
vmemmap_remap_range() to simplify the code and the users.

Link: https://lkml.kernel.org/r/20231205030853.3921-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-move-mmap-lock-to-vmemmap_remap_range
+++ a/mm/hugetlb_vmemmap.c
@@ -163,8 +163,10 @@ static int vmemmap_remap_range(unsigned
 
 	VM_BUG_ON(!PAGE_ALIGNED(start | end));
 
+	mmap_read_lock(&init_mm);
 	ret = walk_page_range_novma(&init_mm, start, end, &vmemmap_remap_ops,
 				    NULL, walk);
+	mmap_read_unlock(&init_mm);
 	if (ret)
 		return ret;
 
@@ -282,7 +284,6 @@ static void vmemmap_restore_pte(pte_t *p
 static int vmemmap_remap_split(unsigned long start, unsigned long end,
 			       unsigned long reuse)
 {
-	int ret;
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= NULL,
 		.flags		= VMEMMAP_SPLIT_NO_TLB_FLUSH,
@@ -291,11 +292,7 @@ static int vmemmap_remap_split(unsigned
 	/* See the comment in the vmemmap_remap_free(). */
 	BUG_ON(start - reuse != PAGE_SIZE);
 
-	mmap_read_lock(&init_mm);
-	ret = vmemmap_remap_range(reuse, end, &walk);
-	mmap_read_unlock(&init_mm);
-
-	return ret;
+	return vmemmap_remap_range(reuse, end, &walk);
 }
 
 /**
@@ -358,7 +355,6 @@ static int vmemmap_remap_free(unsigned l
 	 */
 	BUG_ON(start - reuse != PAGE_SIZE);
 
-	mmap_read_lock(&init_mm);
 	ret = vmemmap_remap_range(reuse, end, &walk);
 	if (ret && walk.nr_walked) {
 		end = reuse + walk.nr_walked * PAGE_SIZE;
@@ -377,7 +373,6 @@ static int vmemmap_remap_free(unsigned l
 
 		vmemmap_remap_range(reuse, end, &walk);
 	}
-	mmap_read_unlock(&init_mm);
 
 	return ret;
 }
@@ -434,11 +429,7 @@ static int vmemmap_remap_alloc(unsigned
 	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
 		return -ENOMEM;
 
-	mmap_read_lock(&init_mm);
-	vmemmap_remap_range(reuse, end, &walk);
-	mmap_read_unlock(&init_mm);
-
-	return 0;
+	return vmemmap_remap_range(reuse, end, &walk);
 }
 
 DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-pagewalk-assert-write-mmap-lock-only-for-walking-the-user-page-tables.patch
mm-hugetlb_vmemmap-use-walk_page_range_novma-to-simplify-the-code.patch
mm-hugetlb_vmemmap-move-pagevmemmapselfhosted-check-to-split_vmemmap_huge_pmd.patch
mm-hugetlb_vmemmap-convert-page-to-folio.patch
mm-hugetlb_vmemmap-add-check-of-config_memory_hotplug-back.patch
mm-hugetlb_vmemmap-move-mmap-lock-to-vmemmap_remap_range.patch


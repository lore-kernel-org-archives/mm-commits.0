Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F47EB64DD
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjGIAah (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjGIAa2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:30:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDF1E4D;
        Sat,  8 Jul 2023 17:30:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0E4D60B5C;
        Sun,  9 Jul 2023 00:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5CBC433C8;
        Sun,  9 Jul 2023 00:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688862626;
        bh=Ab9ivfr92a9kHPL/TtQfn9/vN+qzYWfxD2IFZ0/9Ct8=;
        h=Date:To:From:Subject:From;
        b=N1LAre/6bQGR98O9viwav8DTK4T696pHqes+4+E28DJBOqNQw3z5Nra4y+2EQUY0e
         J2IXT0oLBJ8HC+KCeXgMN4SlZ6mgB1IQm7/7i51PeuNgDGZYEIGVJfCx3fm0iLJ5Hz
         Dv2RpZHuViwLDCZiDOsbpO6ZEqenMN/SaDISd4V0=
Date:   Sat, 08 Jul 2023 17:30:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        osalvador@suse.de, mike.kravetz@oracle.com, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] bootmem-remove-the-vmemmap-pages-from-kmemleak-in-free_bootmem_page.patch removed from -mm tree
Message-Id: <20230709003026.1E5CBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: bootmem: remove the vmemmap pages from kmemleak in free_bootmem_page
has been removed from the -mm tree.  Its filename was
     bootmem-remove-the-vmemmap-pages-from-kmemleak-in-free_bootmem_page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: bootmem: remove the vmemmap pages from kmemleak in free_bootmem_page
Date: Tue, 4 Jul 2023 18:19:42 +0800

commit dd0ff4d12dd2 ("bootmem: remove the vmemmap pages from kmemleak in
put_page_bootmem") fix an overlaps existing problem of kmemleak.  But the
problem still existed when HAVE_BOOTMEM_INFO_NODE is disabled, because in
this case, free_bootmem_page() will call free_reserved_page() directly.

Fix the problem by adding kmemleak_free_part() in free_bootmem_page() when
HAVE_BOOTMEM_INFO_NODE is disabled.

Link: https://lkml.kernel.org/r/20230704101942.2819426-1-liushixin2@huawei.com
Fixes: f41f2ed43ca5 ("mm: hugetlb: free the vmemmap pages associated with each HugeTLB page")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem_info.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/bootmem_info.h~bootmem-remove-the-vmemmap-pages-from-kmemleak-in-free_bootmem_page
+++ a/include/linux/bootmem_info.h
@@ -3,6 +3,7 @@
 #define __LINUX_BOOTMEM_INFO_H
 
 #include <linux/mm.h>
+#include <linux/kmemleak.h>
 
 /*
  * Types for free bootmem stored in page->lru.next. These have to be in
@@ -59,6 +60,7 @@ static inline void get_page_bootmem(unsi
 
 static inline void free_bootmem_page(struct page *page)
 {
+	kmemleak_free_part(page_to_virt(page), PAGE_SIZE);
 	free_reserved_page(page);
 }
 #endif
_

Patches currently in -mm which might be from liushixin2@huawei.com are



Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30023C6FD20
	for <mm-commits@archiver.kernel.org>; Fri, 24 Mar 2023 20:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjCXUwA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Mar 2023 16:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjCXUv7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Mar 2023 16:51:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9984A1F5C5
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 13:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A34962CBA
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 20:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA33C4339B;
        Fri, 24 Mar 2023 20:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679691116;
        bh=eTLrsJm/t1j8x7f2kI2AC2WVphAKFo4JwIH6OEAuit0=;
        h=Date:To:From:Subject:From;
        b=puPODxQ5gl54sHTz0lwge3XkicCpTDmKrIS7MmeyiLDu+YeMoRGeZ6xXJIOV6yGHV
         an/k0fpROPOT05e+92BOkSyx3a8sxBDLEZLwBhbvTrYIoBpiZq5V+eUJjkOjLxTkGu
         cxI/SIsFnkiZsFsWXL5Lk2hRdtJ91z2u7eSBkxMs=
Date:   Fri, 24 Mar 2023 13:51:55 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        tony.luck@intel.com, tongtiangen@huawei.com, stevensd@chromium.org,
        shy828301@gmail.com, osalvador@suse.de, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, kirill@shutemov.name, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hwpoison-introduce-copy_mc_highpage.patch removed from -mm tree
Message-Id: <20230324205156.7FA33C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hwpoison: introduce copy_mc_highpage
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-introduce-copy_mc_highpage.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm/hwpoison: introduce copy_mc_highpage
Date: Sat, 4 Mar 2023 22:51:11 -0800

Similar to how copy_mc_user_highpage is implemented for copy_user_highpage
on #MC supported architecture, introduce the #MC handled version of
copy_highpage.

This helper has immediate usage when khugepaged wants to copy file-backed
memory pages and tolerate #MC.

Link: https://lkml.kernel.org/r/20230305065112.1932255-3-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tong Tiangen <tongtiangen@huawei.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: David Stevens <stevensd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   54 ++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 13 deletions(-)

--- a/include/linux/highmem.h~mm-hwpoison-introduce-copy_mc_highpage
+++ a/include/linux/highmem.h
@@ -315,7 +315,29 @@ static inline void copy_user_highpage(st
 
 #endif
 
+#ifndef __HAVE_ARCH_COPY_HIGHPAGE
+
+static inline void copy_highpage(struct page *to, struct page *from)
+{
+	char *vfrom, *vto;
+
+	vfrom = kmap_local_page(from);
+	vto = kmap_local_page(to);
+	copy_page(vto, vfrom);
+	kmsan_copy_page_meta(to, from);
+	kunmap_local(vto);
+	kunmap_local(vfrom);
+}
+
+#endif
+
 #ifdef copy_mc_to_kernel
+/*
+ * If architecture supports machine check exception handling, define the
+ * #MC versions of copy_user_highpage and copy_highpage. They copy a memory
+ * page with #MC in source page (@from) handled, and return the number
+ * of bytes not copied if there was a #MC, otherwise 0 for success.
+ */
 static inline int copy_mc_user_highpage(struct page *to, struct page *from,
 					unsigned long vaddr, struct vm_area_struct *vma)
 {
@@ -332,29 +354,35 @@ static inline int copy_mc_user_highpage(
 
 	return ret;
 }
-#else
-static inline int copy_mc_user_highpage(struct page *to, struct page *from,
-					unsigned long vaddr, struct vm_area_struct *vma)
-{
-	copy_user_highpage(to, from, vaddr, vma);
-	return 0;
-}
-#endif
-
-#ifndef __HAVE_ARCH_COPY_HIGHPAGE
 
-static inline void copy_highpage(struct page *to, struct page *from)
+static inline int copy_mc_highpage(struct page *to, struct page *from)
 {
+	unsigned long ret;
 	char *vfrom, *vto;
 
 	vfrom = kmap_local_page(from);
 	vto = kmap_local_page(to);
-	copy_page(vto, vfrom);
-	kmsan_copy_page_meta(to, from);
+	ret = copy_mc_to_kernel(vto, vfrom, PAGE_SIZE);
+	if (!ret)
+		kmsan_copy_page_meta(to, from);
 	kunmap_local(vto);
 	kunmap_local(vfrom);
+
+	return ret;
+}
+#else
+static inline int copy_mc_user_highpage(struct page *to, struct page *from,
+					unsigned long vaddr, struct vm_area_struct *vma)
+{
+	copy_user_highpage(to, from, vaddr, vma);
+	return 0;
 }
 
+static inline int copy_mc_highpage(struct page *to, struct page *from)
+{
+	copy_highpage(to, from);
+	return 0;
+}
 #endif
 
 static inline void memcpy_page(struct page *dst_page, size_t dst_off,
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-khugepaged-recover-from-poisoned-file-backed-memory.patch


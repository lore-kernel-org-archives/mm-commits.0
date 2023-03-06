Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E266BC61DA4
	for <mm-commits@archiver.kernel.org>; Mon,  6 Mar 2023 21:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCFVWV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCFVWU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2023 16:22:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1450D67804
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 13:22:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A50FC60B09
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 21:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FBCC433D2;
        Mon,  6 Mar 2023 21:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678137738;
        bh=28xM+QOn2iXK3lupxS3a5OKa4IP8B1M8+NUjDn+wT2A=;
        h=Date:To:From:Subject:From;
        b=lha2IOr581OQyojVBx8vcM2exWQjeqnyEQk6pxG3EXWasNWtPzovOXfcpsiGy2edV
         6ubBWlfBIuI39AV8N41VLB0UlNnlJ+GA3Wp6H+UhQZXSk1x4xxDYIpM7KEJ18Z5x+r
         whzFb941zFmjCCuLKCFSEUePbusyoM5kuhnSOuqQ=
Date:   Mon, 06 Mar 2023 13:22:17 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        tony.luck@intel.com, tongtiangen@huawei.com, stevensd@chromium.org,
        shy828301@gmail.com, osalvador@suse.de, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, kirill@shutemov.name, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-introduce-copy_mc_highpage.patch added to mm-unstable branch
Message-Id: <20230306212218.08FBCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: introduce copy_mc_highpage
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-introduce-copy_mc_highpage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-introduce-copy_mc_highpage.patch

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

mm-khugepaged-recover-from-poisoned-anonymous-memory.patch
mm-hwpoison-introduce-copy_mc_highpage.patch
mm-khugepaged-recover-from-poisoned-file-backed-memory.patch


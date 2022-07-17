Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CEBCCCA480
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 23:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiGQX13 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 19:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiGQX12 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 19:27:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3304312602
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 16:27:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AABF7B80E4C
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 23:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B851C3411E;
        Sun, 17 Jul 2022 23:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658100444;
        bh=B6RbAHn10UyWauda6wWtuUfTMc79yaNCh0EJEUBYYts=;
        h=Date:To:From:Subject:From;
        b=MvWHvGRSifNFbuRketdyLd0k4M05m3whCeXwo410BeROA0SqBXGKX09fUH3tlWei1
         839yglxksP96Vj9gxxKDrclSeqVIO1pQg3JVNfx9zRQg4vOUv3sl+SlsiFu5JU+pyB
         rAxYnu2KcYLlZfWbjl0jJme6DCH4Ix6hI+vTzd38=
Date:   Sun, 17 Jul 2022 16:27:23 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-thp-kill-transparent_hugepage_active-fix.patch removed from -mm tree
Message-Id: <20220717232724.3B851C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-thp-kill-transparent_hugepage_active-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-kill-transparent_hugepage_active-fix.patch

This patch was dropped because it was folded into mm-thp-kill-transparent_hugepage_active.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-kill-transparent_hugepage_active-fix
Date: Tue Jun 21 05:51:42 PM PDT 2022

check vma->vm_mm, per Zach

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/huge_memory.c~mm-thp-kill-transparent_hugepage_active-fix
+++ a/mm/huge_memory.c
@@ -73,6 +73,9 @@ bool hugepage_vma_check(struct vm_area_s
 			unsigned long vm_flags,
 			bool smaps)
 {
+	if (!vma->vm_mm)
+		return false;
+
 	if (!transhuge_vma_enabled(vma, vm_flags))
 		return false;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-thp-kill-transparent_hugepage_active.patch
mm-thp-kill-transparent_hugepage_active-fix-fix.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch


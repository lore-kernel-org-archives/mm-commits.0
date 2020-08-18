Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FAE2C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7592520674
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790429;
	bh=RyfbK6oC6lMrOiDaRHPDPPxO0RIMbfJ7HIPDybzDiD0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1DuoH6STJMyL5c4BcexQq3UwMkhchMD6ywxjC7gW9/LgSHDUxyltYoFw98hTY04I+
	 zaYMY0OJxAk+O2nFIN10VGUn1EYq5tTrzDpLT/LirUKlQjlMXn0w8yC+IoCLTDfpRf
	 7vrbelhQ7X0HAXzcN4+1AgE8wYCByetqDTgm0rM8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgHRWk3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727106AbgHRWkY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:40:24 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 832F32078D;
        Tue, 18 Aug 2020 22:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790423;
        bh=RyfbK6oC6lMrOiDaRHPDPPxO0RIMbfJ7HIPDybzDiD0=;
        h=Date:From:To:Subject:From;
        b=KFclDexiLC/+ubPEmWtaE8OyEutGzqT6AJ3BPAsq3YDKqEIBeXXGIrxEwJyogYcF0
         7NlF2y3tfYrL+wK9CJOgopvAfkVDMCwLCO24I+62sp/mr2vtK72/QymjczXEMht+iB
         n9Bj6MQ5KEXQwqTUphotZfyR7AuVC08yxI+XLPHc=
Date:   Tue, 18 Aug 2020 15:40:23 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, kirill.shutemov@linux.intel.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-move-page-flags-include-to-top-of-file.patch
 removed from -mm tree
Message-ID: <20200818224023.1vPIyKvPr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move page-flags include to top of file
has been removed from the -mm tree.  Its filename was
     mm-move-page-flags-include-to-top-of-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move page-flags include to top of file

Give up on the notion that we can remove page-flags.h from mm.h.  There
are currently 14 inline functions which use a PageFoo function.  Also, two
of the files directly included by mm.h include page-flags.h themselves,
and there are probably more indirect inclusions.  So just include it at
the top like any other header file.

Link: http://lkml.kernel.org/r/20200629151959.15779-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-move-page-flags-include-to-top-of-file
+++ a/include/linux/mm.h
@@ -24,6 +24,7 @@
 #include <linux/resource.h>
 #include <linux/page_ext.h>
 #include <linux/err.h>
+#include <linux/page-flags.h>
 #include <linux/page_ref.h>
 #include <linux/memremap.h>
 #include <linux/overflow.h>
@@ -668,11 +669,6 @@ int vma_is_stack_for_current(struct vm_a
 struct mmu_gather;
 struct inode;
 
-/*
- * FIXME: take this include out, include page-flags.h in
- * files which need it (119 of them)
- */
-#include <linux/page-flags.h>
 #include <linux/huge_mm.h>
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are



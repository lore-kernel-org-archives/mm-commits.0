Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F1DBC727AE
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244080AbjHXXWQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244074AbjHXXV5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFFB19A1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDE5563676
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333DBC433C7;
        Thu, 24 Aug 2023 23:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919309;
        bh=B02QNY2N4Zty6yFpS64laFsnVnaq+Untn4l7ie00Auo=;
        h=Date:To:From:Subject:From;
        b=qZh1Jbdqg5gpvmrjUaMAudLPQmDPhq/XRQ3Wqm+/UZnpDYVGybCD0bHtBd9CDtaoh
         OsDoBbD7rQj+4Kmdoh/sEw2zsynJtafq6NqQsCSty3c21bH5z2Q7PDiOPSzMHdfALT
         WNKXEIzKipFj9FWDS6pnZU0Ih6CIetC0V8c5MGi8=
Date:   Thu, 24 Aug 2023 16:21:48 -0700
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-tidy-up-set_ptes-definition.patch removed from -mm tree
Message-Id: <20230824232149.333DBC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: tidy up set_ptes definition
has been removed from the -mm tree.  Its filename was
     mm-tidy-up-set_ptes-definition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: tidy up set_ptes definition
Date: Wed, 2 Aug 2023 16:14:00 +0100

Now that all architectures are converted, we can remove the PFN_PTE_SHIFT
ifdef and we can define set_pte_at() unconditionally.

Link: https://lkml.kernel.org/r/20230802151406.3735276-33-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/pgtable.h~mm-tidy-up-set_ptes-definition
+++ a/include/linux/pgtable.h
@@ -204,7 +204,6 @@ static inline int pmd_young(pmd_t pmd)
 #endif
 
 #ifndef set_ptes
-#ifdef PFN_PTE_SHIFT
 /**
  * set_ptes - Map consecutive pages to a contiguous range of addresses.
  * @mm: Address space to map the pages into.
@@ -234,13 +233,8 @@ static inline void set_ptes(struct mm_st
 	}
 	arch_leave_lazy_mmu_mode();
 }
-#ifndef set_pte_at
-#define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, pte, 1)
-#endif
 #endif
-#else
 #define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, pte, 1)
-#endif
 
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from willy@infradead.org are



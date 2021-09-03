Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71741C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A1676113A
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349933AbhICVAF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233315AbhICU7z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C0AA610FB;
        Fri,  3 Sep 2021 20:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702735;
        bh=4jYmqDhpQs3dEAuo4++HNcl+Wk6cwDm1Ku62Sxtqfdc=;
        h=Date:From:To:Subject:From;
        b=OM+1yWaRF+7Xigmb0YWMcW3jbxmnLvHtJCfuVKyPPs3kYz7I+0dWIqndH8GlBkbZp
         4zqfubGVMZBtGckHf6KR1FPr3QBFBvzUSkeFLJhZPxXIGIFQoaK/MXcmapmXewAPW3
         Nk2yfhdhWlROJk8ZX2uTLkGk3c7tNv31spbRv494=
Date:   Fri, 03 Sep 2021 13:58:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, willy@infradead.org
Subject:  [merged] avoid-a-warning-in-sparse-memory-support.patch
 removed from -mm tree
Message-ID: <20210903205855.YFAwDRpmY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmzone.h: avoid a warning in sparse memory support
has been removed from the -mm tree.  Its filename was
     avoid-a-warning-in-sparse-memory-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: include/linux/mmzone.h: avoid a warning in sparse memory support

cppcheck warns that we're possibly losing information by shifting an int. 
It's a false positive, because we don't allow for a NUMA node ID that
large, but if we ever change SECTION_NID_SHIFT, it could become a problem,
and in any case this is usually a legitimate warning.  Fix it by adding
the necessary cast, which makes the compiler generate the right code.

Link: https://lkml.kernel.org/r/YOya+aBZFFmC476e@casper.infradead.org
Link: https://lkml.kernel.org/r/202107130348.6LsVT9Nc-lkp@intel.com
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~avoid-a-warning-in-sparse-memory-support
+++ a/mm/sparse.c
@@ -117,7 +117,7 @@ static inline int sparse_index_init(unsi
  */
 static inline unsigned long sparse_encode_early_nid(int nid)
 {
-	return (nid << SECTION_NID_SHIFT);
+	return ((unsigned long)nid << SECTION_NID_SHIFT);
 }
 
 static inline int sparse_early_nid(struct mem_section *section)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-bogus-vm_bug_on.patch
mm-mark-idle-page-tracking-as-broken.patch
mm-move-kvmalloc-related-functions-to-slabh.patch


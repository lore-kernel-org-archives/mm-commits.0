Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8349C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7427161A23
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhCXX3j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 19:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231603AbhCXX3I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 19:29:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1795619BB;
        Wed, 24 Mar 2021 23:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616628547;
        bh=w7dpSPGDSSKse+SVNEw+O82p7htr3+UCqgPHaNgKTu8=;
        h=Date:From:To:Subject:From;
        b=OUYrUWzW3ELD7pio69SSkSS+8yLpVSvnyjq+zDl1Wba0t8ulwg61yJV/lA88Rbc16
         FVhEvd54/p8rgJSXNROpJxL38HtcqO6NfY4ttnIchTvRbJaf8CzZ5VBM03aUIPyKT1
         jOVu3GhH9ooQL2bbCb78rLJSGJIOC/WWqN0Lh3l4=
Date:   Wed, 24 Mar 2021 16:29:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        jhubbard@nvidia.com, corbet@lwn.net, willy@infradead.org
Subject:  + mm-doc-fix-fault_flag_allow_retry_first-kerneldoc.patch
 added to -mm tree
Message-ID: <20210324232907.sZXUJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/doc: fix fault_flag_allow_retry_first kerneldoc
has been added to the -mm tree.  Its filename is
     mm-doc-fix-fault_flag_allow_retry_first-kerneldoc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-doc-fix-fault_flag_allow_retry_first-kerneldoc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-doc-fix-fault_flag_allow_retry_first-kerneldoc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/doc: fix fault_flag_allow_retry_first kerneldoc

make htmldocs reports:

./include/linux/mm.h:496: warning: Function parameter or member 'flags' not described in 'fault_flag_allow_retry_first'

Add a description.

Link: https://lkml.kernel.org/r/20210322195022.2143603-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm.h~mm-doc-fix-fault_flag_allow_retry_first-kerneldoc
+++ a/include/linux/mm.h
@@ -475,6 +475,7 @@ extern pgprot_t protection_map[16];
 
 /**
  * fault_flag_allow_retry_first - check ALLOW_RETRY the first time
+ * @flags: Fault flags.
  *
  * This is mostly used for places where we want to try to avoid taking
  * the mmap_lock for too long a time when waiting for another condition
_

Patches currently in -mm which might be from willy@infradead.org are

mm-filemap-use-filemap_read_page-in-filemap_fault.patch
mm-filemap-drop-check-for-truncated-page-after-i-o.patch
mm-introduce-and-use-mapping_empty.patch
mm-stop-accounting-shadow-entries.patch
dax-account-dax-entries-as-nrpages.patch
mm-remove-nrexceptional-from-inode.patch
mm-move-page_mapping_file-to-pagemaph.patch
mm-doc-fix-fault_flag_allow_retry_first-kerneldoc.patch
mm-doc-fix-page_maybe_dma_pinned-kerneldoc.patch
mm-doc-turn-fault-flags-into-an-enum.patch
mm-doc-add-mmh-and-mm_typesh-to-the-mm-api-document.patch
mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch
mm-page_alloc-rename-gfp_mask-to-gfp.patch
mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask.patch
mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch
mm-mempolicy-rewrite-alloc_pages-documentation.patch
mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch
mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch
include-remove-pagemaph-from-blkdevh.patch


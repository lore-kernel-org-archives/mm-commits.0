Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4E8C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiLLCNz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiLLCNv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:13:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C629BC33
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:13:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CAAA60EC3
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E38C433D2;
        Mon, 12 Dec 2022 02:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811219;
        bh=7hKBGF1bgo9XiA78pwYMU/fkPJiLth3WnT+paLxTbYw=;
        h=Date:To:From:Subject:From;
        b=1qQ7YdNtSP860SECjG0DAKdORB5+g6m2PdFHcsdbiilACM/ue1XKmx3ozl0oTclzM
         vzNnWvKDOMPhvXgLk9MWIs4SMLiQJ7BIJ5b7NqT5c6k0u9mDKZHWsiGfzXpYHKpB+S
         mCLTI6GfbNbxQQkvGdXDI8rHuTwz+4PIonS4kWEs=
Date:   Sun, 11 Dec 2022 18:13:38 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pagewalk-add-walk_page_range_vma.patch removed from -mm tree
Message-Id: <20221212021339.64E38C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/pagewalk: add walk_page_range_vma()
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-add-walk_page_range_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/pagewalk: add walk_page_range_vma()
Date: Fri, 21 Oct 2022 12:11:39 +0200

Let's add walk_page_range_vma(), which is similar to walk_page_vma(),
however, is only interested in a subset of the VMA range.

To be used in KSM code to stop using follow_page() next.

Link: https://lkml.kernel.org/r/20221021101141.84170-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagewalk.h |    3 +++
 mm/pagewalk.c            |   20 ++++++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/include/linux/pagewalk.h~mm-pagewalk-add-walk_page_range_vma
+++ a/include/linux/pagewalk.h
@@ -101,6 +101,9 @@ int walk_page_range_novma(struct mm_stru
 			  unsigned long end, const struct mm_walk_ops *ops,
 			  pgd_t *pgd,
 			  void *private);
+int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
+			unsigned long end, const struct mm_walk_ops *ops,
+			void *private);
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		void *private);
 int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
--- a/mm/pagewalk.c~mm-pagewalk-add-walk_page_range_vma
+++ a/mm/pagewalk.c
@@ -517,6 +517,26 @@ int walk_page_range_novma(struct mm_stru
 	return walk_pgd_range(start, end, &walk);
 }
 
+int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
+			unsigned long end, const struct mm_walk_ops *ops,
+			void *private)
+{
+	struct mm_walk walk = {
+		.ops		= ops,
+		.mm		= vma->vm_mm,
+		.vma		= vma,
+		.private	= private,
+	};
+
+	if (start >= end || !walk.mm)
+		return -EINVAL;
+	if (start < vma->vm_start || end > vma->vm_end)
+		return -EINVAL;
+
+	mmap_assert_locked(walk.mm);
+	return __walk_page_range(start, end, &walk);
+}
+
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		void *private)
 {
_

Patches currently in -mm which might be from david@redhat.com are



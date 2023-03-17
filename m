Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B354C6FD1D
	for <mm-commits@archiver.kernel.org>; Fri, 17 Mar 2023 04:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjCQE2E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Mar 2023 00:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCQE2D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Mar 2023 00:28:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68C617CCC
        for <mm-commits@vger.kernel.org>; Thu, 16 Mar 2023 21:28:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79E7EB82426
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 04:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BFFC433D2;
        Fri, 17 Mar 2023 04:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679027279;
        bh=xI99wdnIGPNxg8doo8Oma3WPGem3lb6yN6/bpecScZs=;
        h=Date:To:From:Subject:From;
        b=eMOaTZ1tUYBsey/756uzP7DBA3Vb42Jthxjcz7iB9vKyz/3ISUXo/WA4lU0RjPW9Q
         GmHTgG0YNueuw2bckBJvJc/Q7gk0chm24AQ4XXQp9WY9ep3nf3KnNRrxAITraZOAnR
         t8wcLZfO21KG5gbjUTLbBDv1MxHpKQcJxewHnK2c=
Date:   Thu, 16 Mar 2023 21:27:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix.patch added to mm-unstable branch
Message-Id: <20230317042759.37BFFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix.

adjust comment as suggested by Lorenzo

Link: https://lkml.kernel.org/r/74f2ea6c-f1a9-6dd7-260c-25e660f42379@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix
+++ a/mm/mmap.c
@@ -755,8 +755,8 @@ int vma_shrink(struct vma_iterator *vmi,
 
 /*
  * If the vma has a ->close operation then the driver probably needs to release
- * per-vma resources, so we don't attempt to merge those in case the caller
- * indicates the current vma may be removed as part of the merge.
+ * per-vma resources, so we don't attempt to merge those if the caller indicates
+ * the current vma may be removed as part of the merge.
  */
 static inline bool is_mergeable_vma(struct vm_area_struct *vma,
 		struct file *file, unsigned long vm_flags,
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-reduce-page-alloc-free-sanity-checks.patch
mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3.patch
mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4.patch
mm-mmap-vma_merge-initialize-mid-and-next-in-natural-order.patch
mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch
mm-mmap-vma_merge-rename-adj_next-to-adj_start.patch
mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool.patch
mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch
mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix.patch
mm-mremap-simplify-vma-expansion-again.patch


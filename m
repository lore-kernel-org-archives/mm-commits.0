Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 648E0C76196
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 20:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjCOURl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 16:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbjCOURg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 16:17:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A08F1CBE8
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 13:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9A8261E61
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 20:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B769C433D2;
        Wed, 15 Mar 2023 20:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678911454;
        bh=Sll5ksADd6AZgTChnSLZDgmbn70RSGzNKiorEm3G84A=;
        h=Date:To:From:Subject:From;
        b=Rz6NPDv4MMA3CJ7GmH/i3Z3dunntpWREAjFeB5kz3m1Tae7tiEIXPyHduoiLpK6AE
         /ugonLLV9IKNcjf9OBHzpWqR+ZDveeUeF4y2bwmxjIaFC41I+OAAtYCpwFRKSAoiVF
         qi50POmjU9YeAPBSrw4V4LtDRSTpfUlCagV4rk0I=
Date:   Wed, 15 Mar 2023 13:17:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-simplify-vma-expansion-again.patch added to mm-unstable branch
Message-Id: <20230315201734.2B769C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: simplify vma expansion again
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-simplify-vma-expansion-again.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-simplify-vma-expansion-again.patch

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
Subject: mm/mremap: simplify vma expansion again
Date: Thu, 9 Mar 2023 12:12:58 +0100

This effectively reverts d014cd7c1c35 ("mm, mremap: fix mremap() expanding
for vma's with vm_ops->close()").  After the recent changes, vma_merge()
is able to handle the expansion properly even when the vma being expanded
has a vm_ops->close operation, so we don't need to special case it
anymore.

Link: https://lkml.kernel.org/r/20230309111258.24079-11-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/mm/mremap.c~mm-mremap-simplify-vma-expansion-again
+++ a/mm/mremap.c
@@ -1041,23 +1041,11 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			 * vma (expand operation itself) and possibly also with
 			 * the next vma if it becomes adjacent to the expanded
 			 * vma and  otherwise compatible.
-			 *
-			 * However, vma_merge() can currently fail due to
-			 * is_mergeable_vma() check for vm_ops->close (see the
-			 * comment there). Yet this should not prevent vma
-			 * expanding, so perform a simple expand for such vma.
-			 * Ideally the check for close op should be only done
-			 * when a vma would be actually removed due to a merge.
 			 */
-			if (!vma->vm_ops || !vma->vm_ops->close) {
-				vma = vma_merge(&vmi, mm, vma, extension_start,
-					extension_end, vma->vm_flags, vma->anon_vma,
-					vma->vm_file, extension_pgoff, vma_policy(vma),
-					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
-			} else if (vma_expand(&vmi, vma, vma->vm_start,
-					addr + new_len, vma->vm_pgoff, NULL)) {
-				vma = NULL;
-			}
+			vma = vma_merge(&vmi, mm, vma, extension_start,
+				extension_end, vma->vm_flags, vma->anon_vma,
+				vma->vm_file, extension_pgoff, vma_policy(vma),
+				vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 			if (!vma) {
 				vm_unacct_memory(pages);
 				ret = -ENOMEM;
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
mm-mremap-simplify-vma-expansion-again.patch


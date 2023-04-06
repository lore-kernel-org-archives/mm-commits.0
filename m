Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C50CC77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbjDFCp0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbjDFCpB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7517290
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4608264217
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06ABC433EF;
        Thu,  6 Apr 2023 02:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749099;
        bh=SISMDGA2pbVV5M1oG2ZJZ6VIPY6U1WEcPblqq6x+E0k=;
        h=Date:To:From:Subject:From;
        b=U1UfsmUzSjUQ8zEBI9ijdGCH1JgnprzKCnpNgnoyAv2kv+fsD3dGy1e14xQ/3g3yH
         FnKjtdCeYZLs68Dd3DBigz9kU0hr20KaToTuGNf5UyfPJxmzsqPG8Ekhc7zF/o3nx/
         +hPqUHdnCGBz2KZRuLQlLsId4Es3yVZC9Kdb20hM=
Date:   Wed, 05 Apr 2023 19:44:59 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-simplify-vma-expansion-again.patch removed from -mm tree
Message-Id: <20230406024459.A06ABC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mremap: simplify vma expansion again
has been removed from the -mm tree.  Its filename was
     mm-mremap-simplify-vma-expansion-again.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/mm/mremap.c~mm-mremap-simplify-vma-expansion-again
+++ a/mm/mremap.c
@@ -1040,23 +1040,11 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
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

mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch


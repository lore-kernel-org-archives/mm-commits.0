Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19DBC77B71
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbjDFCpU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbjDFCox (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C196187
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FD766429D
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D654EC433D2;
        Thu,  6 Apr 2023 02:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749091;
        bh=W6ww2Lw2P5cdGO2vb0jsIr3ClZ7ElFz7cs18tYvuySc=;
        h=Date:To:From:Subject:From;
        b=lcJ2uOM85SfuTebrLAkuLo3d33UeBW6cO3ykyj4qSBqz6lZynuGzIEw1merSAN8wX
         wxCmVjHZk4SvLUXehnIfFWMDTTFMFRrwVwag57/zXzIBycPcgzLya88GTiAFGwmWEk
         uMQvY15YaqTmXReoMGKVMGY+Zu0WAFKC/fpu9f0c=
Date:   Wed, 05 Apr 2023 19:44:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4.patch removed from -mm tree
Message-Id: <20230406024451.D654EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap/vma_merge: use the proper vma pointer in case 4
has been removed from the -mm tree.  Its filename was
     mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mmap/vma_merge: use the proper vma pointer in case 4
Date: Thu, 9 Mar 2023 12:12:52 +0100

Almost all cases now use the 'next' pointer for the vma following the
merged area, and the cases diagram shows it as XXXX.  Case 4 is different
as it uses 'mid' and NNNN, so change it for consistency.  No functional
change.

Link: https://lkml.kernel.org/r/20230309111258.24079-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4
+++ a/mm/mmap.c
@@ -851,9 +851,9 @@ can_vma_merge_after(struct vm_area_struc
  * vma, PPPPPP is the prev vma specified, and NNNNNN the next vma after:
  *
  *     AAAA             AAAA                   AAAA
- *    PPPPPPNNNNNN    PPPPPPNNNNNN       PPPPPPNNNNNN
+ *    PPPPPPNNNNNN    PPPPPPXXXXXX       PPPPPPNNNNNN
  *    cannot merge    might become       might become
- *                    PPNNNNNNNNNN       PPPPPPPPPPNN
+ *                    PPXXXXXXXXXX       PPPPPPPPPPNN
  *    mmap, brk or    case 4 below       case 5 below
  *    mremap move:
  *                        AAAA               AAAA
@@ -972,9 +972,9 @@ struct vm_area_struct *vma_merge(struct
 		res = next;
 		if (prev && addr < prev->vm_end) {	/* case 4 */
 			vma_end = addr;
-			adjust = mid;
+			adjust = next;
 			adj_next = -(prev->vm_end - addr);
-			err = dup_anon_vma(mid, prev);
+			err = dup_anon_vma(next, prev);
 		} else {
 			vma = next;			/* case 3 */
 			vma_start = addr;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch


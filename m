Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D6AC1B0D8
	for <mm-commits@archiver.kernel.org>; Sun,  6 Dec 2020 06:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61D3522D2C
	for <mm-commits@archiver.kernel.org>; Sun,  6 Dec 2020 06:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgLFGQI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Dec 2020 01:16:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgLFGQH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 6 Dec 2020 01:16:07 -0500
Date:   Sat, 05 Dec 2020 22:15:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607235316;
        bh=S5T9snE/qxxRE5C1ixuUvr1S8OmU5pS8Mg83NSxZzqc=;
        h=From:To:Subject:In-Reply-To:From;
        b=Lf+c5c0GmFMmyKo2VB4QmT0Kr1mRczVdgisFsG01yR7xYei+d42HyiURngj4CJGQp
         w5RnEiJRf7HnAzOcN9DZEmMwf0jkYT5rN+H9kNVusYDHTLe5iPKsuHBk8qjmfDop2y
         DXCKXbIvGOH10Sk63spwKwwcOV34ZEFAv7wGTuQ8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, hushiyuan@huawei.com,
        jgg@nvidia.com, linmiaohe@huawei.com, linux-mm@kvack.org,
        liuzixian4@huawei.com, louhongxiang@huawei.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 12/12] mm/mmap.c: fix mmap return value when vma
 is merged after call_mmap()
Message-ID: <20201206061515.sa2v5S_CL%akpm@linux-foundation.org>
In-Reply-To: <20201205221412.67f14b9b3a5ef531c76dd452@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liu Zixian <liuzixian4@huawei.com>
Subject: mm/mmap.c: fix mmap return value when vma is merged after call_mmap()

On success, mmap should return the begin address of newly mapped area, but
patch "mm: mmap: merge vma after call_mmap() if possible" set vm_start of
newly merged vma to return value addr.  Users of mmap will get wrong
address if vma is merged after call_mmap().  We fix this by moving the
assignment to addr before merging vma.

We have a driver which changes vm_flags, and this bug is found by our
testcases.

Link: https://lkml.kernel.org/r/20201203085350.22624-1-liuzixian4@huawei.com
Fixes: d70cec898324 ("mm: mmap: merge vma after call_mmap() if possible")
Signed-off-by: Liu Zixian <liuzixian4@huawei.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hongxiang Lou <louhongxiang@huawei.com>
Cc: Hu Shiyuan <hushiyuan@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/mm/mmap.c~fix-mmap-return-value-when-vma-is-merged-after-call_mmap
+++ a/mm/mmap.c
@@ -1808,6 +1808,17 @@ unsigned long mmap_region(struct file *f
 		if (error)
 			goto unmap_and_free_vma;
 
+		/* Can addr have changed??
+		 *
+		 * Answer: Yes, several device drivers can do it in their
+		 *         f_op->mmap method. -DaveM
+		 * Bug: If addr is changed, prev, rb_link, rb_parent should
+		 *      be updated for vma_link()
+		 */
+		WARN_ON_ONCE(addr != vma->vm_start);
+
+		addr = vma->vm_start;
+
 		/* If vm_flags changed after call_mmap(), we should try merge vma again
 		 * as we may succeed this time.
 		 */
@@ -1822,25 +1833,12 @@ unsigned long mmap_region(struct file *f
 				fput(vma->vm_file);
 				vm_area_free(vma);
 				vma = merge;
-				/* Update vm_flags and possible addr to pick up the change. We don't
-				 * warn here if addr changed as the vma is not linked by vma_link().
-				 */
-				addr = vma->vm_start;
+				/* Update vm_flags to pick up the change. */
 				vm_flags = vma->vm_flags;
 				goto unmap_writable;
 			}
 		}
 
-		/* Can addr have changed??
-		 *
-		 * Answer: Yes, several device drivers can do it in their
-		 *         f_op->mmap method. -DaveM
-		 * Bug: If addr is changed, prev, rb_link, rb_parent should
-		 *      be updated for vma_link()
-		 */
-		WARN_ON_ONCE(addr != vma->vm_start);
-
-		addr = vma->vm_start;
 		vm_flags = vma->vm_flags;
 	} else if (vm_flags & VM_SHARED) {
 		error = shmem_zero_setup(vma);
_

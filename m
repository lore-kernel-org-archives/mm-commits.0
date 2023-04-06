Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF72AC77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbjDFCgo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbjDFCgj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:36:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187EC5FDB
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:36:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A102064227
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0695DC433EF;
        Thu,  6 Apr 2023 02:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680748598;
        bh=0jyf8Eo54hWBNm1a+QSsRxwoGndHWYUnKRALEX0Ay+0=;
        h=Date:To:From:Subject:From;
        b=Km+za/zJaVhcqfEDvJAHbkH90XQtVKj1K98sXGodlzK9MEwnAiYaSC4ACWw9sSKEE
         0/EXvJ899f04Y70twfGGnMUtDEh+Azxl11mxcABHojJKBzVuWowvR5nSsuRv2d0v9E
         f+KeFnHVAG+zWGuGyfxMO4UkLYbMjXAmCzMeYNWE=
Date:   Wed, 05 Apr 2023 19:36:37 -0700
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-convert-vread-to-vread_iter-v8.patch removed from -mm tree
Message-Id: <20230406023638.0695DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-vmalloc-convert-vread-to-vread_iter-v8
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-convert-vread-to-vread_iter-v8.patch

This patch was dropped because it was folded into mm-vmalloc-convert-vread-to-vread_iter.patch

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm-vmalloc-convert-vread-to-vread_iter-v8
Date: Thu, 23 Mar 2023 10:15:19 +0000

redo Stephen's sparc build fix

Link: https://lkml.kernel.org/r/8506cbc667c39205e65a323f750ff9c11a463798.1679566220.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    2 +-
 mm/vmalloc.c            |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-convert-vread-to-vread_iter-v8
+++ a/include/linux/vmalloc.h
@@ -9,12 +9,12 @@
 #include <asm/page.h>		/* pgprot_t */
 #include <linux/rbtree.h>
 #include <linux/overflow.h>
+#include <linux/uio.h>
 
 #include <asm/vmalloc.h>
 
 struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 struct notifier_block;		/* in notifier.h */
-struct iov_iter;		/* in uio.h */
 
 /* bits in flags of vmalloc's vm_struct below */
 #define VM_IOREMAP		0x00000001	/* ioremap() and friends */
--- a/mm/vmalloc.c~mm-vmalloc-convert-vread-to-vread_iter-v8
+++ a/mm/vmalloc.c
@@ -33,7 +33,6 @@
 #include <linux/compiler.h>
 #include <linux/memcontrol.h>
 #include <linux/llist.h>
-#include <linux/uio.h>
 #include <linux/bitops.h>
 #include <linux/rbtree_augmented.h>
 #include <linux/overflow.h>
@@ -3448,7 +3447,7 @@ EXPORT_SYMBOL(vmalloc_32_user);
  *
  * Returns the number of zeroed bytes.
  */
-size_t zero_iter(struct iov_iter *iter, size_t count)
+static size_t zero_iter(struct iov_iter *iter, size_t count)
 {
 	size_t remains = count;
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-refactor-do_fault_around.patch
mm-pefer-fault_around_pages-to-fault_around_bytes.patch
maintainers-add-myself-as-vmalloc-reviewer.patch
mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch
fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch
fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch
iov_iter-add-copy_page_to_iter_nofault.patch
mm-vmalloc-convert-vread-to-vread_iter.patch
mm-mmap-vma_merge-further-improve-prev-next-vma-naming.patch
mm-mmap-vma_merge-fold-curr-next-assignment-logic.patch
mm-mmap-vma_merge-explicitly-assign-res-vma-extend-invariants.patch
mm-mmap-vma_merge-init-cleanup-be-explicit-about-the-non-mergeable-case.patch


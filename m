Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B49C433DB
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 17:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BB0A64E45
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 17:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhBHRYh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Feb 2021 12:24:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:35840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234893AbhBHRXT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Feb 2021 12:23:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B081A64E6E;
        Mon,  8 Feb 2021 17:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612804849;
        bh=8l0fJtEYie+CjNPjSsOCrmRUM62MsJXi9RAxA1l54xA=;
        h=Date:From:To:Subject:From;
        b=SPpkL8dyLDo/gPqM3xOKinwTszstMJv8+KhCY2DY17FNxRhG5H+WqJTwxR6V5X8KK
         mKAj9huXC9G2ktcAaYnGJyTEILM3moFl4p7LQKgq8XmF+tZ0KW4NK7X6vzmKkdlTEx
         bCLPug93pQEWbB5kxmbwgMX0MTKLh3bbRnxHDaTU=
Date:   Mon, 08 Feb 2021 09:20:48 -0800
From:   akpm@linux-foundation.org
To:     dja@axtens.net, hch@lst.de, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, rick.p.edgecombe@intel.com,
        stable@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-vmalloc-separate-put-pages-and-flush-vm-flags.patch removed from -mm
 tree
Message-ID: <20210208172048.v9fS2xjms%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: separate put pages and flush VM flags
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-separate-put-pages-and-flush-vm-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: mm/vmalloc: separate put pages and flush VM flags

When VM_MAP_PUT_PAGES was added, it was defined with the same value as
VM_FLUSH_RESET_PERMS.  This doesn't seem like it will cause any big
functional problems other than some excess flushing for VM_MAP_PUT_PAGES
allocations.

Redefine VM_MAP_PUT_PAGES to have its own value.  Also, rearrange things
so flags are less likely to be missed in the future.

Link: https://lkml.kernel.org/r/20210122233706.9304-1-rick.p.edgecombe@intel.com
Fixes: b944afc9d64d ("mm: add a VM_MAP_PUT_PAGES flag for vmap")
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Axtens <dja@axtens.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-separate-put-pages-and-flush-vm-flags
+++ a/include/linux/vmalloc.h
@@ -24,7 +24,8 @@ struct notifier_block;		/* in notifier.h
 #define VM_UNINITIALIZED	0x00000020	/* vm_struct is not fully initialized */
 #define VM_NO_GUARD		0x00000040      /* don't add guard page */
 #define VM_KASAN		0x00000080      /* has allocated kasan shadow memory */
-#define VM_MAP_PUT_PAGES	0x00000100	/* put pages and free array in vfree */
+#define VM_FLUSH_RESET_PERMS	0x00000100	/* reset direct map and flush TLB on unmap, can't be freed in atomic context */
+#define VM_MAP_PUT_PAGES	0x00000200	/* put pages and free array in vfree */
 
 /*
  * VM_KASAN is used slighly differently depending on CONFIG_KASAN_VMALLOC.
@@ -37,12 +38,6 @@ struct notifier_block;		/* in notifier.h
  * determine which allocations need the module shadow freed.
  */
 
-/*
- * Memory with VM_FLUSH_RESET_PERMS cannot be freed in an interrupt or with
- * vfree_atomic().
- */
-#define VM_FLUSH_RESET_PERMS	0x00000100      /* Reset direct map and flush TLB on unmap */
-
 /* bits [20..32] reserved for arch specific ioremap internals */
 
 /*
_

Patches currently in -mm which might be from rick.p.edgecombe@intel.com are



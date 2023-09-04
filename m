Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358D0C83F3E
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 19:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjIDTyC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 15:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjIDTyC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 15:54:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1C6E8
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 12:53:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B967BCE0ECA
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 19:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085B1C433C8;
        Mon,  4 Sep 2023 19:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693857229;
        bh=FFYGYYc+Dgeq5tjztXh8lhmZvEFRCrqkST4RlLbpTqs=;
        h=Date:To:From:Subject:From;
        b=bYK/o7qIszADUUzXXdaz0RmNCu1ubNCFqvQ+iDD2K5n9JaR/11NWCW4P6wHbMJ19T
         gpkkaWdKIQrQbpZvsbfXMouZLJioDprzS478WHauM6sikbb5J4XPBJrH6cJiLRxKtE
         8lP3dsZgiAl8NIqXuCxb1zxSpMsrpepCGdFAGG/8=
Date:   Mon, 04 Sep 2023 12:53:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        paulmck@kernel.org, oleksiy.avramchenko@sony.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com,
        joel@joelfernandes.org, hch@lst.de, david@fromorbit.com,
        bhe@redhat.com, urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-add-va_alloc-helper.patch added to mm-unstable branch
Message-Id: <20230904195349.085B1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: add va_alloc() helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-add-va_alloc-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-add-va_alloc-helper.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: add va_alloc() helper
Date: Tue, 29 Aug 2023 10:11:34 +0200

Patch series "Mitigate a vmap lock contention", v2.

Test on AMD Ryzen Threadripper 3970X 32-Core Processor: sudo
./test_vmalloc.sh run_test_mask=127 nr_threads=64

<v6.5-rc6 perf>
  94.17%     0.90%  [kernel]    [k] _raw_spin_lock
  93.27%    93.05%  [kernel]    [k] native_queued_spin_lock_slowpath
  74.69%     0.25%  [kernel]    [k] __vmalloc_node_range
  72.64%     0.01%  [kernel]    [k] __get_vm_area_node
  72.04%     0.89%  [kernel]    [k] alloc_vmap_area
  42.17%     0.00%  [kernel]    [k] vmalloc
  32.53%     0.00%  [kernel]    [k] __vmalloc_node
  24.91%     0.25%  [kernel]    [k] vfree
  24.32%     0.01%  [kernel]    [k] remove_vm_area
  22.63%     0.21%  [kernel]    [k] find_unlink_vmap_area
  15.51%     0.00%  [unknown]   [k] 0xffffffffc09a74ac
  14.35%     0.00%  [kernel]    [k] ret_from_fork_asm
  14.35%     0.00%  [kernel]    [k] ret_from_fork
  14.35%     0.00%  [kernel]    [k] kthread
<v6.5-rc6 perf>
   vs
<v6.5-rc6+v2 perf>
  74.32%     2.42%  [kernel]    [k] __vmalloc_node_range
  69.58%     0.01%  [kernel]    [k] vmalloc
  54.21%     1.17%  [kernel]    [k] __alloc_pages_bulk
  48.13%    47.91%  [kernel]    [k] clear_page_orig
  43.60%     0.01%  [unknown]   [k] 0xffffffffc082f16f
  32.06%     0.00%  [kernel]    [k] ret_from_fork_asm
  32.06%     0.00%  [kernel]    [k] ret_from_fork
  32.06%     0.00%  [kernel]    [k] kthread
  31.30%     0.00%  [unknown]   [k] 0xffffffffc082f889
  22.98%     4.16%  [kernel]    [k] vfree
  14.36%     0.28%  [kernel]    [k] __get_vm_area_node
  13.43%     3.35%  [kernel]    [k] alloc_vmap_area
  10.86%     0.04%  [kernel]    [k] remove_vm_area
   8.89%     2.75%  [kernel]    [k] _raw_spin_lock
   7.19%     0.00%  [unknown]   [k] 0xffffffffc082fba3
   6.65%     1.37%  [kernel]    [k] free_unref_page
   6.13%     6.11%  [kernel]    [k] native_queued_spin_lock_slowpath
<v6.5-rc6+v2 perf>

On smaller systems, for example, 8xCPU Hikey960 board the contention is
not that high and is approximately ~16 percent.


This patch (of 9):

Currently __alloc_vmap_area() function contains an open codded logic that
finds and adjusts a VA based on allocation request.

Introduce a va_alloc() helper that adjusts found VA only.  It will be used
later at least in two places.

There is no a functional change as a result of this patch.

Link: https://lkml.kernel.org/r/20230829081142.3619-1-urezki@gmail.com
Link: https://lkml.kernel.org/r/20230829081142.3619-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-va_alloc-helper
+++ a/mm/vmalloc.c
@@ -1481,6 +1481,32 @@ adjust_va_to_fit_type(struct rb_root *ro
 	return 0;
 }
 
+static unsigned long
+va_alloc(struct vmap_area *va,
+		struct rb_root *root, struct list_head *head,
+		unsigned long size, unsigned long align,
+		unsigned long vstart, unsigned long vend)
+{
+	unsigned long nva_start_addr;
+	int ret;
+
+	if (va->va_start > vstart)
+		nva_start_addr = ALIGN(va->va_start, align);
+	else
+		nva_start_addr = ALIGN(vstart, align);
+
+	/* Check the "vend" restriction. */
+	if (nva_start_addr + size > vend)
+		return vend;
+
+	/* Update the free vmap_area. */
+	ret = adjust_va_to_fit_type(root, head, va, nva_start_addr, size);
+	if (WARN_ON_ONCE(ret))
+		return vend;
+
+	return nva_start_addr;
+}
+
 /*
  * Returns a start address of the newly allocated area, if success.
  * Otherwise a vend is returned that indicates failure.
@@ -1493,7 +1519,6 @@ __alloc_vmap_area(struct rb_root *root,
 	bool adjust_search_size = true;
 	unsigned long nva_start_addr;
 	struct vmap_area *va;
-	int ret;
 
 	/*
 	 * Do not adjust when:
@@ -1511,18 +1536,8 @@ __alloc_vmap_area(struct rb_root *root,
 	if (unlikely(!va))
 		return vend;
 
-	if (va->va_start > vstart)
-		nva_start_addr = ALIGN(va->va_start, align);
-	else
-		nva_start_addr = ALIGN(vstart, align);
-
-	/* Check the "vend" restriction. */
-	if (nva_start_addr + size > vend)
-		return vend;
-
-	/* Update the free vmap_area. */
-	ret = adjust_va_to_fit_type(root, head, va, nva_start_addr, size);
-	if (WARN_ON_ONCE(ret))
+	nva_start_addr = va_alloc(va, root, head, size, align, vstart, vend);
+	if (nva_start_addr == vend)
 		return vend;
 
 #if DEBUG_AUGMENT_LOWEST_MATCH_CHECK
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-node_size-based-on-cpu-cores.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6D3C6FA8A
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiIKXXP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiIKXXH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:23:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5990524F3A
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:23:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F00BCB80BAB
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FF0C433D6;
        Sun, 11 Sep 2022 23:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662938584;
        bh=G+r1Nd4c3CIXTkrO5wR2WS5RHuV8lEh0MrYCjaY+ysE=;
        h=Date:To:From:Subject:From;
        b=q/r3/Zx6EdKyZAgvTKQIrq28+v4dY3Nm7Z1MPGjOrQY7PYT4+Ls8yNfgz9jCQVCxb
         Lif2R5FFY0TXx051CZOLAX6T8xz7bFcXxESXRRv+dLU8hz+4VPU3w5VBrzTVvt9qXZ
         YrBZF08OB0zpzrWLdoI2OoNtoK9zvKj3QiUiZ3Yg=
Date:   Sun, 11 Sep 2022 16:23:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, ruansy.fnst@fujitsu.com,
        riteshh@linux.ibm.com, rgoldwyn@suse.de, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, hch@lst.de,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-failure-fall-back-to-vma_address-when-notify_failure-fails.patch removed from -mm tree
Message-Id: <20220911232304.A3FF0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure: fall back to vma_address() when ->notify_failure() fails
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fall-back-to-vma_address-when-notify_failure-fails.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm/memory-failure: fall back to vma_address() when ->notify_failure() fails
Date: Fri, 26 Aug 2022 10:18:14 -0700

In the case where a filesystem is polled to take over the memory failure
and receives -EOPNOTSUPP it indicates that page->index and page->mapping
are valid for reverse mapping the failure address.  Introduce
FSDAX_INVALID_PGOFF to distinguish when add_to_kill() is being called from
mf_dax_kill_procs() by a filesytem vs the typical memory_failure() path.

Otherwise, vma_pgoff_address() is called with an invalid fsdax_pgoff which
then trips this failing signature:

 kernel BUG at mm/memory-failure.c:319!
 invalid opcode: 0000 [#1] PREEMPT SMP PTI
 CPU: 13 PID: 1262 Comm: dax-pmd Tainted: G           OE    N 6.0.0-rc2+ #62
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
 RIP: 0010:add_to_kill.cold+0x19d/0x209
 [..]
 Call Trace:
  <TASK>
  collect_procs.part.0+0x2c4/0x460
  memory_failure+0x71b/0xba0
  ? _printk+0x58/0x73
  do_madvise.part.0.cold+0xaf/0xc5

Link: https://lkml.kernel.org/r/166153429427.2758201.14605968329933175594.stgit@dwillia2-xfh.jf.intel.com
Fixes: c36e20249571 ("mm: introduce mf_dax_kill_procs() for fsdax case")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fall-back-to-vma_address-when-notify_failure-fails
+++ a/mm/memory-failure.c
@@ -345,13 +345,17 @@ static unsigned long dev_pagemap_mapping
  * not much we can do.	We just print a message and ignore otherwise.
  */
 
+#define FSDAX_INVALID_PGOFF ULONG_MAX
+
 /*
  * Schedule a process for later kill.
  * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
  *
- * Notice: @fsdax_pgoff is used only when @p is a fsdax page.
- *   In other cases, such as anonymous and file-backend page, the address to be
- *   killed can be caculated by @p itself.
+ * Note: @fsdax_pgoff is used only when @p is a fsdax page and a
+ * filesystem with a memory failure handler has claimed the
+ * memory_failure event. In all other cases, page->index and
+ * page->mapping are sufficient for mapping the page back to its
+ * corresponding user virtual address.
  */
 static void add_to_kill(struct task_struct *tsk, struct page *p,
 			pgoff_t fsdax_pgoff, struct vm_area_struct *vma,
@@ -367,11 +371,7 @@ static void add_to_kill(struct task_stru
 
 	tk->addr = page_address_in_vma(p, vma);
 	if (is_zone_device_page(p)) {
-		/*
-		 * Since page->mapping is not used for fsdax, we need
-		 * calculate the address based on the vma.
-		 */
-		if (p->pgmap->type == MEMORY_DEVICE_FS_DAX)
+		if (fsdax_pgoff != FSDAX_INVALID_PGOFF)
 			tk->addr = vma_pgoff_address(fsdax_pgoff, 1, vma);
 		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
 	} else
@@ -523,7 +523,8 @@ static void collect_procs_anon(struct pa
 			if (!page_mapped_in_vma(page, vma))
 				continue;
 			if (vma->vm_mm == t->mm)
-				add_to_kill(t, page, 0, vma, to_kill);
+				add_to_kill(t, page, FSDAX_INVALID_PGOFF, vma,
+					    to_kill);
 		}
 	}
 	read_unlock(&tasklist_lock);
@@ -559,7 +560,8 @@ static void collect_procs_file(struct pa
 			 * to be informed of all such data corruptions.
 			 */
 			if (vma->vm_mm == t->mm)
-				add_to_kill(t, page, 0, vma, to_kill);
+				add_to_kill(t, page, FSDAX_INVALID_PGOFF, vma,
+					    to_kill);
 		}
 	}
 	read_unlock(&tasklist_lock);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are



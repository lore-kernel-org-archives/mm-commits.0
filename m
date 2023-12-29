Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84F612B99;
	Fri, 29 Dec 2023 19:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tZMy91R4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CB4C433C8;
	Fri, 29 Dec 2023 19:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703876845;
	bh=VeNqkKpc0NYluTw50JCX3V29xXFVmRyhiDDu1enAJdA=;
	h=Date:To:From:Subject:From;
	b=tZMy91R4eWbSNLrk9zgZFRz3RvR9JG/MEcM9Jvnxide0CnNQNVQxvuNNRCgFgvwYl
	 oqXXxtfxgPlOoXUa8hn7ElkmrtmO8qW3P+LuGkjW+8F4bZ7XtESW0e5tjMOGnXrgoz
	 gTbyTdhb8PXiBEvMM3n2hXp/lDwYpVjAzYT31ZCY=
Date: Fri, 29 Dec 2023 11:07:25 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jiajun.xie.sh@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-unmap_mapping_range-high-bits-shift-bug.patch removed from -mm tree
Message-Id: <20231229190725.A2CB4C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix unmap_mapping_range high bits shift bug
has been removed from the -mm tree.  Its filename was
     mm-fix-unmap_mapping_range-high-bits-shift-bug.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiajun Xie <jiajun.xie.sh@gmail.com>
Subject: mm: fix unmap_mapping_range high bits shift bug
Date: Wed, 20 Dec 2023 13:28:39 +0800

The bug happens when highest bit of holebegin is 1, suppose holebegin is
0x8000000111111000, after shift, hba would be 0xfff8000000111111, then
vma_interval_tree_foreach would look it up fail or leads to the wrong
result.

error call seq e.g.:
- mmap(..., offset=0x8000000111111000)
  |- syscall(mmap, ... unsigned long, off):
     |- ksys_mmap_pgoff( ... , off >> PAGE_SHIFT);

  here pgoff is correctly shifted to 0x8000000111111,
  but pass 0x8000000111111000 as holebegin to unmap
  would then cause terrible result, as shown below:

- unmap_mapping_range(..., loff_t const holebegin)
  |- pgoff_t hba = holebegin >> PAGE_SHIFT;
          /* hba = 0xfff8000000111111 unexpectedly */

The issue happens in Heterogeneous computing, where the device(e.g. 
gpu) and host share the same virtual address space.

A simple workflow pattern which hit the issue is:
        /* host */
    1. userspace first mmap a file backed VA range with specified offset.
                        e.g. (offset=0x800..., mmap return: va_a)
    2. write some data to the corresponding sys page
                         e.g. (va_a = 0xAABB)
        /* device */
    3. gpu workload touches VA, triggers gpu fault and notify the host.
        /* host */
    4. reviced gpu fault notification, then it will:
            4.1 unmap host pages and also takes care of cpu tlb
                  (use unmap_mapping_range with offset=0x800...)
            4.2 migrate sys page to device
            4.3 setup device page table and resolve device fault.
        /* device */
    5. gpu workload continued, it accessed va_a and got 0xAABB.
    6. gpu workload continued, it wrote 0xBBCC to va_a.
        /* host */
    7. userspace access va_a, as expected, it will:
            7.1 trigger cpu vm fault.
            7.2 driver handling fault to migrate gpu local page to host.
    8. userspace then could correctly get 0xBBCC from va_a
    9. done

But in step 4.1, if we hit the bug this patch mentioned, then userspace
would never trigger cpu fault, and still get the old value: 0xAABB.

Making holebegin unsigned first fixes the bug.

Link: https://lkml.kernel.org/r/20231220052839.26970-1-jiajun.xie.sh@gmail.com
Signed-off-by: Jiajun Xie <jiajun.xie.sh@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-fix-unmap_mapping_range-high-bits-shift-bug
+++ a/mm/memory.c
@@ -3624,8 +3624,8 @@ EXPORT_SYMBOL_GPL(unmap_mapping_pages);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows)
 {
-	pgoff_t hba = holebegin >> PAGE_SHIFT;
-	pgoff_t hlen = (holelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	pgoff_t hba = (pgoff_t)(holebegin) >> PAGE_SHIFT;
+	pgoff_t hlen = ((pgoff_t)(holelen) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	/* Check for overflow. */
 	if (sizeof(holelen) > sizeof(hlen)) {
_

Patches currently in -mm which might be from jiajun.xie.sh@gmail.com are



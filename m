Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD687482C5
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 17:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oVycDVXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A02C433CB;
	Wed, 20 Dec 2023 17:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703095001;
	bh=lZ0P/v65juZ4LnkJzDFQ7rHZ4bpuDxkfeLlN+56213k=;
	h=Date:To:From:Subject:From;
	b=oVycDVXMWUxuvyjvGxK6hFrqwdvK5UF8cDMkcgN07cxAYfnLqqUqofPnwhc78OWCK
	 +MKCkvAjKnLvSQMVgLYlpyb6Xkkn7SK4tZu6yh8S7bAP1xTzHJR2er68vE4Vkv9ijh
	 DQ2zf98R3DJHDEaUEpmYK2BixPQDZmZmYcjFbqEA=
Date: Wed, 20 Dec 2023 09:56:40 -0800
To: mm-commits@vger.kernel.org,jiajun.xie.sh@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-unmap_mapping_range-high-bits-shift-bug.patch added to mm-hotfixes-unstable branch
Message-Id: <20231220175641.25A02C433CB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix unmap_mapping_range high bits shift bug
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-unmap_mapping_range-high-bits-shift-bug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-unmap_mapping_range-high-bits-shift-bug.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

Turn holebegin to unsigned first fixes the bug.

Link: https://lkml.kernel.org/r/20231220052839.26970-1-jiajun.xie.sh@gmail.com
Signed-off-by: Jiajun Xie <jiajun.xie.sh@gmail.com>
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

mm-fix-unmap_mapping_range-high-bits-shift-bug.patch


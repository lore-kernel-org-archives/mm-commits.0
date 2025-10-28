Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25C926F45A;
	Tue, 28 Oct 2025 20:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761682725; cv=none; b=MIYy4JTCJrXSRNBk+7hcNgcl3ISJfIn6323Ed7JM2g0jwi/hCQVsPxBUWSB2Kubin0wjnOYwZRKL8iEbuix058JpL+oC6hWYE91Uo63zeD1B+OG53arfcAL1uvhHw1Z5j5MYVwIEOcGURz4Zjz2BAn6A6STpoc6d+c2cY9aTcXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761682725; c=relaxed/simple;
	bh=G/DeR1+OI+6jQSknYH0IpEvj4EMs9GoX5ZRaBksYlk8=;
	h=Date:To:From:Subject:Message-Id; b=lIxmR+/xeZCmCyE0RUU6FxnFkwrJP6VgYDWgDljSMIanqQ+yUnp/CPJXqpyScwWr9WA+CaXc2Vay5oq5BLJu3nbu3TK9f8J1b8p6c/UzDAc1k8mW1TZN21yrpca8m23mbLoU8+ihEP2dbyM6hfYOodOG9zoYUa6LXvoR4mEvyZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gLu3E/09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gLu3E/09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EEBC4CEE7;
	Tue, 28 Oct 2025 20:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761682724;
	bh=G/DeR1+OI+6jQSknYH0IpEvj4EMs9GoX5ZRaBksYlk8=;
	h=Date:To:From:Subject:From;
	b=gLu3E/09jOhA40SrRJb8b1RG+IN06fUaTrFKyf+OncDFsL3bxxvrZW/xoknRk3ogH
	 BqqgDi5Mj2tmNzhe0yoyCwQbc0AE2WAffF+QXi11gEFVAm5IPE3zB82HlzgjPGEjDF
	 J91x+eLa36GXZYT8T8wuemO/tFH67F+XiZLsGgr4=
Date: Tue, 28 Oct 2025 13:18:49 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,isaacmanjarres@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-fix-hash-table-order-logging-in-alloc_large_system_hash.patch added to mm-hotfixes-unstable branch
Message-Id: <20251028201844.D4EEBC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: fix hash table order logging in alloc_large_system_hash()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mm_init-fix-hash-table-order-logging-in-alloc_large_system_hash.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-fix-hash-table-order-logging-in-alloc_large_system_hash.patch

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
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: mm/mm_init: fix hash table order logging in alloc_large_system_hash()
Date: Tue, 28 Oct 2025 12:10:12 -0700

When emitting the order of the allocation for a hash table,
alloc_large_system_hash() unconditionally subtracts PAGE_SHIFT from log
base 2 of the allocation size.  This is not correct if the allocation size
is smaller than a page, and yields a negative value for the order as seen
below:

TCP established hash table entries: 32 (order: -4, 256 bytes, linear) TCP
bind hash table entries: 32 (order: -2, 1024 bytes, linear)

Use get_order() to compute the order when emitting the hash table
information to correctly handle cases where the allocation size is smaller
than a page:

TCP established hash table entries: 32 (order: 0, 256 bytes, linear) TCP
bind hash table entries: 32 (order: 0, 1024 bytes, linear)

Link: https://lkml.kernel.org/r/20251028191020.413002-1-isaacmanjarres@google.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_init-fix-hash-table-order-logging-in-alloc_large_system_hash
+++ a/mm/mm_init.c
@@ -2469,7 +2469,7 @@ void *__init alloc_large_system_hash(con
 		panic("Failed to allocate %s hash table\n", tablename);
 
 	pr_info("%s hash table entries: %ld (order: %d, %lu bytes, %s)\n",
-		tablename, 1UL << log2qty, ilog2(size) - PAGE_SHIFT, size,
+		tablename, 1UL << log2qty, get_order(size), size,
 		virt ? (huge ? "vmalloc hugepage" : "vmalloc") : "linear");
 
 	if (_hash_shift)
_

Patches currently in -mm which might be from isaacmanjarres@google.com are

mm-mm_init-fix-hash-table-order-logging-in-alloc_large_system_hash.patch


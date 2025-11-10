Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09622D77E2;
	Mon, 10 Nov 2025 05:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752027; cv=none; b=sEtQtwysBMGgsZNqBjjITNxEX43rZrof6/UldjyMsGG7SlyvEL1vTYxpGlt76PB4xhC7L3vC5PKImQpJ79rLGdklIFHzYRd4bIGn4QIi2z8DmslTtwARPFgPkiTWVHWQpEBRNTGGXdcINmvx2aYJui+RTfoLvXFvsyvt4vQh4zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752027; c=relaxed/simple;
	bh=tRmDNEe95J00oECXbDdgGYqzjh9DrZSzS/WVd884pfs=;
	h=Date:To:From:Subject:Message-Id; b=IRfGJuR9zFtXSunOe1zpgv91jiBdAmyTHzb4d+PvL6FmZxkWfBX4kRr4spUu3ImjZOhmSGvLOBilsPYfeCtsRDrTV+XfReDwSLtpT9xXEPBu6+4tLldbQawxXFaDx1zVNXO2IygMs/UK7BcRZY77kuJLgGXN2LEPHSXiaJ5nYGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2VAvaXFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2VAvaXFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6986BC19425;
	Mon, 10 Nov 2025 05:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752027;
	bh=tRmDNEe95J00oECXbDdgGYqzjh9DrZSzS/WVd884pfs=;
	h=Date:To:From:Subject:From;
	b=2VAvaXFNE8tF7VEYDj5W8maSsP++0k5oP9Pq6aJdJFmx94QERebTAUjY39Yj1Pa3g
	 rY4cvOtXvMN6B2fwPR4HnpuQltyo5ocCOY8cx1OEL+ZpIx8Q/tlsKd2jN49xI3Yd9v
	 vuA7gkMVtAK51AHMsAppCxwpo7ERbkYm/f5EtvyE=
Date: Sun, 09 Nov 2025 21:20:26 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,david@redhat.com,isaacmanjarres@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mm_init-fix-hash-table-order-logging-in-alloc_large_system_hash.patch removed from -mm tree
Message-Id: <20251110052027.6986BC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: fix hash table order logging in alloc_large_system_hash()
has been removed from the -mm tree.  Its filename was
     mm-mm_init-fix-hash-table-order-logging-in-alloc_large_system_hash.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
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



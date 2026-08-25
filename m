Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ECC33DEFD
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622805; cv=none; b=GRZEB7Je8pg/lfSn0Iy/QBbtedb3HxxIo8TPWVK2DRDaWP21JImXz0JMs387YAZdqXsJgiaZrHiZ4MkraF9oqQrx9pVx5ayKcjJrdKKyEro9f2xcgNNzZUdW7ElJsZXYeQbz8Dy7DSKPHvfJeydL8Sc/cSfOaQ1uwKggcagunRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622805; c=relaxed/simple;
	bh=yASdp3M34Nj6xqw+92+P52bBRTG6gXxIB9PY7jRp9as=;
	h=Date:To:From:Subject:Message-Id; b=omUDqWvujLQ7VgFemt6kZzQXd8ZYiKMX3J5EL8vZahU3/v349irOyVDTTDqHX9v7lMhkRGl/x9+4tkq339HPnb5dwHDKDpC5NcYh1SOfB+ck7lZcJggB5pFvACJewxk7GPLySL/ikuHzibRZ5afh/HNrFiddUUP63fVf9PNpUi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h1u7tFOq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h1u7tFOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9301F000E9;
	Tue, 25 Aug 2026 01:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622804;
	bh=o1i3Lo/SfX+N9pXoQ8guEPZ4ndQY71/oH9TwSwVJr68=;
	h=Date:To:From:Subject;
	b=h1u7tFOqlt3vuhvoIRyDI6kL94P1vduv/FlI85F56kD/l3L/mTXP3rjPpH9UAMeg+
	 PHJJ875TIvu1e1PG6xzZRyF2Ro7KMHn0tix6ucWmGInKxgbn/nFe5j89D+rkQJuqH1
	 EIZtiam5ArjgWU9cIjT9CGJFjIDdDRJ9IAzvCzwo=
Date: Mon, 24 Aug 2026 18:53:23 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,david@kernel.org,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-proper-pte-accessor-in-move_ptes.patch removed from -mm tree
Message-Id: <20260825015323.EF9301F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use proper PTE accessor in move_ptes()
has been removed from the -mm tree.  Its filename was
     mm-use-proper-pte-accessor-in-move_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: mm: use proper PTE accessor in move_ptes()
Date: Mon, 20 Jul 2026 16:16:33 +0200

Follow the pattern established by commit c33c794828f2 ("mm: ptep_get()
conversion") and use the proper PTE accessor instead of a direct pointer
dereference.

Link: https://lore.kernel.org/20260720141633.501799-1-agordeev@linux.ibm.com
Fixes: b36b701bbcd9 ("mm: expose abnormal new_pte during move_ptes")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-use-proper-pte-accessor-in-move_ptes
+++ a/mm/mremap.c
@@ -264,7 +264,7 @@ static int move_ptes(struct pagetable_mo
 
 	for (; old_addr < old_end; old_ptep += nr_ptes, old_addr += nr_ptes * PAGE_SIZE,
 		new_ptep += nr_ptes, new_addr += nr_ptes * PAGE_SIZE) {
-		VM_WARN_ON_ONCE(!pte_none(*new_ptep));
+		VM_WARN_ON_ONCE(!pte_none(ptep_get(new_ptep)));
 
 		nr_ptes = 1;
 		max_nr_ptes = (old_end - old_addr) >> PAGE_SHIFT;
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are



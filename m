Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71E0314D37
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439022; cv=none; b=aQJ32zjWdsKuxAT3mJV0JW3HrUplSCExfzq6248eqZqIglqbJb/3mFrhX1RQphOcIbAEqsxRsYwlXZEWhDDU83zDy262XnMX/5PJQf1Roo5aI8Z6L+fBQI18+84uq/U/xcxHP47eT3dEwahD5CMl7kX1YVQOwhmv0af2NXqlUhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439022; c=relaxed/simple;
	bh=8wH1x+Rqz40PUsTG7nqY8NwkmRX0D28w+r9cUPF8q1M=;
	h=Date:To:From:Subject:Message-Id; b=M4zsQJYT794FKoEHqC8DobTqt98SR+D0QTndQXSFCYQYGsPRlGLSE1WEqQg1mF24d3ZYmNMz4p7oRLdUayZmZeuysvbRBdUcdbBncZAhEG+queEfAOjueLhruqKo16O7ybknjIznWFFEt6Xg8WmmhDiishBhaKKyRfYVXQY+/S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cGxVTAaq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cGxVTAaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE611F00893;
	Tue,  2 Jun 2026 22:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439021;
	bh=5DclGmwyDdbGixcJT9YrRDNjUh0lJD1l0vTnwSJdL2Q=;
	h=Date:To:From:Subject;
	b=cGxVTAaqho9DrZ9xq82ZXT6Hk3krc/BCICqxZ9M8fEg4oquyyPcTrzOe8q3Xve2+w
	 YEG5x6WXMy7MMH4H+8W0b/AQ5SQqh+DTvbvqKJHZVz9dQ0P3/dt7jXd3IbsaEQbA8R
	 5ibltFdmA8G0iWaDdUEOd3UoT+CH0gFa6+6zE9vE=
Date: Tue, 02 Jun 2026 15:23:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-mm-use-free_reserved_page-in-vmem_free_pages.patch removed from -mm tree
Message-Id: <20260602222341.6BE611F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/mm: use free_reserved_page() in vmem_free_pages()
has been removed from the -mm tree.  Its filename was
     s390-mm-use-free_reserved_page-in-vmem_free_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: s390/mm: use free_reserved_page() in vmem_free_pages()
Date: Mon, 11 May 2026 16:05:35 +0200

We never select CONFIG_HAVE_BOOTMEM_INFO_NODE on s390. Therefore,
free_bootmem_page() nowadays always translates to free_reserved_page().

Let's use free_reserved_page() to replace the free_bootmem_page() loop.
We can stop including bootmem_info.h.

Likely, vmemmap freeing code could be factored out into the core in the
future.

Link: https://lore.kernel.org/20260511-bootmem_info_prep-v1-7-3fb0be6fc688@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/vmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/s390/mm/vmem.c~s390-mm-use-free_reserved_page-in-vmem_free_pages
+++ a/arch/s390/mm/vmem.c
@@ -4,7 +4,6 @@
  */
 
 #include <linux/memory_hotplug.h>
-#include <linux/bootmem_info.h>
 #include <linux/cpufeature.h>
 #include <linux/memblock.h>
 #include <linux/pfn.h>
@@ -51,7 +50,7 @@ static void vmem_free_pages(unsigned lon
 	if (PageReserved(page)) {
 		/* allocated from memblock */
 		while (nr_pages--)
-			free_bootmem_page(page++);
+			free_reserved_page(page++);
 	} else {
 		free_pages(addr, order);
 	}
_

Patches currently in -mm which might be from david@kernel.org are



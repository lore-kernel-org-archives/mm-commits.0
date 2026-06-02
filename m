Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015B33B8BA4
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439020; cv=none; b=CMJUtOdQjE8xB5Z9CGNTnRa26JAWkScUAkp3JIWT6618vtW+Vnep6wbNeUAjiw1Pmk8JX05Sre4WHsgSs5HEekcP3+0J1po5ih7RsFC9oaSw+9/bMul6LqqELdWP412+hRDQaYV83VYGAAhBsTN5hRD4q9iKA8/sn1yeJBTpP/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439020; c=relaxed/simple;
	bh=tSGXgBI/Ja8bQx+fu5FxEF+zo92xo5X1JPze6oKYD3c=;
	h=Date:To:From:Subject:Message-Id; b=gmpKNx7bGbY4Ih8J/QS7xM745cqgC7xWKsmKSWbQ7wKj+nGate+bppDwjXq/a5tKkJPSFe5HXetw82+/Xy00SsyUC5oSmqLW2EOGN3SJGAABFUtZ1W4PCOCKKI1dGcYkOkZzaGvnjzCgHRyfLteX4NDWtJPW1aymBBUFgQ2KMqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WJKsZ4rS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WJKsZ4rS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D611F00893;
	Tue,  2 Jun 2026 22:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439018;
	bh=CKudyZbVAUNvSjsdUdSYb8HKBhRvf9T/TuRnZ/Pcbj8=;
	h=Date:To:From:Subject;
	b=WJKsZ4rSuT0F0NyvZ1RJHU3WNf4npL1BDKGQoYxbBioXzecvDQWoo4OPYlAYIu9RM
	 hhhtnYTo2FgzOH2NyCspEAyAlzKTel6ekUbjgu3w/1Hj+gP6DN5gWnjTTahu9eVWYv
	 SrmH3SO4Yv2a4HuH0mtLZDzEpUXeS0kgkl7M4xHY=
Date: Tue, 02 Jun 2026 15:23:38 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-bootmem_info-stop-marking-the-pgdat-as-node_info.patch removed from -mm tree
Message-Id: <20260602222338.A9D611F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/bootmem_info: stop marking the pgdat as NODE_INFO
has been removed from the -mm tree.  Its filename was
     mm-bootmem_info-stop-marking-the-pgdat-as-node_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/bootmem_info: stop marking the pgdat as NODE_INFO
Date: Mon, 11 May 2026 16:05:33 +0200

We removed the last user of NODE_INFO in commit 119c31caa59e ("mm/sparse:
remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for CONFIG_MEMORY_HOTPLUG").

But it really was never used it besides for safety-checks ever since it was
introduced in commit 04753278769f ("memory hotplug: register section/node
id to free"), where we had the comment:

	5) The node information like pgdat has similar issues. But, this
	   will be able to be solved too by this.
	   (Not implemented yet, but, remembering node id in the pages.)

Of course, that never happened, and we are not planning on freeing the
node data (pgdat/pglist_data), during memory hotunplug.

So let's just stop marking the pgdat as NODE_INFO.

Link: https://lore.kernel.org/20260511-bootmem_info_prep-v1-5-3fb0be6fc688@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
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

 mm/bootmem_info.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/bootmem_info.c~mm-bootmem_info-stop-marking-the-pgdat-as-node_info
+++ a/mm/bootmem_info.c
@@ -62,15 +62,8 @@ static void __init register_page_bootmem
 
 void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
 {
-	unsigned long i, pfn, end_pfn, nr_pages;
+	unsigned long pfn, end_pfn;
 	int node = pgdat->node_id;
-	struct page *page;
-
-	nr_pages = PAGE_ALIGN(sizeof(struct pglist_data)) >> PAGE_SHIFT;
-	page = virt_to_page(pgdat);
-
-	for (i = 0; i < nr_pages; i++, page++)
-		get_page_bootmem(node, page, NODE_INFO);
 
 	pfn = pgdat->node_start_pfn;
 	end_pfn = pgdat_end_pfn(pgdat);
_

Patches currently in -mm which might be from david@kernel.org are



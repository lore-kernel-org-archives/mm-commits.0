Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D362216602
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188386; cv=none; b=VgQCUG7hWmE1KUj/Ae/q1syvvCMzFYDvYcI5K6knNABX+g3q2x+09DZXFnGosjuas52/7SNOsfatLO8pIFeEZO2oFd+CfBGZAzE7QAi/iKUF2D7XY76U9WxOuuTqwiXBoP/7HPzi+kqrMdTKcfrllmeUQ8DKjT7FNlTir4Han1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188386; c=relaxed/simple;
	bh=37PfIhiM7FkjT599OBgSjdceuKu/5GByO6bOq4c3xcs=;
	h=Date:To:From:Subject:Message-Id; b=iMt5ROQqHNskL2rhlusAbQhTZr+wxqMxXx6nMSV1hpLXIP5Jlo/uEB/j9Nj9ezioP3aiisDhhDZCsGWLiQQ/BRF5l3+xjkda9aaOCDH0mTsIY7Gjl87sz8SweHsz93rFGG4v7Nuax/2RBNjS7ER4F+/lbX+0/6AtORvyTVOAZj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YSfGXlGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YSfGXlGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A60C4CEEC;
	Mon, 17 Mar 2025 05:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188385;
	bh=37PfIhiM7FkjT599OBgSjdceuKu/5GByO6bOq4c3xcs=;
	h=Date:To:From:Subject:From;
	b=YSfGXlGZMqGjQsx54seruvlmKUdRN58a8hp3o7FkkjDsV54Q3SMeK+/P32A8SRglC
	 kRMkOnI/r/HIhoKN3goDyaZoGwn1TGlw0mET7FvdSNoNo8WpTpvmeyVt96u3Xm9zlq
	 MvhFCSD4JoBq9PBttoimRg1lHTZ3gKknMaUq0XIo=
Date: Sun, 16 Mar 2025 22:13:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch removed from -mm tree
Message-Id: <20250317051305.D5A60C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: move huge_boot_pages list init to hugetlb_bootmem_alloc
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: move huge_boot_pages list init to hugetlb_bootmem_alloc
Date: Fri, 28 Feb 2025 18:29:17 +0000

Instead of initializing the per-node hugetlb bootmem pages list from the
alloc function, we can now do it in a somewhat cleaner way, since there is
an explicit hugetlb_bootmem_alloc function.  Initialize the lists there.

Link: https://lkml.kernel.org/r/20250228182928.2645936-17-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc
+++ a/mm/hugetlb.c
@@ -3586,7 +3586,6 @@ static unsigned long __init hugetlb_page
 static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 {
 	unsigned long allocated;
-	static bool initialized __initdata;
 
 	/* skip gigantic hugepages allocation if hugetlb_cma enabled */
 	if (hstate_is_gigantic(h) && hugetlb_cma_size) {
@@ -3594,17 +3593,6 @@ static void __init hugetlb_hstate_alloc_
 		return;
 	}
 
-	/* hugetlb_hstate_alloc_pages will be called many times, initialize huge_boot_pages once */
-	if (!initialized) {
-		int i = 0;
-
-		for (i = 0; i < MAX_NUMNODES; i++)
-			INIT_LIST_HEAD(&huge_boot_pages[i]);
-		h->next_nid_to_alloc = first_online_node;
-		h->next_nid_to_free = first_online_node;
-		initialized = true;
-	}
-
 	/* do node specific alloc */
 	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
 		return;
@@ -4928,13 +4916,20 @@ bool __init hugetlb_bootmem_allocated(vo
 void __init hugetlb_bootmem_alloc(void)
 {
 	struct hstate *h;
+	int i;
 
 	if (__hugetlb_bootmem_allocated)
 		return;
 
+	for (i = 0; i < MAX_NUMNODES; i++)
+		INIT_LIST_HEAD(&huge_boot_pages[i]);
+
 	hugetlb_parse_params();
 
 	for_each_hstate(h) {
+		h->next_nid_to_alloc = first_online_node;
+		h->next_nid_to_free = first_online_node;
+
 		if (hstate_is_gigantic(h))
 			hugetlb_hstate_alloc_pages(h);
 	}
_

Patches currently in -mm which might be from fvdl@google.com are



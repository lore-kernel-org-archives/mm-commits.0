Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832337;
	b=b2p7M98dtM/ITkEzWX5U2cUHPuAq5s8EB9Yu4R7/KH9RQYOSFeN03Jf36FXmDhGvKdyU
	 JrukpOIQkSTye1E1ts9LE/qTOCxUybtOKi1H5QtqzMD795yBxxjTrZ4GGR8I+R17gja/j
	 B/kVv7CYo1JRrf2AxTWxRGER6FqvMN1myD6y7l5uEs78Dq+Tb3xhbLJ/fFiGVOrUvEJLp
	 P9p8VGNbLVgLRrzPq6yi4x2jUeqMv9I41zp9vl1WIiQt56Kmx9IhkxKzp0UafC97OQ2xV
	 c2KBQgqg8NQHAGHrOqc7uXBBe5Fm0XtKoBnRveRv60+KB1MHBMFeN9kvYgYJaVhbHNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832337;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=yNr11QzI/wM3SG6FGSkfh8ybXlxycqNtC+bduuv1CoE=;
	b=T2VJ4uaaXntuXGnekv2iPjIz2a+DzerW3d/0aMPMpBL3sQAHtUHcnVz75khoQhjbzWzT
	 WsK7e2Y1l/5uT1C+yWieSkc3kV1M+8vi7XQAcd1wQeBH3HfOMNyj/SNjmxwCdeIX0K4kN
	 6M23aF1+PO0l+xZkyT8D4OUdK2+yV0q2ov5Jc6A28QxmSz3rNAfsuC8hp4/ilOjkMzvRR
	 3IeVUswRXFe/5QVJD41n6S70Xeg/CS3yQmOsxJ5uR92fJShbY1KuEYu+MI2qSLabRsxeI
	 g8EluOFuVy9sZqhMuB9oBM2wMmaStN3iYIcyKtLsKpj5+9z7kjk+OIrbs3Wodsgj5Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=R+iFzyoA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74927606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=R+iFzyoA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3808F1F01828;
	Sat, 24 Oct 2026 08:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832337;
	bh=yNr11QzI/wM3SG6FGSkfh8ybXlxycqNtC+bduuv1CoE=;
	h=Date:To:From:Subject;
	b=R+iFzyoAm28uxs4oKlK/kuPsWkC5OZrOl1pZiGDHbW4H9xXOjJ7ZI2Vg3hF8H+ZLw
	 qbBAv4RwtEjYgrPqDwmNqWFJvRXRVI1j/jlLfRT3iQybqdnTydXmS2V7H/7Jbf/oVC
	 zOZHT4YP/k8tojMycdE7zKXDDEkclFOLvDhRwlNU=
Date: Sat, 24 Oct 2026 01:58:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kbingham@kernel.org,kasong@tencent.com,jan.kiszka@siemens.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch removed from -mm tree
Message-Id: <20261024085857.3808F1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/sparse: move initialization of section metadata to sparse_metadata_init()
has been removed from the -mm tree.  Its filename was
     mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: move initialization of section metadata to sparse_metadata_init()
Date: Mon, 21 Sep 2026 21:58:55 +0200

Let's move the code responsible for initializing sparse metadata (usemap,
memmap) into a helper.  Cleanup the variable while at it (e.g.,
"map_count").

Drop the rather obvious code comments.

No functional change intended.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-3-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
---

 mm/sparse.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- a/mm/sparse.c~mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init
+++ a/mm/sparse.c
@@ -255,38 +255,39 @@ static void __init sparse_init_nid(int n
 	}
 }
 
+static void __init sparse_metadata_init(void)
+{
+	unsigned long start_section_nr = first_present_section_nr();
+	int nid_begin = sparse_early_nid(__nr_to_section(start_section_nr));
+	unsigned long section_nr, nr_sections = 1;
+
+	for_each_present_section_nr(start_section_nr + 1, section_nr) {
+		const int nid = sparse_early_nid(__nr_to_section(section_nr));
+
+		if (nid == nid_begin) {
+			nr_sections++;
+			continue;
+		}
+		sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
+		nid_begin = nid;
+		start_section_nr = section_nr;
+		nr_sections = 1;
+	}
+	sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
+}
+
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
  */
 void __init sparse_init(void)
 {
-	unsigned long pnum_end, pnum_begin, map_count = 1;
-	int nid_begin;
-
 	if (compound_info_has_mask()) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
 				    MAX_FOLIO_VMEMMAP_ALIGN));
 	}
 
-	pnum_begin = first_present_section_nr();
-	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
-
-	for_each_present_section_nr(pnum_begin + 1, pnum_end) {
-		int nid = sparse_early_nid(__nr_to_section(pnum_end));
-
-		if (nid == nid_begin) {
-			map_count++;
-			continue;
-		}
-		/* Init node with sections in range [pnum_begin, pnum_end) */
-		sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
-		nid_begin = nid;
-		pnum_begin = pnum_end;
-		map_count = 1;
-	}
-	/* cover the last node */
-	sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
+	sparse_metadata_init();
 	sparse_init_subsection_map();
 	vmemmap_populate_print_last();
 }
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC6228DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489820; cv=none; b=BQNDYwUtpXyvTVto4IqZ3DGYgJXe/vzmnOH/vd25rdWivm8zVm1rPDMlrfLX4sQAw6b+odDaaJn/ntc6IkYkOc2jGh2nTV8C54FSEXpLPwd4y3dsO/80zfOLnB6/x0hCedTf5OTzbB7/SyulOkZQGFLlZcb0bbEXAyv7bkyqnfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489820; c=relaxed/simple;
	bh=FoeHi7Pl8dzLJSjyhxe9u91UQslNJ7/FaXP9MPkKAhY=;
	h=Date:To:From:Subject:Message-Id; b=I+OiiEE03Vr+4J9qidjH+gvnE1KOmaw4nAf1Rlu8shfakjJg+OYmOZ5yCzYlNDp03HDMxlZ+qziMJx91lI/m94OJRNyfbZt6kbZAj8q5sSjwJlEGkpuN/oitLI8lvEnWAzg/PsBKtM6v3CC1BkkvfGh9B0qp9Khzqm6hvJwuPaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tjWElCyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tjWElCyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B18C4CEE7;
	Sun, 21 Sep 2025 21:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489820;
	bh=FoeHi7Pl8dzLJSjyhxe9u91UQslNJ7/FaXP9MPkKAhY=;
	h=Date:To:From:Subject:From;
	b=tjWElCyFNcWAQ6YA3Og5WDegxWlOIn4rU2mdU4mdrWlFR2zoL7bc21YlV990mi3SP
	 qRT7Zh+iyWeoBr9orm1K/wDkKCq2mVpKcrFopJ3y7YXpwhIMhpSEc0/Wn/7E1NQe7Q
	 fa1jT/Wf/z245dVagcVrIF/pM3mwdcrH0rAxtifc=
Date: Sun, 21 Sep 2025 14:23:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-limit-folio-compound-page-sizes-in-problematic-kernel-configs.patch removed from -mm tree
Message-Id: <20250921212340.32B18C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: limit folio/compound page sizes in problematic kernel configs
has been removed from the -mm tree.  Its filename was
     mm-limit-folio-compound-page-sizes-in-problematic-kernel-configs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: limit folio/compound page sizes in problematic kernel configs
Date: Mon, 1 Sep 2025 17:03:32 +0200

Let's limit the maximum folio size in problematic kernel config where the
memmap is allocated per memory section (SPARSEMEM without
SPARSEMEM_VMEMMAP) to a single memory section.

Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE but
not SPARSEMEM_VMEMMAP: sh.

Fortunately, the biggest hugetlb size sh supports is 64 MiB
(HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
(SECTION_SIZE_BITS == 26), so their use case is not degraded.

As folios and memory sections are naturally aligned to their order-2 size
in memory, consequently a single folio can no longer span multiple memory
sections on these problematic kernel configs.

nth_page() is no longer required when operating within a single compound
page / folio.

Link: https://lkml.kernel.org/r/20250901150359.867252-12-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-limit-folio-compound-page-sizes-in-problematic-kernel-configs
+++ a/include/linux/mm.h
@@ -2053,11 +2053,25 @@ static inline long folio_nr_pages(const
 	return folio_large_nr_pages(folio);
 }
 
-/* Only hugetlbfs can allocate folios larger than MAX_ORDER */
-#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#define MAX_FOLIO_ORDER		PUD_ORDER
-#else
+#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
+/*
+ * We don't expect any folios that exceed buddy sizes (and consequently
+ * memory sections).
+ */
 #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
+#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+/*
+ * Only pages within a single memory section are guaranteed to be
+ * contiguous. By limiting folios to a single memory section, all folio
+ * pages are guaranteed to be contiguous.
+ */
+#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
+#else
+/*
+ * There is no real limit on the folio size. We limit them to the maximum we
+ * currently expect (e.g., hugetlb, dax).
+ */
+#define MAX_FOLIO_ORDER		PUD_ORDER
 #endif
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
_

Patches currently in -mm which might be from david@redhat.com are



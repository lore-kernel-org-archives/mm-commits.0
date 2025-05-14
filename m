Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7958282E1
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 22:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747262250; cv=none; b=qUAgqELvr65LRm3fHOdcrcLqTgQGKsYl+6eg8yBCwWpy9cE20czruVHs1IP77QvJ4L6D15wHrbIZXWCH41mm11DBBGYRN4aVELyhXuSHMKHM9WxAgf6pIOUlElAM2j1hPZZd/N4XBMKk+LoAMVzg8HixVJhzMnj0aDlOm1AZpbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747262250; c=relaxed/simple;
	bh=CgGLl3/uZSybGL/3Edk3BS/9SroBp+ui/dehBVMGWEA=;
	h=Date:To:From:Subject:Message-Id; b=OSDLRjhdHnbhFfQ4OVEo/ioSf4NYn9KQgLcXQXzFYOekqxf/USAi9ngJuxz+U2fZsj1ZTpjRUxwN3EX+sm8shodRylVU4jejWC8UFKJmBmajcuPZtlWoNV2QBgptEfL6RuULdK02K9FHUlW01Z70W61yJ3aW2zeWqtw5Pt7mrO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ntfqSQtm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ntfqSQtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136D6C4CEE3;
	Wed, 14 May 2025 22:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747262250;
	bh=CgGLl3/uZSybGL/3Edk3BS/9SroBp+ui/dehBVMGWEA=;
	h=Date:To:From:Subject:From;
	b=ntfqSQtm7O1UAWJzuKwe6caQamiuEBKPdHyCpJkQ3NVE+0k1tXTVQ/BFZv87qZGLj
	 sy+IFX3JQbGye6C72MNms0wSdDyuv7I6W6WEiP3aa8sX62UZy1us+BDyhPN60QH3Sv
	 pLgdbCskARF2zQtIMM8STtWIMeX2/m1qasxv7KzQ=
Date: Wed, 14 May 2025 15:37:29 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,willy@infradead.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,Ignacio.MorenoGonzalez@kuka.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-madvise-make-madv_nohugepage-a-no-op-if-thp.patch removed from -mm tree
Message-Id: <20250514223730.136D6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
has been removed from the -mm tree.  Its filename was
     mm-madvise-make-madv_nohugepage-a-no-op-if-thp.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Subject: mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
Date: Thu, 08 May 2025 12:20:27 +0200

VM_NOHUGEPAGE is a no-op if CONFIG_TRANSPARENT_HUGEPAGE is disabled.  So
it makes no sense to return an error when calling madvise() with
MADV_NOHUGEPAGE in that case.

Link: https://lkml.kernel.org/r/20250508-madvise-nohugepage-noop-without-thp-v1-1-e7ceffb197f3@kuka.com
Signed-off-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/huge_mm.h~mm-madvise-make-madv_nohugepage-a-no-op-if-thp
+++ a/include/linux/huge_mm.h
@@ -506,6 +506,8 @@ bool unmap_huge_pmd_locked(struct vm_are
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#include <uapi/asm/mman.h>
+
 static inline bool folio_test_pmd_mappable(struct folio *folio)
 {
 	return false;
@@ -595,6 +597,9 @@ static inline bool unmap_huge_pmd_locked
 static inline int hugepage_madvise(struct vm_area_struct *vma,
 				   unsigned long *vm_flags, int advice)
 {
+	/* On a !THP kernel, MADV_NOHUGEPAGE is a no-op, but MADV_NOHUGEPAGE is not supported */
+	if (advice == MADV_NOHUGEPAGE)
+		return 0;
 	return -EINVAL;
 }
 
_

Patches currently in -mm which might be from Ignacio.MorenoGonzalez@kuka.com are

mm-mmap-map-map_stack-to-vm_nohugepage-only-if-thp-is-enabled.patch


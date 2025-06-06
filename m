Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970411FAA
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 05:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749186184; cv=none; b=e6EjYLEHbIElrhOp2OqsorV3kGFQX2V8zWExijE1UowFgV339VDQjvhXxZpiwXZuYTij/Pou074XBN8/sG62slZEiFU3spf9KRECHemmqxyY/Mh0N8Mg4zDeDvsbg4CPkN/o+q45ws6Ky7ZYMrSPnwuOs893cfMt9uNAHDSt+CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749186184; c=relaxed/simple;
	bh=4Kgii/6IAWFaIPhq1BTWCZkbBfz9kVnNS3sxl8rpUEM=;
	h=Date:To:From:Subject:Message-Id; b=XC9AC3LYKe/usSg3eweaYyuxWza0Ob9iIfeNtZbvPRGadrwT8RsvfGpOsIyy2x4ME7GSp45PVbfZKHbeM3y5rMOhYcqMJxHJnT/V8/xEJyOTWKg+TZWWVrS5SnnONDg1cGrj9ILhpgUKgelEemZljeimtWP9lSQ6jHCBU0acb2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fbn7BF7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fbn7BF7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6194EC4CEEB;
	Fri,  6 Jun 2025 05:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749186184;
	bh=4Kgii/6IAWFaIPhq1BTWCZkbBfz9kVnNS3sxl8rpUEM=;
	h=Date:To:From:Subject:From;
	b=Fbn7BF7o2ztLmM12dhrj9pCcLscwfEJ+jWkBUpaUzihWz1/jCr85mk3sqU/W8Mrml
	 cAqTJB1zwj5WDvwyucaRSPTe2HPHG4/Qx6nkL7J4AgOHnLwwNMwEdgMngG8Q6P9AU7
	 nIS9nzKzdrTJlIzC65FyzzRu+mr3kZ0q4qoxUf+g=
Date: Thu, 05 Jun 2025 22:03:03 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-mm-swap-section.patch removed from -mm tree
Message-Id: <20250606050304.6194EC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add mm swap section
has been removed from the -mm tree.  Its filename was
     maintainers-add-mm-swap-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add mm swap section
Date: Wed, 4 Jun 2025 17:31:39 +0100

In furtherance of ongoing efforts to ensure people are aware of who
de-facto maintains/has an interest in specific parts of mm, as well trying
to avoid get_maintainers.pl listing only Andrew and the mailing list for
mm files - establish a swap memory management section and add relevant
maintainers/reviewers.

Link: https://lkml.kernel.org/r/20250604163139.126630-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: Baoquan He <bhe@redhat.com>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-swap-section
+++ a/MAINTAINERS
@@ -15816,6 +15816,25 @@ S:	Maintained
 F:	include/linux/secretmem.h
 F:	mm/secretmem.c
 
+MEMORY MANAGEMENT - SWAP
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Kemeng Shi <shikemeng@huaweicloud.com>
+R:	Kairui Song <kasong@tencent.com>
+R:	Nhat Pham <nphamcs@gmail.com>
+R:	Baoquan He <bhe@redhat.com>
+R:	Barry Song <baohua@kernel.org>
+R:	Chris Li <chrisl@kernel.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	include/linux/swap.h
+F:	include/linux/swapfile.h
+F:	include/linux/swapops.h
+F:	mm/page_io.c
+F:	mm/swap.c
+F:	mm/swap.h
+F:	mm/swap_state.c
+F:	mm/swapfile.c
+
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@redhat.com>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch


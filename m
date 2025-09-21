Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F6228DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489851; cv=none; b=Ti3Nx0hi2PF1qwhxxE/+F7j61lEJLECQgWeMHpYK7YOsUvmje5Fw4cvlbSK92evhgV5fU0JfzulTRy1p2zMI5h8bvaCtqBqCULbnsvu5kpAuZZoQgE+KNtQ1wsmasl2WvS66RseR5LgElEFu/QTYUkHv4W5IsfRJJiyzeRGuTeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489851; c=relaxed/simple;
	bh=zCmuj/1BaIBnChPWVDvhtBSUTKoiBAdRjeBjC2T+W8I=;
	h=Date:To:From:Subject:Message-Id; b=k4HVL08IFBmY52dbbuS9BH2c8Fbrkk/WRjAMIFa2K88S3felcm87qujtP6d3HRMesQciCFfqA0tQvgeD8B0MpJ06cfWYn1eqmlOwJgk4HJcI20wxne4NkITaNYDX4ehWATNJ/yd1lSKLbNVB/CKE4djZgJmxEnf+1fiPMZyR6Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XiHoyR5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XiHoyR5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF21C4CEE7;
	Sun, 21 Sep 2025 21:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489851;
	bh=zCmuj/1BaIBnChPWVDvhtBSUTKoiBAdRjeBjC2T+W8I=;
	h=Date:To:From:Subject:From;
	b=XiHoyR5wiYaJ8Cfl5ugmMyT3Pm+m+TdBP5GNAJmiyr4SIEXjk9fgkar45Fl8v0Njv
	 L4enXNoffEeTox0SMEECcZy+qwsP/KXGRyV7sjrlKd217lI8VjZkaHh5upA1tSzYJz
	 suaYdwmjbhrvUwd2HxkgIvhFenHbj2NESU4niPHo=
Date: Sun, 21 Sep 2025 14:24:10 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-nth_page.patch removed from -mm tree
Message-Id: <20250921212411.1EF21C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove nth_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-nth_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: remove nth_page()
Date: Mon, 1 Sep 2025 17:03:58 +0200

Now that all users are gone, let's remove it.

Link: https://lkml.kernel.org/r/20250901150359.867252-38-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h                   |    2 --
 tools/testing/scatterlist/linux/mm.h |    1 -
 2 files changed, 3 deletions(-)

--- a/include/linux/mm.h~mm-remove-nth_page
+++ a/include/linux/mm.h
@@ -210,9 +210,7 @@ extern unsigned long sysctl_admin_reserv
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 bool page_range_contiguous(const struct page *page, unsigned long nr_pages);
-#define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 #else
-#define nth_page(page,n) ((page) + (n))
 static inline bool page_range_contiguous(const struct page *page,
 		unsigned long nr_pages)
 {
--- a/tools/testing/scatterlist/linux/mm.h~mm-remove-nth_page
+++ a/tools/testing/scatterlist/linux/mm.h
@@ -51,7 +51,6 @@ static inline unsigned long page_to_phys
 
 #define page_to_pfn(page) ((unsigned long)(page) / PAGE_SIZE)
 #define pfn_to_page(pfn) (void *)((pfn) * PAGE_SIZE)
-#define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
 #define __min(t1, t2, min1, min2, x, y) ({              \
 	t1 min1 = (x);                                  \
_

Patches currently in -mm which might be from david@redhat.com are



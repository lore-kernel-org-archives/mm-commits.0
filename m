Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB68928DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489816; cv=none; b=j3ywCdgyhCL/F5YiDWoHn1kw5o7n7RHs/AQzwzsmXwLCnGOJnO6i/89Ht5zsIHrKzK9yrW+eUceuFoeTJMDexWmxh0eO2Uy9Z8xgt8DMUZwY5lFYAI1NbW6voFKOTIreUNmaO47F97DIXRXHC4x1IPRXTGENk4nXfjddEpdDRf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489816; c=relaxed/simple;
	bh=FdEhemN8UifS8RqCV+4qRjEh/qUPosqDmC2eRm7I2VI=;
	h=Date:To:From:Subject:Message-Id; b=EQSSSxzTglGrja77yuqbE1akw92XDwigKwM50zNAAgqK10zbUuJDepwliD9qwdIk5+Xpd2BFe6xKOogPhvfZLr0yJnVyDo00A5drzOy5HaFGjg/aLVjDRq3T0+9Arpczpj+GVel9uZcPdW4/u7RjT/Rf3k4hsVJdQd524/UbbA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WVoQiEix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WVoQiEix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE7FC4CEE7;
	Sun, 21 Sep 2025 21:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489816;
	bh=FdEhemN8UifS8RqCV+4qRjEh/qUPosqDmC2eRm7I2VI=;
	h=Date:To:From:Subject:From;
	b=WVoQiEixqLUQ3JBpyKIeREChhHcHmWWu9kageb8EUbv2sjZub0jdHbb164AEvJVqu
	 r91+GBf3XNykrlO81URjuOM3YJD3zI8nZo3pPjKVfJbE4P0S+YFL5mujnkuxuLeh7S
	 WGfIkflPOM7U+PXDSG3uH9t8rSqtFRH9YdGSiVcs=
Date: Sun, 21 Sep 2025 14:23:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-check-for-unreasonable-folio-sizes-when-registering-hstate.patch removed from -mm tree
Message-Id: <20250921212336.7FE7FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: check for unreasonable folio sizes when registering hstate
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-check-for-unreasonable-folio-sizes-when-registering-hstate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: check for unreasonable folio sizes when registering hstate
Date: Mon, 1 Sep 2025 17:03:29 +0200

Let's check that no hstate that corresponds to an unreasonable folio size
is registered by an architecture.  If we were to succeed registering, we
could later try allocating an unsupported gigantic folio size.

Further, let's add a BUILD_BUG_ON() for checking that HUGETLB_PAGE_ORDER
is sane at build time.  As HUGETLB_PAGE_ORDER is dynamic on powerpc, we
have to use a BUILD_BUG_ON_INVALID() to make it compile.

No existing kernel configuration should be able to trigger this check:
either SPARSEMEM without SPARSEMEM_VMEMMAP cannot be configured or
gigantic folios will not exceed a memory section (the case on sparse).

Link: https://lkml.kernel.org/r/20250901150359.867252-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-check-for-unreasonable-folio-sizes-when-registering-hstate
+++ a/mm/hugetlb.c
@@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
 
 	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
 			__NR_HPAGEFLAGS);
+	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
 
 	if (!hugepages_supported()) {
 		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
@@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned
 	}
 	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
 	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
+	WARN_ON(order > MAX_FOLIO_ORDER);
 	h = &hstates[hugetlb_max_hstate++];
 	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
 	h->order = order;
_

Patches currently in -mm which might be from david@redhat.com are



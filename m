Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727E22D3A98
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754959476; cv=none; b=Bp4keXnxdXk5UETqqZYY75mtvqRuhtkXHRRsrikxxMB2LLH90Scz+u/Lp3Pkz6uppLJApLxOQOOHv/v50+s5DQd5blFcIAsYAiWXHRYsuXyAMD7TFolx8NiE6kjRCEaOCDGctv7K6AP7Jx75W7DEw3bSfmh3KDCi/w0YpFcXacA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754959476; c=relaxed/simple;
	bh=RRtYkcq/8RCmX/WKOqcD6Y0pF5n0lw+hje3JnXFt5S0=;
	h=Date:To:From:Subject:Message-Id; b=EZvGD4u3coyeWQZ9zMjgsxHfnU5uDougFFAqlkISdt+y9E67V/ungOwdHGF4rfQGiyRsLw95nA4y4Rbujpces455CqVsjokDwcodLihxKbIOrz530VmJDqEECWyQ5C3eLJgd7WxH8w5ofumpaf1Ec+CdIVbCj6JetS4qUM8w8Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fjBObBIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fjBObBIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1E8C4CEED;
	Tue, 12 Aug 2025 00:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754959475;
	bh=RRtYkcq/8RCmX/WKOqcD6Y0pF5n0lw+hje3JnXFt5S0=;
	h=Date:To:From:Subject:From;
	b=fjBObBIbIXCJTcYU/KGW0HIlT75G2ItITyB995womwiP7/Rq15MZOC6m6pt1Xn+pY
	 yW02sxrQwwWhyuqXFDmvnmWM3AB/akZreifKiECffGUa7JTb/AIf3/zDLMhjh7bvrX
	 G93kok8Os3M971qtNzdMFn1kPvIiVwIU4nCWkTTs=
Date: Mon, 11 Aug 2025 17:44:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,npache@redhat.com,mhocko@suse.com,mcgrof@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hch@lst.de,djwong@kernel.org,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,axboe@kernel.dk,p.raghav@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-largest_zero_folio-routine.patch added to mm-new branch
Message-Id: <20250812004434.EE1E8C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add largest_zero_folio() routine
has been added to the -mm mm-new branch.  Its filename is
     mm-add-largest_zero_folio-routine.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-largest_zero_folio-routine.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: mm: add largest_zero_folio() routine
Date: Mon, 11 Aug 2025 10:41:12 +0200

The callers of mm_get_huge_zero_folio() have access to a mm struct and the
lifetime of the huge_zero_folio is tied to the lifetime of the mm struct.

largest_zero_folio() will give access to huge_zero_folio when
PERSISTENT_HUGE_ZERO_FOLIO config option is enabled for callers that do
not want to tie the lifetime to a mm struct.  This is very useful for
filesystem and block layers where the request completions can be async and
there is no guarantee on the mm struct lifetime.

This function will return a ZERO_PAGE folio if PERSISTENT_HUGE_ZERO_FOLIO
is disabled or if we failed to allocate a huge_zero_folio during early
init.

Link: https://lkml.kernel.org/r/20250811084113.647267-5-kernel@pankajraghav.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/include/linux/huge_mm.h~mm-add-largest_zero_folio-routine
+++ a/include/linux/huge_mm.h
@@ -714,4 +714,26 @@ static inline int split_folio_to_order(s
 	return split_folio_to_list_to_order(folio, NULL, new_order);
 }
 
+/**
+ * largest_zero_folio - Get the largest zero size folio available
+ *
+ * This function shall be used when mm_get_huge_zero_folio() cannot be
+ * used as there is no appropriate mm lifetime to tie the huge zero folio
+ * from the caller.
+ *
+ * Deduce the size of the folio with folio_size instead of assuming the
+ * folio size.
+ *
+ * Return: pointer to PMD sized zero folio if CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
+ * is enabled or a single page sized zero folio
+ */
+static inline struct folio *largest_zero_folio(void)
+{
+	struct folio *folio = get_persistent_huge_zero_folio();
+
+	if (folio)
+		return folio;
+
+	return page_folio(ZERO_PAGE(0));
+}
 #endif /* _LINUX_HUGE_MM_H */
_

Patches currently in -mm which might be from p.raghav@samsung.com are

mm-rename-huge_zero_page-to-huge_zero_folio.patch
mm-rename-mmf_huge_zero_page-to-mmf_huge_zero_folio.patch
mm-add-persistent-huge-zero-folio.patch
mm-add-largest_zero_folio-routine.patch
block-use-largest_zero_folio-in-__blkdev_issue_zero_pages.patch


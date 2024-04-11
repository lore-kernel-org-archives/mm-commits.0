Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1941754B
	for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2024 20:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712868452; cv=none; b=YCPT+ce9MKEprdsUiu51aJIeOaViSb/S+IXS1aLsJmrFq2v+dZcEIiOGkH4RubX1WONtNqiZthNEy02XotPHMMubIgGtxnJgjzhWBEvCSil8r6B28ede4v5QPLN1JphQgYSHlfPhvjAhe7OmaKA6ae96Z4/xUkapSJqRPS6QOFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712868452; c=relaxed/simple;
	bh=KjfYJXehBEeY5Sych5qGXX2xCEXgNtSDu4pytpZbU4Q=;
	h=Date:To:From:Subject:Message-Id; b=t/jcO9bYUXbK4WihID2Zd1ZeeDcRZxMJdYc+0ltwYS4bRvXacfjOPK7CWq8vNTaAA9lFHNdjQtnURvWBcJtDrSWeiVpkR/9+arDzu1O++UjxndhE8g7Cp0VfcmZpkmdjq4OsjcqNn0ua8jQhCXXSKpaRME7LsNL2XSUKkfxEpuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iYK8l8dx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iYK8l8dx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2832EC072AA;
	Thu, 11 Apr 2024 20:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712868452;
	bh=KjfYJXehBEeY5Sych5qGXX2xCEXgNtSDu4pytpZbU4Q=;
	h=Date:To:From:Subject:From;
	b=iYK8l8dxwXyzCAQW+AvtibkhdV4OfBl7UHkmSfxjN+9zJy/1xG0xQu/3nYmXK0iak
	 59ybh9WKOTehwDbz+glcLnDz2wZcj46f3RhEECIeyyAuH+mCJ5NHx1PzoEm2zdDK+O
	 BCUZU9VE5suGjPc/7RkNJQawAfozji3Gf78zunXY=
Date: Thu, 11 Apr 2024 13:47:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,david@redhat.com,chrisw@sous-sol.org,aarcange@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-add-folio_set_stable_node.patch added to mm-unstable branch
Message-Id: <20240411204732.2832EC072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: add folio_set_stable_node
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-add-folio_set_stable_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-add-folio_set_stable_node.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: add folio_set_stable_node
Date: Thu, 11 Apr 2024 14:17:04 +0800

Turn set_page_stable_node() into a wrapper folio_set_stable_node, and then
use it to replace the former.  we will merge them together after all place
converted to folio.

Link: https://lkml.kernel.org/r/20240411061713.1847574-4-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/ksm.c~mm-ksm-add-folio_set_stable_node
+++ a/mm/ksm.c
@@ -1109,6 +1109,12 @@ static inline void set_page_stable_node(
 	page->mapping = (void *)((unsigned long)stable_node | PAGE_MAPPING_KSM);
 }
 
+static inline void folio_set_stable_node(struct folio *folio,
+					 struct ksm_stable_node *stable_node)
+{
+	set_page_stable_node(&folio->page, stable_node);
+}
+
 #ifdef CONFIG_SYSFS
 /*
  * Only called through the sysfs control interface:
@@ -3241,7 +3247,7 @@ void folio_migrate_ksm(struct folio *new
 		 * has gone stale (or that folio_test_swapcache has been cleared).
 		 */
 		smp_wmb();
-		set_page_stable_node(&folio->page, NULL);
+		folio_set_stable_node(folio, NULL);
 	}
 }
 #endif /* CONFIG_MIGRATION */
_

Patches currently in -mm which might be from alexs@kernel.org are

mm-ksm-add-ksm_get_folio.patch
mm-ksm-use-folio-in-remove_rmap_item_from_tree.patch
mm-ksm-add-folio_set_stable_node.patch
mm-ksm-use-folio-in-remove_stable_node.patch
mm-ksm-use-folio-in-stable_node_dup.patch
mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item.patch
mm-ksm-use-folio-in-write_protect_page.patch
mm-ksm-convert-chain-series-funcs-and-replace-get_ksm_page.patch
mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node.patch


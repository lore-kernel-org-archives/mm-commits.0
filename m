Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269D413D51B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291568; cv=none; b=EZdd0Pob3UHNy0fE7dNrb91LC8vZ1hNs4con7NX4Xwksn/GZ7ZRpR31mdLvzJC2Z1sNnbFppy/ItGFq+vKu8uL6DNJeUir1RaARLkvVL9HMNO54uK4v52DVFPjECKuU3qcm/ldFgMu54QnEfsPmRwN6yJb3S/vshzpMBixxA09k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291568; c=relaxed/simple;
	bh=o8RH3WA3sOyvlzy7Mm/sWCmwiYf7ls16l4NCgpJfVCU=;
	h=Date:To:From:Subject:Message-Id; b=Gv0lF5I9iFhp2hK18AvmgisuAYJQvIQQKlpgRIhFQwRkdcynMzJZaRc49Z/ITz3yurg4z3JSpZQEWYIt4IK/oSE3Nrqz8yMiml3fr9POgmiXn0MyzI848a+UeEuxxvyh6x3j99sJKPucaQNGcoHSmVj5Yztjn4oAS67lSdqmsz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xdg3ysac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xdg3ysac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FEFC32782;
	Tue, 25 Jun 2024 04:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291567;
	bh=o8RH3WA3sOyvlzy7Mm/sWCmwiYf7ls16l4NCgpJfVCU=;
	h=Date:To:From:Subject:From;
	b=xdg3ysaclSCX4+vsAsi4W9HwG6xzX8BWVb4wChoeNaOhQd5uRf8f1qBnRiOg6n176
	 MXVWQy1MtbSVgZBa7OAWO4cSBbJ3K4XhnjBeGziLA+bOJE9mhvRaaDyvdL+Sm7Qh3C
	 Tau+zt7CiSqSIUorM5fPcZ5hF55mjQpydDGrsvtY=
Date: Mon, 24 Jun 2024 21:59:27 -0700
To: mm-commits@vger.kernel.org,vdonnefort@google.com,dan.j.williams@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch removed from -mm tree
Message-Id: <20240625045927.A2FEFC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: sanity check that zeropages are not passed to RMAP
has been removed from the -mm tree.  Its filename was
     mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: sanity check that zeropages are not passed to RMAP
Date: Wed, 22 May 2024 14:57:13 +0200

Using insert_page() we might have previously ended up passing the zeropage
into rmap code.  Make sure that won't happen again.

Note that we won't check the huge zeropage for now, which might still end
up in RMAP code.

Link: https://lkml.kernel.org/r/20240522125713.775114-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/rmap.h~mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap
+++ a/include/linux/rmap.h
@@ -200,6 +200,9 @@ static inline void __folio_rmap_sanity_c
 	/* hugetlb folios are handled separately. */
 	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 
+	/* When (un)mapping zeropages, we should never touch ref+mapcount. */
+	VM_WARN_ON_FOLIO(is_zero_folio(folio), folio);
+
 	/*
 	 * TODO: we get driver-allocated folios that have nothing to do with
 	 * the rmap using vm_insert_page(); therefore, we cannot assume that
_

Patches currently in -mm which might be from david@redhat.com are

mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch


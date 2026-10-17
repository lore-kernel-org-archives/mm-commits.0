Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90479379ED7
	for <mm-commits@vger.kernel.org>; Sat, 17 Oct 2026 02:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792203697; cv=none; b=jGCwDwMjJYlN4t4KBl76Aba+PwQ6od7eKtqEHFnw6q8eoccd8yJkzhtp8yXgO76gu7cTTffdMZhmj2iMAyZrFfgV3sww7sqZGDtkPDyrEdwYGIei6jZvi1kbCWhAQ5XKF0hZOqgHOspGLlkE2WZUDu7mGfn1Xk1GZuJOaeyYDyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792203697; c=relaxed/simple;
	bh=Iirutwm8PHN1O8i85EYylC0H9krUFHNc9etL6nY5yqs=;
	h=Date:To:From:Subject:Message-Id; b=l6zKeZzoOpDisFqKeOd0IpMe9RJSf72YzB35aL8f4a6ZgqNjbNBAfhbS+mVYFirZgPfNDQCIMcug3u+gzBso/IhPDOnMft9htXD1YFk3S58dN+0KCEfJtxC21rKdPrq0N975lTfGNg+UDdqvtbePZX5SfSmtrz4uRGRsQrUA16Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MLYmSN2R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MLYmSN2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7411F000C4;
	Sat, 17 Oct 2026 02:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792203696;
	bh=9PiOMUmSkVOch0aKDqpu794Jzm3OO3jn9ZudsT5tqng=;
	h=Date:To:From:Subject;
	b=MLYmSN2RNhgXpYQ3m/fKf/OXSOKj0tPWhLrXEbLBoi3R9fX/ZRjHYNxAQKtJju3De
	 xjG3ugeNBAxhZuUc2CpVTWLjs32JjcErvZ/g+t+cq6zLRJesWZMDU3G3OuIYsU7Mq+
	 HQPMzMmdIJ+aK0icCs6UeKPuKPoHWehfcC9jk5Fc=
Date: Fri, 16 Oct 2026 19:21:35 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,rppt@kernel.org,ritesh.list@gmail.com,joao.m.martins@oracle.com,dave.jiang@intel.com,alison.schofield@intel.com,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-warn-on-unaligned-compound-zone-device-ranges.patch added to mm-unstable branch
Message-Id: <20261017022136.0D7411F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: warn on unaligned compound zone device ranges
has been added to the -mm mm-unstable branch.  Its filename is
     mm-warn-on-unaligned-compound-zone-device-ranges.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-warn-on-unaligned-compound-zone-device-ranges.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: warn on unaligned compound zone device ranges
Date: Fri, 16 Oct 2026 21:13:34 +0800

A compound page of order N must start at a PFN aligned to 2^N pages. 
Therefore, a range used to initialize compound pages must start on a
compound-page boundary and contain an integral number of compound pages.

Two recent Device DAX bugs were caused by ranges that violated this
invariant, but neither was detected by memmap_init_zone_device().

Warn if the adjusted zone-device range violates this invariant so future
violations are reported when the compound pages are initialized.

Link: https://lore.kernel.org/20261016131334.3419393-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/r/20261016053944.2579541-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/r/20261016054914.2601510-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---

 mm/mm_init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mm_init.c~mm-warn-on-unaligned-compound-zone-device-ranges
+++ a/mm/mm_init.c
@@ -1142,6 +1142,8 @@ void __ref memmap_init_zone_device(struc
 	if (!nr_pages)
 		return;
 
+	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));
+
 	/*
 	 * Seed the reusable head-page template from the first real struct
 	 * page. The normal page-init and refcount helpers must operate on
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init-fix.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-warn-on-unaligned-compound-zone-device-ranges.patch


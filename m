Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711353ED111
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 19:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773690991; cv=none; b=XRA2Bz1fwe5OhduqpyqQEZy4ws9S4iPmRAu8XR7A72SFTS8MfOzsPRJ4i7LBeL06DR4AUGEnslLI1rmA8F4VTZYJjVg5gME/cIFWEoht70MPCR6MUKBDXiEEcwsnzU3oam2H0fo0tpqwRubgrMbNnABXgbF8UXouwpMMVf6WeDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773690991; c=relaxed/simple;
	bh=60efY1x/+67vV2eprX/IU6yUD/7n5IHV27Dsmf39qYw=;
	h=Date:To:From:Subject:Message-Id; b=Ysy7Lm5wVwvR0+rjIvmNoTxxR6fXyGz4W9N4SAmrUx6qHfIvTGNfL4+up9jw87T43OEa4HjgCU7BJcP6cntWjvRQk0mpwJ1tJ5jp4KXp48IOfme3lOFd5XhvJTwi2z7eLYNWw1vPJk8kDSCsaswmUWuIASsMEDiKbWsVrCQiDMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=galYK9Zv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="galYK9Zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C35C2BC9E;
	Mon, 16 Mar 2026 19:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773690990;
	bh=60efY1x/+67vV2eprX/IU6yUD/7n5IHV27Dsmf39qYw=;
	h=Date:To:From:Subject:From;
	b=galYK9ZvJyGQYaGJ8Lcosp6BvYzb6nb9RWz9puTSgK1rndPAC/oQr51CB8GUnqbJE
	 LbBpHv5CMtqBEDQkOh9XOHEzggMrIS8qm/yX0XLaLFMVJ+tnHQBicnvc3IjmPuHnQe
	 DxpBEaclZIDU8giDXP5FiR55DtqFepNLaR2zre0A=
Date: Mon, 16 Mar 2026 12:56:30 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-update-vmemmap_deduprst-fix.patch added to mm-unstable branch
Message-Id: <20260316195630.C9C35C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: update vmemmap_dedup.rst
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-update-vmemmap_deduprst-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-update-vmemmap_deduprst-fix.patch

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
From: Kiryl Shutsemau <kas@kernel.org>
Subject: hugetlb: update vmemmap_dedup.rst
Date: Mon, 2 Mar 2026 10:56:28 +0000

Update the documentation regarding vmemmap optimization for hugetlb to
reflect the changes in how the kernel maps the tail pages.

Fake heads no longer exist. Remove their description.

Link: https://lkml.kernel.org/r/20260302105630.303492-1-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/vmemmap_dedup.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/vmemmap_dedup.rst~hugetlb-update-vmemmap_deduprst-fix
+++ a/Documentation/mm/vmemmap_dedup.rst
@@ -128,8 +128,8 @@ The first page of ``struct page`` (page
 contains the 4 ``struct page`` necessary to describe the HugeTLB. The remaining
 pages of ``struct page`` (page 1 to page 7) are tail pages.
 
-The optimization is only applied when the size of the struct page is a power-of-2
-In this case, all tail pages of the same order are identical. See
+The optimization is only applied when the size of the struct page is a power
+of 2. In this case, all tail pages of the same order are identical. See
 compound_head(). This allows us to remap the tail pages of the vmemmap to a
 shared, read-only page. The head page is also remapped to a new page. This
 allows the original vmemmap pages to be freed.
@@ -143,7 +143,7 @@ Here is how things look after remapping:
  |           |                     |     1     | ------┐
  |           |                     +-----------+       |
  |           |                     |     2     | ------┼        +----------------------------+
- |           |                     +-----------+       |        | A single, per-node page    |
+ |           |                     +-----------+       |        | A single, per-zone page    |
  |           |                     |     3     | ------┼------> | frame shared among all     |
  |           |                     +-----------+       |        | hugepages of the same size |
  |           |                     |     4     | ------┼        +----------------------------+
_

Patches currently in -mm which might be from kas@kernel.org are

mm-move-max_folio_order-definition-to-mmzoneh.patch
mm-change-the-interface-of-prep_compound_tail.patch
mm-rename-the-compound_head-field-in-the-struct-page-to-compound_info.patch
mm-move-set-clear_compound_head-next-to-compound_head.patch
riscv-mm-align-vmemmap-to-maximal-folio-size.patch
loongarch-mm-align-vmemmap-to-maximal-folio-size.patch
mm-rework-compound_head-for-power-of-2-sizeofstruct-page.patch
mm-sparse-check-memmap-alignment-for-compound_info_has_mask.patch
mm-hugetlb-defer-vmemmap-population-for-bootmem-hugepages.patch
mm-hugetlb-refactor-code-around-vmemmap_walk.patch
x86-vdso-undefine-config_hugetlb_page_optimize_vmemmap-for-vdso32.patch
mm-hugetlb-remove-fake-head-pages.patch
mm-drop-fake-head-checks.patch
hugetlb-remove-vmemmap_synchronize_rcu.patch
mm-hugetlb-remove-hugetlb_optimize_vmemmap_key-static-key.patch
mm-remove-the-branch-from-compound_head.patch
hugetlb-update-vmemmap_deduprst.patch
hugetlb-update-vmemmap_deduprst-fix.patch
mm-slab-use-compound_head-in-page_slab.patch


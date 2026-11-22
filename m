Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795305713;
	b=QMJleOywCJrD9AZmoj52q3/S4C9yC2I24z9bjQ9uf391SXg2XeVzBlXx8Yhl9L98+htp
	 9obKdWYsG0TLhY/32CdvunUH2KXmdyroRMyytClPhXjKdDAuCIT6zhOdHNGdu++Glkvvk
	 AelH3hUl1CI8cDX4xZOTESeGS7I/jPf5TA0GDuOUmuQQcv0cyU+hStp4rd26fiWDXXVd2
	 s3VWeaS8V1L3KkRsP+xHGhC0EeaVIt8FZVw7hAG0Ukoi4C+oUyhL4og6np66nvFgZ/id4
	 levCbNU1PNot3Qt+wtYzfxgi4iWI5P85Huuem3jWTUIIq+DuyvmsZXPSSrNjtqEdWWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795305713;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=I+IIENFxLDP2luRj8b7Q6Jt6bDjOsblgFRuR2eKya5Y=;
	b=Yz/Ynm4Raa9BOxTTJ0Ku99FnXRPSSpKtq2xghNkMv4te24+W/Wes1lUU7WV0sU+SMISq
	 BfuvQhp1i/HC0BenjitgkR+iOffFJD4+4FWS3XaW0dam1U5IznT/SklXUOTj2FAOoYMq7
	 lyHNfv/NShhWkAjwAaTr3L3f27SroQ9iIdtKJM2nyfXvC7VgNUXpmFJx7gabGlL2VmNFL
	 a03Atmf2FNyAAmUiR5fP31h6w2HdZEIlG+yl1SxYZQEG0g3Z2MDtVuZ74i1sH4CTz5cAL
	 S68rUyvMvyCF1geL7ZXUxSxOmCwCrxM8rLgt2dIzmtOcHS3WzXx0ZS7Sp7+4TCa86cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L7ctKCUT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66516606A320;
	Sun, 22 Nov 2026 00:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L7ctKCUT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD16D1F000CF;
	Sun, 22 Nov 2026 00:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795305713;
	bh=I+IIENFxLDP2luRj8b7Q6Jt6bDjOsblgFRuR2eKya5Y=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=L7ctKCUTw+RgNuwtjAYYgifwsjJyq4dnrnerQISy+1n0US/0swM2FfZK6XMNuKTr/
	 K54A+dpyD/0xSKchPg/44Qp4/utDUiAwkPjsUKVMHo2PY7Iz1OIuIeyxCRDiE0ex0e
	 53K9oK1wijnNGeYVYIFmYRPgNG7sypst7f0uGGZc=
Date: Sat, 21 Nov 2026 16:01:52 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	thomas.hellstrom@linux.intel.com,stable@vger.kernel.org,sj@kernel.org,
	patchwork@emeril.freedesktop.org,mpenttil@redhat.com,matthew.brost@intel.com,
	ljs@kernel.org,leon@kernel.org,jgg@ziepe.ca,francois.dugast@intel.com,
	christian.koenig@amd.com,balbirs@nvidia.com,apopple@nvidia.com,
	akpm@linux-foundation.org,airlied@gmail.com,jm5905938@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <179342234355.4.16705453209886955762@gmail.com>
References: <179342234355.4.16705453209886955762@gmail.com>
Subject: + mm-hmm-account-for-subpage-offsets-in-device-private-pmds.patch added to mm-hotfixes-unstable branch
Message-Id: <20261122000152.DD16D1F000CF@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hmm: account for subpage offsets in device-private PMDs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hmm-account-for-subpage-offsets-in-device-private-pmds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hmm-account-for-subpage-offsets-in-device-private-pmds.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Aveline Noir <jm5905938@gmail.com>
Subject: mm/hmm: account for subpage offsets in device-private PMDs
Date: Sat, 31 Oct 2026 15:07:58 +1100

When a query starts inside a device-private PMD owned by
range->dev_private_owner, hmm_vma_handle_absent_pmd() still fills the PFN
array from the folio's first page.  The returned PFNs therefore refer to
earlier pages rather than the requested subrange.

Nouveau's GPU fault path can query one page of a device-private PMD at a
time.  Xe's SVM fault, prefetch and userptr mapping paths can also query
subranges of their own device-private PMDs.  An unprivileged process with
access to the GPU render node can reach these paths on hardware supporting
device-private THP migration.  Xe can read the wrong application data or
silently overwrite earlier pages of the same process's device-private
folio.

Nouveau aligns a one-page GPU fault to the PMD head by subtracting the
fault offset from the returned page.  The faulty HMM PFN already refers to
the head, so this subtraction can select a page before the folio.  If the
preceding page belongs to another allocation, GPU access can expose or
overwrite unrelated userspace data; an invalid page can also fault the
kernel during its address conversion.  This worst case follows from the
source, but has not been demonstrated on a real GPU.

Add the query's PMD-relative page offset to the initial PFN, as the
present PMD path already does.

The device-private PMD migration machinery first shipped in 6.19. 
Backport this fix to the maintained 7.3.y stable series; the HMM path
exists in 6.18.y but cannot be reached through an in-tree PMD-producing
device-private migration path there.

Link: https://patch.msgid.link/179342234355.4.16705453209886955762@gmail.com
Fixes: 10b9feee2d0d ("mm/hmm: populate PFNs from PMD swap entry")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: https://lore.kernel.org/20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Patchwork <patchwork@emeril.freedesktop.org>
Cc: SJ Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>

 mm/hmm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hmm.c~mm-hmm-account-for-subpage-offsets-in-device-private-pmds
+++ a/mm/hmm.c
@@ -355,7 +355,8 @@ static int hmm_vma_handle_absent_pmd(str
 	    range->dev_private_owner) {
 		unsigned long cpu_flags = HMM_PFN_VALID |
 			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
-		unsigned long pfn = softleaf_to_pfn(entry);
+		unsigned long pfn = softleaf_to_pfn(entry) +
+			((start & ~PMD_MASK) >> PAGE_SHIFT);
 		unsigned long i;
 
 		if (softleaf_is_device_private_write(entry))
_

Patches currently in -mm which might be from jm5905938@gmail.com are

mm-hmm-account-for-subpage-offsets-in-device-private-pmds.patch
mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch
mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch
mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch
docs-admin-guide-mm-damon-start-fix-grammar.patch
docs-admin-guide-mm-damon-stat-fix-pronoun-agreement.patch
docs-admin-guide-mm-damon-usage-fix-grammar.patch
docs-admin-guide-mm-damon-lru_sort-fix-remaining-grammar.patch
docs-mm-damon-design-fix-grammar-and-typos.patch
docs-mm-damon-api-fix-verb-form.patch
docs-mm-damon-maintainer-profile-fix-subject-verb-agreement.patch
docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos.patch
mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion.patch
mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion-fix.patch


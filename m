Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23493312832
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 19:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782932646; cv=none; b=LA74ZsZauCe8k+AMqFYQTkiGm25dzXaIiBQUbp4JdFpqdZRWh0rE2LOBk9vEyFBd8aUlmTEosMKq/88G0Z8OsHLENVrXqNrz2lhXAJB/NVt4JkAkOCG/h8dQtsG1AAUiZdfhbaV9df3V3xwX55KEC6ohzgMCQ1Z8ZxpStg0rbzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782932646; c=relaxed/simple;
	bh=fmWlpfkHLUKIjjMtxumGSfEwe2auzSeQ4MxF2PNOFIs=;
	h=Date:To:From:Subject:Message-Id; b=fTQU1YH8kCcDiQC9bstJNYEMBx/Sw4SuKxn/knY32aY0mo86Ojf6jKBCEZEur1erECBmbEokWKaZHoqVdo8dWNBqJicLJVpMdxjDA8ycDPBZZiTuqIY2jAuks5sZ47REIxSJPrd2aULy23RaWvahNKAJaYj8QY+HSUu2CPfepLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nMfvdJHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nMfvdJHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC471F000E9;
	Wed,  1 Jul 2026 19:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782932644;
	bh=BHRWDt+x+tVBmBiOkigaPDdeWNOZm7KDO4Gehkzf44k=;
	h=Date:To:From:Subject;
	b=nMfvdJHNfSP46ODHShDr/9n+wLRpfwiJULHipm9GYkivLTR72yQIGy1S8vyNrQtYb
	 UlZD1oTChCOL5o3MuVkFzN9GWtZbdCKyFzmgcmREoTALIXR1TKD6OzZ+OxVOK+W2E8
	 lcikthUVpTaGbUJokIkSWkujT6nx8CoATLRR2JbM=
Date: Wed, 01 Jul 2026 12:04:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sj@kernel.org,richard.weiyang@gmail.com,ljs@kernel.org,lance.yang@linux.dev,klarasmodin@gmail.com,david@kernel.org,balbirs@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_vma_mapped-fix-device-private-pmd-handling-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20260701190404.8DC471F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_vma_mapped-fix-device-private-pmd-handling-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_vma_mapped-fix-device-private-pmd-handling-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_vma_mapped-fix-device-private-pmd-handling-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_vma_mapped-fix-device-private-pmd-handling-fix
Date: Wed Jul  1 12:00:04 PM PDT 2026

fix Raspberry Pi 1 build, per David

Reported-by: Klara Modin <klarasmodin@gmail.com>
Tested-by: Klara Modin <klarasmodin@gmail.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-fix-device-private-pmd-handling-fix
+++ a/mm/page_vma_mapped.c
@@ -243,8 +243,9 @@ restart:
 		 */
 		pmde = pmdp_get_lockless(pvmw->pmd);
 
-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
-		    pmd_is_device_private_entry(pmde)) {
+		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		    (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
+		    pmd_is_device_private_entry(pmde))) {
 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
 			pmde = *pvmw->pmd;
 			if (pmd_is_migration_entry(pmde)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_vma_mapped-fix-device-private-pmd-handling-fix.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch
mm-page_owner-add-print_mode-filter-fix.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8C0258EF0
	for <mm-commits@vger.kernel.org>; Fri,  3 Oct 2025 23:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759534997; cv=none; b=ANZr2xEXn2z3eIV7qyvygtBY0EKRfw+VIgfBHIb2byteDMJoOPhnzVR5g/MSHBZ+AArYPha9ItJxKZ4woflIEtzbRKg8LuWcb4DlSbzyELuJQAOdbXhetoMnhGSDXxW+QZFgC5XfwaiouYjZhtDfsFX8CS32WuLlI3CpsNIW1/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759534997; c=relaxed/simple;
	bh=fYN8Yo74FkjOXRFjBsahzTxAL6E4ombi45QR/eE8TY8=;
	h=Date:To:From:Subject:Message-Id; b=DWMA8/aTeR36TuMQrmCDu4Cl2Cd0jaYzaalY4NETDyu9fXONLCeBlFVGsAW43AhxzWvY+SOyUMazyphSxOojR4b6SzZpSzFSA5BPWvyPFC33+1ltmz9B2w2Fs3gEXpvLfw8x4QzN3kIk5NQwnVNRQtuANBlVufJWA3AaC27hM48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pQyZyX0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pQyZyX0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61379C4CEF5;
	Fri,  3 Oct 2025 23:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759534997;
	bh=fYN8Yo74FkjOXRFjBsahzTxAL6E4ombi45QR/eE8TY8=;
	h=Date:To:From:Subject:From;
	b=pQyZyX0qPl3cZ57M/Qe2cTxKApheib3eB/qOnYOQsmLOEk87/EkeyYFmpXRC/lAJw
	 55y3e3DkRzsgdsZ0YdkvndBnR8wp+LJ16QOgZj4Pm4RYhYaWMH6ZU/aG4f5tu3W4T3
	 OmBDT1q1UPTXF+yKtuzXtcSsy2bYGqBJRDfsxZak=
Date: Fri, 03 Oct 2025 16:43:16 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,dev.jain@arm.com,david@redhat.com,apopple@nvidia.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-mm-drop-pxx_mkdevmap-descriptions-from-page-table-helpers.patch removed from -mm tree
Message-Id: <20251003234317.61379C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/mm: drop pxx_mkdevmap() descriptions from page table helpers
has been removed from the -mm tree.  Its filename was
     documentation-mm-drop-pxx_mkdevmap-descriptions-from-page-table-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Documentation/mm: drop pxx_mkdevmap() descriptions from page table helpers
Date: Mon, 29 Sep 2025 13:00:45 +0100

Remove pxx_mkdevmap() descriptions, as these helper functions have already
been dropped (including DEBUG_VM_PGTABLE test) via the commit d438d2734170
("mm: remove devmap related functions and page table bits").

Link: https://lkml.kernel.org/r/20250929120045.1109707-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/arch_pgtable_helpers.rst |    6 ------
 1 file changed, 6 deletions(-)

--- a/Documentation/mm/arch_pgtable_helpers.rst~documentation-mm-drop-pxx_mkdevmap-descriptions-from-page-table-helpers
+++ a/Documentation/mm/arch_pgtable_helpers.rst
@@ -52,8 +52,6 @@ PTE Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pte_mkspecial             | Creates a special PTE                            |
 +---------------------------+--------------------------------------------------+
-| pte_mkdevmap              | Creates a ZONE_DEVICE mapped PTE                 |
-+---------------------------+--------------------------------------------------+
 | pte_mksoft_dirty          | Creates a soft dirty PTE                         |
 +---------------------------+--------------------------------------------------+
 | pte_clear_soft_dirty      | Clears a soft dirty PTE                          |
@@ -124,8 +122,6 @@ PMD Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pmd_mkspecial             | Creates a special PMD                            |
 +---------------------------+--------------------------------------------------+
-| pmd_mkdevmap              | Creates a ZONE_DEVICE mapped PMD                 |
-+---------------------------+--------------------------------------------------+
 | pmd_mksoft_dirty          | Creates a soft dirty PMD                         |
 +---------------------------+--------------------------------------------------+
 | pmd_clear_soft_dirty      | Clears a soft dirty PMD                          |
@@ -185,8 +181,6 @@ PUD Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pud_wrprotect             | Creates a write protected PUD                    |
 +---------------------------+--------------------------------------------------+
-| pud_mkdevmap              | Creates a ZONE_DEVICE mapped PUD                 |
-+---------------------------+--------------------------------------------------+
 | pud_mkinvalid             | Invalidates a present PUD; do not call for       |
 |                           | non-present PUD [1]                              |
 +---------------------------+--------------------------------------------------+
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-thp-drop-follow_devmap_pmd-default-stub.patch
mm-ptdump-replace-read_once-with-standard-page-table-accessors.patch


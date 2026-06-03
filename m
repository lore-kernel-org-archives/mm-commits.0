Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1B14DC551;
	Wed,  3 Jun 2026 23:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780529195; cv=none; b=umJHEz2i2om9CQpQ/IaUnb046MzQcVAzD5hQllVPGfEUpNS63RDjPhn23Gqa8Rii/MlZzEU5iyilY8ZA/NVezbUZ5JkBPtpqxDfJ8AoUyNSzymUohr+swLs61q9N9mAxc4Es9YAhAllp5tEmtL5Ufl4vdePU/4gLvvMxfP+V4Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780529195; c=relaxed/simple;
	bh=9RMrajPBRgMjN5Ny4+hK0lvwl7xY3jyaIHsa2Dv9/UU=;
	h=Date:To:From:Subject:Message-Id; b=M7YlBCUn1WGYuSdzEgvnDtOCm+52MrePsOGlwGmGBgdU49NKqWfdScK0aG1O45rav5+n+URe903oimEZqMlFEaC5a9sYTls4FtqLMoA3iQQbKDS74yyWCgMQCWjvcxxJWyaGIAAGrX/1gazFVB6c3cRVWtN7xzODN4A/GadXGlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CpX3ucDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CpX3ucDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCCA1F00898;
	Wed,  3 Jun 2026 23:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780529194;
	bh=pr8BqlPbv62/bT+dYsH4Zg/A66Ca3ZwPzLMvc4a36O4=;
	h=Date:To:From:Subject;
	b=CpX3ucDyH4MaHw/eb5XSdfxsDFipiQT1omV/DwijgbywDuBj0oUe0YwcMvls87eME
	 oq7ZWw2N5KUx33cnRB7MQFv37N+9p6RiLMGlZp/w9O+KCtlAnWhobDDQrYYe1RtXzA
	 ogV3bWPAZlVe6vm0EVSIi+I8+UY4bzNtBQczxnbQ=
Date: Wed, 03 Jun 2026 16:26:33 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,riel@surriel.com,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,jannh@google.com,hannes@cmpxchg.org,chrisl@kernel.org,baoquan.he@linux.dev,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mincore-handle-non-swap-entries-before-config_swap-guard.patch removed from -mm tree
Message-Id: <20260603232634.3CCCA1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mincore: handle non-swap entries before !CONFIG_SWAP guard
has been removed from the -mm tree.  Its filename was
     mm-mincore-handle-non-swap-entries-before-config_swap-guard.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/mincore: handle non-swap entries before !CONFIG_SWAP guard
Date: Tue, 2 Jun 2026 10:22:47 -0700

mincore_swap() also fields migration/hwpoison entries (and shmem
swapin-error entries), which can exist on !CONFIG_SWAP builds when
CONFIG_MIGRATION or CONFIG_MEMORY_FAILURE is enabled.  The
!IS_ENABLED(CONFIG_SWAP) guard ran before the non-swap-entry early return,
so mincore_pte_range() can spuriously WARN and report these pages
nonresident on !CONFIG_SWAP kernels.

Move the guard below the non-swap-entry check so only true swap entries
trip the WARN, and migration/hwpoison entries take the existing "uptodate
/ non-shmem" path.

Link: https://lore.kernel.org/20260602172247.279421-1-usama.arif@linux.dev
Fixes: 1f2052755c15 ("mm/mincore: use a helper for checking the swap cache")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/mincore.c~mm-mincore-handle-non-swap-entries-before-config_swap-guard
+++ a/mm/mincore.c
@@ -64,11 +64,6 @@ static unsigned char mincore_swap(swp_en
 	struct folio *folio = NULL;
 	unsigned char present = 0;
 
-	if (!IS_ENABLED(CONFIG_SWAP)) {
-		WARN_ON(1);
-		return 0;
-	}
-
 	/*
 	 * Shmem mapping may contain swapin error entries, which are
 	 * absent. Page table may contain migration or hwpoison
@@ -77,6 +72,11 @@ static unsigned char mincore_swap(swp_en
 	if (!softleaf_is_swap(entry))
 		return !shmem;
 
+	if (!IS_ENABLED(CONFIG_SWAP)) {
+		WARN_ON(1);
+		return 0;
+	}
+
 	/*
 	 * Shmem mapping lookup is lockless, so we need to grab the swap
 	 * device. mincore page table walk locks the PTL, and the swap
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-bypass-mmap_miss-heuristic-for-vm_exec-readahead.patch
mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch


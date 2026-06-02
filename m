Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB62C23ED6A;
	Tue,  2 Jun 2026 19:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780429626; cv=none; b=NptuMZ1gW19HO8Z0kR+1VFDnpyY7Pv/aC8YzPIFm8Xl6GfNsgaTg+ImhLSoPLoaoT9TfBM5MSS+tHDMxZIXXRDhepx3TzgHOmRaPHQTODK0aXKPn3zLGzD/O03azzwvAhERK5rFzep+c/L7XYM1AjC6iL68Hp2iGNx7QdA8Fy+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780429626; c=relaxed/simple;
	bh=988h3oP0ZzvxnJLyczvTbKwHgWEgSI5Yq494RePLLIg=;
	h=Date:To:From:Subject:Message-Id; b=mkaqBdrWpQ4PYaNs0nmUSTjWJ5/oFnvJGdq051SWy7QDr5NFrFgfFWXaDmKbdnVVX/tHpjQKuBeQQ78ymrZDpl7v0zRDtYvBHoHkMkY/QnHz0CocGahBncYvagUWrAudrHCbXziaLqTAvL94xtMpup+48NeO4dPVqpGkpNA55g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T/geGRJq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T/geGRJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD591F00893;
	Tue,  2 Jun 2026 19:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780429624;
	bh=GZz9RP0mu2Kh7gwi2ngE+Hf6GzJWvrjBXMa52H2h/HU=;
	h=Date:To:From:Subject;
	b=T/geGRJqC8Et2jAWiGv7idaRfWpiju3h6blgs1f+/xkc/dZS5dWahBqYULkySJtQ3
	 Za0itEVcvk9ezWyNj9w3yKQ6jHk2vEm2bi7iRT1Vs3be7NUDhXxPA6obWVf3g4h5gR
	 7zk94UZUqH8YUCi7cXT3aTZ8yn+Av8LqUqSiFlsQ=
Date: Tue, 02 Jun 2026 12:47:03 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,riel@surriel.com,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,jannh@google.com,hannes@cmpxchg.org,chrisl@kernel.org,baoquan.he@linux.dev,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-handle-non-swap-entries-before-config_swap-guard.patch added to mm-hotfixes-unstable branch
Message-Id: <20260602194704.4DD591F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mincore: handle non-swap entries before !CONFIG_SWAP guard
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mincore-handle-non-swap-entries-before-config_swap-guard.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-handle-non-swap-entries-before-config_swap-guard.patch

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
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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

mm-mincore-handle-non-swap-entries-before-config_swap-guard.patch
mm-make-mmap_miss-accounting-symmetric-for-vm_seq_read.patch
mm-bypass-mmap_miss-heuristic-for-vm_exec-readahead.patch
mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch


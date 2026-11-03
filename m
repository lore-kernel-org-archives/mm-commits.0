Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793739856;
	b=v7IROlCpHVDbvMyrQXaeGKmf3NOeMU3YOyjRADLQrDzYpMBiU5kqxSEX5s4oX90b+XOe
	 FGAwuO57iMtZEDOo3K/4gEscPHSkZ9Cj1y9QJR1e6vKy17E2Z7E5kpo1upgIDmXQNpC9Q
	 MGjG/RJuCMha3Ya1O/Us+A+l1s8Gic8zNfXr2iq+ZuuWU+oIzGv1CU2P0WhDL9gE+CWXa
	 jlaJ7p/zOCXeO5A7T4+1+4UpblimLyzexUcDLh4vOu9xzwN95XZP1TRhifXc2+k0Lh2xX
	 5QCsv2xFC6gyiFqXvi6VI/tpG8cWjbyL/eBaKJTsIWUG+v1t+OyJQ56F86ZD3eYClnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793739856;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=tPkmbS/DcQdR15psKi510VxebKD/kAOekTPxwWImK8k=;
	b=J2nMNmnXsENJCzENaGV8c+19Y2G9NQV/ZlxysRVGbbGQh/qm+IBYFY55sJ7XfC7oE48m
	 JGLvAG4YV7H3kgnfBnq9vwiesdzjknm1AlNyRphqx4iyeSfKGP/v1WzWGWumY7AvpuuWz
	 1NbVCGZR/uGCURmsolzPsVjPsgMKXffuotSTiFN1oTTDx/0nO4InPVINgi7qBmiB4IceM
	 aCtQ7Qosx7KXnnxaynb9h/F7uHylF2DrLzsZ/9/+L7qXQ699I5Z0AggeeQhOX3FYJeAKt
	 rDkXwwkKBcB7eFAobOMIoxr0YvZ5xmpPYg//2r3SZr/XhMvauDoYVp6qSSav0QusVwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FAuS6O43;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507B0606A326
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 21:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FAuS6O43
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF511F00A16;
	Tue,  3 Nov 2026 21:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793739855;
	bh=tPkmbS/DcQdR15psKi510VxebKD/kAOekTPxwWImK8k=;
	h=Date:To:From:Subject;
	b=FAuS6O43J2CKDacxAQRLriXKRUqGlwgAxbzT7GtlLU5aqlzGTUfIV9p9mbFG8pSHK
	 GSaCFe/XioFg8ADESTWT7TXwn5Q/o+hhocuWkPEXgPP3poLsg+pA/Pbcv5MS5oo190
	 RajOl0aHSr8jj/zIKMWoxsmR6Xk2MEKX/Ma2BTNo=
Date: Tue, 03 Nov 2026 13:04:15 -0800
To: mm-commits@vger.kernel.org,wujianyue000@gmail.com,
	shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,
	kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,
	baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-drop-the-swap-cache-guard-and-reclaim-in-swap_free_hibernation_slot.patch added to mm-new branch
Message-Id: <20261103210415.BBF511F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm, swap: drop the swap cache guard and reclaim in swap_free_hibernation_slot()
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-drop-the-swap-cache-guard-and-reclaim-in-swap_free_hibernation_slot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-drop-the-swap-cache-guard-and-reclaim-in-swap_free_hibernation_slot.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm, swap: drop the swap cache guard and reclaim in swap_free_hibernation_slot()
Date: Wed, 04 Nov 2026 00:25:47 +0800

Both are there for a folio that readahead might have put on the slot.  A
hibernation entry is not a shadow and has no swap count, so the swap cache
turns it away and no such folio can exist.

Link: https://lore.kernel.org/20261104-swap-hibernation-slots-v4-3-0ba9393609e1@tencent.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Jianyue Wu <wujianyue000@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/swapfile.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/mm/swapfile.c~mm-swap-drop-the-swap-cache-guard-and-reclaim-in-swap_free_hibernation_slot
+++ a/mm/swapfile.c
@@ -2227,18 +2227,8 @@ void swap_free_hibernation_slot(swp_entr
 	pgoff_t offset = swp_offset(entry);
 
 	ci = swap_cluster_lock(si, offset);
-	/*
-	 * A slot with a folio in the swap cache is freed when the folio
-	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
-	 * Readahead can put a folio here, and freeing the slot now would
-	 * leave that folio with no entry behind it.
-	 */
-	if (!swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
-		__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
+	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
 	swap_cluster_unlock(ci);
-
-	/* In theory readahead might add it to the swap cache by accident */
-	__try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
 }
 
 static int __find_hibernation_swap_type(dev_t device, sector_t offset)
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swap-only-allow-swapped-out-slots-into-the-swap-cache.patch
mm-swap-give-hibernation-swap-slots-their-own-swap-table-entry-type.patch
mm-swap-drop-the-swap-cache-guard-and-reclaim-in-swap_free_hibernation_slot.patch


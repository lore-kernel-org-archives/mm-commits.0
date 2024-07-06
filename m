Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798E7134A9
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720291582; cv=none; b=LR2aIJd9wtdDDhvkoql4oxshtkDA/uCIBnJDEX3Airgn0TtCMi3huDsuX4aBOPFO0ST4BmzizKQ94P4ZyKfpmAzZkMEqE9/uK7lWV0lEgfLbG0lBwGMeUplce/Hi/rPpf/c7J5zgrhOCeFNkPzC+mAa8/q9uXohpVRLwG/E0ou4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720291582; c=relaxed/simple;
	bh=6myqmtCIiF2mhgjjI3/pOf7AYx/FtL40ALbx8ibiNUA=;
	h=Date:To:From:Subject:Message-Id; b=Vvvkrfsy2BC3jVRRD83zrshE7PMxzFDTwSyqT4TXGkDow+zjqNEueI9paSdTqNckYZ+zieclbN9aVE7CqbX81YW3snWDcvTpGng3jAOZFEkTRsiZuqs14byVKE4nEZf85JB/nbOTgt3LaN1JAHY/rPr8zbH6+AQYQOCI+/dlQ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CTDWFAmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CTDWFAmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A4AC2BD10;
	Sat,  6 Jul 2024 18:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720291582;
	bh=6myqmtCIiF2mhgjjI3/pOf7AYx/FtL40ALbx8ibiNUA=;
	h=Date:To:From:Subject:From;
	b=CTDWFAmxZ/FaMLIgWx7VAZJeM/mhOUBPe+jI5M2V6eh5yuaKjqsx1py/U+g14Utbi
	 8b2PxuPJDRgMC+FOUi2gxhK9XuP3dGj4IVaCTNh/oe8yfYZqKOsL9IiXnWnw0ndCM3
	 kDfvWtLBf7w5s5bH8PH4iXwC3bBDjH/RFmkNO6OE=
Date: Sat, 06 Jul 2024 11:46:21 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix.patch removed from -mm tree
Message-Id: <20240706184621.F2A4AC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix
has been removed from the -mm tree.  Its filename was
     mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix.patch

This patch was dropped because it was folded into mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix
Date: Thu Jun 27 01:16:00 PM PDT 2024

reflow to 80 cols

Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix
+++ a/mm/swapfile.c
@@ -3181,11 +3181,11 @@ SYSCALL_DEFINE2(swapon, const char __use
 	}
 
 	/*
-	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
-	 * be above MAX_PAGE_ORDER incase of a large swap file.
+	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order
+	 * might be above MAX_PAGE_ORDER incase of a large swap file.
 	 */
-	p->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(unsigned long),
-				    GFP_KERNEL | __GFP_ZERO);
+	p->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages),
+				sizeof(unsigned long), GFP_KERNEL | __GFP_ZERO);
 	if (!p->zeromap) {
 		error = -ENOMEM;
 		goto bad_swap_unlock_inode;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix.patch


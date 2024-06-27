Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB36819EECE
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 20:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719519483; cv=none; b=i1QHpMzGvTmTsPjKVAcFEtA1cJjhkMUDE3KIF11g1Efc3GDloPHvIE4IMN0nCYuuMGCVRbTmvB5vICBgblnUzneBcTT/idC85k62EFMeL2LMtll1g1NJEPFQK2PxHWoc160SQCqSbJJQdqfOIHKq1W+hU8KAvItdPVlwikeQqnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719519483; c=relaxed/simple;
	bh=IxgCdOClMGn6Di6ezjDqx2eC1YTCXnG2WYNFvogP5JY=;
	h=Date:To:From:Subject:Message-Id; b=uJ+TisMaoZFP3YmTDxcaScvKXiMn4cbjSH6WON/AEaeeGmVYDSKKHumKQnfxvrr9ua/0XrPsGIs/1wD4ikd2L6oMRBsFS85EDlilctZqWrUAs7W4c3e9a+EPcSvoEjgb+4sGiYmNzT8+w7xrinFRM7EzUvXwHucPqwrd0PEF1Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=upS9TOHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="upS9TOHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2412EC2BBFC;
	Thu, 27 Jun 2024 20:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719519482;
	bh=IxgCdOClMGn6Di6ezjDqx2eC1YTCXnG2WYNFvogP5JY=;
	h=Date:To:From:Subject:From;
	b=upS9TOHiHuTXPoLWOOLR5c4i9itW/AhmKr50JyKf6uZsJrhIx53owwBTBJXPOLcQA
	 +izYQ+xTW9CZx0Y4QnouVlwb25MltbJ55aOF+nBYSP7OaadPNAK2X8hPyvLy3Wpfns
	 8DG5K5HCTFdh5JrsOZ20gHZzZrKr7aGEFkvgeHAc=
Date: Thu, 27 Jun 2024 13:18:01 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,shakeel.butt@linux.dev,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chengming.zhou@linux.dev,ak@linux.intel.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7.patch added to mm-unstable branch
Message-Id: <20240627201802.2412EC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7
has been added to the -mm mm-unstable branch.  Its filename is
     mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7
Date: Thu, 27 Jun 2024 11:55:29 +0100

Change to kvmalloc_array for zeromap allocation instead of kvzalloc as it
does an additional overflow check, and use sizeof(unsigned long) for
allocation size calculation to take into account 32 bit kernels.

Link: https://lkml.kernel.org/r/20240627105730.3110705-2-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7
+++ a/mm/swapfile.c
@@ -3170,7 +3170,12 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap_unlock_inode;
 	}
 
-	p->zeromap = kvzalloc(DIV_ROUND_UP(maxpages, 8), GFP_KERNEL);
+	/*
+	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
+	 * be above MAX_PAGE_ORDER incase of a large swap file.
+	 */
+	p->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(unsigned long),
+				    GFP_KERNEL | __GFP_ZERO);
 	if (!p->zeromap) {
 		error = -ENOMEM;
 		goto bad_swap_unlock_inode;
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v6.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7.patch
mm-remove-code-to-handle-same-filled-pages.patch


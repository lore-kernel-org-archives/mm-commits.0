Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E203819F470
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 20:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719519484; cv=none; b=oQIKfb0vI5DdWovH4qNqhWFzjoHae3i43CaW+IgVP+4laimh9/ImEjrPgmL4l97+Im/MvDmUydK6W7aywVmLsaXyY7T3daidBQiYX+LFceF0SYVKSKgoYCb2wEXy7FO9rLGPet9snpY9oTkmSUxOcyZykCUbWDUGBWvwX5mYT04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719519484; c=relaxed/simple;
	bh=VUMr8kvEZhph3SeuZkhJyXXrAr9hDZ/VbSIWs+6/wlY=;
	h=Date:To:From:Subject:Message-Id; b=Ft18jHFjknp35rlsCtMJwKR4CIqw71SM9Yd2RS4gZnhcajpnSBPN3fr2oJsyDuLHS1CS9ZnvMkbXdGjsjy6SkpnW0Mm9+xD1SBM66OCDdGlOEn3XTNKVDIj2iyHjyU6/rdC7l3WuVUHl4k1+IFWUgiJxegU747RGvaLD1sVfoiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OhsGZWNZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OhsGZWNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCBFC32789;
	Thu, 27 Jun 2024 20:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719519483;
	bh=VUMr8kvEZhph3SeuZkhJyXXrAr9hDZ/VbSIWs+6/wlY=;
	h=Date:To:From:Subject:From;
	b=OhsGZWNZXNxB6XL6ocSCE2SrOyBAwm7co4RKGOzZ7YRV18HIhuqSNv4b4hBK/uyB9
	 RyM2p9/vGE8a6k2YlChcSG83dlYBZai2kPGr3PGsdbHcf2/TjfCO2gfuST/HOSB1jJ
	 q6CByH5o1L21OR2LumHCBcB31n7COIVuGHPsewo4=
Date: Thu, 27 Jun 2024 13:18:02 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix.patch added to mm-unstable branch
Message-Id: <20240627201803.6FCBFC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix.patch

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
@@ -3171,11 +3171,11 @@ SYSCALL_DEFINE2(swapon, const char __use
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

mm-huge_memoryc-fix-used-uninitialized.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch


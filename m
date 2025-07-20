Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F3B13AD3F
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976911; cv=none; b=HxVBzRS/x0IAItNT6elnPYIojxLSRJNaEnFR62b6bsTVzBwRutf0TG6kyDzoX0UleFUU+Z2m4xHHOtR7o+/z/CV/Ayy2NDCsuqWpWam0SCQjzukVfv4eK8FLPy/t11Au4agX++REwTzjttvFTDBPPvbQ00HC/ZzfLt7iyuYaaGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976911; c=relaxed/simple;
	bh=drKa/wBEnRuMP3hOJvpQ4x/6+Y7YeKUOEgBCIOoS8g8=;
	h=Date:To:From:Subject:Message-Id; b=M2jcAdfce0sVWd+0nOwDyVUcom37m7y3jnp1+nxZCXGJmt57KLDEQDxun/cG1Qx66KbDxfNlgU2oPeWNDoBjSgBhatvH10CVCV29XrjJCY6tk5KsbJDX3KJZh3CGk7YhqaiGUiUpzZBlML6XltPVfLvFfIbSOc7w7ZfwuA9TDt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p/BzU8bI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p/BzU8bI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C53C4CEE3;
	Sun, 20 Jul 2025 02:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976911;
	bh=drKa/wBEnRuMP3hOJvpQ4x/6+Y7YeKUOEgBCIOoS8g8=;
	h=Date:To:From:Subject:From;
	b=p/BzU8bI2EsZ7mDOQhFjkjGz7mHZLpaP2h5QtmFJHYZpVz78ozshoqwCCxWoNMVUF
	 KUrHv/2sQ+ipKgdFiqYI2tQ9SzBVs+dM/ukR5ZlP2UVMomCIi2zoChJLWm3RVaBwXD
	 SkbGcetyKy9xBPN8VFDtxT85NeA7D9IpegxwzzU0=
Date: Sat, 19 Jul 2025 19:01:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,linux@jordanrome.com,david@redhat.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memoryc-use-folios-in-__access_remote_vm.patch removed from -mm tree
Message-Id: <20250720020151.97C53C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory.c: use folios in __access_remote_vm()
has been removed from the -mm tree.  Its filename was
     mm-memoryc-use-folios-in-__access_remote_vm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/memory.c: use folios in __access_remote_vm()
Date: Wed, 9 Jul 2025 12:40:17 -0700

Use kmap_local_folio() instead of kmap_local_page().  Replaces 2 calls to
compound_head() with one.

This prepares us for the removal of unmap_and_put_page().

Link: https://lkml.kernel.org/r/20250709194017.927978-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jordan Rome <linux@jordanrome.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-memoryc-use-folios-in-__access_remote_vm
+++ a/mm/memory.c
@@ -6691,6 +6691,7 @@ static int __access_remote_vm(struct mm_
 	while (len) {
 		int bytes, offset;
 		void *maddr;
+		struct folio *folio;
 		struct vm_area_struct *vma = NULL;
 		struct page *page = get_user_page_vma_remote(mm, addr,
 							     gup_flags, &vma);
@@ -6722,21 +6723,22 @@ static int __access_remote_vm(struct mm_
 			if (bytes <= 0)
 				break;
 		} else {
+			folio = page_folio(page);
 			bytes = len;
 			offset = addr & (PAGE_SIZE-1);
 			if (bytes > PAGE_SIZE-offset)
 				bytes = PAGE_SIZE-offset;
 
-			maddr = kmap_local_page(page);
+			maddr = kmap_local_folio(folio, folio_page_idx(folio, page) * PAGE_SIZE);
 			if (write) {
 				copy_to_user_page(vma, page, addr,
 						  maddr + offset, buf, bytes);
-				set_page_dirty_lock(page);
+				folio_mark_dirty_lock(folio);
 			} else {
 				copy_from_user_page(vma, page, addr,
 						    buf, maddr + offset, bytes);
 			}
-			unmap_and_put_page(page, maddr);
+			folio_release_kmap(folio, maddr);
 		}
 		len -= bytes;
 		buf += bytes;
_

Patches currently in -mm which might be from vishal.moola@gmail.com are



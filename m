Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632443451C6
	for <mm-commits@vger.kernel.org>; Thu, 29 Jan 2026 23:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769729107; cv=none; b=hAAZfQpD2M9TR0YdaTN9RbjZxYGcROPgyMw1HJkTm4jtIljrbXxCesic5+U6j+MYdSZsejLvaaTiE64RDG9xLbV46wjBb0Ms9BhsIasTcsfnYJwgpdzcorIntYjOTJurzhmwdCxj1v51NRVIBhS7eUL1N8MuZ0rOwLfSWeYltvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769729107; c=relaxed/simple;
	bh=99Xy8y6FRgMBA+KLO/OIyIF0sMrYqptM+qxe9EuxXQE=;
	h=Date:To:From:Subject:Message-Id; b=Hk+PX2sUNzVjt8w2qqjMZRfe8Ijf2V1J8Tj8CfEMloRPINhxl5eO1L0fgkXKeB44yQxkpbN76FX2DNdgu7AR1B2F+EN8ppUstsbgIn85Kfv+10O+HHB4qtjYXi6MXiNYZcDcImrDbSoTn2R1D6oiIi89olSrWTHj8Kh37/PsGEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xzLum2Ew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xzLum2Ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC9FC4CEF7;
	Thu, 29 Jan 2026 23:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769729106;
	bh=99Xy8y6FRgMBA+KLO/OIyIF0sMrYqptM+qxe9EuxXQE=;
	h=Date:To:From:Subject:From;
	b=xzLum2EwyIdPX6iTZGFUmlk+FD1Pv+/mVGMdi8nzvHdVWAk/jD7ehcKp3GNWeF6sp
	 Zu232SCt+XuAn/2cNKKVBr0BSsjxh/iA2Bb0MSxpkzP+fTi8VOObop+beJFw1+mGPo
	 tPYUlcDU2JXOZiel2O07bvjshLGhsxx22lcDsrrk=
Date: Thu, 29 Jan 2026 15:25:06 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rientjes@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,bgeffon@google.com,arjunroy@google.com,greenjustin@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-vma_map_pages-to-use-vm_insert_pages.patch added to mm-new branch
Message-Id: <20260129232506.CDC9FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: refactor vma_map_pages to use vm_insert_pages
has been added to the -mm mm-new branch.  Its filename is
     mm-refactor-vma_map_pages-to-use-vm_insert_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-refactor-vma_map_pages-to-use-vm_insert_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Justin Green <greenjustin@chromium.org>
Subject: mm: refactor vma_map_pages to use vm_insert_pages
Date: Wed, 28 Jan 2026 17:56:47 -0500

vma_map_pages currently calls vm_insert_page on each individual page in
the mapping, which creates significant overhead because we are repeatedly
spinlocking.  Instead, we should batch insert pages using vm_insert_pages,
which amortizes the cost of the spinlock.

Tested through watching hardware accelerated video on a MTK ChromeOS
device.  This particular path maps both a V4L2 buffer and a GEM allocated
buffer into userspace and converts the contents from one pixel format to
another.  Both vb2_mmap() and mtk_gem_object_mmap() exercise this pathway.

Link: https://lkml.kernel.org/r/20260128225648.2938636-1-greenjustin@chromium.org
Signed-off-by: Justin Green <greenjustin@chromium.org>
Acked-by: Brian Geffon <bgeffon@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Arjun Roy <arjunroy@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/mm/memory.c~mm-refactor-vma_map_pages-to-use-vm_insert_pages
+++ a/mm/memory.c
@@ -2568,7 +2568,6 @@ static int __vm_map_pages(struct vm_area
 {
 	unsigned long count = vma_pages(vma);
 	unsigned long uaddr = vma->vm_start;
-	int ret, i;
 
 	/* Fail if the user requested offset is beyond the end of the object */
 	if (offset >= num)
@@ -2578,14 +2577,7 @@ static int __vm_map_pages(struct vm_area
 	if (count > num - offset)
 		return -ENXIO;
 
-	for (i = 0; i < count; i++) {
-		ret = vm_insert_page(vma, uaddr, pages[offset + i]);
-		if (ret < 0)
-			return ret;
-		uaddr += PAGE_SIZE;
-	}
-
-	return 0;
+	return vm_insert_pages(vma, uaddr, pages + offset, &count);
 }
 
 /**
_

Patches currently in -mm which might be from greenjustin@chromium.org are

mm-refactor-vma_map_pages-to-use-vm_insert_pages.patch


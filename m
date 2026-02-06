Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1018F30F52F
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421687; cv=none; b=FfI/LsD9nbkXlCds5KPtYT55uB5SjKGPrr9ZXa7V1/ajdLhBilnk+zeDUB+cewUlZAyXzKRgkzIGZW4ReBSgSdCGDFn7kF9/puBTgvCChSKy1mK55xaHN0lN7/Qe7NTKAQdJ1ni5fRS8fp74Lk0v6m3UfPB16BsBcGmNUPmXMbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421687; c=relaxed/simple;
	bh=Hlz6tKG7LQrlMwjwMi6jtRQqcFAa+VFeGDXaMAq7sTg=;
	h=Date:To:From:Subject:Message-Id; b=PGneavJO+tCu3lB1kGC+MBTxBG2X1lZQDS7cTsOB7WutVDds/1naghCJpVG18OUfzFt+q6ITCAuFkovjYAV0GrrYgyy6Lcm3aXsHCMkQR/rjyQXMKRKIxkXiocrBTI1U0Boi98Rsk2x3EfrYlDQzJmDQSo0Tcsp14Z1n/csnOQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZJVI3ago; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZJVI3ago"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999CCC116C6;
	Fri,  6 Feb 2026 23:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421686;
	bh=Hlz6tKG7LQrlMwjwMi6jtRQqcFAa+VFeGDXaMAq7sTg=;
	h=Date:To:From:Subject:From;
	b=ZJVI3agoUiyWWLU55xGEJmmJ7+gVa1t7Oc+weOncS3Y+FbTHU66Ktv3Ex3t5J3/pG
	 9gfvOF+DlwKLnJKaof/9oPam5I4NWYHk9R3xoG2AEyJ+IrRyIHamAMaKCBPlm02cfs
	 h9y1Qd4Cdfgf2UaIHvCvOMtgIvm0Bv/9UDgABI84=
Date: Fri, 06 Feb 2026 15:48:06 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rientjes@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,bgeffon@google.com,arjunroy@google.com,greenjustin@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-refactor-vma_map_pages-to-use-vm_insert_pages.patch removed from -mm tree
Message-Id: <20260206234806.999CCC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: refactor vma_map_pages to use vm_insert_pages
has been removed from the -mm tree.  Its filename was
     mm-refactor-vma_map_pages-to-use-vm_insert_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2499,7 +2499,6 @@ static int __vm_map_pages(struct vm_area
 {
 	unsigned long count = vma_pages(vma);
 	unsigned long uaddr = vma->vm_start;
-	int ret, i;
 
 	/* Fail if the user requested offset is beyond the end of the object */
 	if (offset >= num)
@@ -2509,14 +2508,7 @@ static int __vm_map_pages(struct vm_area
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



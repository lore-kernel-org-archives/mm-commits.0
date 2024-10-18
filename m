Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33188186616
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 22:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729289671; cv=none; b=qJmApZ5w6crx20sPmwu0gGdoYbCdU5FLCw3oa9T1XwlDAN/j0GTLvL0sZ+w+9pTqb8rikqirPsBhr0ZAhZ3LXFmD8LA8NvK997o906OARBe3h5foO5EWESSCzcGgEfv02EL+59nGrdeOXiPbUrrDiNbW4FYZHipR4E3gKw/USaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729289671; c=relaxed/simple;
	bh=3niRU8lazFRUDgxrGvJvOjxQWNgBdVElKTOBH+XObkQ=;
	h=Date:To:From:Subject:Message-Id; b=fbWHllf1Wj2m8I9hmXqPSEbHD6BMO83IaoIE6c5nRPan+xbtKtasLIlXHjwTJbIT77ISH+DkIkCcHKxvwRQNiGa7ZAo7wfp+Cn5Exdfdlw4MVspRhXwsKtIKYjMoOSFRLtJ2ufmjj+v7RifEXMkz9t1wLgxx6OPeydLIGwM6SQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HDRv1+zJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HDRv1+zJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27A2C4CEC3;
	Fri, 18 Oct 2024 22:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729289670;
	bh=3niRU8lazFRUDgxrGvJvOjxQWNgBdVElKTOBH+XObkQ=;
	h=Date:To:From:Subject:From;
	b=HDRv1+zJ3TMNoQiYQnjB2Kr/IB7Eb6Xtd/5QGo1jOJU8sg3tFw7cp8h8NesUxFWuR
	 ve7FmrYuz4yZDHHSHPP6BipttMiAtiYZVLVOxszDVeL1EbslpRF1EkqXR2TM3cJ3bp
	 2opTyQHCuEVtkww6FggfxdYUK3TVzWubfKpmAt90=
Date: Fri, 18 Oct 2024 15:14:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,syoshida@redhat.com,peterx@redhat.com,pasha.tatashin@soleen.com,osalvador@suse.de,minchan@kernel.org,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,apopple@nvidia.com,airlied@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-memfd-stop-leaking-pinned-pages-in-low-memory-conditions.patch added to mm-hotfixes-unstable branch
Message-Id: <20241018221430.B27A2C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: memfd: stop leaking pinned pages in low memory conditions
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-memfd-stop-leaking-pinned-pages-in-low-memory-conditions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-memfd-stop-leaking-pinned-pages-in-low-memory-conditions.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: memfd: stop leaking pinned pages in low memory conditions
Date: Thu, 17 Oct 2024 18:17:11 -0700

If check_and_migrate_movable_pages() fails, typically with -ENOMEM, then
memfd_pin_folios() will leave pages pinned. Those are leaked forever,
and are visible to user space as a memory leak.

Fix this by unpinning the folios that try_grab_folio(FOLL_PIN) has
pinned, in such error cases.

Link: https://lkml.kernel.org/r/20241018011711.183642-3-jhubbard@nvidia.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/gup.c~mm-gup-memfd-stop-leaking-pinned-pages-in-low-memory-conditions
+++ a/mm/gup.c
@@ -3719,12 +3719,10 @@ long memfd_pin_folios(struct file *memfd
 		ret = check_and_migrate_movable_folios(nr_folios, folios);
 	} while (ret == -EAGAIN);
 
-	memalloc_pin_restore(flags);
-	return ret ? ret : nr_folios;
 err:
 	memalloc_pin_restore(flags);
-	unpin_folios(folios, nr_folios);
-
-	return ret;
+	if (ret)
+		unpin_folios(folios, nr_folios);
+	return ret ? ret : nr_folios;
 }
 EXPORT_SYMBOL_GPL(memfd_pin_folios);
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions.patch
mm-gup-memfd-stop-leaking-pinned-pages-in-low-memory-conditions.patch
kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch


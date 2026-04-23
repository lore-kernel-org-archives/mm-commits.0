Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9742080C1;
	Thu, 23 Apr 2026 16:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776960225; cv=none; b=s3xkaaDtA3NgrFe4R4EQlB4CQzRrljvVqA2/gsjilpHgZdlv7A2otuW+x3w8/ZyIWs2l7Br5zSIbc58qoIheqE0rsivwpJ9wNtz3caBFV6m1q78F2ogFUUmp82U5TZLgd47APTDr2IqMVakyRVaeQ5zgv6YwbkNnyLFGaEU3Nqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776960225; c=relaxed/simple;
	bh=0MqkS3pEJJEHMAinvcJOMq9F+y5UEPVL0I4bxXe0zUk=;
	h=Date:To:From:Subject:Message-Id; b=iLfziyfLpy5WHOGLN1Vu8AVULfdhcQnK1ZXYN9aho/7QWIs0iH7gGxzFSb1jEk5GzMAHO4xWUUnZFJzegV3e0saF9aOxai1rXlu68uevDWaiJssvUkiliE7pjNn9oQ8dXZp6xHMhDPu67CCA3lnEMfovknYkjpfRcYdW6OnWZsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RDGM0I9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RDGM0I9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34122C2BCAF;
	Thu, 23 Apr 2026 16:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776960225;
	bh=0MqkS3pEJJEHMAinvcJOMq9F+y5UEPVL0I4bxXe0zUk=;
	h=Date:To:From:Subject:From;
	b=RDGM0I9evGor9UQ2BuKJgfpXw4aT/w+Fi03c1TQDhOCL95GPVjGpQwZfSIPdiARSq
	 L9g+latU/HkPofqo7ykLdSpT7iiU21M31dBC8HiUbb9r2sFLM3wJmBPJOrQzTUpN1r
	 OHfR1ERkOeP15O/uLfCt4kt/ZoK3u8LQ9itk2oFk=
Date: Thu, 23 Apr 2026 09:03:44 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,gregkh@linuxfoundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-honour-foll_pin-in-nommu-__get_user_pages_locked.patch added to mm-new branch
Message-Id: <20260423160345.34122C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: honour FOLL_PIN in NOMMU __get_user_pages_locked()
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-honour-foll_pin-in-nommu-__get_user_pages_locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-honour-foll_pin-in-nommu-__get_user_pages_locked.patch

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
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: mm/gup: honour FOLL_PIN in NOMMU __get_user_pages_locked()
Date: Thu, 23 Apr 2026 16:28:04 +0200

The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
get_page() reference for each page regardless of foll_flags:

	if (pages[i])
		get_page(pages[i]);

This is reached from pin_user_pages*() with FOLL_PIN set. 
unpin_user_page() is shared between MMU and NOMMU configurations and
unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.

This means that pin adds 1, and then unpin will subtract 1024.

If a user maps a page (refcount 1), registers it 1023 times as an io_uring
fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
the page is freed and returned to the buddy allocator.  The remaining 1022
unpins write into whatever was reallocated, and the user's VMA still maps
the freed page (NOMMU has no MMU to invalidate it).  Reallocating the page
for an io_uring pbuf_ring then lets userspace corrupt the new owner's data
through the stale mapping.

Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
symmetric.

Link: https://lore.kernel.org/2026042303-vendor-outright-b9d2@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Reported-by: Anthropic
Assisted-by: gkh_clanker_t1000
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-honour-foll_pin-in-nommu-__get_user_pages_locked
+++ a/mm/gup.c
@@ -1983,6 +1983,7 @@ static long __get_user_pages_locked(stru
 	struct vm_area_struct *vma;
 	bool must_unlock = false;
 	vm_flags_t vm_flags;
+	int ret, err = -EFAULT;
 	long i;
 
 	if (!nr_pages)
@@ -2019,8 +2020,14 @@ static long __get_user_pages_locked(stru
 
 		if (pages) {
 			pages[i] = virt_to_page((void *)start);
-			if (pages[i])
-				get_page(pages[i]);
+			if (!pages[i])
+				break;
+			ret = try_grab_folio(page_folio(pages[i]), 1, foll_flags);
+			if (unlikely(ret)) {
+				pages[i] = NULL;
+				err = ret;
+				break;
+			}
 		}
 
 		start = (start + PAGE_SIZE) & PAGE_MASK;
@@ -2031,7 +2038,7 @@ static long __get_user_pages_locked(stru
 		*locked = 0;
 	}
 
-	return i ? : -EFAULT;
+	return i ? : err;
 }
 #endif /* !CONFIG_MMU */
 
_

Patches currently in -mm which might be from gregkh@linuxfoundation.org are

mm-gup-honour-foll_pin-in-nommu-__get_user_pages_locked.patch


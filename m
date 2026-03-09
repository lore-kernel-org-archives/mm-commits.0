Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB50F23EA90
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 19:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084460; cv=none; b=IjWNhO7qt3IQJnC0osKk0ATAmWNRoIQLYuoi1eT/Mjgpb3q8vYyCx16SDZrK183hgTDK6dfg50lFgwfUZSVjQ4q/7hVKGjWqdedg06oz0iPFv5CN3hYUrw5HTV8oX50gfnqEFKDVYgOv2YOjlxq26x/sZXuIBY3NCfs6puKfyYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084460; c=relaxed/simple;
	bh=UO0ewSFFx0jfzFM5FEFX2eIBXxNumWWojvzP159uzOU=;
	h=Date:To:From:Subject:Message-Id; b=sou9EHkfa/Sd6k92Jac/viEJKswlGggdL5MDa+L0pVjpg4kDHZV3PxFjS64Q4Hw2yKl5yv6lkqk2mcdHqklHttovB1OJPMQY6dAJf3zFX8KtkTLjNBtiChqqoAqVqPgEgI+sIcMg7I6cqSPt96C8tjryaYrODnSld8bA63BCdzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AN2TlTiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AN2TlTiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58271C4CEF7;
	Mon,  9 Mar 2026 19:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773084460;
	bh=UO0ewSFFx0jfzFM5FEFX2eIBXxNumWWojvzP159uzOU=;
	h=Date:To:From:Subject:From;
	b=AN2TlTivqIkwu7eUrQibOAW/j1eY8D7YStMpzcxnxxZuy79sUhNpj4qNci+jEOh7j
	 +xwAzth1G++4nLPq+kwYUqcdux39YM4oKOZBEASoBXgGKNC8xIWLYLgAxfjOqHRv31
	 uIYqKEX76LOVwRCb6qjku8lyrtlaHYPyVBK+Stq8=
Date: Mon, 09 Mar 2026 12:27:39 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-drop-restriction-on-maximum-page-order.patch added to mm-new branch
Message-Id: <20260309192740.58271C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: drop restriction on maximum page order
has been added to the -mm mm-new branch.  Its filename is
     kho-drop-restriction-on-maximum-page-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-drop-restriction-on-maximum-page-order.patch

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
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho: drop restriction on maximum page order
Date: Mon, 9 Mar 2026 12:34:07 +0000

KHO currently restricts the maximum order of a restored page to the
maximum order supported by the buddy allocator.  While this works fine for
much of the data passed across kexec, it is possible to have pages larger
than MAX_PAGE_ORDER.

For one, it is possible to get a larger order when using
kho_preserve_pages() if the number of pages is large enough, since it
tries to combine multiple aligned 0-order preservations into one higher
order preservation.

For another, upcoming support for hugepages can have gigantic hugepages
being preserved over KHO.

There is no real reason for this limit.  The KHO preservation machinery
can handle any page order.  Remove this artificial restriction on max page
order.

Link: https://lkml.kernel.org/r/20260309123410.382308-2-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-drop-restriction-on-maximum-page-order
+++ a/kernel/liveupdate/kexec_handover.c
@@ -411,7 +411,7 @@ static struct page *kho_restore_page(phy
 	 * check also implicitly makes sure phys is order-aligned since for
 	 * non-order-aligned phys addresses, magic will never be set.
 	 */
-	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER))
+	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC))
 		return NULL;
 	nr_pages = (1 << info.order);
 
_

Patches currently in -mm which might be from pratyush@kernel.org are

memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch
kho-move-alloc-tag-init-to-kho_init_foliopages.patch
kho-make-sure-preservations-do-not-span-multiple-numa-nodes.patch
kho-drop-restriction-on-maximum-page-order.patch


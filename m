Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623D22836BD
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 18:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730059; cv=none; b=n68kIUoDiviVn0tRRILeJ9OBL5Entt85LZ7qP+ogWiOqkixHoEfLkdhQ0KmUxSX3f8j+JacaNZOLPN4aQK0K7Lb+PRzOpx3kLuvwUvUF8fECDG07Y3qdhW2/AA+ffPAW2gv58wKxg/itj90xvB7ZSnX//Nfac8mYOjk9fKbetpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730059; c=relaxed/simple;
	bh=IRauTQDb3Y+/TaK5fSCqCO+xkV3XbpRSieKFKEVR03A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQXJvlRGk/EU606btmtTY7si7zwtLfVo+BYJQKvYJYmvThPKv1hTZxHrpU3PDIPX6jhb/XwB8UwG6RYEkt9WLeUiDuxFGwjtTDv6ArvsdynbOLPgh6bVBqTc5l8Iqz4asYtLXpvBp7/BhS+XpSDHXl99WfMg+6Qu3EGl3uWzHzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PvoC0xue; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PvoC0xue"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746730056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q5/23zlrnHFzwE6MGdBit0bCGvQ4G45X1cFPE9kDshA=;
	b=PvoC0xueN7bqHTncgnoHIptex5hbb8pY1bXMY2fASmsmjag72R/Fz+khP5zk0x8hIwYlp8
	6w5rCJmAnj1uBSLIDNKaOxfrvzzTCkHNQ8V+iAkgo93E8uiv/TyYBosHOL0c1d3jDCbjuK
	qyMo/365FdaKranwXPnzIYpZsC3QQmE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-iJb-pDkYPcmovQ2QKpZJBA-1; Thu, 08 May 2025 14:47:35 -0400
X-MC-Unique: iJb-pDkYPcmovQ2QKpZJBA-1
X-Mimecast-MFC-AGG-ID: iJb-pDkYPcmovQ2QKpZJBA_1746730054
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-47ae87b5182so22054181cf.2
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 11:47:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730054; x=1747334854;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q5/23zlrnHFzwE6MGdBit0bCGvQ4G45X1cFPE9kDshA=;
        b=jHLUBGxCAs85QuO26rHTQ4iPLabRg1S2GxZw2JR5Z0kQbG1ac9zmIVm821IukdxWxa
         2Z9liSOfsL4XMVu/zVSOPtx9aQpwE3Evl7rX2lgnSjtVzqvPUaRhxeFgscpZr/TMsKR/
         36EYb+XL8VlbXAJvPe/vWzZo+Ss4pmfbJUMuSSBRCIzzs0wkJwbFC+B1tmju1FdnJPzf
         4jtp9PkuMWVMcrf6nFqDno8bcqiSY5WYQXWTyZPxnbTw3EGyfoiWHpI3BQ+v0b4mzlW4
         6cWUUEPsVnakmvqn74obqX+q/nw09optW7/+Is6stwWJxUSKJRDCLRwV+xD8fWHoaUgP
         NNFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZPVYqncV0ZoC2si54KVAKSF73E1LygbQSBkQznurZNOS9uHgin8IPv5xUKoLVnmglpePscfGfGXYx@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw7XwT7as2LyXR4etcAchgffLUnX/Org5TJuZ4sUwnALcta3cq
	vblt+jJcHdEvPI44Y//kzMcvZBVTmVylKuo3M34YuOUANkEYzRh3bhSonqNBJL+lqfNe9koEKZ5
	HhY4kB47Df4d0MV5GCN9Z4sJ51d+2c9js8/hCvnsYe/KPD6Xv+o1QBn4ILQM=
X-Gm-Gg: ASbGnctTfXh4x6uqYzmbW18JbAbUzlfZ4iPk+dBgIREgeWDFnzMWzXWZkGUQwedTUeT
	2xLHpAG9cQZ5l4veHyQWqv8uHsta05+Bh1Wdn0JOpg7G0nmtxbrNqIMEd6neIZ/Gtw952ocn+nq
	hWdsdv/IIUsm0CI7vx4tyn+x+K8kQNsvHEiQJwa//x7rZiq1Dy83C0KkO0fQHrnD7bPWe9EZIwT
	5FZrQAfS9IhFAKcoT/S487Qygm5iUypK+wRnxSYDtTaZKJEDd4I+YZ/cIXuTCd+reWIRXW0kt42
	c/Q=
X-Received: by 2002:ac8:58cf:0:b0:48a:582a:64de with SMTP id d75a77b69052e-49452712ea8mr5262301cf.7.1746730054421;
        Thu, 08 May 2025 11:47:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+5uaZ6k4YhwMdCOmyVAytMqfziPmY6tiSlEhYybcDPVNBd9pDKWlCugS1rn+QTlOQA6P6AQ==
X-Received: by 2002:ac8:58cf:0:b0:48a:582a:64de with SMTP id d75a77b69052e-49452712ea8mr5261941cf.7.1746730053961;
        Thu, 08 May 2025 11:47:33 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945248d0b3sm1637851cf.19.2025.05.08.11.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 11:47:33 -0700 (PDT)
Date: Thu, 8 May 2025 14:47:30 -0400
From: Peter Xu <peterx@redhat.com>
To: Pantelis Antoniou <p.antoniou@partner.samsung.com>
Cc: David Hildenbrand <david@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, wade.farnsworth@siemens.com,
	jhubbard@nvidia.com, c.briere@samsung.com, artem.k@samsung.com,
	David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <aBz8QuzT7YkPqrrF@x1.local>
References: <aBy8v7gi3tsQ5-iy@x1.local>
 <20250508173612.34d1bea3@sarc.samsung.com>
 <aBzI3sl6r3HtAWP4@x1.local>
 <cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
 <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
 <20250508173535.GA8129@ziepe.ca>
 <20250508204711.6cf9f6e3@sarc.samsung.com>
 <1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
 <20250508211136.7a0a3865@sarc.samsung.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250508211136.7a0a3865@sarc.samsung.com>

On Thu, May 08, 2025 at 09:11:36PM +0300, Pantelis Antoniou wrote:
> This has been going on for more than a decade at this point.

I wasn't aware how long, but I need to confess I am also aware of such in
virt context where drivers map these pages in PFNMAPs..  So KVM also has
similar cases happening in corner case setups.

> 
> Can we get a plan on how to go around fixing these issues correctly?
> 
> 1. Drivers/subsystems (DRM in this case) are doing remap_pfn_range() to
> map system memory with a page attached to user space.
> Up until recently this was OK, since no-one tried to pin the pages for
> any reason. It doesn't seem like this is the right way to do it.
> What is the right way?
> 
> 2. DRM in particular has no standardized way to handle mapping system
> memory Buffer Objects (BOs) to userspace. Each driver is free to do it's
> own thing and does so. What is the right way to handle this case.
> 
> 3. While we go about fixing it, this has caused a pretty significant
> userspace regression, where the address space that those BOs reside
> cannot be used for I/O when a network filesystem is involved. I think
> it's a matter of time when regular filesystem start using the same
> method of pining and doing I/O instead of using the filecache on fast
> memory mediums.

I mentioned it elsewhere, but _if_ fixing all the drivers isn't possible in
the near future.. we could still have chance to not mess with GUP (in which
case PFNMAP is also working like that for so many years, likely what the
drivers do on abusing pages in PFNMAPs...).  That is supporting such
special pages in iov_iter.

I attached such patch below, not saying that we should merge it, but IMHO
it's much better than fiddling with gup here, and so far that's the best I
can think if (and only if it works for 9pfs's current zerocopy case).. I
only smoked it, but I didn't verify it.

PS: I was also thinking maybe if 9pfs is the only affected so far, I wonder
if we could try to fallback to cached RW when necessary, IIUC that's still
working, right (and is 9pfs a production-level fs)?  But I think that's not
as good as below if supporting that isn't extremely hard.

Thanks,

=======8<======
From cd4aa467e4b653b5bd8496b5123d65d06e2e3263 Mon Sep 17 00:00:00 2001
From: Peter Xu <peterx@redhat.com>
Date: Thu, 8 May 2025 14:35:24 -0400
Subject: [PATCH] iov_iter: Supports special PFNMAP for user buffer when
 pfn_valid()

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/mm.h |  1 +
 lib/iov_iter.c     | 60 +++++++++++++++++++++++++++++++++++++++++++++-
 mm/gup.c           | 16 +++++++++++++
 3 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 38e16c984b9a..f79fd14599fa 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1459,6 +1459,7 @@ static inline void put_page(struct page *page)
  */
 #define GUP_PIN_COUNTING_BIAS (1U << 10)
 
+int pin_user_page(struct page *page);
 void unpin_user_page(struct page *page);
 void unpin_folio(struct folio *folio);
 void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index d9e19fb2dcf3..2eb24b2793f0 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1809,6 +1809,64 @@ static ssize_t iov_iter_extract_kvec_pages(struct iov_iter *i,
 	return size;
 }
 
+/**
+ * iov_iter_pin_user_pages() - pin user pages for iov iter ops
+ *
+ * @start:      starting user address
+ * @nr_pages:   number of pages from start to pin
+ * @gup_flags:  flags modifying pin behaviour
+ * @pages:      array that receives pointers to the pages pinned.
+ *              Should be at least nr_pages long.
+ *
+ * Almost a wrapper for pin_user_pages_fast(), but also supports PFNMAPs
+ * where in extremely rare cases there's actually struct page available
+ * (e.g. device drivers playing trick with PFNMAP by injecting allocated
+ * RAM pages).
+ */
+static inline int
+iov_iter_pin_user_pages(unsigned long start, int nr_pages,
+			unsigned int gup_flags, struct page **pages)
+{
+	struct follow_pfnmap_args args;
+	struct vm_area_struct *vma;
+	struct mm_struct *mm;
+	int res, ret;
+
+	res = pin_user_pages_fast(start, nr_pages, gup_flags, pages);
+
+	/* Normally, GUP should really work already.. */
+	if (likely(res > 0))
+		return res;
+
+	/*
+	 * This is to take care of an extremely rare case: retry in case if
+	 * it's a PFNMAP that has struct page backed.
+	 *
+	 * So far it does the minimum we need in the failure path.  It
+	 * assumes the PFNMAP entries must exist in the pgtables already,
+	 * and it resolves one PFN at a time.
+	 */
+	mm = current->mm;
+	mmap_read_lock(mm);
+	vma = vma_lookup(current->mm, start);
+	if (!vma)
+		goto out;
+
+	args.vma = vma;
+	args.address = start;
+
+	ret = follow_pfnmap_start(&args);
+	if (ret)
+		goto out;
+	/* Did we find a special page under VM_PFNMAP? */
+	if (pfn_valid(args.pfn) && pin_user_page(pfn_to_page(args.pfn)))
+		res = 1;
+	follow_pfnmap_end(&args);
+out:
+	mmap_read_unlock(mm);
+	return res;
+}
+
 /*
  * Extract a list of contiguous pages from a user iterator and get a pin on
  * each of them.  This should only be used if the iterator is user-backed
@@ -1846,7 +1904,7 @@ static ssize_t iov_iter_extract_user_pages(struct iov_iter *i,
 	maxpages = want_pages_array(pages, maxsize, offset, maxpages);
 	if (!maxpages)
 		return -ENOMEM;
-	res = pin_user_pages_fast(addr, maxpages, gup_flags, *pages);
+	res = iov_iter_pin_user_pages(addr, maxpages, gup_flags, *pages);
 	if (unlikely(res <= 0))
 		return res;
 	maxsize = min_t(size_t, maxsize, res * PAGE_SIZE - offset);
diff --git a/mm/gup.c b/mm/gup.c
index d3aac58862c0..eede221ac89a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -178,6 +178,22 @@ int __must_check try_grab_folio(struct folio *folio, int refs,
 	return 0;
 }
 
+/**
+ * pin_user_page() - dma-pinned a page
+ * @page:            pointer to page to be pinned
+ *
+ * NOTE!  One should normally use pin_user_pages*() API instead.  This
+ * should be only useful in extremely special cases, like struct page under
+ * VM_PFNMAP.
+ *
+ * Returns: 0 if success, negative if pin failed
+ */
+int pin_user_page(struct page *page)
+{
+	return try_grab_folio(page_folio(page), 1, FOLL_PIN);
+}
+EXPORT_SYMBOL(pin_user_page);
+
 /**
  * unpin_user_page() - release a dma-pinned page
  * @page:            pointer to page to be released
-- 
2.49.0


-- 
Peter Xu


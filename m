Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA7E2D9484;
	Mon, 21 Sep 2026 04:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789963930; cv=none; b=coauPwwZ4/rZ4YzR0xN/7SOyE7baAUH0vdw6Hu0dFnx8+iSy2yrrOhoKjTwBJ3NbSvbUA9/iEmRA81O6llFmVna6VOX0J9RApzA/9G9S1T6HGTxHKJKpqECWDPvbcdkn85YeePboN/KDW6xbTBxVzq4P5151DrQ+iQiCkRVL2rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789963930; c=relaxed/simple;
	bh=JQteEG8aEomBNPZ/3WuvISiRCdp0U1U8G8bw6F46X/c=;
	h=Date:To:From:Subject:Message-Id; b=uKRnnl0M9+Niwuv1lt7zQQ9FzRlAHqkGISiYHpK837jBv4rP3VQEphVJE0bBR6x4fB8w6bpQPvjagGV0A7dIfVU3b9HDoYj3chtK3H6Yo+NntGkwj04ygfPSGwYW2RDKLix0uoMveYzGSSJz5gOviYduQgYjiyGLffCnkE4p99g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ekcbdR9o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ekcbdR9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAB21F000FF;
	Mon, 21 Sep 2026 04:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789963929;
	bh=0fP/BttSWFVif+inM5k3TC5NNn6OzY5ZqIHsXFmdegE=;
	h=Date:To:From:Subject;
	b=ekcbdR9o4ke9VS5Cf6us9K5fIzaDACHZEbRoJaXcXwxZZJ0g3ssanRzSFKdS53Dhf
	 1F6AFKOD+U8tQIQayU2UdlQNzwtt9Kzyc3ByTBSba+J1Z2NSZE9Qd47NJsBMtCxt9f
	 3Wc15ln3/9hpKZfygEwoYu7ufQyPafeKqzqqoC4Y=
Date: Sun, 20 Sep 2026 21:12:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,gregkh@linuxfoundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-gup-honour-foll_pin-in-nommu-__get_user_pages_locked.patch removed from -mm tree
Message-Id: <20260921041209.3EAB21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: honour FOLL_PIN in NOMMU __get_user_pages_locked()
has been removed from the -mm tree.  Its filename was
     mm-gup-honour-foll_pin-in-nommu-__get_user_pages_locked.patch

This patch was dropped because it is obsolete

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

While at it, don't return NULL pointers in the page array, as this is
really not expected for GUP users; instead, just fail and return
-EFAULT.

[david@kernel.org: changelog update]
  https://lore.kernel.org/e9c5cf89-fa4c-4b83-ae70-9d3c72542ee9@kernel.org
Link: https://lore.kernel.org/2026042303-vendor-outright-b9d2@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: David Hildenbrand <david@kernel.org>
Reported-by: Anthropic
Assisted-by: gkh_clanker_t1000
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
---

 mm/gup.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-honour-foll_pin-in-nommu-__get_user_pages_locked
+++ a/mm/gup.c
@@ -1987,6 +1987,7 @@ static long __get_user_pages_locked(stru
 	struct vm_area_struct *vma;
 	bool must_unlock = false;
 	vm_flags_t vm_flags;
+	int ret, err = -EFAULT;
 	long i;
 
 	if (!nr_pages)
@@ -2022,8 +2023,14 @@ static long __get_user_pages_locked(stru
 
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
@@ -2034,7 +2041,7 @@ static long __get_user_pages_locked(stru
 		*locked = 0;
 	}
 
-	return i ? : -EFAULT;
+	return i ? : err;
 }
 #endif /* !CONFIG_MMU */
 
_

Patches currently in -mm which might be from gregkh@linuxfoundation.org are



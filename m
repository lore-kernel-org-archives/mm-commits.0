Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832450;
	b=tVVcE9bFp9Te5yfbzbuqjdySw0rIXJe0Qrmiw6DuCvsM/t0woKWRs8ogn3Jbt6JGCafn
	 yH/5OIkOSl+631N4IbG8QomdJcUDjm4pH0O1pGzTZRR3frtQvKKJYOcqryHR0zBPlVfCY
	 aymAjgvnB4WoHOwx55fDh2MyRsBTLD91xmNto9gJk1JXvPfsU0f2TGJblMW6wz033euwN
	 UhoivjEC03IOWju4zLN8yVOjVeXpkfOulz6wud3J20KbMauAEbPpWlVzmGkV9oobTV/W9
	 VNyfGdeayh+B+stc6mphSEi1Yfu0DaN0yfr31SrHftkxN7TH1Nkift++oWIA4K+MDNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832450;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6/3Cdg8BZRLMKN98qoc9P0XrnK7tXY/4MWbF84ERtPI=;
	b=nLBMPY+5iU+wTdeYPsrx2PpopJ4bvy2Xu6cQyXo+sx3Ys+kgjfjAdb6eIawZVh4DCj18
	 ROJtjThy8jWhVXsTPzEGfcp1Mx1JLcwgxDmCIogogu2gb3zlX2t8qTSWF/zkH0r9N6jZl
	 U63aAeDIFR+rQ8kT6TUPSjBTGIBuLl4lyLz5bCIodPV2/t+9ukTEai90J+8Yj806ooMJG
	 veV5oBiue8gifUJTgi75d6FSbcqQlpvEwax08YAbmUz98+4+NpzVYPxQYa7+EAgTpkSGz
	 kfFzBsgzM0R6hiupgi3hgAVtIdzoQiy3pxNg7aS8kyy768UJxe/PlA6lhrnzyr+Ljvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="tB/BjWZC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F95606A322
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tB/BjWZC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0551F01825;
	Sat, 24 Oct 2026 09:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832450;
	bh=6/3Cdg8BZRLMKN98qoc9P0XrnK7tXY/4MWbF84ERtPI=;
	h=Date:To:From:Subject;
	b=tB/BjWZCf+/gIF9rTRAbPw8pPOSAU2hAjKpYuTHIQJFzOVEW/H8M2r74Fglh/7lzg
	 thkmaSoRIBVUG7Y+YCiZQe/+6Qon/dB9ovdY0lwWLxFEOUwItP5ArvJQQs9VwC2hw7
	 RIUHJZsr7BxJdlPHNI7GaqZu6cW0EFh3QFoea0e0=
Date: Sat, 24 Oct 2026 02:00:49 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,dev.jain@arm.com,baohua@kernel.org,jiangwen6@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-bail-out-early-on-invalid-page_shift-in-__vmap_pages_range_noflush.patch removed from -mm tree
Message-Id: <20261024090049.DC0551F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vmalloc: bail out early on invalid page_shift in __vmap_pages_range_noflush()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-bail-out-early-on-invalid-page_shift-in-__vmap_pages_range_noflush.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wen Jiang <jiangwen6@xiaomi.com>
Subject: mm/vmalloc: bail out early on invalid page_shift in __vmap_pages_range_noflush()
Date: Sun,  4 Oct 2026 15:16:39 +0800

__vmap_pages_range_noflush() currently only warns when page_shift is
smaller than PAGE_SHIFT, then continues with the invalid shift.  Return
-EINVAL instead so the bogus argument is caught immediately.

Link: https://lore.kernel.org/20261004071639.119857-1-jiangwenxiaomi@gmail.com
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-bail-out-early-on-invalid-page_shift-in-__vmap_pages_range_noflush
+++ a/mm/vmalloc.c
@@ -684,7 +684,8 @@ int __vmap_pages_range_noflush(unsigned
 {
 	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
 
-	WARN_ON(page_shift < PAGE_SHIFT);
+	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
+		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
 			page_shift == PAGE_SHIFT)
_

Patches currently in -mm which might be from jiangwen6@xiaomi.com are



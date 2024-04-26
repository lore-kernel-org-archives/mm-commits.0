Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D489078C8A
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103868; cv=none; b=fWJUVvnN8ZKeABGRws8C2JLXbeAJx9CcrRb/GPCJ5CyiUUFS5M+zY4lmkLZ3jTgybl6/b8p3ao5usqNU1k8qPjGhcJfQvzDH6fxW8RSyi41StG6ppiRpmHl8J/RFp/hwZg68r7F9kykbXyW37L77p1tcbnp966TCtD+I01AGHeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103868; c=relaxed/simple;
	bh=9cGQT3fNU5wu+T1xQ2LGAwNP2ok8FT+YtA1MVitD9Bg=;
	h=Date:To:From:Subject:Message-Id; b=S/cxbs+IF9j+DGgB2YSlTY9MMJ9cIWKJSYkX+qhGWSGg2HZXgkQf9GTvgeeAepcuDsG3c5O0Mva5+xqs2nUHC/QaPX4nwu3EeUeF8ue7BmlFGac68tG69fFcNeK+Kwfw39lllw0IUzWhUkvs8b3NteSWpA0SIueqCw6NqZR39ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=anm85GOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="anm85GOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A894DC113CD;
	Fri, 26 Apr 2024 03:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103868;
	bh=9cGQT3fNU5wu+T1xQ2LGAwNP2ok8FT+YtA1MVitD9Bg=;
	h=Date:To:From:Subject:From;
	b=anm85GOZOmfC2P1pNDOsfjrrzPQ/cBpfhJz1e7aywBTzGihtYBayVWmacLnfxkJ43
	 FUQ3R8L/S1sVRmZSz6/+OTsZPQpFKHQsbg6MAJKvV2ikxTFLWXhu+zyLiE/LSwB++1
	 cUd+qAFSOe2zqIikPWprwPRWCBmgIPD6SEStI/ik=
Date: Thu, 25 Apr 2024 20:57:48 -0700
To: mm-commits@vger.kernel.org,jglisse@redhat.com,duoming@zju.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_hmmc-handle-src_pfns-and-dst_pfns-allocation-failure.patch removed from -mm tree
Message-Id: <20240426035748.A894DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_hmm.c: handle src_pfns and dst_pfns allocation failure
has been removed from the -mm tree.  Its filename was
     lib-test_hmmc-handle-src_pfns-and-dst_pfns-allocation-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Duoming Zhou <duoming@zju.edu.cn>
Subject: lib/test_hmm.c: handle src_pfns and dst_pfns allocation failure
Date: Tue, 12 Mar 2024 08:59:05 +0800

The kcalloc() in dmirror_device_evict_chunk() will return null if the
physical memory has run out.  As a result, if src_pfns or dst_pfns is
dereferenced, the null pointer dereference bug will happen.

Moreover, the device is going away.  If the kcalloc() fails, the pages
mapping a chunk could not be evicted.  So add a __GFP_NOFAIL flag in
kcalloc().

Finally, as there is no need to have physically contiguous memory, Switch
kcalloc() to kvcalloc() in order to avoid failing allocations.

Link: https://lkml.kernel.org/r/20240312005905.9939-1-duoming@zju.edu.cn
Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmmc-handle-src_pfns-and-dst_pfns-allocation-failure
+++ a/lib/test_hmm.c
@@ -1226,8 +1226,8 @@ static void dmirror_device_evict_chunk(s
 	unsigned long *src_pfns;
 	unsigned long *dst_pfns;
 
-	src_pfns = kcalloc(npages, sizeof(*src_pfns), GFP_KERNEL);
-	dst_pfns = kcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL);
+	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
+	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
 
 	migrate_device_range(src_pfns, start_pfn, npages);
 	for (i = 0; i < npages; i++) {
@@ -1250,8 +1250,8 @@ static void dmirror_device_evict_chunk(s
 	}
 	migrate_device_pages(src_pfns, dst_pfns, npages);
 	migrate_device_finalize(src_pfns, dst_pfns, npages);
-	kfree(src_pfns);
-	kfree(dst_pfns);
+	kvfree(src_pfns);
+	kvfree(dst_pfns);
 }
 
 /* Removes free pages from the free list so they can't be re-allocated */
_

Patches currently in -mm which might be from duoming@zju.edu.cn are



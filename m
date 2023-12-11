Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F6946B2
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PAWg1yxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F43C433C8;
	Mon, 11 Dec 2023 00:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256110;
	bh=AJ/icjIwEZ0Itq2CqfU83kVD8NYxCySL4M2MgjFmJ5I=;
	h=Date:To:From:Subject:From;
	b=PAWg1yxyptZXRqf8tLZmgyLFRezmw/n93GhqY5EgAsShwmBXbUG/H1ycEJRcXTA98
	 qRep2coM9K7zmxlqHe/boe82uC+q6Qs6RGyqzCSAW32ya+A8Xf7o+UXrh3X6DyV+xz
	 vkAz/qVvCch1pzx08I4I6EQDbcd/RXwRib9Tox2s=
Date: Sun, 10 Dec 2023 16:55:09 -0800
To: mm-commits@vger.kernel.org,ira.weiny@intel.com,fabio.maria.de.francesco@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-util-use-kmap_local_page-in-memcmp_pages.patch removed from -mm tree
Message-Id: <20231211005509.E4F43C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/util: use kmap_local_page() in memcmp_pages()
has been removed from the -mm tree.  Its filename was
     mm-util-use-kmap_local_page-in-memcmp_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Fabio De Francesco <fabio.maria.de.francesco@linux.intel.com>
Subject: mm/util: use kmap_local_page() in memcmp_pages()
Date: Mon, 20 Nov 2023 15:15:27 +0100

kmap_atomic() has been deprecated in favor of kmap_local_page().

Therefore, replace kmap_atomic() with kmap_local_page() in memcmp_pages().

kmap_atomic() is implemented like a kmap_local_page() which also disables
page-faults and preemption (the latter only in !PREEMPT_RT kernels).  The
kernel virtual addresses returned by these two API are only valid in the
context of the callers (i.e., they cannot be handed to other threads).

With kmap_local_page() the mappings are per thread and CPU local like in
kmap_atomic(); however, they can handle page-faults and can be called from
any context (including interrupts).  The tasks that call kmap_local_page()
can be preempted and, when they are scheduled to run again, the kernel
virtual addresses are restored and are still valid.

In memcmp_pages(), the block of code between the mapping and un-mapping
does not depend on the above-mentioned side effects of kmap_aatomic(), so
that mere replacements of the old API with the new one is all that is
required (i.e., there is no need to explicitly call pagefault_disable()
and/or preempt_disable()).

Link: https://lkml.kernel.org/r/20231120141554.6612-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/util.c~mm-util-use-kmap_local_page-in-memcmp_pages
+++ a/mm/util.c
@@ -1047,11 +1047,11 @@ int __weak memcmp_pages(struct page *pag
 	char *addr1, *addr2;
 	int ret;
 
-	addr1 = kmap_atomic(page1);
-	addr2 = kmap_atomic(page2);
+	addr1 = kmap_local_page(page1);
+	addr2 = kmap_local_page(page2);
 	ret = memcmp(addr1, addr2, PAGE_SIZE);
-	kunmap_atomic(addr2);
-	kunmap_atomic(addr1);
+	kunmap_local(addr2);
+	kunmap_local(addr1);
 	return ret;
 }
 
_

Patches currently in -mm which might be from fabio.maria.de.francesco@linux.intel.com are



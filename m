Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E9A468D
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UrJomjVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13B1C433C7;
	Mon, 11 Dec 2023 00:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256112;
	bh=FZZFKHRmWrlcTMEkJ0G92OUqvtSrK2fIl0/Mt7Xlrg8=;
	h=Date:To:From:Subject:From;
	b=UrJomjVSvYn66wghy2/VBYUco+zK1g1amVs+XbtkwCk5LowGIQStpYt1Q+QNLTZGH
	 viYyePiciLKkpD9paVaQprJ4PlnQH3u8Bf8lxwyUYpcKViXXpWkewUbEsbJo8rlbNG
	 M1q0gh4s6T7ShGr72Zg2RuOeeY4enr7sHKvDmfBw=
Date: Sun, 10 Dec 2023 16:55:12 -0800
To: mm-commits@vger.kernel.org,ira.weiny@intel.com,fabio.maria.de.francesco@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempool-replace-kmap_atomic-with-kmap_local_page.patch removed from -mm tree
Message-Id: <20231211005512.C13B1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempool: replace kmap_atomic() with kmap_local_page()
has been removed from the -mm tree.  Its filename was
     mm-mempool-replace-kmap_atomic-with-kmap_local_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fabio.maria.de.francesco@linux.intel.com>
Subject: mm/mempool: replace kmap_atomic() with kmap_local_page()
Date: Mon, 20 Nov 2023 15:26:31 +0100

kmap_atomic() has been deprecated in favor of kmap_local_page().

Therefore, replace kmap_atomic() with kmap_local_page().

kmap_atomic() is implemented like a kmap_local_page() which also disables
page-faults and preemption (the latter only in !PREEMPT_RT kernels).  The
kernel virtual addresses returned by these two API are only valid in the
context of the callers (i.e., they cannot be handed to other threads).

With kmap_local_page() the mappings are per thread and CPU local like in
kmap_atomic(); however, they can handle page-faults and can be called from
any context (including interrupts).  The tasks that call kmap_local_page()
can be preempted and, when they are scheduled to run again, the kernel
virtual addresses are restored and are still valid.

The code blocks between the mappings and un-mappings don't rely on the
above-mentioned side effects of kmap_atomic(), so that mere replacements
of the old API with the new one is all that they require (i.e., there is
no need to explicitly call pagefault_disable() and/or preempt_disable()).

Link: https://lkml.kernel.org/r/20231120142640.7077-1-fabio.maria.de.francesco@linux.intel.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/mempool.c~mm-mempool-replace-kmap_atomic-with-kmap_local_page
+++ a/mm/mempool.c
@@ -64,10 +64,10 @@ static void check_element(mempool_t *poo
 	} else if (pool->free == mempool_free_pages) {
 		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
-		void *addr = kmap_atomic((struct page *)element);
+		void *addr = kmap_local_page((struct page *)element);
 
 		__check_element(pool, addr, 1UL << (PAGE_SHIFT + order));
-		kunmap_atomic(addr);
+		kunmap_local(addr);
 	}
 }
 
@@ -89,10 +89,10 @@ static void poison_element(mempool_t *po
 	} else if (pool->alloc == mempool_alloc_pages) {
 		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
-		void *addr = kmap_atomic((struct page *)element);
+		void *addr = kmap_local_page((struct page *)element);
 
 		__poison_element(addr, 1UL << (PAGE_SHIFT + order));
-		kunmap_atomic(addr);
+		kunmap_local(addr);
 	}
 }
 #else /* CONFIG_DEBUG_SLAB || CONFIG_SLUB_DEBUG_ON */
_

Patches currently in -mm which might be from fabio.maria.de.francesco@linux.intel.com are



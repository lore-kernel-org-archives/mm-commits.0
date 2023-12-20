Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F024D585
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ux5kVI0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D241C433C8;
	Wed, 20 Dec 2023 22:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112571;
	bh=lhMNEofPocKi8IqWTJ9wJT1LAndx3ViG15bIloS9Czc=;
	h=Date:To:From:Subject:From;
	b=ux5kVI0+vdfp+9XnvOPX+7mqzung0483ykvDloDacKTVej29q4NqbZTY66MfIgSTg
	 etambcHp/5Or4XFkXGLIEflCv6fcNA2KAVoEkFci+Kfqp0R57Qewtga6Tk3T4bluUr
	 GYhLS4RcbjbeCbe1yXBqxR3h4uU+IdgrtNFZIH6w=
Date: Wed, 20 Dec 2023 14:49:30 -0800
To: mm-commits@vger.kernel.org,ira.weiny@intel.com,fabio.maria.de.francesco@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-replace-kmap-with-kmap_local_page.patch removed from -mm tree
Message-Id: <20231220224931.0D241C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: replace kmap() with kmap_local_page()
has been removed from the -mm tree.  Its filename was
     mm-memory-replace-kmap-with-kmap_local_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fabio.maria.de.francesco@linux.intel.com>
Subject: mm/memory: replace kmap() with kmap_local_page()
Date: Thu, 14 Dec 2023 09:10:04 +0100

kmap() has been deprecated in favor of kmap_local_page().

Therefore, replace kmap() with kmap_local_page() in mm/memory.c.

There are two main problems with kmap(): (1) It comes with an overhead as
the mapping space is restricted and protected by a global lock for
synchronization and (2) it also requires global TLB invalidation when the
kmap's pool wraps and it might block when the mapping space is fully
utilized until a slot becomes available.

With kmap_local_page() the mappings are per thread, CPU local, can take
page-faults, and can be called from any context (including interrupts). 
It is faster than kmap() in kernels with HIGHMEM enabled.  The tasks can
be preempted and, when they are scheduled to run again, the kernel virtual
addresses are restored and still valid.

Obviously, thread locality implies that the kernel virtual addresses
returned by kmap_local_page() are only valid in the context of the callers
(i.e., they cannot be handed to other threads).

The use of kmap_local_page() in mm/memory.c does not break the
above-mentioned assumption, so it is allowed and preferred.

Link: https://lkml.kernel.org/r/20231215084417.2002370-1-fabio.maria.de.francesco@linux.intel.com
Link: https://lkml.kernel.org/r/20231214081039.1919328-1-fabio.maria.de.francesco@linux.intel.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-memory-replace-kmap-with-kmap_local_page
+++ a/mm/memory.c
@@ -5944,7 +5944,7 @@ static int __access_remote_vm(struct mm_
 			if (bytes > PAGE_SIZE-offset)
 				bytes = PAGE_SIZE-offset;
 
-			maddr = kmap(page);
+			maddr = kmap_local_page(page);
 			if (write) {
 				copy_to_user_page(vma, page, addr,
 						  maddr + offset, buf, bytes);
@@ -5953,8 +5953,7 @@ static int __access_remote_vm(struct mm_
 				copy_from_user_page(vma, page, addr,
 						    buf, maddr + offset, bytes);
 			}
-			kunmap(page);
-			put_page(page);
+			unmap_and_put_page(page, maddr);
 		}
 		len -= bytes;
 		buf += bytes;
_

Patches currently in -mm which might be from fabio.maria.de.francesco@linux.intel.com are



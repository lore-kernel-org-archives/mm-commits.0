Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B1D6D1B8
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 19:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZBEBHaLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96D1C433C9;
	Thu, 14 Dec 2023 19:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702583272;
	bh=E7vYeIcVpbAmI9kq7dTp1SkYbR3rZgPg+wkhoYKJFQo=;
	h=Date:To:From:Subject:From;
	b=ZBEBHaLaVjkHmreMHtSXQiJaewYNufagoLjnIzraGjkMvITeVPshcmyY0tZoN9+19
	 xnZIcdB4wSCwclPyzt0lFpC88jJnQfrYaC0lY9r+O9SFFuzQZHXpL0Nw9RHcvyL0Ng
	 6lub10BrsaxcKg4gG/YwBC88fGYo9iwcHvERQrjs=
Date: Thu, 14 Dec 2023 11:47:52 -0800
To: mm-commits@vger.kernel.org,ira.weiny@intel.com,fabio.maria.de.francesco@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-replace-kmap-with-kmap_local_page.patch added to mm-unstable branch
Message-Id: <20231214194752.D96D1C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: replace kmap() with kmap_local_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-replace-kmap-with-kmap_local_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-replace-kmap-with-kmap_local_page.patch

This patch will later appear in the mm-unstable branch at
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

Link: https://lkml.kernel.org/r/20231214081039.1919328-1-fabio.maria.de.francesco@linux.intel.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
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

mm-memory-replace-kmap-with-kmap_local_page.patch


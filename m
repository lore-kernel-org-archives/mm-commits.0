Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148244692
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h8Z2Ex8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D467FC433C7;
	Mon, 11 Dec 2023 00:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256111;
	bh=c16imL+alUO/IYjwyxjiBY3NMO+UaDn6DDt8pV5NKD4=;
	h=Date:To:From:Subject:From;
	b=h8Z2Ex8m2xPXT4Nk3r1oPhsInZpxxhYubgyLA5EwiC5jRiNilHi9o7Z5RUQ4Is3My
	 FkK4T0Mwg8bhZjRJ3tm7Lqiq+Y6lxdHhftlKxc7YItCd35HAD2jh17QByrVVGSYJBZ
	 UK/Pm4tk81Mvow3CaNv/NEwQosi8t7GC/5tkNpOM=
Date: Sun, 10 Dec 2023 16:55:11 -0800
To: mm-commits@vger.kernel.org,ira.weiny@intel.com,fabio.maria.de.francesco@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-use-kmap_local_page-in-__wp_page_copy_user.patch removed from -mm tree
Message-Id: <20231211005511.D467FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: use kmap_local_page() in __wp_page_copy_user()
has been removed from the -mm tree.  Its filename was
     mm-memory-use-kmap_local_page-in-__wp_page_copy_user.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fabio.maria.de.francesco@linux.intel.com>
Subject: mm/memory: use kmap_local_page() in __wp_page_copy_user()
Date: Mon, 20 Nov 2023 15:24:05 +0100

kmap_atomic() has been deprecated in favor of kmap_local_{folio,page}.

Therefore, replace kmap_atomic() with kmap_local_page in
__wp_page_copy_user().

kmap_atomic() disables preemption in !PREEMPT_RT kernels and
unconditionally disables also page-faults.  My limited knowledge of the
implementation of __wp_page_copy_user() makes me think that the latter
side effect is still needed here, but kmap_local_page() is implemented not
to disable page-faults.

So, in addition to the conversion to local mapping, add explicit
pagefault_disable() / pagefault_enable() between mapping and un-mapping.

Link: https://lkml.kernel.org/r/20231120142418.6977-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memory-use-kmap_local_page-in-__wp_page_copy_user
+++ a/mm/memory.c
@@ -2841,7 +2841,8 @@ static inline int __wp_page_copy_user(st
 	 * just copying from the original user address. If that
 	 * fails, we just zero-fill it. Live with it.
 	 */
-	kaddr = kmap_atomic(dst);
+	kaddr = kmap_local_page(dst);
+	pagefault_disable();
 	uaddr = (void __user *)(addr & PAGE_MASK);
 
 	/*
@@ -2909,7 +2910,8 @@ warn:
 pte_unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-	kunmap_atomic(kaddr);
+	pagefault_enable();
+	kunmap_local(kaddr);
 	flush_dcache_page(dst);
 
 	return ret;
_

Patches currently in -mm which might be from fabio.maria.de.francesco@linux.intel.com are



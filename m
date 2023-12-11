Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F7D4692
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iVjaP15x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EF3C433C7;
	Mon, 11 Dec 2023 00:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256111;
	bh=FRD4jaWJiSd65svfzpx+fKz3elQ6x66AYjJUGV9bINg=;
	h=Date:To:From:Subject:From;
	b=iVjaP15xsqjD1plFp2J3f9lqRQuqDCu6VnsxIqAbHJEbVTzvP7NPPKRfLsmsqomvQ
	 HaORmzxKAjvOBBSNAjqRmqW8Zi/xXB4Zpc44PDYTxKmo1/5d9VeElYvGDATf2JsFhH
	 Sn9hEwadZBfijFYYD7964fMKN9zepqOHWZxfvx+Y=
Date: Sun, 10 Dec 2023 16:55:10 -0800
To: mm-commits@vger.kernel.org,ira.weiny@intel.com,fabio.maria.de.francesco@linux.intel.com,fabio.maria.de.francesco@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-use-kmap_local_page-in-calc_checksum.patch removed from -mm tree
Message-Id: <20231211005510.E9EF3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: use kmap_local_page() in calc_checksum()
has been removed from the -mm tree.  Its filename was
     mm-ksm-use-kmap_local_page-in-calc_checksum.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fabio.maria.de.francesco@intel.com>
Subject: mm/ksm: use kmap_local_page() in calc_checksum()
Date: Mon, 20 Nov 2023 15:18:44 +0100

kmap_atomic() has been deprecated in favor of kmap_local_page().

Therefore, replace kmap_atomic() with kmap_local_page() in
calc_checksum().

kmap_atomic() is implemented like a kmap_local_page() which also disables
page-faults and preemption (the latter only in !PREEMPT_RT kernels).  The
kernel virtual addresses returned by these two API are only valid in the
context of the callers (i.e., they cannot be handed to other threads).

With kmap_local_page() the mappings are per thread and CPU local like in
kmap_atomic(); however, they can handle page-faults and can be called from
any context (including interrupts).  The tasks that call kmap_local_page()
can be preempted and, when they are scheduled to run again, the kernel
virtual addresses are restored and are still valid.

In calc_checksum(), the block of code between the mapping and un-mapping
does not depend on the above-mentioned side effects of kmap_aatomic(), so
that a mere replacements of the old API with the new one is all that is
required (i.e., there is no need to explicitly call pagefault_disable()
and/or preempt_disable()).

Link: https://lkml.kernel.org/r/20231120141855.6761-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/ksm.c~mm-ksm-use-kmap_local_page-in-calc_checksum
+++ a/mm/ksm.c
@@ -1099,9 +1099,9 @@ error:
 static u32 calc_checksum(struct page *page)
 {
 	u32 checksum;
-	void *addr = kmap_atomic(page);
+	void *addr = kmap_local_page(page);
 	checksum = xxhash(addr, PAGE_SIZE, 0);
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 	return checksum;
 }
 
_

Patches currently in -mm which might be from fabio.maria.de.francesco@intel.com are



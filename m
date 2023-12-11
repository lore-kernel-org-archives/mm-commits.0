Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B24468D
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wPgpWeZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F278C433C7;
	Mon, 11 Dec 2023 00:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256119;
	bh=eyRwvAbQfc/Nfx/4U1WyUlD2cuh3hwLOE7m2KeV49DE=;
	h=Date:To:From:Subject:From;
	b=wPgpWeZnFU6+DN66nI+rC7tWjcnC2QMWAIr5mEkZPYFmz7EKjNTKfhmpPmDakYt6+
	 3k/AUeK42yYVrun3UyNsOLxaYyuvN/FgFfhjTW5bvnZPt+uzYEfXd/Su9odbnwRU+C
	 WyhUdkDH6WYfOnvqjSuHTos80jXTRr40W1kZP6t0=
Date: Sun, 10 Dec 2023 16:55:18 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,fancer.lancer@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-extend-init-unavailable-range-doc-info.patch removed from -mm tree
Message-Id: <20231211005519.4F278C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: extend init unavailable range doc info
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-extend-init-unavailable-range-doc-info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Serge Semin <fancer.lancer@gmail.com>
Subject: mm/mm_init.c: extend init unavailable range doc info
Date: Wed, 22 Nov 2023 21:24:03 +0300

Besides of the already described reasons the pages backended memory holes
might be persistent due to having memory mapped IO spaces behind those
ranges in the framework of flatmem kernel config.  Add such note to the
init_unavailable_range() method kdoc in order to point out to one more
reason of having the function executed for such regions.

[fancer.lancer@gmail.com: update per Mike]
  Link: https://lkml.kernel.org/r/20231202111855.18392-1-fancer.lancer@gmail.com
Link: https://lkml.kernel.org/r/20231122182419.30633-6-fancer.lancer@gmail.com
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mm_init.c~mm-mm_initc-extend-init-unavailable-range-doc-info
+++ a/mm/mm_init.c
@@ -796,6 +796,7 @@ overlap_memmap_init(unsigned long zone,
  * - physical memory bank size is not necessarily the exact multiple of the
  *   arbitrary section size
  * - early reserved memory may not be listed in memblock.memory
+ * - non-memory regions covered by the contigious flatmem mapping
  * - memory layouts defined with memmap= kernel parameter may not align
  *   nicely with memmap sections
  *
_

Patches currently in -mm which might be from fancer.lancer@gmail.com are



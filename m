Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FE822313
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 19:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719257527; cv=none; b=dSjYhf2V35lojdVjs7n9I3Zdl7AOiQtKj4MFNoGCUt4RvBZ7lzpNd8rOHxnvkncHZNcJHGPoS8XnUjbtdJxQW6yzPepctaVyolpbV9JBoVvvFFGCtE7AHkLKMYmRT2dL8IbjyH704rJuVFSuOuzBs1rrx9LhlFTHhiROYZCp5Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719257527; c=relaxed/simple;
	bh=C1pLDjW30EWKXsmCnG1Gd89LgKZXwcBw7i8hopI5GN8=;
	h=Date:To:From:Subject:Message-Id; b=crVlQteQtR0PH2zewQ0lg8wiH3uJ2ml+EzRHnQ2RWlfzsKr8YN1OEszCMA/2NkhjC/PZCGBzU9oUGcn6vB+zjs0UQRnLBiFmTREUZQuLk7yBN3i1P/W0+6Jcvfr9y8OylvmXpVFm6vcSlINi6gLscuqbWvljAqqwREb0umQfH1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DNpwvaVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DNpwvaVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B354C2BBFC;
	Mon, 24 Jun 2024 19:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719257527;
	bh=C1pLDjW30EWKXsmCnG1Gd89LgKZXwcBw7i8hopI5GN8=;
	h=Date:To:From:Subject:From;
	b=DNpwvaVHZ3fVjbPjmYfrLiy31rM4D5YAgLaYcNJdHaq7CL82hIqEuZPdmnakWx3JJ
	 jzPYu4iTDPlT3XpdIVA3Yrzxfnp/LhYpqfFTbY8cc0Np+l/Cmy1WYHtIa1paY3R7JV
	 4YZBGjDe9XB/v0WaMReXFB+rMYE6pKnJEMb9is7U=
Date: Mon, 24 Jun 2024 12:32:06 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-4.patch added to mm-unstable branch
Message-Id: <20240624193207.2B354C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-4
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-4.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-4
Date: Mon Jun 24 12:28:05 PM PDT 2024

huge_memory.c needs mm_types.h

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: kernel test robot <lkp@intel.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/huge_memory.c~mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-4
+++ a/mm/huge_memory.c
@@ -20,6 +20,7 @@
 #include <linux/swapops.h>
 #include <linux/backing-dev.h>
 #include <linux/dax.h>
+#include <linux/mm_types.h>
 #include <linux/khugepaged.h>
 #include <linux/freezer.h>
 #include <linux/pfn_t.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-4.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch


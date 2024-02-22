Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540DD210F8;
	Thu, 22 Feb 2024 23:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644512; cv=none; b=PuQBm9LyDdFf59jz5kEAyGg7DrHbelEppAWzGqAKG2TkPqfvMRU4VXBIOvOIqAeBnBVy1CaOactNKmHBJJLvosWkCpGlM9Es+npEvSoLRhWde1zK2mGrRLdfZem3Ai/eJhqlyAS7/bPtaZ8gihKEY/YiHvo+MnryWF6fWTnoJ7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644512; c=relaxed/simple;
	bh=cir/6b6g0lwcVlHZPpyFvr6Mt+KOxsK89qL0js8+Pq8=;
	h=Date:To:From:Subject:Message-Id; b=ggpFZWiM/tL0Ux4sWETpqNZtaCImOeCnO7RbDP+T3jZDdKLA6s9OCPAmKmlu5UiOrirvkGG8kWCAynP7FfGYTvrlGtmRvuDWXYgQDglLpRoS0DkmFUjk3+pC66/18kswQFUGYhNIR2C9/ayJBj12+GCf6SAigjTjd2XaBWRWfY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mW1YNZFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mW1YNZFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FA7C433C7;
	Thu, 22 Feb 2024 23:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644512;
	bh=cir/6b6g0lwcVlHZPpyFvr6Mt+KOxsK89qL0js8+Pq8=;
	h=Date:To:From:Subject:From;
	b=mW1YNZFKdrYbqEnQuFbXAynIy7W85YbbXjTvkNL4vP6iysam45LsGVH+E2ff4rRO7
	 7BzyzDDvZOmW8U/iTK86rlNJ+V4646ojei5Rl5D6gHbM/cKUKk124m9bKweV9gyWki
	 yF3qcL3hMiiluHNfQlZuYdplhTVQSg899VQzZwvg=
Date: Thu, 22 Feb 2024 15:28:31 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,snitzer@kernel.org,mpatocka@redhat.com,lkp@intel.com,linux@armlinux.org.uk,hch@lst.de,hca@linux.ibm.com,dm-devel@lists.linux.dev,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-fix-incorrect-list-of-data-cache-aliasing-architectures.patch removed from -mm tree
Message-Id: <20240222232832.28FA7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax: fix incorrect list of data cache aliasing architectures
has been removed from the -mm tree.  Its filename was
     dax-fix-incorrect-list-of-data-cache-aliasing-architectures.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: dax: fix incorrect list of data cache aliasing architectures
Date: Thu, 15 Feb 2024 09:46:33 -0500

commit d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
prevents DAX from building on architectures with virtually aliased
dcache with:

  depends on !(ARM || MIPS || SPARC)

This check is too broad (e.g. recent ARMv7 don't have virtually aliased
dcaches), and also misses many other architectures with virtually
aliased data cache.

This is a regression introduced in the v4.0 Linux kernel where the
dax mount option is removed for 32-bit ARMv7 boards which have no data
cache aliasing, and therefore should work fine with FS_DAX.

This was turned into the following check in alloc_dax() by a preparatory
change:

        if (ops && (IS_ENABLED(CONFIG_ARM) ||
            IS_ENABLED(CONFIG_MIPS) ||
            IS_ENABLED(CONFIG_SPARC)))
                return NULL;

Use cpu_dcache_is_aliasing() instead to figure out whether the environment
has aliasing data caches.

Link: https://lkml.kernel.org/r/20240215144633.96437-10-mathieu.desnoyers@efficios.com
Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Michael Sclafani <dm-devel@lists.linux.dev>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/super.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/dax/super.c~dax-fix-incorrect-list-of-data-cache-aliasing-architectures
+++ a/drivers/dax/super.c
@@ -13,6 +13,7 @@
 #include <linux/uio.h>
 #include <linux/dax.h>
 #include <linux/fs.h>
+#include <linux/cacheinfo.h>
 #include "dax-private.h"
 
 /**
@@ -456,9 +457,7 @@ struct dax_device *alloc_dax(void *priva
 	 * except for device-dax (NULL operations pointer), which does
 	 * not use aliased mappings from the kernel.
 	 */
-	if (ops && (IS_ENABLED(CONFIG_ARM) ||
-	    IS_ENABLED(CONFIG_MIPS) ||
-	    IS_ENABLED(CONFIG_SPARC)))
+	if (ops && cpu_dcache_is_aliasing())
 		return ERR_PTR(-EOPNOTSUPP);
 
 	if (WARN_ON_ONCE(ops && !ops->zero_page_range))
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are



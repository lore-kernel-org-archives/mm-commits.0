Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DD24EB2B
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 21:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707427661; cv=none; b=NC9aJPfao/lluX5yURmxmF0w/CyafoDOZm0TTZWjSO1MgPLbufb5T7YNtiL0A0+9NXV30LkmUc8ZKNEaEZjs+oylNJrBGwqPePgJjciBxwn88uR/RRBZOwS5M/f+i2vaQQ24mjCZHEqwUfQWLk5C95SD+HVZBiIg2J/SpfHNDQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707427661; c=relaxed/simple;
	bh=xNDE0mfDmVPXDQWBQnwL3zS3mtC/zqBnRvmDQmWrpbo=;
	h=Date:To:From:Subject:Message-Id; b=k2efCU8ANWvWA5i0JlstuSombnHELJDk+O0RudwET/ltfJl4K1wg2SC7Ju1QfWfocziTlA78D26Ib3OKt2pld8cEVj6CCHPchQ4woG92hgtHECmILI4HlYUkyovCSxd69tE+5/dTDd9Cz9ZSNF7M68HenDOytFGXCvcRlru0+fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zov9g9Ic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zov9g9Ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987A6C433C7;
	Thu,  8 Feb 2024 21:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707427660;
	bh=xNDE0mfDmVPXDQWBQnwL3zS3mtC/zqBnRvmDQmWrpbo=;
	h=Date:To:From:Subject:From;
	b=Zov9g9IcHvfiI1cU68S81SydFSX9W/x3PmynrpSwNfvIhD3FQlaPfMaVOk87ReVM0
	 1AVhd/MFUd1bvFgcTfKyWm2fXmTCCuVPPfx6Pzmw5p/hDggMACrxgV4lT2+li2092/
	 ixMSrQrIuskudDgrm6HILx/ra9m8RbZfeGa6NwLU=
Date: Thu, 08 Feb 2024 13:27:39 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,torvalds@linux-foundation.org,snitzer@kernel.org,mpatocka@redhat.com,linux@armlinux.org.uk,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-fix-incorrect-list-of-data-cache-aliasing-architectures.patch added to mm-unstable branch
Message-Id: <20240208212740.987A6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dax: fix incorrect list of data cache aliasing architectures
has been added to the -mm mm-unstable branch.  Its filename is
     dax-fix-incorrect-list-of-data-cache-aliasing-architectures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-fix-incorrect-list-of-data-cache-aliasing-architectures.patch

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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: dax: fix incorrect list of data cache aliasing architectures
Date: Thu, 8 Feb 2024 13:49:09 -0500

commit d92576f1167c ("dax: does not work correctly with virtual aliasing
caches") prevents DAX from building on architectures with virtually
aliased dcache with:

  depends on !(ARM || MIPS || SPARC)

This check is too broad (e.g.  recent ARMv7 don't have virtually aliased
dcaches), and also misses many other architectures with virtually aliased
data cache.

This is a regression introduced in the v4.0 Linux kernel where the dax
mount option is removed for 32-bit ARMv7 boards which have no data cache
aliasing, and therefore should work fine with FS_DAX.

This was turned into the following check in alloc_dax() by a preparatory
change:

        if (ops && (IS_ENABLED(CONFIG_ARM) ||
            IS_ENABLED(CONFIG_MIPS) ||
            IS_ENABLED(CONFIG_SPARC)))
                return NULL;

Use cpu_dcache_is_aliasing() instead to figure out whether the environment
has aliasing data caches.

Link: https://lkml.kernel.org/r/20240208184913.484340-9-mathieu.desnoyers@efficios.com
Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
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

nvdimm-pmem-fix-leak-on-dax_add_host-failure.patch
nvdimm-pmem-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dm-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dcssblk-handle-alloc_dax-eopnotsupp-failure.patch
virtio-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dax-check-for-data-cache-aliasing-at-runtime.patch
introduce-cpu_dcache_is_aliasing-across-all-architectures.patch
dax-fix-incorrect-list-of-data-cache-aliasing-architectures.patch
nvdimm-pmem-cleanup-alloc_dax-error-handling.patch
dm-cleanup-alloc_dax-error-handling.patch
dcssblk-cleanup-alloc_dax-error-handling.patch
virtio-cleanup-alloc_dax-error-handling.patch


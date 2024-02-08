Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65D14205E
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 21:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707427647; cv=none; b=ONzbNKpyTsBkXJercMcsEIk6FaFrvzLQYsA6JtjPtJ85xyCV4qKFpV7BI6y16WRiybiJei5ws+CXIx3YtBYHtMVyuTVjnNLFIyFEcD6r8zMC5RJHV2zdsYiBX6R6NZZZGKSCKCteANSdOEZWV5uBwzIbb6pKp2h80N9YbtVJ3ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707427647; c=relaxed/simple;
	bh=IKXwZYZox1CWXTSz9M1lGVPVHG4BGpODAhVDoTvIk9s=;
	h=Date:To:From:Subject:Message-Id; b=O2fZYSsLFwxNVmNZB03Miao+pubprrlKnlGHdrwaPZ0DRXdyXUK27BysRN5D9hqxwsLnnQbOazI759YIYC96t2nIvbq0tidaRg//TfILLICE2RCLCs17mKM834rNzHXXxVEtmgbJcMbRbzoCQ9a0DFmURnXNJ1myFVp3x8ZdyGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pWKV94KG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pWKV94KG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE6AC433C7;
	Thu,  8 Feb 2024 21:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707427647;
	bh=IKXwZYZox1CWXTSz9M1lGVPVHG4BGpODAhVDoTvIk9s=;
	h=Date:To:From:Subject:From;
	b=pWKV94KG7n1ZjLA3gOX6xLdAI2BlpUOBvF8MOfv/77nO7AABu9KQIcp8RnruRQBc3
	 CHkme0Kny1P9xtu/caxpKb5cDegerwlfgQZ2vCwT/4+KLd9uohWwkJTTGegdV2VIhh
	 Z5+I2JJrP2eORl6tJ9YJiSuyKBG2HBeYPJlzv6qM=
Date: Thu, 08 Feb 2024 13:27:26 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,torvalds@linux-foundation.org,snitzer@kernel.org,mpatocka@redhat.com,linux@armlinux.org.uk,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nvdimm-pmem-fix-leak-on-dax_add_host-failure.patch added to mm-unstable branch
Message-Id: <20240208212727.1DE6AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nvdimm/pmem: fix leak on dax_add_host() failure
has been added to the -mm mm-unstable branch.  Its filename is
     nvdimm-pmem-fix-leak-on-dax_add_host-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nvdimm-pmem-fix-leak-on-dax_add_host-failure.patch

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
Subject: nvdimm/pmem: fix leak on dax_add_host() failure
Date: Thu, 8 Feb 2024 13:49:02 -0500

Patch series "Introduce cpu_dcache_is_aliasing() to fix DAX regression",
v4.

This commit introduced in v4.0 prevents building FS_DAX on 32-bit ARM,
even on ARMv7 which does not have virtually aliased data caches:

commit d92576f1167c ("dax: does not work correctly with virtual aliasing caches")

It used to work fine before: I have customers using DAX over pmem on
ARMv7, but this regression will likely prevent them from upgrading their
kernel.

The root of the issue here is the fact that DAX was never designed to
handle virtually aliasing data caches (VIVT and VIPT with aliasing data
cache).  It touches the pages through their linear mapping, which is not
consistent with the userspace mappings with virtually aliasing data
caches.

This patch series introduces cpu_dcache_is_aliasing() with the new Kconfig
option ARCH_HAS_CPU_CACHE_ALIASING and implements it for all
architectures.  The implementation of cpu_dcache_is_aliasing() is either
evaluated to a constant at compile-time or a runtime check, which is what
is needed on ARM.

With this we can basically narrow down the list of architectures which are
unsupported by DAX to those which are really affected.


This patch (of 12):

Fix a leak on dax_add_host() error, where "goto out_cleanup_dax" is done
before setting pmem->dax_dev, which therefore issues the two following
calls on NULL pointers:

out_cleanup_dax:
        kill_dax(pmem->dax_dev);
        put_dax(pmem->dax_dev);

Link: https://lkml.kernel.org/r/20240208184913.484340-1-mathieu.desnoyers@efficios.com
Link: https://lkml.kernel.org/r/20240208184913.484340-2-mathieu.desnoyers@efficios.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/pmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/nvdimm/pmem.c~nvdimm-pmem-fix-leak-on-dax_add_host-failure
+++ a/drivers/nvdimm/pmem.c
@@ -566,12 +566,11 @@ static int pmem_attach_disk(struct devic
 	set_dax_nomc(dax_dev);
 	if (is_nvdimm_sync(nd_region))
 		set_dax_synchronous(dax_dev);
+	pmem->dax_dev = dax_dev;
 	rc = dax_add_host(dax_dev, disk);
 	if (rc)
 		goto out_cleanup_dax;
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
-	pmem->dax_dev = dax_dev;
-
 	rc = device_add_disk(dev, disk, pmem_attribute_groups);
 	if (rc)
 		goto out_remove_host;
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


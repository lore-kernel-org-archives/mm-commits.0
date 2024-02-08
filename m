Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838384F1ED
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 21:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707427651; cv=none; b=fucH6n6hLaAN9svEfx6qJk1fapHPb+eD89jUMdlBzbc9ByXD6qpTJjW/I32yPR0rYssbP/e1Uehrvez+JVcbShOhC3KEgOIcJgTI9Z+8M+ewXI9TdfRBaazF1VxFpw057JvqBCv97VIXp/dJpu6nPVApmJIMwB/IhskCQEC6AE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707427651; c=relaxed/simple;
	bh=qBTYeGoN5n/2EfwxTItL8JMPcUab3n/XPrpqfcvfATA=;
	h=Date:To:From:Subject:Message-Id; b=A4gZ7TafYdq6gK+ix609EC6bVzKEBykiVJrwJavgmPTNuNKCk6r8fj27jfBVf0+LRvpPZnmzF308zW923gI7QE62hxc6ugR51PNnDUsy8LiX/3GJnv5hDw1fWTHT2Kcb7fUSKj+5N0+DOhMoHULQtE05Ewnr+5VcLSByJyVr7Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZJTJ+vyA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZJTJ+vyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01FDC433F1;
	Thu,  8 Feb 2024 21:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707427651;
	bh=qBTYeGoN5n/2EfwxTItL8JMPcUab3n/XPrpqfcvfATA=;
	h=Date:To:From:Subject:From;
	b=ZJTJ+vyA9FAcjUPhjoCzIwWfuJTghtKvnTthOdiNZPMeDAp8X8ZI6yBiZdH76RV2r
	 IXOx010F9SJNwt0BFasI92svZkeCrK78eebua+ljit4EVtdtM27uxOZ0LwBxu75tG4
	 a4hmXVkn6Wg/WgiaTRgSGl9smXCWl9dsKkyXBnXI=
Date: Thu, 08 Feb 2024 13:27:30 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,torvalds@linux-foundation.org,snitzer@kernel.org,mpatocka@redhat.com,linux@armlinux.org.uk,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,akpm@linux-foundation.org,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dcssblk-handle-alloc_dax-eopnotsupp-failure.patch added to mm-unstable branch
Message-Id: <20240208212730.E01FDC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dcssblk: handle alloc_dax() -EOPNOTSUPP failure
has been added to the -mm mm-unstable branch.  Its filename is
     dcssblk-handle-alloc_dax-eopnotsupp-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dcssblk-handle-alloc_dax-eopnotsupp-failure.patch

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
Subject: dcssblk: handle alloc_dax() -EOPNOTSUPP failure
Date: Thu, 8 Feb 2024 13:49:05 -0500

In preparation for checking whether the architecture has data cache
aliasing within alloc_dax(), modify the error handling of dcssblk
dcssblk_add_store() to handle alloc_dax() -EOPNOTSUPP failures.

Considering that s390 is not a data cache aliasing architecture, and
considering that DCSSBLK selects DAX, a return value of -EOPNOTSUPP from
alloc_dax() should make dcssblk_add_store() fail.

For the transition, consider that alloc_dax() returning NULL is the same
as returning -EOPNOTSUPP.

Link: https://lkml.kernel.org/r/20240208184913.484340-5-mathieu.desnoyers@efficios.com
Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/block/dcssblk.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/s390/block/dcssblk.c~dcssblk-handle-alloc_dax-eopnotsupp-failure
+++ a/drivers/s390/block/dcssblk.c
@@ -549,6 +549,7 @@ dcssblk_add_store(struct device *dev, st
 	int rc, i, j, num_of_segments;
 	struct dcssblk_dev_info *dev_info;
 	struct segment_info *seg_info, *temp;
+	struct dax_device *dax_dev;
 	char *local_buf;
 	unsigned long seg_byte_size;
 
@@ -677,13 +678,13 @@ dcssblk_add_store(struct device *dev, st
 	if (rc)
 		goto put_dev;
 
-	dev_info->dax_dev = alloc_dax(dev_info, &dcssblk_dax_ops);
-	if (IS_ERR(dev_info->dax_dev)) {
-		rc = PTR_ERR(dev_info->dax_dev);
-		dev_info->dax_dev = NULL;
+	dax_dev = alloc_dax(dev_info, &dcssblk_dax_ops);
+	if (IS_ERR_OR_NULL(dax_dev)) {
+		rc = IS_ERR(dax_dev) ? PTR_ERR(dax_dev) : -EOPNOTSUPP;
 		goto put_dev;
 	}
-	set_dax_synchronous(dev_info->dax_dev);
+	set_dax_synchronous(dax_dev);
+	dev_info->dax_dev = dax_dev;
 	rc = dax_add_host(dev_info->dax_dev, dev_info->gd);
 	if (rc)
 		goto out_dax;
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


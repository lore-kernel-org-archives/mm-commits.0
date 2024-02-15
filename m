Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA4D1384B8;
	Thu, 15 Feb 2024 20:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708027572; cv=none; b=ixjz6KcI0p40sL+vf/zQHrZx4vbZnIH54TgdrsZXlV5oBnfgP7iW4mPjwKxTl1UsTaMflWn05O6YX74unChUGfCsVKCfPogSTRX+4/qjE0Yo3sQ4+HYYh3OJhbu/GDYHiS/9Pntdz4bty7MjmbZciqbNDoIW0gUDL7ihd5r6ViE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708027572; c=relaxed/simple;
	bh=MbDO1OGusUpcGW3iM7pT8h766s9nUqt0Q8emBUNS17Q=;
	h=Date:To:From:Subject:Message-Id; b=teX2SBf5cL3Jbs3BHuZeoIKGCv3qTb6tECD9ONKxq5eFai2+kYemUBQNpM8kQA4pIXtsfzY++K7xnArHud8e6hsYk4HO3coqnkDogtzsptbqkvQBs9mIXGF/QJLNbF37rPdd2ZNORi38FB4fyuSR4vW79jUSrx8H+0VuYbvxBko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uxbd5KdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uxbd5KdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F2AC433F1;
	Thu, 15 Feb 2024 20:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708027571;
	bh=MbDO1OGusUpcGW3iM7pT8h766s9nUqt0Q8emBUNS17Q=;
	h=Date:To:From:Subject:From;
	b=uxbd5KdSirmi9TfiFCQEgTGQ6qfXQTTNj1PO3djRhhZlviVr19OxdfVaxhmrbVYCP
	 0Exmtd/9Lun5N7A4VIXzr7VzrXj9eCF7JVqzMP1qZjS2pdeknUIFzQf3x1AmGo6Jgf
	 P8is/wjz5CmUObxSa2QsmFEXFvRAuppTCYSu/nq4=
Date: Thu, 15 Feb 2024 12:06:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,snitzer@kernel.org,mpatocka@redhat.com,lkp@intel.com,linux@armlinux.org.uk,hch@lst.de,hca@linux.ibm.com,dm-devel@lists.linux.dev,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + virtio-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch added to mm-unstable branch
Message-Id: <20240215200611.D1F2AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: virtio: Treat alloc_dax() -EOPNOTSUPP failure as non-fatal
has been added to the -mm mm-unstable branch.  Its filename is
     virtio-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/virtio-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch

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
Subject: virtio: Treat alloc_dax() -EOPNOTSUPP failure as non-fatal
Date: Thu, 15 Feb 2024 09:46:30 -0500

In preparation for checking whether the architecture has data cache
aliasing within alloc_dax(), modify the error handling of virtio
virtio_fs_setup_dax() to treat alloc_dax() -EOPNOTSUPP failure as
non-fatal.

Link: https://lkml.kernel.org/r/20240215144633.96437-7-mathieu.desnoyers@efficios.com
Co-developed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
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
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Michael Sclafani <dm-devel@lists.linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/virtio_fs.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/fuse/virtio_fs.c~virtio-treat-alloc_dax-eopnotsupp-failure-as-non-fatal
+++ a/fs/fuse/virtio_fs.c
@@ -16,6 +16,7 @@
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
 #include <linux/highmem.h>
+#include <linux/cleanup.h>
 #include <linux/uio.h>
 #include "fuse_i.h"
 
@@ -795,8 +796,11 @@ static void virtio_fs_cleanup_dax(void *
 	put_dax(dax_dev);
 }
 
+DEFINE_FREE(cleanup_dax, struct dax_dev *, if (!IS_ERR_OR_NULL(_T)) virtio_fs_cleanup_dax(_T))
+
 static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
 {
+	struct dax_device *dax_dev __free(cleanup_dax) = NULL;
 	struct virtio_shm_region cache_reg;
 	struct dev_pagemap *pgmap;
 	bool have_cache;
@@ -804,6 +808,12 @@ static int virtio_fs_setup_dax(struct vi
 	if (!IS_ENABLED(CONFIG_FUSE_DAX))
 		return 0;
 
+	dax_dev = alloc_dax(fs, &virtio_fs_dax_ops);
+	if (IS_ERR(dax_dev)) {
+		int rc = PTR_ERR(dax_dev);
+		return rc == -EOPNOTSUPP ? 0 : rc;
+	}
+
 	/* Get cache region */
 	have_cache = virtio_get_shm_region(vdev, &cache_reg,
 					   (u8)VIRTIO_FS_SHMCAP_ID_CACHE);
@@ -849,10 +859,7 @@ static int virtio_fs_setup_dax(struct vi
 	dev_dbg(&vdev->dev, "%s: window kaddr 0x%px phys_addr 0x%llx len 0x%llx\n",
 		__func__, fs->window_kaddr, cache_reg.addr, cache_reg.len);
 
-	fs->dax_dev = alloc_dax(fs, &virtio_fs_dax_ops);
-	if (IS_ERR(fs->dax_dev))
-		return PTR_ERR(fs->dax_dev);
-
+	fs->dax_dev = no_free_ptr(dax_dev);
 	return devm_add_action_or_reset(&vdev->dev, virtio_fs_cleanup_dax,
 					fs->dax_dev);
 }
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

nvdimm-pmem-fix-leak-on-dax_add_host-failure.patch
dax-add-empty-static-inline-for-config_dax=n.patch
dax-alloc_dax-return-err_ptr-eopnotsupp-for-config_dax=n.patch
nvdimm-pmem-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dm-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dcssblk-handle-alloc_dax-eopnotsupp-failure.patch
virtio-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dax-check-for-data-cache-aliasing-at-runtime.patch
introduce-cpu_dcache_is_aliasing-across-all-architectures.patch
dax-fix-incorrect-list-of-data-cache-aliasing-architectures.patch


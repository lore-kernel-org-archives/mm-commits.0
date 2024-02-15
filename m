Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0728113A274;
	Thu, 15 Feb 2024 20:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708027574; cv=none; b=qKrADJAHZdQvdwwsBro0VIGzVkYJQNhyw5dJAM8j/DsS9WM+l9sSpDRqWAEJkPvgZU3tjPTV+BcpOYntW1J5xXyiiqLLHlYvbbFw0lb1CMpJIRFrrnnLyAP3qFyXUV76umvIJNgvk5mv4Ci4FZEkYCw+2m9X0gzzAFRNSJ9V5P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708027574; c=relaxed/simple;
	bh=wqT4aymXjlZf5+V0ppfRJC5QBB6CkcAiMPoc++byL8g=;
	h=Date:To:From:Subject:Message-Id; b=hugPxN50TEKxs9aSeImbF7fLNmScR6z4vNElahRV+v/MnTNvX1PdW7ohFzD1T01UB3dqmgcmqBkkowT1UekA41tMY2dUz1aL+R1RFXl3y+U8QnlIARtn2p63nnroaBPQCFUvpmMAhX7vSJ5jPMC7fTJDju5tde/8c0Rf371J/58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e+fR6QKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e+fR6QKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD900C433C7;
	Thu, 15 Feb 2024 20:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708027573;
	bh=wqT4aymXjlZf5+V0ppfRJC5QBB6CkcAiMPoc++byL8g=;
	h=Date:To:From:Subject:From;
	b=e+fR6QKUW0sMufS+D+vfBlp8NATuT8Kj9V94cEB2AG8smcB6/THOnfrMaHY7XdALM
	 wa3S5POIQ01MSw/StbDgWPh2wxZZD6XYHYCg9QB6w2H15g/Qd6x6/HIBQaJXQ/OSGg
	 Mv4oMzolCHFXC+kvMva8NnpIYI/ksBMSYWEh6v2w=
Date: Thu, 15 Feb 2024 12:06:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,snitzer@kernel.org,mpatocka@redhat.com,lkp@intel.com,linux@armlinux.org.uk,hch@lst.de,hca@linux.ibm.com,dm-devel@lists.linux.dev,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-check-for-data-cache-aliasing-at-runtime.patch added to mm-unstable branch
Message-Id: <20240215200613.BD900C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dax: Check for data cache aliasing at runtime
has been added to the -mm mm-unstable branch.  Its filename is
     dax-check-for-data-cache-aliasing-at-runtime.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-check-for-data-cache-aliasing-at-runtime.patch

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
Subject: dax: Check for data cache aliasing at runtime
Date: Thu, 15 Feb 2024 09:46:31 -0500

Replace the following fs/Kconfig:FS_DAX dependency:

  depends on !(ARM || MIPS || SPARC)

By a runtime check within alloc_dax(). This runtime check returns
ERR_PTR(-EOPNOTSUPP) if the @ops parameter is non-NULL (which means
the kernel is using an aliased mapping) on an architecture which
has data cache aliasing.

Change the return value from NULL to PTR_ERR(-EOPNOTSUPP) for
CONFIG_DAX=n for consistency.

This is done in preparation for using cpu_dcache_is_aliasing() in a
following change which will properly support architectures which detect
data cache aliasing at runtime.

Link: https://lkml.kernel.org/r/20240215144633.96437-8-mathieu.desnoyers@efficios.com
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

 drivers/dax/super.c |   10 ++++++++++
 fs/Kconfig          |    1 -
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/dax/super.c~dax-check-for-data-cache-aliasing-at-runtime
+++ a/drivers/dax/super.c
@@ -451,6 +451,16 @@ struct dax_device *alloc_dax(void *priva
 	dev_t devt;
 	int minor;
 
+	/*
+	 * Unavailable on architectures with virtually aliased data caches,
+	 * except for device-dax (NULL operations pointer), which does
+	 * not use aliased mappings from the kernel.
+	 */
+	if (ops && (IS_ENABLED(CONFIG_ARM) ||
+	    IS_ENABLED(CONFIG_MIPS) ||
+	    IS_ENABLED(CONFIG_SPARC)))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (WARN_ON_ONCE(ops && !ops->zero_page_range))
 		return ERR_PTR(-EINVAL);
 
--- a/fs/Kconfig~dax-check-for-data-cache-aliasing-at-runtime
+++ a/fs/Kconfig
@@ -60,7 +60,6 @@ endif # BLOCK
 config FS_DAX
 	bool "File system based Direct Access (DAX) support"
 	depends on MMU
-	depends on !(ARM || MIPS || SPARC)
 	depends on ZONE_DEVICE || FS_DAX_LIMITED
 	select FS_IOMAP
 	select DAX
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


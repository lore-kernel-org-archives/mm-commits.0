Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3D51A5A2;
	Thu, 22 Feb 2024 23:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644510; cv=none; b=sfOZ3bPMqqp1fLoApE6lF3GmjxyzglKGmI571QTECtLyg4GaKOUtDVf0zTwj/q3e1a5jcYWkbGfNbpWcIVIFba/lrUyQ5JZkdaGj7QSrTgBg+0VSXKW7wn56RcMbG5JFQTv2Yk2mZpkGKiWQYaw2HOCSX8J3utLGnHU6akQJPng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644510; c=relaxed/simple;
	bh=X4rKkKIN4cuaNjwidKC/1S7qMRmK2FkAQ/gCT72a+nw=;
	h=Date:To:From:Subject:Message-Id; b=ofcJkuynmkC2JIkUCeRscLSsJYs41Z10bMwmxl3xdmfv5xHrsJbGGLTzD2Ju1+3HFJq2o7nHcbXcaOmP9TmIW4WSt3+KEoAqrUJQdjnsQ4a6FgCNNE6ki0szo15oPcip/LZPXarO2h7ff20P7vPZ4oUWaIb07xm6fgcCpThooCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y9McF8kU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y9McF8kU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC01C433C7;
	Thu, 22 Feb 2024 23:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644509;
	bh=X4rKkKIN4cuaNjwidKC/1S7qMRmK2FkAQ/gCT72a+nw=;
	h=Date:To:From:Subject:From;
	b=Y9McF8kUSvlETisTZWsVWWL+yvxHpnK5DjfXxY1uhwRsJMsztLWQvtD171+4LGRr4
	 1d6sEycvpwSoX/yVt30RgSThuzI6U38ipxGGPvgUmc72zbWf/az5CyqfFaNkqra5Od
	 CgEpEQODJdbuzZEs0E6qyt8/o0X3qzXd+FhYSSyM=
Date: Thu, 22 Feb 2024 15:28:29 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,snitzer@kernel.org,mpatocka@redhat.com,lkp@intel.com,linux@armlinux.org.uk,hch@lst.de,hca@linux.ibm.com,dm-devel@lists.linux.dev,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-check-for-data-cache-aliasing-at-runtime.patch removed from -mm tree
Message-Id: <20240222232829.CCC01C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax: check for data cache aliasing at runtime
has been removed from the -mm tree.  Its filename was
     dax-check-for-data-cache-aliasing-at-runtime.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: dax: check for data cache aliasing at runtime
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



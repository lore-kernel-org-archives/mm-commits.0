Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9941384B8;
	Thu, 15 Feb 2024 20:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708027566; cv=none; b=Pe7rs9nrBCfhJh/nxWTpxHpZLR/lxb+7ZimVpNyH3MuBUFxPeykdBRmmTILzu78pbF/wTsEvugMw7Z8a1tWU62NBYL7AYiBPL9vEPACfT0ph/iaCy0XJLXUx46+CW4fOAHUA1L+JExBTpZwt3tm3z+b9+CagSa+yabaeFbVrG+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708027566; c=relaxed/simple;
	bh=VIgcNFWGx3c8ewr/GWLWUgvCMcpgapvZ2LRupJePTx0=;
	h=Date:To:From:Subject:Message-Id; b=VffgnFgwd0OPuTpnXHtjRUzbDp8sQDBh07HBRXyd87aV8SsobTNaVUuG7PBJOr4hcq40IvLbrhnUOxvnJjFMwX5mE20Mu2IupOnExZh6iw1lyfVFmQcSO/8JjILNGPqUk26slrc+NTDOOxcJ8sScaqkU2wbwGGMKFJy0WbIQ4Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2o5Y0lOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2o5Y0lOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1937C433F1;
	Thu, 15 Feb 2024 20:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708027566;
	bh=VIgcNFWGx3c8ewr/GWLWUgvCMcpgapvZ2LRupJePTx0=;
	h=Date:To:From:Subject:From;
	b=2o5Y0lOlbJq2VaVwnCpuGszKJCUignthY9KNlnfc0nHrsdWc+Y7uBBBin0QJh3/G9
	 t/as/kJSN6osn1R3xoQQgcyTONDOFB4eFha/+lwTrAjs724aRhtYX0w3RDjTayIoOC
	 LU2/wGqVtsPCeiYhZPpw2aE8IjofEAPDc/TRcb0w=
Date: Thu, 15 Feb 2024 12:06:05 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,snitzer@kernel.org,mpatocka@redhat.com,lkp@intel.com,linux@armlinux.org.uk,hch@lst.de,hca@linux.ibm.com,dm-devel@lists.linux.dev,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nvdimm-pmem-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch added to mm-unstable branch
Message-Id: <20240215200605.E1937C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nvdimm/pmem: Treat alloc_dax() -EOPNOTSUPP failure as non-fatal
has been added to the -mm mm-unstable branch.  Its filename is
     nvdimm-pmem-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nvdimm-pmem-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch

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
Subject: nvdimm/pmem: Treat alloc_dax() -EOPNOTSUPP failure as non-fatal
Date: Thu, 15 Feb 2024 09:46:27 -0500

In preparation for checking whether the architecture has data cache
aliasing within alloc_dax(), modify the error handling of nvdimm/pmem
pmem_attach_disk() to treat alloc_dax() -EOPNOTSUPP failure as non-fatal.

[ Based on commit "nvdimm/pmem: Fix leak on dax_add_host() failure". ]

Link: https://lkml.kernel.org/r/20240215144633.96437-4-mathieu.desnoyers@efficios.com
Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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

 drivers/nvdimm/pmem.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/nvdimm/pmem.c~nvdimm-pmem-treat-alloc_dax-eopnotsupp-failure-as-non-fatal
+++ a/drivers/nvdimm/pmem.c
@@ -560,17 +560,19 @@ static int pmem_attach_disk(struct devic
 	dax_dev = alloc_dax(pmem, &pmem_dax_ops);
 	if (IS_ERR(dax_dev)) {
 		rc = PTR_ERR(dax_dev);
-		goto out;
+		if (rc != -EOPNOTSUPP)
+			goto out;
+	} else {
+		set_dax_nocache(dax_dev);
+		set_dax_nomc(dax_dev);
+		if (is_nvdimm_sync(nd_region))
+			set_dax_synchronous(dax_dev);
+		pmem->dax_dev = dax_dev;
+		rc = dax_add_host(dax_dev, disk);
+		if (rc)
+			goto out_cleanup_dax;
+		dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	}
-	set_dax_nocache(dax_dev);
-	set_dax_nomc(dax_dev);
-	if (is_nvdimm_sync(nd_region))
-		set_dax_synchronous(dax_dev);
-	pmem->dax_dev = dax_dev;
-	rc = dax_add_host(dax_dev, disk);
-	if (rc)
-		goto out_cleanup_dax;
-	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	rc = device_add_disk(dev, disk, pmem_attribute_groups);
 	if (rc)
 		goto out_remove_host;
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


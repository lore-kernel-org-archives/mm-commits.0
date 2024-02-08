Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045AB4205E
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 21:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707427649; cv=none; b=gycI09m/n9jbZ8/SbUiDehatXXZOy8Qpf1RMvdQ0biWoNqUpPUXmi45YLChtDco2eY2hRdeu7Z7vp1tpDvPFwt2h2qro5OD3YMM3qLHK8PI3VnJ4AI3uxyafIJ5zUKlixRkSmuTx1w/VgKpUqMbkhTBfla8/z64+ffZfm5M9sJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707427649; c=relaxed/simple;
	bh=zJfaGHgV8XCLeqSI0n/8hhBIl3coTOugcf/LrI/8bk8=;
	h=Date:To:From:Subject:Message-Id; b=Uz8UDWXVj3Z/3Hc5VnnfCd0FNuxVdoO0LuBW9Sss5cRIcGe7qb0uSeLy7HK3EM9HwWxTJaTvTum99e88TOLiUzSTS473BOV2ndNTRzgotDlTaC/z8KacfUU4sRaaOtKIsFE35ubNIB6SpFahi13zwkROqAqwYwqFz9zZh/hwfl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pQRpqumY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pQRpqumY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF3CC43390;
	Thu,  8 Feb 2024 21:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707427648;
	bh=zJfaGHgV8XCLeqSI0n/8hhBIl3coTOugcf/LrI/8bk8=;
	h=Date:To:From:Subject:From;
	b=pQRpqumYeSU5vT9Slz7Tf/5vajq4Dtb/sfJOWTwr6yAVo9Bdx4PgVvWS3mdPxq9wT
	 XQ8XeWMo/j0rHdv5b/HTcgn25K8jWrLssz93j9WE/rTZrRIvy4lFhtsyooCJJTJERy
	 2WjQ0jVbeJ94xLFIer7jky3UtrnZQRS2PlExZPxA=
Date: Thu, 08 Feb 2024 13:27:27 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,torvalds@linux-foundation.org,snitzer@kernel.org,mpatocka@redhat.com,linux@armlinux.org.uk,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,akpm@linux-foundation.org,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nvdimm-pmem-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch added to mm-unstable branch
Message-Id: <20240208212728.6BF3CC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nvdimm/pmem: treat alloc_dax() -EOPNOTSUPP failure as non-fatal
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
Subject: nvdimm/pmem: treat alloc_dax() -EOPNOTSUPP failure as non-fatal
Date: Thu, 8 Feb 2024 13:49:03 -0500

In preparation for checking whether the architecture has data cache
aliasing within alloc_dax(), modify the error handling of nvdimm/pmem
pmem_attach_disk() to treat alloc_dax() -EOPNOTSUPP failure as non-fatal.

For the transition, consider that alloc_dax() returning NULL is the same
as returning -EOPNOTSUPP.

Link: https://lkml.kernel.org/r/20240208184913.484340-3-mathieu.desnoyers@efficios.com
Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
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

 drivers/nvdimm/pmem.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/drivers/nvdimm/pmem.c~nvdimm-pmem-treat-alloc_dax-eopnotsupp-failure-as-non-fatal
+++ a/drivers/nvdimm/pmem.c
@@ -558,19 +558,21 @@ static int pmem_attach_disk(struct devic
 	disk->bb = &pmem->bb;
 
 	dax_dev = alloc_dax(pmem, &pmem_dax_ops);
-	if (IS_ERR(dax_dev)) {
-		rc = PTR_ERR(dax_dev);
-		goto out;
+	if (IS_ERR_OR_NULL(dax_dev)) {
+		rc = IS_ERR(dax_dev) ? PTR_ERR(dax_dev) : -EOPNOTSUPP;
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077773FD4
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 19:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714158790; cv=none; b=Bd09ZvHePkEb2AOoJSrvILpKk0q6FPCL1VwnGtS3ZRWKwAu9M15AAntULAULHUtdRTFSBB38Ci4znn6Owl+t62t44vFJEaGZvaDvgzIBJSFCU+z2GowGn5FlgEC+Ay8esc1OmEF3dl1Odj+DRX8SRTgo6F7RIBgCn2hvVGIRPNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714158790; c=relaxed/simple;
	bh=aUYs9USPzXfPbM7HWFQxUTklEj1GKi6n0ejuWGRNj0s=;
	h=Date:To:From:Subject:Message-Id; b=I4jDYWRfzutcdlbYPxOIsC1VaSNtRoZZVey4N5Lml9fpavzLHAFTXpSGSAtHyyTtDDVtNvc1zoJ9j1Xhndzi4bPClifIHfgXgszPHDv7H4NCPLGfy5sdkfStWLA7JFv7zvJMYieAV1X4C/I9GbAQwLCLMROxQJGDchxYUfmCja0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vd8WM8/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vd8WM8/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB9FC113CD;
	Fri, 26 Apr 2024 19:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714158789;
	bh=aUYs9USPzXfPbM7HWFQxUTklEj1GKi6n0ejuWGRNj0s=;
	h=Date:To:From:Subject:From;
	b=vd8WM8/qsipqe24lZvWbuoDwChG1uSxATnFl68SC/KtRdLC6RhkS1n5ZMp8wR51aY
	 AgWYyr+kkCNtfJMEn3QDuYxtaQKhRNbY3dcQN1hj3wTXOgMwYm+2tk/YIw24DnIP6J
	 d0CTgbD8BO2VxqgPDn1fB99vvGSeBDnXzqkw6HVU=
Date: Fri, 26 Apr 2024 12:13:08 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,lstoakes@gmail.com,hch@lst.de,baohua@kernel.org,hailong.liu@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-return-value-of-vb_alloc-if-size-is-0.patch added to mm-hotfixes-unstable branch
Message-Id: <20240426191308.DBB9FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: fix return value of vb_alloc if size is 0
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-fix-return-value-of-vb_alloc-if-size-is-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-return-value-of-vb_alloc-if-size-is-0.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Hailong.Liu" <hailong.liu@oppo.com>
Subject: mm/vmalloc: fix return value of vb_alloc if size is 0
Date: Fri, 26 Apr 2024 10:41:49 +0800

vm_map_ram() uses IS_ERR() to validate the return value of vb_alloc().  If
vm_map_ram(page, 0, 0) is executed, vb_alloc(0, GFP_KERNEL) would return
NULL.  In such a case, IS_ERR() cannot handle the return value and lead to
kernel panic by vmap_pages_range_noflush() at last.  To resolve this
issue, return ERR_PTR(-EINVAL) if the size is 0.

Link: https://lkml.kernel.org/r/20240426024149.21176-1-hailong.liu@oppo.com
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Hailong.Liu <hailong.liu@oppo.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-return-value-of-vb_alloc-if-size-is-0
+++ a/mm/vmalloc.c
@@ -2710,7 +2710,7 @@ static void *vb_alloc(unsigned long size
 		 * get_order(0) returns funny result. Just warn and terminate
 		 * early.
 		 */
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 	order = get_order(size);
 
_

Patches currently in -mm which might be from hailong.liu@oppo.com are

mm-vmalloc-fix-return-value-of-vb_alloc-if-size-is-0.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051BB207673
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 23:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741218308; cv=none; b=Ya1pAFz4Q337ga/spUqFdDWmRAL1sc5OI/ehORNWufRrJDpeHI60pjIE9rJtgG/EPhEZZX/uqsz8SCGi39kjBn44NdaT5zLG0rDTY42KoVHHCFzsInllK2IHRM3I8x+I0xmx0FFvAnDXXrG1Az/1vwJ/xDE/P6lZ1ObAAKI7FwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741218308; c=relaxed/simple;
	bh=4cvRlUc3rI2xi5J0tbDDSIPTx3MVmFyTLGgvMGvricI=;
	h=Date:To:From:Subject:Message-Id; b=fYzCOWjGg6ZB9sAv1Cva3CpuWL6i0B+YlIF3ZFtfPVEAX15rdcfxYDoZDmBetqbN6CdtcI73ronoes/C8TqgVU4X8/6+WrXM8nps4BbU7AnJhnWUrYny2tgIVLAIjbDFamCRJ8mNR2obImNqpvnjuM6dXQPmyxYKyBksRFjg99A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T8XgEXjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T8XgEXjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F03FC4CED1;
	Wed,  5 Mar 2025 23:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741218307;
	bh=4cvRlUc3rI2xi5J0tbDDSIPTx3MVmFyTLGgvMGvricI=;
	h=Date:To:From:Subject:From;
	b=T8XgEXjmIHlMmDBPA+k6ZpIR0u3EMN1E0W/4dyS0YQ5r7v5ij8pYfM7p2SUU65u7g
	 3blF2xuE2cBAnPnm6KzuxP2jji7hF3eWD5Fn562QsWr4dT2CouiQacLF/ngCXaGlKc
	 5reUJ9NYBIztUWdLgDabDEnX6K+2S/r3E1uUGQMo=
Date: Wed, 05 Mar 2025 15:45:06 -0800
To: mm-commits@vger.kernel.org,mika.westerberg@linux.intel.com,Jonathan.Cameron@huawei.com,ilpo.jarvinen@linux.intel.com,huang.ying.caritas@gmail.com,dan.j.williams@intel.com,bhelgaas@google.com,andriy.shevchenko@linux.intel.com,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] resource-fix-resource-leak-in-get_free_mem_region.patch removed from -mm tree
Message-Id: <20250305234507.5F03FC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: fix resource leak in get_free_mem_region()
has been removed from the -mm tree.  Its filename was
     resource-fix-resource-leak-in-get_free_mem_region.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: resource: fix resource leak in get_free_mem_region()
Date: Tue, 4 Mar 2025 12:34:15 +0800

The leak is detected by the kernel memory leak detector (`kmemleak`)
following a `cxl create-region` failure:

 cxl_acpi ACPI0017:00: decoder0.0: created region2
 cxl region2: HPA allocation error (-34) for size:0x0000000100000000 in CXL Window 0 [mem 0xa90000000-0x1a8fffffff flags 0x200]
 kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

    __kmalloc_cache_noprof+0x28c/0x350
    get_free_mem_region+0x45/0x380
    alloc_free_mem_region+0x1d/0x30
    size_store+0x180/0x290 [cxl_core]
    kernfs_fop_write_iter+0x13f/0x1e0
    vfs_write+0x37c/0x540
    ksys_write+0x68/0xe0
    do_syscall_64+0x6e/0x190
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

[akpm@linux-foundation.org: fix braceology]
Link: https://lkml.kernel.org/r/20250304043415.610286-1-lizhijian@fujitsu.com
Fixes: 14b80582c43e ("resource: Introduce alloc_free_mem_region()")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dan Wiliams <dan.j.williams@intel.com>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Mika Westeberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/resource.c~resource-fix-resource-leak-in-get_free_mem_region
+++ a/kernel/resource.c
@@ -1998,8 +1998,11 @@ get_free_mem_region(struct device *dev,
 	if (flags & GFR_REQUEST_REGION) {
 		free_resource(res);
 		devres_free(dr);
-	} else if (dev)
+	} else if (dev) {
 		devm_release_action(dev, remove_free_mem_region, res);
+	} else {
+		free_resource(res);
+	}
 
 	return ERR_PTR(-ERANGE);
 }
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are



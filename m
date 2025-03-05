Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D2D195
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 00:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741133556; cv=none; b=BhO7sQThEIuoNLQvTOTHYj58YShJokYZyl10+0VvnINW08kfoMtrF4gPGuXIfeKtRIJU7qIcem1+uUN/Q5PXEm1CMb4C7KPAteTP3xklJt09RmnZ/70YlP/ub8Me/J7eyqAv4ghbVnlILnl6sTLL5YZ+G0es57k3t91XHd2c6RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741133556; c=relaxed/simple;
	bh=eNNUVju4UPoDGdGjwURHQXsHpYql2W2vsWt0NsZqFVg=;
	h=Date:To:From:Subject:Message-Id; b=rwv5wSAMdsT1J62paPtri5tJhib1XeJoREgFgvLL289hv/3EOcZZKcwMlcJa0N7eXgJxoeHO9/M8gz6O4UVZy/WcdzgdOYUzs2GkG47MuV35RTwMal/uZtles29efYoVnqwZpRYEzcDDw1/9Sk72RVoXGw21vgcxTfosuvOQL+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lnBvYZDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lnBvYZDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD349C4CEE5;
	Wed,  5 Mar 2025 00:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741133555;
	bh=eNNUVju4UPoDGdGjwURHQXsHpYql2W2vsWt0NsZqFVg=;
	h=Date:To:From:Subject:From;
	b=lnBvYZDWAZeVg8nwyStDk7RB1iVwouaFrvR2f7cuCVPvJtWP+nEzLxhZ3UNiMWFvg
	 Je/O2a30NdT0cfXZVy4yyqPAAT94jD+keKJoQQ5rO2TY67r/mNKyFo/qmC35IXNsdS
	 HR8vPYoTjz5vSd5+IOEOVou8Ec1O8G26Ef7Q/1rw=
Date: Tue, 04 Mar 2025 16:12:35 -0800
To: mm-commits@vger.kernel.org,mika.westerberg@linux.intel.com,Jonathan.Cameron@huawei.com,ilpo.jarvinen@linux.intel.com,huang.ying.caritas@gmail.com,dan.j.williams@intel.com,bhelgaas@google.com,andriy.shevchenko@linux.intel.com,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-fix-resource-leak-in-get_free_mem_region.patch added to mm-nonmm-unstable branch
Message-Id: <20250305001235.CD349C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: fix resource leak in get_free_mem_region()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-fix-resource-leak-in-get_free_mem_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-fix-resource-leak-in-get_free_mem_region.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

 kernel/resource.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/resource.c~resource-fix-resource-leak-in-get_free_mem_region
+++ a/kernel/resource.c
@@ -2000,6 +2000,8 @@ get_free_mem_region(struct device *dev,
 		devres_free(dr);
 	} else if (dev)
 		devm_release_action(dev, remove_free_mem_region, res);
+	else
+		free_resource(res);
 
 	return ERR_PTR(-ERANGE);
 }
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are

resource-fix-resource-leak-in-get_free_mem_region.patch


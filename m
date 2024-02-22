Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CAA13791D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644502; cv=none; b=GSzF7UHRvgnDq8t4hB6Ki1TV7Fujh3H3GJg2A31EJBTdBmHUCOolTF0bq1RnSTi9ljSp7Ut2OJDt3jzoT2kMjuDVj2QY1+mYuThDunaSnp2b1888FVK3/1BdVILUbvazys2MCghKL1gTZku58DOD+Gl5iX6o4DtiU4075ipFlX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644502; c=relaxed/simple;
	bh=XdHZnqskjNi6ZwL+QZWoLpjdR1rYorQqcoEtcPERNAM=;
	h=Date:To:From:Subject:Message-Id; b=kmp1ZUqDZf/b16LM/WG1YB+8sQrhGhOKbLyi2mIv9C+R7UfKvlhQ7EvHULz+Uz2z18cbbjCBpl7/x7Ou2RS3Dlzfr0xtBo3IcSshDr0kps2/Z/pP96r2u9uP44cxHHppSWnVKWBTmBT/2dZy2OEGglhoKWpoRfSu9bdvBnsIilo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OKQ92lkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OKQ92lkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15930C433F1;
	Thu, 22 Feb 2024 23:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644502;
	bh=XdHZnqskjNi6ZwL+QZWoLpjdR1rYorQqcoEtcPERNAM=;
	h=Date:To:From:Subject:From;
	b=OKQ92lkIMaKOM5Zwjv541JtJDHI6FVQ6dEd7Z1MPluI/bkgd0MsUP2ww5roOtfxGU
	 H/jyLoS5YbEBlpj5d9516oR2/vRzllMDmnzJTU3TK5nOvwLdbj0zIeQBHIAnFu0swm
	 /6tXNVRHP6XC0taK9g0do5ge/gt6KqApf5+JPDAY=
Date: Thu, 22 Feb 2024 15:28:21 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,torvalds@linux-foundation.org,snitzer@kernel.org,mpatocka@redhat.com,linux@armlinux.org.uk,fan.ni@samsung.com,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nvdimm-pmem-fix-leak-on-dax_add_host-failure.patch removed from -mm tree
Message-Id: <20240222232822.15930C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nvdimm/pmem: fix leak on dax_add_host() failure
has been removed from the -mm tree.  Its filename was
     nvdimm-pmem-fix-leak-on-dax_add_host-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: nvdimm/pmem: fix leak on dax_add_host() failure
Date: Thu, 8 Feb 2024 13:49:02 -0500

Fix a leak on dax_add_host() error, where "goto out_cleanup_dax" is done
before setting pmem->dax_dev, which therefore issues the two following
calls on NULL pointers:

out_cleanup_dax:
        kill_dax(pmem->dax_dev);
        put_dax(pmem->dax_dev);

Link: https://lkml.kernel.org/r/20240208184913.484340-1-mathieu.desnoyers@efficios.com
Link: https://lkml.kernel.org/r/20240208184913.484340-2-mathieu.desnoyers@efficios.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
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



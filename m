Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF45E17BD3;
	Thu, 22 Feb 2024 23:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644507; cv=none; b=E8xxo3jk4BHj81py4q7crtni8RUC5Ovy68HpJNpU2gPQLsvNkvn66W5vdoCubpOWAYMHsUGTytHrzKVNmgMoD+DfAaJfL2Q9VyjywUACQD5fyhFQhaE+IhkbpxH7wWISl8MlNbjhsWxzXW5YbQss40Ec2hsjkO1ZhJZQUgdwCtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644507; c=relaxed/simple;
	bh=00GI9fBjwnL7EJ4Xi9D/9NBaPz7yutlqad4+U8ZUocE=;
	h=Date:To:From:Subject:Message-Id; b=qlCFzRvKZORTNlAOuVkxI04HB4ZtWiNwHdDcKuyP8nNx9zJ6ek5W4AkOVQViJ5wNs/tKVuQ3JLyIwvsvAkpQbQSazfk0750gGJOjYHi2jvx2MK148F70qtgkMMqXdCo444/YHSTlwYW7Z0q18L1USclNyKK61gShCcEdiQNH/Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jDTnKBke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jDTnKBke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4773BC433C7;
	Thu, 22 Feb 2024 23:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644507;
	bh=00GI9fBjwnL7EJ4Xi9D/9NBaPz7yutlqad4+U8ZUocE=;
	h=Date:To:From:Subject:From;
	b=jDTnKBke+gxel01d/YipJhMLp+fCcManIQAwziIBMoHB3esxCgyyNSwPpZkFbHu6W
	 KBCZ5KJCJD3RO14zMdPVJVD0fh1Dt85B9YgAzosJTknhtj68cBxtrDbsPzEwbbHI/f
	 PRbEtuA7bWw2v8txj/JTkXPGHmygRF/e3AsD3MoI=
Date: Thu, 22 Feb 2024 15:28:26 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,snitzer@kernel.org,mpatocka@redhat.com,lkp@intel.com,linux@armlinux.org.uk,hch@lst.de,hca@linux.ibm.com,dm-devel@lists.linux.dev,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dcssblk-handle-alloc_dax-eopnotsupp-failure.patch removed from -mm tree
Message-Id: <20240222232827.4773BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dcssblk: handle alloc_dax() -EOPNOTSUPP failure
has been removed from the -mm tree.  Its filename was
     dcssblk-handle-alloc_dax-eopnotsupp-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: dcssblk: handle alloc_dax() -EOPNOTSUPP failure
Date: Thu, 15 Feb 2024 09:46:29 -0500

In preparation for checking whether the architecture has data cache
aliasing within alloc_dax(), modify the error handling of dcssblk
dcssblk_add_store() to handle alloc_dax() -EOPNOTSUPP failures.

Considering that s390 is not a data cache aliasing architecture,
and considering that DCSSBLK selects DAX, a return value of -EOPNOTSUPP
from alloc_dax() should make dcssblk_add_store() fail.

Link: https://lkml.kernel.org/r/20240215144633.96437-6-mathieu.desnoyers@efficios.com
Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
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
Cc: kernel test robot <lkp@intel.com>
Cc: Michael Sclafani <dm-devel@lists.linux.dev>
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
+	if (IS_ERR(dax_dev)) {
+		rc = PTR_ERR(dax_dev);
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



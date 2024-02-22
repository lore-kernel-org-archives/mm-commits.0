Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A884B1D69B;
	Thu, 22 Feb 2024 23:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644506; cv=none; b=rdtQbgg8S3eckOfCYRUCExmi5a5a3fLvvGbq+9n6FNv0CmCebKXbRdFmtoVIUDMclCrXkB0FkbAZVqTNGC16PPZGJkpekxQkL0zAOoXLZc7UJv7+20C8IUUuEtdlkwC8ewjsvOZ5By8wie7hapvd89EjI9HHfADaVI5aKo/JZlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644506; c=relaxed/simple;
	bh=Twe1QSXS4rGQXvajUlMmgmYAQoSPd5zxXoMB9tAYmvM=;
	h=Date:To:From:Subject:Message-Id; b=HSNDpG8+BlxFwZWEwlfzwtR/im2BFlmb5VyHwgxZ2n2YLTIXcvoVXhkLdBKIMIjBcJ5l2IdioXpb35zHykv27YIYe89rYO+kRHj5iynlGhKI3F06pR6PK5Y9yd3BGrGlliwiRU9NMA8xnCR3non9DU/qKOvYJn8qprokNVRPQds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OILP3fZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OILP3fZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10074C433C7;
	Thu, 22 Feb 2024 23:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644506;
	bh=Twe1QSXS4rGQXvajUlMmgmYAQoSPd5zxXoMB9tAYmvM=;
	h=Date:To:From:Subject:From;
	b=OILP3fZDh5WT6WMhqBEDYhDjWYDjgX21hc1Vw1lJmGL7UlkoD9RzC0xcb0GOE8AWw
	 kCjGZlDxIYyulTppD1YVES87YKflDL3vgBV2A1cka5zN98sfWMZJGLa1/e2gs6SZdC
	 cPM3sU/iM9i8Lmm4RrEug8eVenHCKH5XN5a178rw=
Date: Thu, 22 Feb 2024 15:28:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,snitzer@kernel.org,mpatocka@redhat.com,lkp@intel.com,linux@armlinux.org.uk,hch@lst.de,hca@linux.ibm.com,dm-devel@lists.linux.dev,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dm-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch removed from -mm tree
Message-Id: <20240222232826.10074C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dm: treat alloc_dax() -EOPNOTSUPP failure as non-fatal
has been removed from the -mm tree.  Its filename was
     dm-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: dm: treat alloc_dax() -EOPNOTSUPP failure as non-fatal
Date: Thu, 15 Feb 2024 09:46:28 -0500

In preparation for checking whether the architecture has data cache
aliasing within alloc_dax(), modify the error handling of dm alloc_dev()
to treat alloc_dax() -EOPNOTSUPP failure as non-fatal.

Link: https://lkml.kernel.org/r/20240215144633.96437-5-mathieu.desnoyers@efficios.com
Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Suggested-by: Dan Williams <dan.j.williams@intel.com>
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

 drivers/md/dm.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/md/dm.c~dm-treat-alloc_dax-eopnotsupp-failure-as-non-fatal
+++ a/drivers/md/dm.c
@@ -2054,6 +2054,7 @@ static void cleanup_mapped_device(struct
 static struct mapped_device *alloc_dev(int minor)
 {
 	int r, numa_node_id = dm_get_numa_node();
+	struct dax_device *dax_dev;
 	struct mapped_device *md;
 	void *old_md;
 
@@ -2122,15 +2123,15 @@ static struct mapped_device *alloc_dev(i
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
-	if (IS_ENABLED(CONFIG_FS_DAX)) {
-		md->dax_dev = alloc_dax(md, &dm_dax_ops);
-		if (IS_ERR(md->dax_dev)) {
-			md->dax_dev = NULL;
+	dax_dev = alloc_dax(md, &dm_dax_ops);
+	if (IS_ERR(dax_dev)) {
+		if (PTR_ERR(dax_dev) != -EOPNOTSUPP)
 			goto bad;
-		}
-		set_dax_nocache(md->dax_dev);
-		set_dax_nomc(md->dax_dev);
-		if (dax_add_host(md->dax_dev, md->disk))
+	} else {
+		set_dax_nocache(dax_dev);
+		set_dax_nomc(dax_dev);
+		md->dax_dev = dax_dev;
+		if (dax_add_host(dax_dev, md->disk))
 			goto bad;
 	}
 
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are



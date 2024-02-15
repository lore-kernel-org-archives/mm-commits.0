Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699BB1384B8;
	Thu, 15 Feb 2024 20:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708027568; cv=none; b=lr1rHOj5AT0jWnMusBP7D710ytAfHxgl8MkLYhdFDb7TV3MMmpBxXknBy54ZgswRg6H/NdVBZKKgY0iojPh/yu8pcmcIoXaN81mFv20wKf8pUsib+vYxi/GgYzpTMjIKAJVpE4D8w8/kahw5PSvDGxl+qP6s58CIlPhdPpm9m40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708027568; c=relaxed/simple;
	bh=IJbJMp/tqrTAT+J7dPrlzVsYyrxZ0EvQeKFDR+zghRM=;
	h=Date:To:From:Subject:Message-Id; b=ji0vabctXFw+Z34uBeocZ6ajTuzXl0BRkrzkVzIXNm2LjtboAK0XtL+CA7Q/PkR9H6lRqrGYtT3K2k4Qyo6bmOirmwN/1mEzNVCWV7UUBKocxkGejS0BaH/GAc3x2ntcz9NhDgpkUym4MIdGilUrIcM+QAqXoEJminFs2iUMA8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uzkHXuve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uzkHXuve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0301C433F1;
	Thu, 15 Feb 2024 20:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708027568;
	bh=IJbJMp/tqrTAT+J7dPrlzVsYyrxZ0EvQeKFDR+zghRM=;
	h=Date:To:From:Subject:From;
	b=uzkHXuvee4Ms2qRttEpzi6TZiJD2LqIbNd1PYuywJarq9N2xjYE0rTLFY+nU0MUdX
	 z4aiJ2CpeCM03jr1jfpt+oF9+KV9uAEb51qw4FqjEAsOV0uFKOfIHpNYZtjaUxqTGL
	 aCJ7K6c1A2euZidthvZzOxjHwMrqqKHuWZvnzM6I=
Date: Thu, 15 Feb 2024 12:06:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,snitzer@kernel.org,mpatocka@redhat.com,lkp@intel.com,linux@armlinux.org.uk,hch@lst.de,hca@linux.ibm.com,dm-devel@lists.linux.dev,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dm-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch added to mm-unstable branch
Message-Id: <20240215200607.E0301C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dm: Treat alloc_dax() -EOPNOTSUPP failure as non-fatal
has been added to the -mm mm-unstable branch.  Its filename is
     dm-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dm-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch

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
Subject: dm: Treat alloc_dax() -EOPNOTSUPP failure as non-fatal
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


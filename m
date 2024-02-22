Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FC413791F;
	Thu, 22 Feb 2024 23:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644505; cv=none; b=WW0h02MpNprHKs+Wlb8u54sI5yGLay2i3Fxf+9FC69CNH/b+hvKQGcgWJuyLEuhYPR7oLojlAeehwf2Veb30F84epruFLm6zBAyfht72V4Ec4w+79ekT5LazJygOwAKZr4EUm23ZGCRX9+vqLmVfH5551yp0ws4+oYB67ZudceI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644505; c=relaxed/simple;
	bh=Fo3k55E/Ng8nqzlSKH7L4NaRCmEvcgtIvJ5iNPD2yFs=;
	h=Date:To:From:Subject:Message-Id; b=SkfvpHTb3ztINisAjYrs/CFilqQUd+DtSu6nuH3BkaEp5X+n/7fq8M50nZ3d5xJCkAiVIeqXzo8h12YXv7+ibaDR7N/MwhFNAP4a+BKphdX1Vhdu4IAfGujedn0Hjd/p/Bk+Bn0fJY8pRVrbVETqzW2mDsnQCSJ2jgPWujQBOko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pf3RAJLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pf3RAJLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02269C433C7;
	Thu, 22 Feb 2024 23:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644504;
	bh=Fo3k55E/Ng8nqzlSKH7L4NaRCmEvcgtIvJ5iNPD2yFs=;
	h=Date:To:From:Subject:From;
	b=pf3RAJLu1dFsxoytVPKJPXKBF5TOjf6XkCHgv0GHctIEx+n4iSmsFiMOQ47YmiA5W
	 h2Ej8qWg2Pj163Y7WhpaBvh1jpXSKxWcue7Kc8c1fksJi0sRG03LjEZFfA+QUm+zvg
	 A8Alal0JRT/T3SFMvIfs49kkRWEvmi8aN6o+TN3w=
Date: Thu, 22 Feb 2024 15:28:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,snitzer@kernel.org,mpatocka@redhat.com,lkp@intel.com,linux@armlinux.org.uk,hch@lst.de,hca@linux.ibm.com,dm-devel@lists.linux.dev,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-alloc_dax-return-err_ptr-eopnotsupp-for-config_dax=n.patch removed from -mm tree
Message-Id: <20240222232824.02269C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax: alloc_dax() return ERR_PTR(-EOPNOTSUPP) for CONFIG_DAX=n
has been removed from the -mm tree.  Its filename was
     dax-alloc_dax-return-err_ptr-eopnotsupp-for-config_dax=n.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: dax: alloc_dax() return ERR_PTR(-EOPNOTSUPP) for CONFIG_DAX=n
Date: Thu, 15 Feb 2024 09:46:26 -0500

Change the return value from NULL to PTR_ERR(-EOPNOTSUPP) for
CONFIG_DAX=n to be consistent with the fact that CONFIG_DAX=y
never returns NULL.

This is done in preparation for using cpu_dcache_is_aliasing() in a
following change which will properly support architectures which detect
data cache aliasing at runtime.

Link: https://lkml.kernel.org/r/20240215144633.96437-3-mathieu.desnoyers@efficios.com
Fixes: 4e4ced93794a ("dax: Move mandatory ->zero_page_range() check in alloc_dax()")
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

 drivers/dax/super.c |    5 +++++
 include/linux/dax.h |    6 +-----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/dax/super.c~dax-alloc_dax-return-err_ptr-eopnotsupp-for-config_dax=n
+++ a/drivers/dax/super.c
@@ -319,6 +319,11 @@ EXPORT_SYMBOL_GPL(dax_alive);
  * that any fault handlers or operations that might have seen
  * dax_alive(), have completed.  Any operations that start after
  * synchronize_srcu() has run will abort upon seeing !dax_alive().
+ *
+ * Note, because alloc_dax() returns an ERR_PTR() on error, callers
+ * typically store its result into a local variable in order to check
+ * the result. Therefore, care must be taken to populate the struct
+ * device dax_dev field make sure the dax_dev is not leaked.
  */
 void kill_dax(struct dax_device *dax_dev)
 {
--- a/include/linux/dax.h~dax-alloc_dax-return-err_ptr-eopnotsupp-for-config_dax=n
+++ a/include/linux/dax.h
@@ -88,11 +88,7 @@ static inline void *dax_holder(struct da
 static inline struct dax_device *alloc_dax(void *private,
 		const struct dax_operations *ops)
 {
-	/*
-	 * Callers should check IS_ENABLED(CONFIG_DAX) to know if this
-	 * NULL is an error or expected.
-	 */
-	return NULL;
+	return ERR_PTR(-EOPNOTSUPP);
 }
 static inline void put_dax(struct dax_device *dax_dev)
 {
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are



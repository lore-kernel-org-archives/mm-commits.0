Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346641384B8;
	Thu, 15 Feb 2024 20:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708027564; cv=none; b=Ol7UYkPH3ixeGZ4YHLqlXzmHVklzrPekp0vKDlQPmw6tX5eB6e/JGiYOQZTaFoP+ZWhBdvFKVo+zdagO+oc3Eei3pkyDEZ3hYIe4MzZvXKjigC/1jfIidm4OSN3rqqjp/PeAnCZc4FKDX39jBiV9X1+MF1dk4Bs0b4no8j7rBZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708027564; c=relaxed/simple;
	bh=g+M2Fk8puhjh4FzYZNFB/LFOjpd7p3TYKEBWy0IBToQ=;
	h=Date:To:From:Subject:Message-Id; b=QUDaoXTbLKeW9sLnQES7u6Qa9XJM9c8DR+sY56mwvQ4XNgg+F2cIvzZBiogCz1wlWJXLaGNI73Ws1wlDWC+SJyDGZw0Twe2CwEi8mDFqRS+NJTW/szF2KIBEVEsz95TqSjg3A2d5vyy1Sbn4EnSf6eBPkk0k8jH1f1SuLKQmaiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PeUYxYol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PeUYxYol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C0DC433F1;
	Thu, 15 Feb 2024 20:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708027563;
	bh=g+M2Fk8puhjh4FzYZNFB/LFOjpd7p3TYKEBWy0IBToQ=;
	h=Date:To:From:Subject:From;
	b=PeUYxYol4Ox8bmjRBpRjc/BfC2VZjmNAN9itAZ4tK1X6K2bHqDHzFLeceWUj4Eh2r
	 r0fT59H75Tma6kb7cM/utFvGac5yb8qPuFsnOm6owJ0Ni/sBxptuyDojsegMlegE1W
	 0L2IlddEUYsjRPHeifcsGDC0rHm5bEewday9krYk=
Date: Thu, 15 Feb 2024 12:06:03 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,snitzer@kernel.org,mpatocka@redhat.com,lkp@intel.com,linux@armlinux.org.uk,hch@lst.de,hca@linux.ibm.com,dm-devel@lists.linux.dev,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-alloc_dax-return-err_ptr-eopnotsupp-for-config_dax=n.patch added to mm-unstable branch
Message-Id: <20240215200603.A4C0DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dax: alloc_dax() return ERR_PTR(-EOPNOTSUPP) for CONFIG_DAX=n
has been added to the -mm mm-unstable branch.  Its filename is
     dax-alloc_dax-return-err_ptr-eopnotsupp-for-config_dax=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-alloc_dax-return-err_ptr-eopnotsupp-for-config_dax=n.patch

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


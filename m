Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418D13E47A;
	Mon, 12 Feb 2024 22:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707777036; cv=none; b=V6Bt+MdfNnyTJSUWFNR/FKv0yQJQecABOa568o/5LwYzLcRvB0YgIFKtE/8UAudWlurqLts0QhI6CgZiFtUwxDWvZR6yeUPrvQeuw4jYxyxNxtiy7Fm6lrHIq9ju2raNYIOxs/hXETxqKTdH1xQaOPU/czzN2F6v9Ig82vwybXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707777036; c=relaxed/simple;
	bh=kUnMr+SNCT9jlr8T8ZVUvbY0SD55vOhjIGfsTQjt3r4=;
	h=Date:To:From:Subject:Message-Id; b=aSRf2bMaPP8UX5Tco/K+17KTsp6A23PHherPgh7WhU2xCi52/k5973X7Eshi/BlRgUrlvKlihFeV08DzuiR83hDq9M+5yMdBaOYKYQRXgbuyZGminUVGbsPKCtVHassc3ksJTznzXX4ISclkZbFWpk1Ejc3TR8Bpxk5HnctBHOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ktaxdCEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ktaxdCEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A83C433F1;
	Mon, 12 Feb 2024 22:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707777035;
	bh=kUnMr+SNCT9jlr8T8ZVUvbY0SD55vOhjIGfsTQjt3r4=;
	h=Date:To:From:Subject:From;
	b=ktaxdCEb9it2CmaPYzBiUQ+84pXJMr2y4AcBCX2DHvY+4sf5EJf2IeMtk77SXYhZs
	 Ba05gtlghbJ1GrVcTkInufemBYJgawt8B+PIqeHaFkd0BmsUAZcS7f27Fx7D6d0QhK
	 3RQHj5H+ovkIrwJfVC+Uosiev26PyDcrHkHd5TUM=
Date: Mon, 12 Feb 2024 14:30:35 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,torvalds@linux-foundation.org,snitzer@kernel.org,mpatocka@redhat.com,linux@armlinux.org.uk,dm-devel@lists.linux.dev,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-alloc_dax-return-err_ptr-eopnotsupp-for-config_dax=n.patch added to mm-unstable branch
Message-Id: <20240212223035.94A83C433F1@smtp.kernel.org>
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
Date: Mon, 12 Feb 2024 11:30:54 -0500

Patch series "Introduce cpu_dcache_is_aliasing() to fix DAX regression",
v5.

This commit introduced in v4.0 prevents building FS_DAX on 32-bit ARM,
even on ARMv7 which does not have virtually aliased data caches:

commit d92576f1167c ("dax: does not work correctly with virtual aliasing caches")

It used to work fine before: I have customers using DAX over pmem on
ARMv7, but this regression will likely prevent them from upgrading their
kernel.

The root of the issue here is the fact that DAX was never designed to
handle virtually aliasing data caches (VIVT and VIPT with aliasing data
cache).  It touches the pages through their linear mapping, which is not
consistent with the userspace mappings with virtually aliasing data
caches.

This patch series introduces cpu_dcache_is_aliasing() with the new Kconfig
option ARCH_HAS_CPU_CACHE_ALIASING and implements it for all
architectures.  The implementation of cpu_dcache_is_aliasing() is either
evaluated to a constant at compile-time or a runtime check, which is what
is needed on ARM.

With this we can basically narrow down the list of architectures which are
unsupported by DAX to those which are really affected.

Testing done so far:

- Compile allyesconfig on x86-64,
- Compile allyesconfig on x86-64, with FS_DAX=n.
- Compile allyesconfig on x86-64, with DAX=n.
- Boot test after modifying alloc_dax() to force returning -EOPNOTSUPP
  even on x86-64, thus simulating the behavior expected on an
  architecture with data cache aliasing.


This patch (of 5):

Change the return value from NULL to PTR_ERR(-EOPNOTSUPP) for CONFIG_DAX=n
to be consistent with the fact that CONFIG_DAX=y never returns NULL.

This is done in preparation for using cpu_dcache_is_aliasing() in a
following change which will properly support architectures which detect
data cache aliasing at runtime.

Link: https://lkml.kernel.org/r/20240212163101.19614-1-mathieu.desnoyers@efficios.com
Link: https://lkml.kernel.org/r/20240212163101.19614-2-mathieu.desnoyers@efficios.com
Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Michael Sclafani <dm-devel@lists.linux.dev>
Cc: Alasdair Kergon <agk@redhat.com>
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
@@ -86,11 +86,7 @@ static inline void *dax_holder(struct da
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
dax-alloc_dax-return-err_ptr-eopnotsupp-for-config_dax=n.patch
nvdimm-pmem-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dm-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dcssblk-handle-alloc_dax-eopnotsupp-failure.patch
virtio-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dax-check-for-data-cache-aliasing-at-runtime.patch
introduce-cpu_dcache_is_aliasing-across-all-architectures.patch
dax-fix-incorrect-list-of-data-cache-aliasing-architectures.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4303D1D69B;
	Thu, 22 Feb 2024 23:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644503; cv=none; b=bffvm0jkfb9mrsu4ON5jo2RCARUJciro7AJWWzQATST70g28pGAGV1CDyAQAQ+27s5SC3igOkQq73G7PlSx03uSsdLC2XqMC6jzE29FAxMdpquH4dSxClj0N2uNlGh3BH78ced2KlnXvevdwLKbWJFvi/ABzs1OV5lYdqYItd/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644503; c=relaxed/simple;
	bh=ETZIDoD+csl6KRF89iPC7liAXkfoMpXlKtABK1Yi2jI=;
	h=Date:To:From:Subject:Message-Id; b=iiIi2NpTIg2x9ClQlVH44OmBBb7nAbS4N+CKiUaBXScWcpLB6bAxBj3TTvV4nQ2eInc/fjBvleE/Hb5nqKBugmU6g2+4txveOW9EjQ9gdf5yuofBnXwkk4a0/I47qqefnCrWMtikz8EWwm/tcvY6fYY8HGpYb+phovHI8gT9Os4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dePK95ok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dePK95ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9E8C43390;
	Thu, 22 Feb 2024 23:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644503;
	bh=ETZIDoD+csl6KRF89iPC7liAXkfoMpXlKtABK1Yi2jI=;
	h=Date:To:From:Subject:From;
	b=dePK95okEIDS6SuUxoYGELK0hRPOpeR2pWq4g91XcJy7wyKaDBeExs2IGFXgti1xL
	 hEFZNoT2SFUgRcxt0dlAUZyfAT5Dj53Z7TEjGE5JlxbL5x2W9QujDfstFWmamtaJHV
	 Ih1gYuo07WYEyC5SAFMcy3UBupLLQBSoFVuqi7yI=
Date: Thu, 22 Feb 2024 15:28:22 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,snitzer@kernel.org,mpatocka@redhat.com,lkp@intel.com,linux@armlinux.org.uk,hch@lst.de,hca@linux.ibm.com,dm-devel@lists.linux.dev,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-add-empty-static-inline-for-config_dax=n.patch removed from -mm tree
Message-Id: <20240222232823.0D9E8C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax: add empty static inline for CONFIG_DAX=n
has been removed from the -mm tree.  Its filename was
     dax-add-empty-static-inline-for-config_dax=n.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: dax: add empty static inline for CONFIG_DAX=n
Date: Thu, 15 Feb 2024 09:46:25 -0500

Patch series "Introduce cpu_dcache_is_aliasing() to fix DAX regression",
v6.

This commit introduced in v4.0 prevents building FS_DAX on 32-bit ARM,
even on ARMv7 which does not have virtually aliased data caches:

commit d92576f1167c ("dax: does not work correctly with virtual aliasing caches")

Even though it used to work fine before.

The root of the issue here is the fact that DAX was never designed to
handle virtually aliasing data caches (VIVT and VIPT with aliasing data
cache). It touches the pages through their linear mapping, which is not
consistent with the userspace mappings with virtually aliasing data
caches.

This patch series introduces cpu_dcache_is_aliasing() with the new
Kconfig option ARCH_HAS_CPU_CACHE_ALIASING and implements it for all
architectures. The implementation of cpu_dcache_is_aliasing() is either
evaluated to a constant at compile-time or a runtime check, which is
what is needed on ARM.

With this we can basically narrow down the list of architectures which
are unsupported by DAX to those which are really affected.


This patch (of 9):

When building a kernel with CONFIG_DAX=n, all uses of set_dax_nocache()
and set_dax_nomc() need to be either within regions of code or compile
units which are explicitly not compiled, or they need to rely on compiler
optimizations to eliminate calls to those undefined symbols.

It appears that at least the openrisc and loongarch architectures don't
end up eliminating those undefined symbols even if they are provably
within code which is eliminated due to conditional branches depending on
constants.

Implement empty static inline functions for set_dax_nocache() and
set_dax_nomc() in CONFIG_DAX=n to ensure those undefined references are
removed.

Link: https://lkml.kernel.org/r/20240215144633.96437-1-mathieu.desnoyers@efficios.com
Link: https://lkml.kernel.org/r/20240215144633.96437-2-mathieu.desnoyers@efficios.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202402140037.wGfA1kqX-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202402131351.a0FZOgEG-lkp@intel.com/
Fixes: 7ac5360cd4d0 ("dax: remove the copy_from_iter and copy_to_iter methods")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Michael Sclafani <dm-devel@lists.linux.dev>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dax.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/dax.h~dax-add-empty-static-inline-for-config_dax=n
+++ a/include/linux/dax.h
@@ -63,6 +63,8 @@ void kill_dax(struct dax_device *dax_dev
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
 bool dax_synchronous(struct dax_device *dax_dev);
+void set_dax_nocache(struct dax_device *dax_dev);
+void set_dax_nomc(struct dax_device *dax_dev);
 void set_dax_synchronous(struct dax_device *dax_dev);
 size_t dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i);
@@ -109,6 +111,12 @@ static inline bool dax_synchronous(struc
 {
 	return true;
 }
+static inline void set_dax_nocache(struct dax_device *dax_dev)
+{
+}
+static inline void set_dax_nomc(struct dax_device *dax_dev)
+{
+}
 static inline void set_dax_synchronous(struct dax_device *dax_dev)
 {
 }
@@ -124,9 +132,6 @@ static inline size_t dax_recovery_write(
 }
 #endif
 
-void set_dax_nocache(struct dax_device *dax_dev);
-void set_dax_nomc(struct dax_device *dax_dev);
-
 struct writeback_control;
 #if defined(CONFIG_BLOCK) && defined(CONFIG_FS_DAX)
 int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk);
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are



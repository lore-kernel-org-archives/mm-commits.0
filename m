From: akpm@linux-foundation.org
Subject: - devres-support-addresses-greater-than-an-unsigned-long-via-dev_ioremap.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:51 -0700
Message-ID: <200805010933.m419XpYf031161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755558AbYEAJeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:34:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: galak@kernel.crashing.org, greg@kroah.com, htejun@gmail.com, jgarzik@pobox.com, mm-commits@vger.kernel.org


The patch titled
     devres: support addresses greater than an unsigned long via dev_ioremap
has been removed from the -mm tree.  Its filename was
     devres-support-addresses-greater-than-an-unsigned-long-via-dev_ioremap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devres: support addresses greater than an unsigned long via dev_ioremap
From: Kumar Gala <galak@kernel.crashing.org>

Use a resource_size_t instead of unsigned long since some arch's are capable
of having ioremap deal with addresses greater than the size of a unsigned
long.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: Jeff Garzik <jgarzik@pobox.com>
Acked-by: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io.h |    4 ++--
 lib/devres.c       |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/io.h~devres-support-addresses-greater-than-an-unsigned-long-via-dev_ioremap include/linux/io.h
--- a/include/linux/io.h~devres-support-addresses-greater-than-an-unsigned-long-via-dev_ioremap
+++ a/include/linux/io.h
@@ -58,9 +58,9 @@ static inline void devm_ioport_unmap(str
 }
 #endif
 
-void __iomem * devm_ioremap(struct device *dev, unsigned long offset,
+void __iomem * devm_ioremap(struct device *dev, resource_size_t offset,
 			    unsigned long size);
-void __iomem * devm_ioremap_nocache(struct device *dev, unsigned long offset,
+void __iomem * devm_ioremap_nocache(struct device *dev, resource_size_t offset,
 				    unsigned long size);
 void devm_iounmap(struct device *dev, void __iomem *addr);
 int check_signature(const volatile void __iomem *io_addr,
diff -puN lib/devres.c~devres-support-addresses-greater-than-an-unsigned-long-via-dev_ioremap lib/devres.c
--- a/lib/devres.c~devres-support-addresses-greater-than-an-unsigned-long-via-dev_ioremap
+++ a/lib/devres.c
@@ -20,7 +20,7 @@ static int devm_ioremap_match(struct dev
  *
  * Managed ioremap().  Map is automatically unmapped on driver detach.
  */
-void __iomem *devm_ioremap(struct device *dev, unsigned long offset,
+void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
 			   unsigned long size)
 {
 	void __iomem **ptr, *addr;
@@ -49,7 +49,7 @@ EXPORT_SYMBOL(devm_ioremap);
  * Managed ioremap_nocache().  Map is automatically unmapped on driver
  * detach.
  */
-void __iomem *devm_ioremap_nocache(struct device *dev, unsigned long offset,
+void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
 				   unsigned long size)
 {
 	void __iomem **ptr, *addr;
_

Patches currently in -mm which might be from galak@kernel.crashing.org are

origin.patch
powerpc-devres-add-devm_ioremap_prot.patch


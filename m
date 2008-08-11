From: akpm@linux-foundation.org
Subject: + pnp-make-the-resource-type-an-unsigned-long.patch added to -mm tree
Date: Mon, 11 Aug 2008 15:28:03 -0700
Message-ID: <200808112228.m7BMS3lX025036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbYHKW2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 18:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@keyaccess.nl, andi@firstfloor.org, bjorn.helgaas@hp.com, hpa@zytor.com, rene.herman@gmail.com


The patch titled
     pnp: make the resource type an unsigned long
has been added to the -mm tree.  Its filename is
     pnp-make-the-resource-type-an-unsigned-long.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: make the resource type an unsigned long
From: Rene Herman <rene.herman@keyaccess.nl>

PnP encodes the resource type directly as its struct resource->flags value
which is an unsigned long.  Make it so...

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/base.h     |    2 +-
 drivers/pnp/resource.c |    4 ++--
 include/linux/pnp.h    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/pnp/base.h~pnp-make-the-resource-type-an-unsigned-long drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-make-the-resource-type-an-unsigned-long
+++ a/drivers/pnp/base.h
@@ -147,7 +147,7 @@ char *pnp_resource_type_name(struct reso
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
 
 void pnp_free_resources(struct pnp_dev *dev);
-int pnp_resource_type(struct resource *res);
+unsigned long pnp_resource_type(struct resource *res);
 
 struct pnp_resource {
 	struct list_head list;
diff -puN drivers/pnp/resource.c~pnp-make-the-resource-type-an-unsigned-long drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-make-the-resource-type-an-unsigned-long
+++ a/drivers/pnp/resource.c
@@ -467,14 +467,14 @@ int pnp_check_dma(struct pnp_dev *dev, s
 #endif
 }
 
-int pnp_resource_type(struct resource *res)
+unsigned long pnp_resource_type(struct resource *res)
 {
 	return res->flags & (IORESOURCE_IO  | IORESOURCE_MEM |
 			     IORESOURCE_IRQ | IORESOURCE_DMA);
 }
 
 struct resource *pnp_get_resource(struct pnp_dev *dev,
-				  unsigned int type, unsigned int num)
+				  unsigned long type, unsigned int num)
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
diff -puN include/linux/pnp.h~pnp-make-the-resource-type-an-unsigned-long include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-make-the-resource-type-an-unsigned-long
+++ a/include/linux/pnp.h
@@ -21,7 +21,7 @@ struct pnp_dev;
 /*
  * Resource Management
  */
-struct resource *pnp_get_resource(struct pnp_dev *, unsigned int, unsigned int);
+struct resource *pnp_get_resource(struct pnp_dev *, unsigned long, unsigned int);
 
 static inline int pnp_resource_valid(struct resource *res)
 {
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

i2c-dont-autograb-i2c-pca-is.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch


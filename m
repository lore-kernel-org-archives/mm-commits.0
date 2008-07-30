From: akpm@linux-foundation.org
Subject: - resource-add-resource_size.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:13:43 -0700
Message-ID: <200807301913.m6UJDhwm010780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752420AbYG3TPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@igel.co.jp, ben-linux@fluff.org, khali@linux-fr.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     resource: add resource_size()
has been removed from the -mm tree.  Its filename was
     resource-add-resource_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: resource: add resource_size()
From: Magnus Damm <damm@igel.co.jp>

Avoid one-off errors by introducing a resource_size() function.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    4 ++++
 kernel/resource.c      |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/ioport.h~resource-add-resource_size include/linux/ioport.h
--- a/include/linux/ioport.h~resource-add-resource_size
+++ a/include/linux/ioport.h
@@ -118,6 +118,10 @@ extern int allocate_resource(struct reso
 int adjust_resource(struct resource *res, resource_size_t start,
 		    resource_size_t size);
 resource_size_t resource_alignment(struct resource *res);
+static inline resource_size_t resource_size(struct resource *res)
+{
+	return res->end - res->start + 1;
+}
 
 /* Convenience shorthand with allocation */
 #define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name))
diff -puN kernel/resource.c~resource-add-resource_size kernel/resource.c
--- a/kernel/resource.c~resource-add-resource_size
+++ a/kernel/resource.c
@@ -490,7 +490,7 @@ resource_size_t resource_alignment(struc
 {
 	switch (res->flags & (IORESOURCE_SIZEALIGN | IORESOURCE_STARTALIGN)) {
 	case IORESOURCE_SIZEALIGN:
-		return res->end - res->start + 1;
+		return resource_size(res);
 	case IORESOURCE_STARTALIGN:
 		return res->start;
 	default:
_

Patches currently in -mm which might be from damm@igel.co.jp are

origin.patch
linux-next.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch


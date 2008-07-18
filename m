From: akpm@linux-foundation.org
Subject: + resource-add-resource_size.patch added to -mm tree
Date: Fri, 18 Jul 2008 15:37:16 -0700
Message-ID: <200807182237.m6IMbGHs002220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113AbYGRWiK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 18:38:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@igel.co.jp, ben-linux@fluff.org, khali@linux-fr.org, lethal@linux-sh.org


The patch titled
     resource: add resource_size()
has been added to the -mm tree.  Its filename is
     resource-add-resource_size.patch

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

linux-next.patch
sh_keysc-remove-request_mem_region-and-release_mem_region.patch
video-superh-mobile-lcdc-driver.patch
video-superh-mobile-lcdc-driver-update.patch
resource-add-resource_size.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch


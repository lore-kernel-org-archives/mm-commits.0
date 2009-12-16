From: akpm@linux-foundation.org
Subject: [merged] resource-constify-arg-to-resource_size-and-resource_type.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:41:20 -0800
Message-ID: <200912162041.nBGKfKIv013729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965037AbZLPUlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:41:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, greg@kroah.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     resource: constify arg to resource_size() and resource_type()
has been removed from the -mm tree.  Its filename was
     resource-constify-arg-to-resource_size-and-resource_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: resource: constify arg to resource_size() and resource_type()
From: Jean Delvare <khali@linux-fr.org>

resource_size() doesn't change the resource it operates on, so the res
parameter can be marked const.  Same for resource_type().

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/ioport.h~resource-constify-arg-to-resource_size-and-resource_type include/linux/ioport.h
--- a/include/linux/ioport.h~resource-constify-arg-to-resource_size-and-resource_type
+++ a/include/linux/ioport.h
@@ -126,11 +126,11 @@ extern int allocate_resource(struct reso
 int adjust_resource(struct resource *res, resource_size_t start,
 		    resource_size_t size);
 resource_size_t resource_alignment(struct resource *res);
-static inline resource_size_t resource_size(struct resource *res)
+static inline resource_size_t resource_size(const struct resource *res)
 {
 	return res->end - res->start + 1;
 }
-static inline unsigned long resource_type(struct resource *res)
+static inline unsigned long resource_type(const struct resource *res)
 {
 	return res->flags & IORESOURCE_TYPE_BITS;
 }
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch


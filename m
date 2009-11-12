From: akpm@linux-foundation.org
Subject: + resource-constify-arg-to-resource_size-and-resource_type.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:37:59 -0800
Message-ID: <200911122237.nACMbxjZ001693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754707AbZKLWiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:38:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, greg@kroah.com, xiyou.wangcong@gmail.com


The patch titled
     resource: constify arg to resource_size() and resource_type()
has been added to the -mm tree.  Its filename is
     resource-constify-arg-to-resource_size-and-resource_type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
ad525x_dpot-new-driver-for-ad525x-digital-potentiometers.patch
hwmon-driver-for-texas-instruments-amc6821-chip.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
hwmon-w83627ehf-updates.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch
resource-constify-arg-to-resource_size-and-resource_type.patch


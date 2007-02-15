From: akpm@linux-foundation.org
Subject: - usb-in-init_endpoint_class-use-ptr_err-to-obtain-an-errno-value-not-is_err.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:51:38 -0800
Message-ID: <200702150851.l1F8pcgn025308@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40419 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965595AbXBOIwz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:52:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@kernel.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     USB: In init_endpoint_class, use PTR_ERR to obtain an errno value, not IS_ERR
has been removed from the -mm tree.  Its filename was
     usb-in-init_endpoint_class-use-ptr_err-to-obtain-an-errno-value-not-is_err.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: USB: In init_endpoint_class, use PTR_ERR to obtain an errno value, not IS_ERR
From: Josh Triplett <josh@kernel.org>

init_endpoint_class calls class_create, and checks the result for an error
with IS_ERR; however, if true, it then returns the result of IS_ERR (a
boolean) rather than PTR_ERR (the actual errno).

Signed-off-by: Josh Triplett <josh@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/endpoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/core/endpoint.c~usb-in-init_endpoint_class-use-ptr_err-to-obtain-an-errno-value-not-is_err drivers/usb/core/endpoint.c
--- a/drivers/usb/core/endpoint.c~usb-in-init_endpoint_class-use-ptr_err-to-obtain-an-errno-value-not-is_err
+++ a/drivers/usb/core/endpoint.c
@@ -229,7 +229,7 @@ static int init_endpoint_class(void)
 	kref_init(&ep_class->kref);
 	ep_class->class = class_create(THIS_MODULE, "usb_endpoint");
 	if (IS_ERR(ep_class->class)) {
-		result = IS_ERR(ep_class->class);
+		result = PTR_ERR(ep_class->class);
 		goto class_create_error;
 	}
 
_

Patches currently in -mm which might be from josh@kernel.org are

rcutorture-style-cleanup-avoid-=-null-in-boolean-tests.patch
rcutorture-remove-redundant-assignment-to-cur_ops-in.patch

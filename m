From: akpm@osdl.org
Subject: + usb-in-init_endpoint_class-use-ptr_err-to-obtain-an-errno-value-not-is_err.patch added to -mm tree
Date: Thu, 25 Jan 2007 15:14:10 -0800
Message-ID: <200701252314.l0PNEALA001338@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34807 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030499AbXAYXPa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 18:15:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh@kernel.org, greg@kroah.com


The patch titled
     USB: In init_endpoint_class, use PTR_ERR to obtain an errno value, not IS_ERR
has been added to the -mm tree.  Its filename is
     usb-in-init_endpoint_class-use-ptr_err-to-obtain-an-errno-value-not-is_err.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: USB: In init_endpoint_class, use PTR_ERR to obtain an errno value, not IS_ERR
From: Josh Triplett <josh@kernel.org>

init_endpoint_class calls class_create, and checks the result for an error
with IS_ERR; however, if true, it then returns the result of IS_ERR (a
boolean) rather than PTR_ERR (the actual errno).

Signed-off-by: Josh Triplett <josh@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/core/endpoint.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

usb-in-init_endpoint_class-use-ptr_err-to-obtain-an-errno-value-not-is_err.patch

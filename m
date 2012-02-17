From: akpm@linux-foundation.org
Subject: + c2port-class_create-returns-an-err_ptr.patch added to -mm tree
Date: Fri, 17 Feb 2012 15:00:39 -0800
Message-ID: <20120217230039.4C529A0365@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61408 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab2BQXAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2012 18:00:40 -0500
Received: by ggnp1 with SMTP id p1so488935ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2012 15:00:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com


The patch titled
     Subject: c2port: class_create() returns an ERR_PTR
has been added to the -mm tree.  Its filename is
     c2port-class_create-returns-an-err_ptr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: c2port: class_create() returns an ERR_PTR

class_create() doesn't return a NULL, it only returns ERR_PTRs.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/c2port/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/c2port/core.c~c2port-class_create-returns-an-err_ptr drivers/misc/c2port/core.c
--- a/drivers/misc/c2port/core.c~c2port-class_create-returns-an-err_ptr
+++ a/drivers/misc/c2port/core.c
@@ -984,9 +984,9 @@ static int __init c2port_init(void)
 		" - (C) 2007 Rodolfo Giometti\n");
 
 	c2port_class = class_create(THIS_MODULE, "c2port");
-	if (!c2port_class) {
+	if (IS_ERR(c2port_class)) {
 		printk(KERN_ERR "c2port: failed to allocate class\n");
-		return -ENOMEM;
+		return PTR_ERR(c2port_class);
 	}
 	c2port_class->dev_attrs = c2port_attrs;
 
_
Subject: Subject: c2port: class_create() returns an ERR_PTR

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
pps-class_create-returns-an-err_ptr-not-null.patch
c2port-class_create-returns-an-err_ptr.patch
slab-introduce-kmalloc_array.patch
mm-compaction-make-compact_control-order-signed.patch
mm-compaction-make-compact_control-order-signed-fix.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch


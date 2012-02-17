From: akpm@linux-foundation.org
Subject: + pps-class_create-returns-an-err_ptr-not-null.patch added to -mm tree
Date: Fri, 17 Feb 2012 14:59:34 -0800
Message-ID: <20120217225936.81478A0365@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:58932 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753241Ab2BQW7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Feb 2012 17:59:39 -0500
Received: by lahl5 with SMTP id l5so125359lah.1
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2012 14:59:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, giometti@enneenne.com


The patch titled
     Subject: pps: class_create() returns an ERR_PTR, not NULL
has been added to the -mm tree.  Its filename is
     pps-class_create-returns-an-err_ptr-not-null.patch

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
Subject: pps: class_create() returns an ERR_PTR, not NULL

class_create() never returns NULLs only ERR_PTRs.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/pps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pps/pps.c~pps-checking-for-null-instead-of-is_err drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-checking-for-null-instead-of-is_err
+++ a/drivers/pps/pps.c
@@ -369,9 +369,9 @@ static int __init pps_init(void)
 	int err;
 
 	pps_class = class_create(THIS_MODULE, "pps");
-	if (!pps_class) {
+	if (IS_ERR(pps_class)) {
 		pr_err("failed to allocate class\n");
-		return -ENOMEM;
+		return PTR_ERR(pps_class);
 	}
 	pps_class->dev_attrs = pps_attrs;
 
_
Subject: Subject: pps: class_create() returns an ERR_PTR, not NULL

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
pps-class_create-returns-an-err_ptr-not-null.patch
slab-introduce-kmalloc_array.patch
mm-compaction-make-compact_control-order-signed.patch
mm-compaction-make-compact_control-order-signed-fix.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch


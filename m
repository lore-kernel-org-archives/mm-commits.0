From: akpm@linux-foundation.org
Subject: [patch 016/114] drivers/misc/c2port/c2port-duramar2150.c:
 checking for NULL instead of IS_ERR()
Date: Mon, 08 May 2017 15:55:17 -0700
Message-ID: <20170508225517.oLUI5nbDC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45838 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751354AbdEHWzS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.carpenter@oracle.com, giometti@linux.it, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/misc/c2port/c2port-duramar2150.c: checking for NULL instead of IS_ERR()

c2port_device_register() never returns NULL, it uses error pointers.

Link: http://lkml.kernel.org/r/20170412083321.GC3250@mwanda
Fixes: 65131cd52b9e ("c2port: add c2port support for Eurotech Duramar 2150")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/c2port/c2port-duramar2150.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/c2port/c2port-duramar2150.c~c2port-checking-for-null-instead-of-is_err drivers/misc/c2port/c2port-duramar2150.c
--- a/drivers/misc/c2port/c2port-duramar2150.c~c2port-checking-for-null-instead-of-is_err
+++ a/drivers/misc/c2port/c2port-duramar2150.c
@@ -129,8 +129,8 @@ static int __init duramar2150_c2port_ini
 
 	duramar2150_c2port_dev = c2port_device_register("uc",
 					&duramar2150_c2port_ops, NULL);
-	if (!duramar2150_c2port_dev) {
-		ret = -ENODEV;
+	if (IS_ERR(duramar2150_c2port_dev)) {
+		ret = PTR_ERR(duramar2150_c2port_dev);
 		goto free_region;
 	}
 
_

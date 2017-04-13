From: akpm@linux-foundation.org
Subject: + c2port-checking-for-null-instead-of-is_err.patch added to -mm
 tree
Date: Thu, 13 Apr 2017 13:51:51 -0700
Message-ID: <58efe4e7.ms+di43+TdFsbkc4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47144 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932108AbdDMUv5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 16:51:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, giometti@linux.it, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/c2port/c2port-duramar2150.c: checking for NULL instead of IS_ERR()
has been added to the -mm tree.  Its filename is
     c2port-checking-for-null-instead-of-is_err.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/c2port-checking-for-null-instead-of-is_err.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/c2port-checking-for-null-instead-of-is_err.patch

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

Patches currently in -mm which might be from dan.carpenter@oracle.com are

vmci-fix-a-couple-integer-overflow-tests.patch
c2port-checking-for-null-instead-of-is_err.patch


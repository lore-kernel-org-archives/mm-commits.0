From: akpm@linux-foundation.org
Subject: + iio-iio_get_new_idr_val-return-negative-value-on-failure.patch added to -mm tree
Date: Mon, 22 Mar 2010 23:20:23 -0400
Message-ID: <201003230621.o2N6LE63017993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824Ab0CWGVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 02:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonic.adi@gmail.com, greg@kroah.com, jic23@cam.ac.uk


The patch titled
     iio: iio_get_new_idr_val() return negative value on failure
has been added to the -mm tree.  Its filename is
     iio-iio_get_new_idr_val-return-negative-value-on-failure.patch

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
Subject: iio: iio_get_new_idr_val() return negative value on failure
From: sonic zhang <sonic.adi@gmail.com>

Function iio_get_new_idr_val() returns a negative value if it fails.  So,
only error when ret < 0 in iio_device_register_eventset().

Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/iio/industrialio-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/staging/iio/industrialio-core.c~iio-iio_get_new_idr_val-return-negative-value-on-failure drivers/staging/iio/industrialio-core.c
--- a/drivers/staging/iio/industrialio-core.c~iio-iio_get_new_idr_val-return-negative-value-on-failure
+++ a/drivers/staging/iio/industrialio-core.c
@@ -536,6 +536,7 @@ static void iio_device_unregister_sysfs(
 	sysfs_remove_group(&dev_info->dev.kobj, dev_info->attrs);
 }
 
+/* This function return negative value if fails. */
 int iio_get_new_idr_val(struct idr *this_idr)
 {
 	int ret;
@@ -659,7 +660,7 @@ static int iio_device_register_eventset(
 	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
 		dev_info->event_interfaces[i].owner = dev_info->driver_module;
 		ret = iio_get_new_idr_val(&iio_event_idr);
-		if (ret)
+		if (ret < 0)
 			goto error_free_setup_ev_ints;
 		else
 			dev_info->event_interfaces[i].id = ret;
_

Patches currently in -mm which might be from sonic.adi@gmail.com are

iio-iio_get_new_idr_val-return-negative-value-on-failure.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch


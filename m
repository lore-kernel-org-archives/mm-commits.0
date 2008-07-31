From: akpm@linux-foundation.org
Subject: - w1-ds2490c-ds_reset-remove-ds_wait_status.patch removed from -mm tree
Date: Wed, 30 Jul 2008 20:02:24 -0700
Message-ID: <200807310302.m6V32Op0000570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758631AbYGaDDr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:03:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1: ds2490.c ds_reset remove ds_wait_status
has been removed from the -mm tree.  Its filename was
     w1-ds2490c-ds_reset-remove-ds_wait_status.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: ds2490.c ds_reset remove ds_wait_status
From: David Fries <david@fries.net>

ds_reset no longer calls ds_wait_status, the result wasn't used and it
would only delay the following data operations.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds2490.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff -puN drivers/w1/masters/ds2490.c~w1-ds2490c-ds_reset-remove-ds_wait_status drivers/w1/masters/ds2490.c
--- a/drivers/w1/masters/ds2490.c~w1-ds2490c-ds_reset-remove-ds_wait_status
+++ a/drivers/w1/masters/ds2490.c
@@ -457,7 +457,7 @@ static int ds_wait_status(struct ds_devi
 		return 0;
 }
 
-static int ds_reset(struct ds_device *dev, struct ds_status *st)
+static int ds_reset(struct ds_device *dev)
 {
 	int err;
 
@@ -466,14 +466,6 @@ static int ds_reset(struct ds_device *de
 	if (err)
 		return err;
 
-	ds_wait_status(dev, st);
-#if 0
-	if (st->command_buffer_status) {
-		printk(KERN_INFO "Short circuit.\n");
-		return -EIO;
-	}
-#endif
-
 	return 0;
 }
 
@@ -809,12 +801,9 @@ static u8 ds9490r_read_block(void *data,
 static u8 ds9490r_reset(void *data)
 {
 	struct ds_device *dev = data;
-	struct ds_status st;
 	int err;
 
-	memset(&st, 0, sizeof(st));

From: akpm@linux-foundation.org
Subject: - w1-ds2490c-ds_write_block-remove-extra-ds_wait_status.patch removed from -mm tree
Date: Wed, 30 Jul 2008 20:02:30 -0700
Message-ID: <200807310302.m6V32U7D000579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762675AbYGaDCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:02:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1: ds2490.c ds_write_block remove extra ds_wait_status
has been removed from the -mm tree.  Its filename was
     w1-ds2490c-ds_write_block-remove-extra-ds_wait_status.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: ds2490.c ds_write_block remove extra ds_wait_status
From: David Fries <david@fries.net>

Drop the extra ds_wait_status() in ds_write_block().

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds2490.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/w1/masters/ds2490.c~w1-ds2490c-ds_write_block-remove-extra-ds_wait_status drivers/w1/masters/ds2490.c
--- a/drivers/w1/masters/ds2490.c~w1-ds2490c-ds_write_block-remove-extra-ds_wait_status
+++ a/drivers/w1/masters/ds2490.c
@@ -648,8 +648,6 @@ static int ds_write_block(struct ds_devi
 	if (err < 0)
 		return err;
 
-	ds_wait_status(dev, &st);

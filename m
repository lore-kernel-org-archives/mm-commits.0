From: akpm@linux-foundation.org
Subject: [nacked] input-ads7846c-sparse-lock-annotation.patch removed from -mm tree
Date: Wed, 13 May 2009 20:50:39 -0700
Message-ID: <200905140350.n4E3odUM002940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932130AbZENDuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 23:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: ads7846.c sparse lock annotation
has been removed from the -mm tree.  Its filename was
     input-ads7846c-sparse-lock-annotation.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: ads7846.c sparse lock annotation
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ads7846.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/input/touchscreen/ads7846.c~input-ads7846c-sparse-lock-annotation drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~input-ads7846c-sparse-lock-annotation
+++ a/drivers/input/touchscreen/ads7846.c
@@ -769,6 +769,8 @@ static irqreturn_t ads7846_irq(int irq, 
 
 /* Must be called with ts->lock held */
 static void ads7846_disable(struct ads7846 *ts)
+__releases(&ts->lock)
+__acquires(&ts->lock)
 {
 	if (ts->disabled)
 		return;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch


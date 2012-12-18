From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-lms283gf05c-add-missing-const.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:10 -0800
Message-ID: <20121218200510.99C53100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:59281 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:11 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so125585vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, marex@denx.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/lms283gf05.c: add missing const
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-lms283gf05c-add-missing-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/lms283gf05.c: add missing const

Add 'const' to static array that was missing it in its definition.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Marek Vasut <marex@denx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms283gf05.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/lms283gf05.c~drivers-video-backlight-lms283gf05c-add-missing-const drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~drivers-video-backlight-lms283gf05c-add-missing-const
+++ a/drivers/video/backlight/lms283gf05.c
@@ -31,7 +31,7 @@ struct lms283gf05_seq {
 };
 
 /* Magic sequences supplied by manufacturer, for details refer to datasheet */
-static struct lms283gf05_seq disp_initseq[] = {
+static const struct lms283gf05_seq disp_initseq[] = {
 	/* REG, VALUE, DELAY */
 	{ 0x07, 0x0000, 0 },
 	{ 0x13, 0x0000, 10 },
@@ -78,7 +78,7 @@ static struct lms283gf05_seq disp_initse
 	{ 0x22, 0x0000, 0 }
 };
 
-static struct lms283gf05_seq disp_pdwnseq[] = {
+static const struct lms283gf05_seq disp_pdwnseq[] = {
 	{ 0x07, 0x0016, 30 },
 
 	{ 0x07, 0x0004, 0 },
@@ -104,7 +104,7 @@ static void lms283gf05_reset(unsigned lo
 }
 
 static void lms283gf05_toggle(struct spi_device *spi,
-			struct lms283gf05_seq *seq, int sz)
+				const struct lms283gf05_seq *seq, int sz)
 {
 	char buf[3];
 	int i;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch


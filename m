From: akpm@linux-foundation.org
Subject: [merged] misc-remove-mac-pmu-function-declaration-from-misc-device-class.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:55:54 -0800
Message-ID: <200912152155.nBFLtsIf015526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933785AbZLOV40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:56:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, mm-commits@vger.kernel.org


The patch titled
     misc: remove MAC pmu function declaration from misc device class
has been removed from the -mm tree.  Its filename was
     misc-remove-mac-pmu-function-declaration-from-misc-device-class.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: misc: remove MAC pmu function declaration from misc device class
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Commit 8c8709334cec803368a432a33e0f2e116d48fe07 has removed the
pmu_device_init call from misc_init, but unlike other similar commits,
has not removed its declaration.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/char/misc.c~misc-remove-mac-pmu-function-declaration-from-misc-device-class drivers/char/misc.c
--- a/drivers/char/misc.c~misc-remove-mac-pmu-function-declaration-from-misc-device-class
+++ a/drivers/char/misc.c
@@ -62,8 +62,6 @@ static DEFINE_MUTEX(misc_mtx);
 #define DYNAMIC_MINORS 64 /* like dynamic majors */
 static unsigned char misc_minors[DYNAMIC_MINORS / 8];
 
-extern int pmu_device_init(void);

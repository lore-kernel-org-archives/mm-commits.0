From: akpm@linux-foundation.org
Subject: [merged] adt7462-fix-pin-28-monitoring.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:27:06 -0800
Message-ID: <200912182027.nBIKR6b4016605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932849AbZLRU1g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:27:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blofeldus@yahoo.com, djwong@us.ibm.com, khali@linux-fr.org, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     drivers/hwmon/adt7462.c: fix pin 28 monitoring
has been removed from the -mm tree.  Its filename was
     adt7462-fix-pin-28-monitoring.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/hwmon/adt7462.c: fix pin 28 monitoring
From: roger blofeld <blofeldus@yahoo.com>

The ADT7462_PIN28_VOLT value is a 4-bit field, so the corresponding shift
must be 4.

Signed-off-by: Roger Blofeld <blofeldus@yahoo.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adt7462.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/adt7462.c~adt7462-fix-pin-28-monitoring drivers/hwmon/adt7462.c
--- a/drivers/hwmon/adt7462.c~adt7462-fix-pin-28-monitoring
+++ a/drivers/hwmon/adt7462.c
@@ -94,7 +94,7 @@ static const unsigned short normal_i2c[]
 #define		ADT7462_PIN24_SHIFT		6
 #define		ADT7462_PIN26_VOLT_INPUT	0x08
 #define		ADT7462_PIN25_VOLT_INPUT	0x20
-#define		ADT7462_PIN28_SHIFT		6	/* cfg3 */
+#define        ADT7462_PIN28_SHIFT        4    /* cfg3 */
 #define		ADT7462_PIN28_VOLT		0x5
 
 #define ADT7462_REG_ALARM1			0xB8
_

Patches currently in -mm which might be from blofeldus@yahoo.com are

linux-next.patch


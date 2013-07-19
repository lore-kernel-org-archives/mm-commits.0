From: akpm@linux-foundation.org
Subject: [merged] ssb-fix-alignment-of-struct-bcma_device_id.patch removed from -mm tree
Date: Fri, 19 Jul 2013 12:11:30 -0700
Message-ID: <51e98f62.LFs2WqU4NVFtxeZm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3GSTLb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 15:11:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mb@bu3sch.de, linville@tuxdriver.com, linux@arm.linux.org.uk, Larry.Finger@lwfinger.net, arnd@arndb.de

Subject: [merged] ssb-fix-alignment-of-struct-bcma_device_id.patch removed from -mm tree
To: arnd@arndb.de,Larry.Finger@lwfinger.net,linux@arm.linux.org.uk,linville@tuxdriver.com,mb@bu3sch.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 12:11:30 -0700


The patch titled
     Subject: ssb: fix alignment of struct bcma_device_id
has been removed from the -mm tree.  Its filename was
     ssb-fix-alignment-of-struct-bcma_device_id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: ssb: fix alignment of struct bcma_device_id

The ARM OABI and EABI disagree on the alignment of structures with small
members, so module init tools may interpret the ssb device table
incorrectly, as shown by this warning when building the b43 device driver
in an OABI kernel:

FATAL: drivers/net/wireless/b43/b43: sizeof(struct ssb_device_id)=6 is not
a modulo of the size of section __mod_ssb_device_table=88.

Forcing the default (EABI) alignment on the structure makes this problem
go away.  Since the ssb_device_id may have the same problem, better fix
both structures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mod_devicetable.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/mod_devicetable.h~ssb-fix-alignment-of-struct-bcma_device_id include/linux/mod_devicetable.h
--- a/include/linux/mod_devicetable.h~ssb-fix-alignment-of-struct-bcma_device_id
+++ a/include/linux/mod_devicetable.h
@@ -361,7 +361,8 @@ struct ssb_device_id {
 	__u16	vendor;
 	__u16	coreid;
 	__u8	revision;
-};
+	__u8	__pad;
+} __attribute__((packed, aligned(2)));
 #define SSB_DEVICE(_vendor, _coreid, _revision)  \
 	{ .vendor = _vendor, .coreid = _coreid, .revision = _revision, }
 #define SSB_DEVTABLE_END  \
@@ -377,7 +378,7 @@ struct bcma_device_id {
 	__u16	id;
 	__u8	rev;
 	__u8	class;
-};
+} __attribute__((packed,aligned(2)));
 #define BCMA_CORE(_manuf, _id, _rev, _class)  \
 	{ .manuf = _manuf, .id = _id, .rev = _rev, .class = _class, }
 #define BCMA_CORETABLE_END  \
_

Patches currently in -mm which might be from arnd@arndb.de are

linux-next.patch


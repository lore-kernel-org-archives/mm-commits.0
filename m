From: akpm@linux-foundation.org
Subject: [merged] rtc-use-c99-initializers-in-structures.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:20:17 -0700
Message-ID: <543d6961.qjr/EJNtSYosZ7oO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaJNSUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:20:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: use c99 initializers in structures
has been removed from the -mm tree.  Its filename was
     rtc-use-c99-initializers-in-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: rtc: use c99 initializers in structures

Use c99 initializers for structures.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@decl@
identifier i1,fld;
type T;
field list[n] fs;
@@

struct i1 {
 fs
 T fld;
 ...};

@bad@
identifier decl.i1,i2;
expression e;
initializer list[decl.n] is;
@@

struct i1 i2 = { is,
+ .fld = e
- e
 ,...};
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8583.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-pcf8583.c~rtc-use-c99-initializers-in-structures drivers/rtc/rtc-pcf8583.c
--- a/drivers/rtc/rtc-pcf8583.c~rtc-use-c99-initializers-in-structures
+++ a/drivers/rtc/rtc-pcf8583.c
@@ -176,7 +176,11 @@ static int pcf8583_rtc_read_time(struct
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	unsigned char ctrl, year[2];
-	struct rtc_mem mem = { CMOS_YEAR, sizeof(year), year };
+	struct rtc_mem mem = {
+		.loc = CMOS_YEAR,
+		.nr = sizeof(year),
+		.data = year
+	};
 	int real_year, year_offset, err;
 
 	/*
@@ -222,8 +226,16 @@ static int pcf8583_rtc_set_time(struct d
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	unsigned char year[2], chk;
-	struct rtc_mem cmos_year  = { CMOS_YEAR, sizeof(year), year };
-	struct rtc_mem cmos_check = { CMOS_CHECKSUM, 1, &chk };
+	struct rtc_mem cmos_year  = {
+		.loc = CMOS_YEAR,
+		.nr = sizeof(year),
+		.data = year
+	};
+	struct rtc_mem cmos_check = {
+		.loc = CMOS_CHECKSUM,
+		.nr = 1,
+		.data = &chk
+	};
 	unsigned int proper_year = tm->tm_year + 1900;
 	int ret;
 
_

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are

origin.patch
linux-next.patch


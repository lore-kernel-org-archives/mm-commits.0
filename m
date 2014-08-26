From: akpm@linux-foundation.org
Subject: + rtc-use-c99-initializers-in-structures.patch added to -mm tree
Date: Tue, 26 Aug 2014 15:30:19 -0700
Message-ID: <53fd0a7b.KJFOUhOsEwSkkkNM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:43019 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922AbaHZWaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 18:30:20 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so3011037oig.3
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 15:30:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: use c99 initializers in structures
has been added to the -mm tree.  Its filename is
     rtc-use-c99-initializers-in-structures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-use-c99-initializers-in-structures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-use-c99-initializers-in-structures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-use-c99-initializers-in-structures.patch
linux-next.patch


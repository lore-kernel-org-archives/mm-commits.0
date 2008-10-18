From: akpm@linux-foundation.org
Subject: - w1-ds2490c-disable-bit-read-and-write.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:11 -0700
Message-ID: <200810182320.m9INKBgt029680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560AbYJRXUa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: ds2490.c disable bit read and write
has been removed from the -mm tree.  Its filename was
     w1-ds2490c-disable-bit-read-and-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: ds2490.c disable bit read and write
From: David Fries <david@fries.net>

Don't export read and write bit operations, they didn't work, they weren't
used, and they can't be made to work.  The one wire low level bit
operations expect to set high or low levels, the ds2490 hardware only
supports complete read or write time slots, better to just comment them
out.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds2490.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff -puN drivers/w1/masters/ds2490.c~w1-ds2490c-disable-bit-read-and-write drivers/w1/masters/ds2490.c
--- a/drivers/w1/masters/ds2490.c~w1-ds2490c-disable-bit-read-and-write
+++ a/drivers/w1/masters/ds2490.c
@@ -520,6 +520,7 @@ static int ds_touch_bit(struct ds_device
 	return 0;
 }
 
+#if 0
 static int ds_write_bit(struct ds_device *dev, u8 bit)
 {
 	int err;
@@ -538,6 +539,7 @@ static int ds_write_bit(struct ds_device
 
 	return 0;
 }
+#endif
 
 static int ds_write_byte(struct ds_device *dev, u8 byte)
 {
@@ -722,6 +724,7 @@ static u8 ds9490r_touch_bit(void *data, 
 	return ret;
 }
 
+#if 0
 static void ds9490r_write_bit(void *data, u8 bit)
 {
 	struct ds_device *dev = data;
@@ -729,13 +732,6 @@ static void ds9490r_write_bit(void *data
 	ds_write_bit(dev, bit);
 }
 
-static void ds9490r_write_byte(void *data, u8 byte)
-{
-	struct ds_device *dev = data;
-
-	ds_write_byte(dev, byte);
-}
-
 static u8 ds9490r_read_bit(void *data)
 {
 	struct ds_device *dev = data;
@@ -748,6 +744,14 @@ static u8 ds9490r_read_bit(void *data)
 
 	return bit & 1;
 }
+#endif
+
+static void ds9490r_write_byte(void *data, u8 byte)
+{
+	struct ds_device *dev = data;
+
+	ds_write_byte(dev, byte);
+}
 
 static u8 ds9490r_read_byte(void *data)
 {
@@ -812,8 +816,15 @@ static int ds_w1_init(struct ds_device *
 
 	dev->master.data	= dev;
 	dev->master.touch_bit	= &ds9490r_touch_bit;
+	/* read_bit and write_bit in w1_bus_master are expected to set and
+	 * sample the line level.  For write_bit that means it is expected to
+	 * set it to that value and leave it there.  ds2490 only supports an
+	 * individual time slot at the lowest level.  The requirement from
+	 * pulling the bus state down to reading the state is 15us, something
+	 * that isn't realistic on the USB bus anyway.
 	dev->master.read_bit	= &ds9490r_read_bit;
 	dev->master.write_bit	= &ds9490r_write_bit;
+	*/
 	dev->master.read_byte	= &ds9490r_read_byte;
 	dev->master.write_byte	= &ds9490r_write_byte;
 	dev->master.read_block	= &ds9490r_read_block;
_

Patches currently in -mm which might be from david@fries.net are

origin.patch


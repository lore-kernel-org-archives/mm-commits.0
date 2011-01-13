From: akpm@linux-foundation.org
Subject: [folded] nfc-driver-for-nxp-semiconductors-pn544-nfc-chip-update.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:25:59 -0800
Message-ID: <201101130026.p0D0Q0md012394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755961Ab1AMA0H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:26:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matti.j.aaltonen@nokia.com, mm-commits@vger.kernel.org


The patch titled
     nfc-driver-for-nxp-semiconductors-pn544-nfc-chip-update
has been removed from the -mm tree.  Its filename was
     nfc-driver-for-nxp-semiconductors-pn544-nfc-chip-update.patch

This patch was dropped because it was folded into nfc-driver-for-nxp-semiconductors-pn544-nfc-chip.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfc-driver-for-nxp-semiconductors-pn544-nfc-chip-update
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>

updates from review, documentation fix.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/nfc/nfc-pn544.txt |  101 ++++++++++++++++--------------
 drivers/nfc/pn544.c             |   18 ++---
 include/linux/nfc/pn544.h       |    2 
 3 files changed, 63 insertions(+), 58 deletions(-)

diff -puN Documentation/nfc/nfc-pn544.txt~nfc-driver-for-nxp-semiconductors-pn544-nfc-chip-update Documentation/nfc/nfc-pn544.txt
--- a/Documentation/nfc/nfc-pn544.txt~nfc-driver-for-nxp-semiconductors-pn544-nfc-chip-update
+++ a/Documentation/nfc/nfc-pn544.txt
@@ -1,68 +1,77 @@
-Kernel driver for PN544
-========================
-
-* NXP Semiconductor PN544 Near Field Communication (NFC) chip
+Kernel driver for the NXP Semiconductors PN544 Near Field
+Communication chip
 
 Author: Jari Vanhala
 Contact: Matti Aaltonen (matti.j.aaltonen at nokia.com)
 
-Description
------------
+General
+-------
 
 The PN544 is an integrated transmission module for contactless
 communication. The driver goes under drives/nfc/ and is compiled as a
 module named "pn544". It registers a misc device and creates a device
 file named "/dev/pn544".
 
-The driver, is quite simple and it mainly passes data between the
-hardware and the user space.  There are two operating modes: The HCI
-(normal) mode and the firmware update mode. It can write and read in
-both modes.  The hardware sends an interrupt when data is available
-for reading.  Data is read when the read function is called by some
-user space application. Poll() checks the IRQ state. Configuration and
-self testing are done from the user space using read and write.
+Host Interfaces: I2C, SPI and HSU, this driver supports currently only I2C.
+
+The Interface
+-------------
+
+The driver offers a sysfs interface for a hardware test and an IOCTL
+interface for selecting between two operating modes. There are read,
+write and poll functions for transferring messages. The two operating
+modes are the normal (HCI) mode and the firmware update mode.
+
+PN544 is controlled by sending messages from the userspace to the
+chip. The main function of the driver is just to pass those messages
+without caring about the message content.
+
 
-The chip is powered up when the device is opened and otherwise
-it's turned off. Only one instance can use the device at a time.
+Protocols
+---------
 
-Host Interfaces: consisting of I2C, SPI and HSU as physical
-interfaces, this driver support I2C.
+In the normal (HCI) mode and in the firmware update mode read and
+write functions behave a bit differently because the message formats
+or the protocols are different.
 
-The chip is controlled from the user spase by sending SWP/HCI (Single
-Wire Protocol) messages according to the ETSI/SCP standard, see
+In the normal (HCI) mode the protocol used is derived from the ETSI
+HCI specification. The firmware is updated using a specific protocol,
+which is different from HCI.
+
+HCI messages consist of an eight bit header and the message body. The
+header contains the message length. Maximum size for an HCI message is
+33. In HCI mode sent messages are tested for a correct
+checksum. Firmware update messages have the length in the second (MSB)
+and third (LSB) bytes of the message. The maximum FW message length is
+1024 bytes.
+
+For the ETSI HCI specification see
 http://www.etsi.org/WebSite/Technologies/ProtocolSpecification.aspx
 
-The driver handles two kinds of messages: the normal HCI messages and
-the firmware update messages. HCI messages consist of and eight bit
-header and the message body. The header contains the message length.
-Maximum size for an HCI message is 33. In HCI mode sent packets are
-tested for a correct CRC.
-
-Firmware update messages, which can be read and written in the
-firmware upload mode have the length in the second (MSB) and third
-(LSB) bytes of the message.  The maximum FW message size is 1024
-bytes.
-
-The interfaces for pn544 users:
-
-There is a sysfs interface for testing that the hardware is
-operational. Reading from the sysfs file activates the test.  The test
-returns one on success and zero on failure.
+The Hardware Test
+-----------------
+
+The idea of the test is that it can performed by reading from the
+corresponding sysfs file. The test is implemented in the board file
+and it should test that PN544 can be put into the firmware update
+mode. If the test is not implemented the sysfs file does not get
+created.
 
 Example:
 > cat /sys/module/pn544/drivers/i2c\:pn544/3-002b/nfc_test
 1
 
-For mode setting there is an IOCTL interface, which consists of
-two messages:
-
-PN544_GET_FW_MODE returns 1 if the device is in firmware
-update mode and zero in the normal (HCI) mode.
+Normal Operation
+----------------
 
-PN544_SET_FW_MODE is for setting the mode.  The message parameter
-value defines the mode: one corresponds firmware update and zero the
-HCI mode.
+PN544 is powered up when the device file is opened, otherwise it's
+turned off. Only one instance can use the device at a time.
 
+Userspace applications control PN544 with HCI messages. The hardware
+sends an interrupt when data is available for reading. Data is
+physically read when the read function is called by a userspace
+application. Poll() checks the read interrupt state. Configuration and
+self testing are also done from the userspace using read and write.
 
 Example platform data:
 
@@ -86,9 +95,9 @@ static int rx71_pn544_nfc_test(void)
 	/*
 	 * Put the device into the FW update mode
 	 * and then back to the normal mode.
-	 * Return one on success and zero on
-         * failure.
-         */
+	 * Check the behavior and return one on success,
+	 * zero on failure.
+	 */
 }
 
 static void rx71_pn544_nfc_disable(void)
diff -puN drivers/nfc/pn544.c~nfc-driver-for-nxp-semiconductors-pn544-nfc-chip-update drivers/nfc/pn544.c
--- a/drivers/nfc/pn544.c~nfc-driver-for-nxp-semiconductors-pn544-nfc-chip-update
+++ a/drivers/nfc/pn544.c
@@ -110,7 +110,7 @@ static int pn544_enable(struct pn544_inf
 		dev_dbg(&client->dev, "now in HCI-mode\n");
 	}
 
-	msleep(PN544_BOOT_TIME);
+	usleep_range(10000, 15000);
 
 	return 0;
 }
@@ -174,14 +174,13 @@ static int pn544_i2c_write(struct i2c_cl
 	if (check_crc(buf, len))
 		return -EINVAL;
 
-
-	msleep(PN544_I2C_IO_TIME);
+	usleep_range(3000, 6000);
 
 	r = i2c_master_send(client, buf, len);
 	dev_dbg(&client->dev, "send: %d\n", r);
 
 	if (r == -EREMOTEIO) { /* Retry, chip was in standby */
-		msleep(PN544_WAKEUP_GUARD);
+		usleep_range(6000, 10000);
 		r = i2c_master_send(client, buf, len);
 		dev_dbg(&client->dev, "send2: %d\n", r);
 	}
@@ -223,7 +222,7 @@ static int pn544_i2c_read(struct i2c_cli
 	if (r != len)
 		return -EREMOTEIO;
 
-	msleep(PN544_I2C_IO_TIME);
+	usleep_range(3000, 6000);
 
 	return r + 1;
 }
@@ -242,7 +241,7 @@ static int pn544_fw_write(struct i2c_cli
 	dev_dbg(&client->dev, "fw send: %d\n", r);
 
 	if (r == -EREMOTEIO) { /* Retry, chip was in standby */
-		msleep(PN544_WAKEUP_GUARD);
+		usleep_range(6000, 10000);
 		r = i2c_master_send(client, buf, len);
 		dev_dbg(&client->dev, "fw send2: %d\n", r);
 	}
@@ -329,7 +328,7 @@ static ssize_t pn544_read(struct file *f
 	size_t len;
 	int r = 0;
 
-	dev_dbg(&client->dev, "%s: info: %p, count: %d\n", __func__,
+	dev_dbg(&client->dev, "%s: info: %p, count: %zu\n", __func__,
 		info, count);
 
 	mutex_lock(&info->mutex);
@@ -439,7 +438,7 @@ static ssize_t pn544_write(struct file *
 	ssize_t	len;
 	int r;
 
-	dev_dbg(&client->dev, "%s: info: %p, count %d\n", __func__,
+	dev_dbg(&client->dev, "%s: info: %p, count %zu\n", __func__,
 		info, count);
 
 	mutex_lock(&info->mutex);
@@ -633,7 +632,7 @@ static const struct file_operations pn54
 	.poll		= pn544_poll,
 	.open		= pn544_open,
 	.release	= pn544_close,
-	.unlocked_ioctl		= pn544_ioctl,
+	.unlocked_ioctl	= pn544_ioctl,
 };
 
 #ifdef CONFIG_PM
@@ -881,7 +880,6 @@ static int __init pn544_init(void)
 
 static void __exit pn544_exit(void)
 {
-	flush_scheduled_work();
 	i2c_del_driver(&pn544_driver);
 	pr_info(DRIVER_DESC ", Exiting.\n");
 }
diff -puN include/linux/nfc/pn544.h~nfc-driver-for-nxp-semiconductors-pn544-nfc-chip-update include/linux/nfc/pn544.h
--- a/include/linux/nfc/pn544.h~nfc-driver-for-nxp-semiconductors-pn544-nfc-chip-update
+++ a/include/linux/nfc/pn544.h
@@ -46,8 +46,6 @@
 #define PN544_PVDDVEN_TIME	0
 #define PN544_VBATVEN_TIME	0
 #define PN544_GPIO4VEN_TIME	0
-#define PN544_BOOT_TIME		10 /* 3 */
-#define PN544_I2C_IO_TIME	3 /* 100 */
 #define PN544_WAKEUP_ACK	5
 #define PN544_WAKEUP_GUARD	(PN544_WAKEUP_ACK + 1)
 #define PN544_INACTIVITY_TIME	1000
_

Patches currently in -mm which might be from matti.j.aaltonen@nokia.com are

origin.patch
nfc-driver-for-nxp-semiconductors-pn544-nfc-chip.patch


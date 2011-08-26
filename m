From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1307c-eeprom-support-for-ds1388.patch added to -mm tree
Date: Fri, 26 Aug 2011 14:27:57 -0700
Message-ID: <201108262127.p7QLRvhh013097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755396Ab1HZV2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 17:28:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Austin.Boyle@Aviatnet.com, Joakim.Tjernlund@transmode.se, a.zummo@towertech.it, austin.boyle@Aviatnet.com


The patch titled
     drivers/rtc/rtc-ds1307.c: EEPROM support for DS1388
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1307c-eeprom-support-for-ds1388.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-ds1307.c: EEPROM support for DS1388
From: Austin Boyle <Austin.Boyle@Aviatnet.com>

Add support for different sized NVRAM, such as the 512 bytes of EEPROM on
the DS1388 chip.

Signed-off-by: Austin Boyle <austin.boyle@aviatnet.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |  146 ++++++++++++++++++++++++++++++-------
 1 file changed, 119 insertions(+), 27 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-eeprom-support-for-ds1388 drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-eeprom-support-for-ds1388
+++ a/drivers/rtc/rtc-ds1307.c
@@ -95,15 +95,19 @@ enum ds_type {
 #	define RX8025_BIT_VDET		0x40
 #	define RX8025_BIT_XST		0x20
 
+#define DS1307_MAX_NUM_ADDRS	3
 
 struct ds1307 {
 	u8			offset; /* register's offset */
+	u16			nvram_size;
+	u16			nvram_offset;
+	u8			num_addrs;
 	u8			regs[11];
 	enum ds_type		type;
 	unsigned long		flags;
 #define HAS_NVRAM	0		/* bit 0 == sysfs file active */
 #define HAS_ALARM	1		/* bit 1 == irq claimed */
-	struct i2c_client	*client;
+	struct i2c_client	*client[DS1307_MAX_NUM_ADDRS];
 	struct rtc_device	*rtc;
 	struct work_struct	work;
 	s32 (*read_block_data)(const struct i2c_client *client, u8 command,
@@ -113,23 +117,26 @@ struct ds1307 {
 };
 
 struct chip_desc {
-	unsigned		nvram56:1;
+	unsigned		nvram:1;
 	unsigned		alarm:1;
 };
 
 static const struct chip_desc chips[] = {
 [ds_1307] = {
-	.nvram56	= 1,
+	.nvram		= 1,
 },
 [ds_1337] = {
 	.alarm		= 1,
 },
 [ds_1338] = {
-	.nvram56	= 1,
+	.nvram		= 1,
 },
 [ds_1339] = {
 	.alarm		= 1,
 },
+[ds_1388] = {
+	.nvram		= 1,
+},
 [ds_1340] = {
 },
 [ds_3231] = {
@@ -249,7 +256,7 @@ static void ds1307_work(struct work_stru
 	int			stat, control;
 
 	ds1307 = container_of(work, struct ds1307, work);
-	client = ds1307->client;
+	client = ds1307->client[0];
 	lock = &ds1307->rtc->ops_lock;
 
 	mutex_lock(lock);
@@ -295,7 +302,7 @@ static int ds1307_get_time(struct device
 	int		tmp;
 
 	/* read the RTC date and time registers all at once */
-	tmp = ds1307->read_block_data(ds1307->client,
+	tmp = ds1307->read_block_data(ds1307->client[0],
 		ds1307->offset, 7, ds1307->regs);
 	if (tmp != 7) {
 		dev_err(dev, "%s error %d\n", "read", tmp);
@@ -373,7 +380,7 @@ static int ds1307_set_time(struct device
 		"write", buf[0], buf[1], buf[2], buf[3],
 		buf[4], buf[5], buf[6]);
 
-	result = ds1307->write_block_data(ds1307->client,
+	result = ds1307->write_block_data(ds1307->client[0],
 		ds1307->offset, 7, buf);
 	if (result < 0) {
 		dev_err(dev, "%s error %d\n", "write", result);
@@ -531,8 +538,6 @@ static const struct rtc_class_ops ds13xx
 
 /*----------------------------------------------------------------------*/
 
-#define NVRAM_SIZE	56
-
 static ssize_t
 ds1307_nvram_read(struct file *filp, struct kobject *kobj,
 		struct bin_attribute *attr,
@@ -541,19 +546,49 @@ ds1307_nvram_read(struct file *filp, str
 	struct i2c_client	*client;
 	struct ds1307		*ds1307;
 	int			result;
+	unsigned int		addr = 0;
 
 	client = kobj_to_i2c_client(kobj);
 	ds1307 = i2c_get_clientdata(client);
 
-	if (unlikely(off >= NVRAM_SIZE))
+	if (unlikely(off >= ds1307->nvram_size))
 		return 0;
-	if ((off + count) > NVRAM_SIZE)
-		count = NVRAM_SIZE - off;
+	if ((off + count) > ds1307->nvram_size)
+		count = ds1307->nvram_size - off;
 	if (unlikely(!count))
 		return count;
 
-	result = ds1307->read_block_data(client, 8 + off, count, buf);
-	if (result < 0)
+	if (ds1307->nvram_offset < 0xff) {
+		result = ds1307->read_block_data(client,
+						ds1307->nvram_offset + off,
+						count, buf);
+	} else {
+		/* read spans two blocks */
+		if ((off <= 0x00ff) && (off + count > 0x00ff)) {
+			client = ds1307->client[1];
+			addr = (unsigned int)off;
+			result = ds1307->read_block_data(client, addr,
+							(0x100-addr), buf);
+			if (result < 0)
+				goto err;
+			client = ds1307->client[2];
+			result = ds1307->read_block_data(client, 0x00,
+							(count+addr-0x100),
+							(buf+0x100-addr));
+		/* read spans one blocks */
+		} else {
+			if (off <= 0x00ff) {
+				client = ds1307->client[1];
+				addr = (unsigned int)off;
+			} else if (off <= 0x0200) {
+				client = ds1307->client[2];
+				addr = (unsigned int)off - 0x100;
+			}
+			result = ds1307->read_block_data(client, addr,
+							count, buf);
+		}
+	}
+err:	if (result < 0)
 		dev_err(&client->dev, "%s error %d\n", "nvram read", result);
 	return result;
 }
@@ -566,19 +601,49 @@ ds1307_nvram_write(struct file *filp, st
 	struct i2c_client	*client;
 	struct ds1307		*ds1307;
 	int			result;
+	unsigned int		addr = 0;
 
 	client = kobj_to_i2c_client(kobj);
 	ds1307 = i2c_get_clientdata(client);
 
-	if (unlikely(off >= NVRAM_SIZE))
+	if (unlikely(off >= ds1307->nvram_size))
 		return -EFBIG;
-	if ((off + count) > NVRAM_SIZE)
-		count = NVRAM_SIZE - off;
+	if ((off + count) > ds1307->nvram_size)
+		count = ds1307->nvram_size - off;
 	if (unlikely(!count))
 		return count;
 
-	result = ds1307->write_block_data(client, 8 + off, count, buf);
-	if (result < 0) {
+	if (ds1307->nvram_offset < 0xff) {
+		result = ds1307->write_block_data(client,
+						ds1307->nvram_offset + off,
+						count, buf);
+	} else {
+		/* read spans two blocks */
+		if ((off <= 0x00ff) && ((off + count) > 0x00ff)) {
+			client = ds1307->client[1];
+			addr = (unsigned int)off;
+			result = ds1307->write_block_data(client, addr,
+							(0x100-addr), buf);
+			if (result < 0)
+				goto err;
+			client = ds1307->client[2];
+			result = ds1307->write_block_data(client, 0x00,
+							(addr+count-0x100),
+							(buf+0x100-addr));
+		/* read spans one blocks */
+		} else {
+			if (off <= 0x00ff) {
+				client = ds1307->client[1];
+				addr = (unsigned int)off;
+			} else if (off <= 0x0200) {
+				client = ds1307->client[2];
+				addr = (unsigned int)off - 0x100;
+			}
+			result = ds1307->write_block_data(client, addr,
+							count, buf);
+		}
+	}
+err:	if (result < 0) {
 		dev_err(&client->dev, "%s error %d\n", "nvram write", result);
 		return result;
 	}
@@ -593,7 +658,6 @@ static struct bin_attribute nvram = {
 
 	.read	= ds1307_nvram_read,
 	.write	= ds1307_nvram_write,
-	.size	= NVRAM_SIZE,
 };
 
 /*----------------------------------------------------------------------*/
@@ -606,6 +670,7 @@ static int __devinit ds1307_probe(struct
 	struct ds1307		*ds1307;
 	int			err = -ENODEV;
 	int			tmp;
+	int			i;
 	const struct chip_desc	*chip = &chips[id->driver_data];
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	int			want_irq = false;
@@ -625,9 +690,10 @@ static int __devinit ds1307_probe(struct
 
 	i2c_set_clientdata(client, ds1307);
 
-	ds1307->client	= client;
+	ds1307->client[0] = client;
 	ds1307->type	= id->driver_data;
 	ds1307->offset	= 0;
+	ds1307->num_addrs = 1;
 
 	buf = ds1307->regs;
 	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
@@ -643,12 +709,12 @@ static int __devinit ds1307_probe(struct
 	case ds_1339:
 	case ds_3231:
 		/* has IRQ? */
-		if (ds1307->client->irq > 0 && chip->alarm) {
+		if (client->irq > 0 && chip->alarm) {
 			INIT_WORK(&ds1307->work, ds1307_work);
 			want_irq = true;
 		}
 		/* get registers that the "rtc" read below won't read... */
-		tmp = ds1307->read_block_data(ds1307->client,
+		tmp = ds1307->read_block_data(client,
 				DS1337_REG_CONTROL, 2, buf);
 		if (tmp != 2) {
 			pr_debug("read error %d\n", tmp);
@@ -682,7 +748,7 @@ static int __devinit ds1307_probe(struct
 		break;
 
 	case rx_8025:
-		tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
+		tmp = i2c_smbus_read_i2c_block_data(client,
 				RX8025_REG_CTRL1 << 4 | 0x08, 2, buf);
 		if (tmp != 2) {
 			pr_debug("read error %d\n", tmp);
@@ -748,6 +814,14 @@ static int __devinit ds1307_probe(struct
 		break;
 	case ds_1388:
 		ds1307->offset = 1; /* Seconds starts at 1 */
+		ds1307->num_addrs = 3;	/* uses 3 I2C addrs */
+		ds1307->nvram_size = 512; /* 512 bytes EEPROM */
+		ds1307->nvram_offset = 0xff;
+		break;
+	case ds_1307:
+	case ds_1338:
+		ds1307->nvram_size = 56; /* 56 bytes NVRAM */
+		ds1307->nvram_offset = 8;
 		break;
 	default:
 		break;
@@ -755,7 +829,7 @@ static int __devinit ds1307_probe(struct
 
 read_rtc:
 	/* read RTC registers */
-	tmp = ds1307->read_block_data(ds1307->client, ds1307->offset, 8, buf);
+	tmp = ds1307->read_block_data(client, ds1307->offset, 8, buf);
 	if (tmp != 8) {
 		pr_debug("read error %d\n", tmp);
 		err = -EIO;
@@ -867,16 +941,34 @@ read_rtc:
 		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
 	}
 
-	if (chip->nvram56) {
+	if (chip->nvram) {
+		nvram.size = ds1307->nvram_size;
 		err = sysfs_create_bin_file(&client->dev.kobj, &nvram);
 		if (err == 0) {
 			set_bit(HAS_NVRAM, &ds1307->flags);
-			dev_info(&client->dev, "56 bytes nvram\n");
+			dev_info(&client->dev, "%d bytes nvram\n", nvram.size);
+		}
+	}
+
+	/* use dummy devices for multiple address chips */
+	for (i = 1; i < ds1307->num_addrs; i++) {
+		ds1307->client[i] = i2c_new_dummy(client->adapter,
+						client->addr + i);
+		if (!ds1307->client[i]) {
+			dev_err(&client->dev, "Address %02x unavailable\n",
+					client->addr + i);
+			err = -EBUSY;
+			goto exit_dummy;
 		}
+		i2c_set_clientdata(ds1307->client[i], ds1307);
 	}
 
 	return 0;
 
+exit_dummy:
+	for (i = 1; i < ds1307->num_addrs; i++)
+		if (ds1307->client[i])
+			i2c_unregister_device(ds1307->client[i]);
 exit_irq:
 	rtc_device_unregister(ds1307->rtc);
 exit_free:
_

Patches currently in -mm which might be from Austin.Boyle@Aviatnet.com are

drivers-rtc-rtc-ds1307c-eeprom-support-for-ds1388.patch


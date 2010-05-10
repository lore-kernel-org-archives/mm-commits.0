From: akpm@linux-foundation.org
Subject: + ad525x_dpot-simplify-duplicated-sysfs-defines.patch added to -mm tree
Date: Mon, 10 May 2010 15:11:26 -0700
Message-ID: <201005102211.o4AMBQ42025601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753878Ab0EJWLh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 May 2010 18:11:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, vapier@gentoo.org


The patch titled
     ad525x_dpot: simplify duplicated sysfs defines
has been added to the -mm tree.  Its filename is
     ad525x_dpot-simplify-duplicated-sysfs-defines.patch

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
Subject: ad525x_dpot: simplify duplicated sysfs defines
From: Michael Hennerich <michael.hennerich@analog.com>

Macro away the duplication to make maintenance easier.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ad525x_dpot.c |  256 +++++++----------------------------
 1 file changed, 52 insertions(+), 204 deletions(-)

diff -puN drivers/misc/ad525x_dpot.c~ad525x_dpot-simplify-duplicated-sysfs-defines drivers/misc/ad525x_dpot.c
--- a/drivers/misc/ad525x_dpot.c~ad525x_dpot-simplify-duplicated-sysfs-defines
+++ a/drivers/misc/ad525x_dpot.c
@@ -158,175 +158,45 @@ static ssize_t sysfs_do_cmd(struct devic
 
 /* ------------------------------------------------------------------------- */
 
-static ssize_t show_rdac0(struct device *dev,
-			  struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_RDAC | AD525X_RDAC0);
-}
-
-static ssize_t set_rdac0(struct device *dev,
-			 struct device_attribute *attr,
-			 const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_RDAC | AD525X_RDAC0);
-}
-
-static DEVICE_ATTR(rdac0, S_IWUSR | S_IRUGO, show_rdac0, set_rdac0);
-
-static ssize_t show_eeprom0(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_EEPROM | AD525X_RDAC0);
-}
-
-static ssize_t set_eeprom0(struct device *dev,
-			   struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_EEPROM | AD525X_RDAC0);
-}
-
-static DEVICE_ATTR(eeprom0, S_IWUSR | S_IRUGO, show_eeprom0, set_eeprom0);
-
-static ssize_t show_tolerance0(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf,
-			      AD525X_I2C_EEPROM | AD525X_TOL_RDAC0);
-}
-
-static DEVICE_ATTR(tolerance0, S_IRUGO, show_tolerance0, NULL);
-
-/* ------------------------------------------------------------------------- */
-
-static ssize_t show_rdac1(struct device *dev,
-			  struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_RDAC | AD525X_RDAC1);
-}
-
-static ssize_t set_rdac1(struct device *dev,
-			 struct device_attribute *attr,
-			 const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_RDAC | AD525X_RDAC1);
-}
-
-static DEVICE_ATTR(rdac1, S_IWUSR | S_IRUGO, show_rdac1, set_rdac1);
-
-static ssize_t show_eeprom1(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_EEPROM | AD525X_RDAC1);
-}
-
-static ssize_t set_eeprom1(struct device *dev,
-			   struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_EEPROM | AD525X_RDAC1);
-}
-
-static DEVICE_ATTR(eeprom1, S_IWUSR | S_IRUGO, show_eeprom1, set_eeprom1);
-
-static ssize_t show_tolerance1(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf,
-			      AD525X_I2C_EEPROM | AD525X_TOL_RDAC1);
-}
-
-static DEVICE_ATTR(tolerance1, S_IRUGO, show_tolerance1, NULL);
-
-/* ------------------------------------------------------------------------- */
-
-static ssize_t show_rdac2(struct device *dev,
-			  struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_RDAC | AD525X_RDAC2);
-}
-
-static ssize_t set_rdac2(struct device *dev,
-			 struct device_attribute *attr,
-			 const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_RDAC | AD525X_RDAC2);
-}
-
-static DEVICE_ATTR(rdac2, S_IWUSR | S_IRUGO, show_rdac2, set_rdac2);
-
-static ssize_t show_eeprom2(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_EEPROM | AD525X_RDAC2);
-}
-
-static ssize_t set_eeprom2(struct device *dev,
-			   struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_EEPROM | AD525X_RDAC2);
-}
-
-static DEVICE_ATTR(eeprom2, S_IWUSR | S_IRUGO, show_eeprom2, set_eeprom2);
-
-static ssize_t show_tolerance2(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf,
-			      AD525X_I2C_EEPROM | AD525X_TOL_RDAC2);
-}
-
-static DEVICE_ATTR(tolerance2, S_IRUGO, show_tolerance2, NULL);
-
-/* ------------------------------------------------------------------------- */
-
-static ssize_t show_rdac3(struct device *dev,
-			  struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_RDAC | AD525X_RDAC3);
-}
-
-static ssize_t set_rdac3(struct device *dev,
-			 struct device_attribute *attr,
-			 const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_RDAC | AD525X_RDAC3);
-}
-
-static DEVICE_ATTR(rdac3, S_IWUSR | S_IRUGO, show_rdac3, set_rdac3);
-
-static ssize_t show_eeprom3(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_EEPROM | AD525X_RDAC3);
-}
-
-static ssize_t set_eeprom3(struct device *dev,
-			   struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_EEPROM | AD525X_RDAC3);
-}
-
-static DEVICE_ATTR(eeprom3, S_IWUSR | S_IRUGO, show_eeprom3, set_eeprom3);
-
-static ssize_t show_tolerance3(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf,
-			      AD525X_I2C_EEPROM | AD525X_TOL_RDAC3);
-}
-
-static DEVICE_ATTR(tolerance3, S_IRUGO, show_tolerance3, NULL);
+#define DPOT_DEVICE_SHOW(_name, _reg) static ssize_t \
+show_##_name(struct device *dev, \
+			  struct device_attribute *attr, char *buf) \
+{ \
+	return sysfs_show_reg(dev, attr, buf, _reg); \
+}
+
+#define DPOT_DEVICE_SET(_name, _reg) static ssize_t \
+set_##_name(struct device *dev, \
+			 struct device_attribute *attr, \
+			 const char *buf, size_t count) \
+{ \
+	return sysfs_set_reg(dev, attr, buf, count, _reg); \
+}
+
+#define DPOT_DEVICE_SHOW_SET(name, reg) \
+DPOT_DEVICE_SHOW(name, reg) \
+DPOT_DEVICE_SET(name, reg) \
+static DEVICE_ATTR(name, S_IWUSR | S_IRUGO, show_##name, set_##name);
+
+#define DPOT_DEVICE_SHOW_ONLY(name, reg) \
+DPOT_DEVICE_SHOW(name, reg) \
+static DEVICE_ATTR(name, S_IWUSR | S_IRUGO, show_##name, NULL);
+
+DPOT_DEVICE_SHOW_SET(rdac0, AD525X_I2C_RDAC | AD525X_RDAC0);
+DPOT_DEVICE_SHOW_SET(eeprom0, AD525X_I2C_EEPROM | AD525X_RDAC0);
+DPOT_DEVICE_SHOW_ONLY(tolerance0, AD525X_I2C_EEPROM | AD525X_TOL_RDAC0);
+
+DPOT_DEVICE_SHOW_SET(rdac1, AD525X_I2C_RDAC | AD525X_RDAC1);
+DPOT_DEVICE_SHOW_SET(eeprom1, AD525X_I2C_EEPROM | AD525X_RDAC1);
+DPOT_DEVICE_SHOW_ONLY(tolerance1, AD525X_I2C_EEPROM | AD525X_TOL_RDAC1);
+
+DPOT_DEVICE_SHOW_SET(rdac2, AD525X_I2C_RDAC | AD525X_RDAC2);
+DPOT_DEVICE_SHOW_SET(eeprom2, AD525X_I2C_EEPROM | AD525X_RDAC2);
+DPOT_DEVICE_SHOW_ONLY(tolerance2, AD525X_I2C_EEPROM | AD525X_TOL_RDAC2);
+
+DPOT_DEVICE_SHOW_SET(rdac3, AD525X_I2C_RDAC | AD525X_RDAC3);
+DPOT_DEVICE_SHOW_SET(eeprom3, AD525X_I2C_EEPROM | AD525X_RDAC3);
+DPOT_DEVICE_SHOW_ONLY(tolerance3, AD525X_I2C_EEPROM | AD525X_TOL_RDAC3);
 
 static struct attribute *ad525x_attributes_wipers[4][4] = {
 	{
@@ -361,41 +231,19 @@ static const struct attribute_group ad52
 
 /* ------------------------------------------------------------------------- */
 
-static ssize_t set_inc_all(struct device *dev,
-			   struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	return sysfs_do_cmd(dev, attr, buf, count, AD525X_INC_ALL);
-}
-
-static DEVICE_ATTR(inc_all, S_IWUSR, NULL, set_inc_all);
-
-static ssize_t set_dec_all(struct device *dev,
-			   struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	return sysfs_do_cmd(dev, attr, buf, count, AD525X_DEC_ALL);
-}
-
-static DEVICE_ATTR(dec_all, S_IWUSR, NULL, set_dec_all);
-
-static ssize_t set_inc_all_6db(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
-{
-	return sysfs_do_cmd(dev, attr, buf, count, AD525X_INC_ALL_6DB);
-}
-
-static DEVICE_ATTR(inc_all_6db, S_IWUSR, NULL, set_inc_all_6db);
-
-static ssize_t set_dec_all_6db(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
-{
-	return sysfs_do_cmd(dev, attr, buf, count, AD525X_DEC_ALL_6DB);
-}
-
-static DEVICE_ATTR(dec_all_6db, S_IWUSR, NULL, set_dec_all_6db);
+#define DPOT_DEVICE_DO_CMD(_name, _cmd) static ssize_t \
+set_##_name(struct device *dev, \
+			 struct device_attribute *attr, \
+			 const char *buf, size_t count) \
+{ \
+	return sysfs_do_cmd(dev, attr, buf, count, _cmd); \
+} \
+static DEVICE_ATTR(_name, S_IWUSR | S_IRUGO, NULL, set_##_name);
+
+DPOT_DEVICE_DO_CMD(inc_all, AD525X_INC_ALL);
+DPOT_DEVICE_DO_CMD(dec_all, AD525X_DEC_ALL);
+DPOT_DEVICE_DO_CMD(inc_all_6db, AD525X_INC_ALL_6DB);
+DPOT_DEVICE_DO_CMD(dec_all_6db, AD525X_DEC_ALL_6DB);
 
 static struct attribute *ad525x_attributes_commands[] = {
 	&dev_attr_inc_all.attr,
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

fbdev-bfin-t350mcqb-fb-fix-fbmem-allocation-with-blanking-lines.patch
linux-next.patch
backlight-new-driver-for-the-adp8860-backlight-parts.patch
ad525x_dpot-simplify-duplicated-sysfs-defines.patch
ad525x_dpot-extend-write-argument-to-16bits.patch
ad525x_dpot-add-support-for-spi-parts.patch
ad525x_dpot-add-support-for-ad524x-pots.patch
ad525x_dpot-add-support-for-adn2860-and-ad528x-pots.patch
ad525x_dpot-add-support-for-one-time-programmable-pots.patch
fbdev-bfin-lq035q1-fb-respect-new-ppi-mode-platform-field.patch


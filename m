From: akpm@linux-foundation.org
Subject: + k10temp-temperature-sensor-driver-for-amd-family-10h-11h-cpus.patch added to -mm tree
Date: Wed, 25 Nov 2009 11:45:50 -0800
Message-ID: <200911251945.nAPJjo57004118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033AbZKYTqO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 14:46:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clemens@ladisch.de, belyshev@depni.sinp.msu.ru, jordan@cosmicpenguin.net, khali@linux-fr.org


The patch titled
     k10temp: temperature sensor driver for AMD Family 10h/11h CPUs
has been added to the -mm tree.  Its filename is
     k10temp-temperature-sensor-driver-for-amd-family-10h-11h-cpus.patch

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
Subject: k10temp: temperature sensor driver for AMD Family 10h/11h CPUs
From: Clemens Ladisch <clemens@ladisch.de>

Add a driver for the internal temperature sensor of AMD Family 10h and 11h
CPUs.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/k10temp |   60 ++++++++++
 drivers/hwmon/Kconfig       |   12 ++
 drivers/hwmon/Makefile      |    1 
 drivers/hwmon/k10temp.c     |  197 ++++++++++++++++++++++++++++++++++
 4 files changed, 270 insertions(+)

diff -puN /dev/null Documentation/hwmon/k10temp
--- /dev/null
+++ a/Documentation/hwmon/k10temp
@@ -0,0 +1,60 @@
+Kernel driver k10temp
+=====================
+
+Supported chips:
+* AMD Family 10h processors:
+  Socket F: Quad-Core/Six-Core/Embedded Opteron
+  Socket AM2+: Opteron, Phenom (II) X3/X4
+  Socket AM3: Quad-Core Opteron, Athlon/Phenom II X2/X3/X4, Sempron II
+  Socket S1G3: Athlon II, Sempron, Turion II
+* AMD Family 11h processors:
+  Socket S1G2: Athlon (X2), Sempron (X2), Turion X2 (Ultra)
+
+  Prefix: 'k10temp'
+  Addresses scanned: PCI space
+  Datasheets:
+  BIOS and Kernel Developer's Guide (BKDG) For AMD Family 10h Processors:
+    http://support.amd.com/us/Processor_TechDocs/31116.pdf
+  BIOS and Kernel Developer's Guide (BKDG) for AMD Family 11h Processors:
+    http://support.amd.com/us/Processor_TechDocs/41256.pdf
+  Revision Guide for AMD Family 10h Processors:
+    http://support.amd.com/us/Processor_TechDocs/41322.pdf
+  Revision Guide for AMD Family 11h Processors:
+    http://support.amd.com/us/Processor_TechDocs/41788.pdf
+  AMD Family 11h Processor Power and Thermal Data Sheet for Notebooks:
+    http://support.amd.com/us/Processor_TechDocs/43373.pdf
+  AMD Family 10h Server and Workstation Processor Power and Thermal Data Sheet:
+    http://support.amd.com/us/Processor_TechDocs/43374.pdf
+  AMD Family 10h Desktop Processor Power and Thermal Data Sheet:
+    http://support.amd.com/us/Processor_TechDocs/43375.pdf
+
+Author: Clemens Ladisch <clemens@ladisch.de>
+
+Description
+-----------
+
+This driver permits reading of the internal temperature sensor of AMD
+Family 10h and 11h processors.
+
+All these processors have a sensor, but on older revisions of Family 10h
+processors, the sensor may return inconsistent values (erratum 319). The
+driver will refuse to load on these revisions unless you specify the
+"force=1" module parameter.
+
+There is one temperature measurement value, available as temp1_input in
+sysfs. It is measured in degrees Celsius with a resolution of 1/8th degree.
+Please note that it is defined as a relative value; to quote the AMD manual:
+
+  Tctl is the processor temperature control value, used by the platform to
+  control cooling systems. Tctl is a non-physical temperature on an
+  arbitrary scale measured in degrees. It does _not_ represent an actual
+  physical temperature like die or case temperature. Instead, it specifies
+  the processor temperature relative to the point at which the system must
+  supply the maximum cooling for the processor's specified maximum case
+  temperature and maximum thermal power dissipation.
+
+The maximum value for Tctl is available in the file temp1_max.
+
+If the BIOS has enabled hardware temperature control, the threshold at
+which the processor will throttle itself to avoid damage is available in
+temp1_crit and temp1_crit_hyst.
diff -puN drivers/hwmon/Kconfig~k10temp-temperature-sensor-driver-for-amd-family-10h-11h-cpus drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~k10temp-temperature-sensor-driver-for-amd-family-10h-11h-cpus
+++ a/drivers/hwmon/Kconfig
@@ -226,6 +226,18 @@ config SENSORS_K8TEMP
 	  This driver can also be built as a module.  If so, the module
 	  will be called k8temp.
 
+config SENSORS_K10TEMP
+	tristate "AMD Phenom/Sempron/Turion/Opteron temperature sensor"
+	depends on X86 && PCI
+	help
+	  If you say yes here you get support for the temperature
+	  sensor(s) inside your CPU. Supported are later revisions of
+	  the AMD Family 10h and all revisions of the AMD Family 11h
+	  microarchitectures.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called k10temp.
+
 config SENSORS_AMS
 	tristate "Apple Motion Sensor driver"
 	depends on PPC_PMAC && !PPC64 && INPUT && ((ADB_PMU && I2C = y) || (ADB_PMU && !I2C) || I2C) && EXPERIMENTAL
diff -puN drivers/hwmon/Makefile~k10temp-temperature-sensor-driver-for-amd-family-10h-11h-cpus drivers/hwmon/Makefile
--- a/drivers/hwmon/Makefile~k10temp-temperature-sensor-driver-for-amd-family-10h-11h-cpus
+++ a/drivers/hwmon/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_SENSORS_IBMAEM)	+= ibmaem.o
 obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
 obj-$(CONFIG_SENSORS_IT87)	+= it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
+obj-$(CONFIG_SENSORS_K10TEMP)	+= k10temp.o
 obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o hp_accel.o
 obj-$(CONFIG_SENSORS_LIS3_SPI)	+= lis3lv02d.o lis3lv02d_spi.o
 obj-$(CONFIG_SENSORS_LIS3_I2C)	+= lis3lv02d.o lis3lv02d_i2c.o
diff -puN /dev/null drivers/hwmon/k10temp.c
--- /dev/null
+++ a/drivers/hwmon/k10temp.c
@@ -0,0 +1,197 @@
+/*
+ * k10temp.c - AMD Family 10h/11h processor hardware monitoring
+ *
+ * Copyright (c) 2009 Clemens Ladisch <clemens@ladisch.de>
+ *
+ *
+ * This driver is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This driver is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this driver; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/err.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <asm/processor.h>
+
+MODULE_DESCRIPTION("AMD Family 10h/11h CPU core temperature monitor");
+MODULE_AUTHOR("Clemens Ladisch <clemens@ladisch.de>");
+MODULE_LICENSE("GPL");
+
+static bool force;
+module_param(force, bool, 0444);
+MODULE_PARM_DESC(force, "force loading on processors with erratum 319");
+
+#define REG_HARDWARE_THERMAL_CONTROL	0x64
+#define  HTC_ENABLE			0x00000001
+
+#define REG_REPORTED_TEMPERATURE	0xa4
+
+#define REG_NORTHBRIDGE_CAPABILITIES	0xe8
+#define  NB_CAP_HTC			0x00000400
+
+static ssize_t show_temp(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	u32 regval;
+
+	pci_read_config_dword(to_pci_dev(dev),
+			      REG_REPORTED_TEMPERATURE, &regval);
+	return sprintf(buf, "%u\n", (regval >> 21) * 125);
+}
+
+static ssize_t show_temp_max(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", 70 * 1000);
+}
+
+static ssize_t show_temp_crit(struct device *dev,
+			      struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	int show_hyst = attr->index;
+	u32 regval;
+	int value;
+
+	pci_read_config_dword(to_pci_dev(dev),
+			      REG_HARDWARE_THERMAL_CONTROL, &regval);
+	value = ((regval >> 16) & 0x7f) * 500 + 52000;
+	if (show_hyst)
+		value -= ((regval >> 24) & 0xf) * 500;
+	return sprintf(buf, "%d\n", value);
+}
+
+static ssize_t show_name(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "k10temp\n");
+}
+
+static DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL);
+static DEVICE_ATTR(temp1_max, S_IRUGO, show_temp_max, NULL);
+static SENSOR_DEVICE_ATTR(temp1_crit, S_IRUGO, show_temp_crit, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_crit_hyst, S_IRUGO, show_temp_crit, NULL, 1);
+static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
+
+static bool __devinit has_erratum_319(void)
+{
+	/*
+	 * Erratum 319: The thermal sensor of older Family 10h processors
+	 *              (B steppings) may be unreliable.
+	 */
+	return boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model <= 2;
+}
+
+static int __devinit k10temp_probe(struct pci_dev *pdev,
+				   const struct pci_device_id *id)
+{
+	struct device *hwmon_dev;
+	u32 reg_caps, reg_htc;
+	int err;
+
+	if (has_erratum_319() && !force) {
+		dev_err(&pdev->dev,
+			"unreliable CPU thermal sensor; monitoring disabled\n");
+		err = -ENODEV;
+		goto exit;
+	}
+
+	err = device_create_file(&pdev->dev, &dev_attr_temp1_input);
+	if (err)
+		goto exit;
+	err = device_create_file(&pdev->dev, &dev_attr_temp1_max);
+	if (err)
+		goto exit_remove;
+
+	pci_read_config_dword(pdev, REG_NORTHBRIDGE_CAPABILITIES, &reg_caps);
+	pci_read_config_dword(pdev, REG_HARDWARE_THERMAL_CONTROL, &reg_htc);
+	if ((reg_caps & NB_CAP_HTC) && (reg_htc & HTC_ENABLE)) {
+		err = device_create_file(&pdev->dev,
+				&sensor_dev_attr_temp1_crit.dev_attr);
+		if (err)
+			goto exit_remove;
+		err = device_create_file(&pdev->dev,
+				&sensor_dev_attr_temp1_crit_hyst.dev_attr);
+		if (err)
+			goto exit_remove;
+	}
+
+	err = device_create_file(&pdev->dev, &dev_attr_name);
+	if (err)
+		goto exit_remove;
+
+	hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(hwmon_dev)) {
+		err = PTR_ERR(hwmon_dev);
+		goto exit_remove;
+	}
+	dev_set_drvdata(&pdev->dev, hwmon_dev);
+
+	if (has_erratum_319() && force)
+		dev_warn(&pdev->dev,
+			 "unreliable CPU thermal sensor; check erratum 319\n");
+	return 0;
+
+exit_remove:
+	device_remove_file(&pdev->dev, &dev_attr_name);
+	device_remove_file(&pdev->dev, &dev_attr_temp1_input);
+	device_remove_file(&pdev->dev, &dev_attr_temp1_max);
+	device_remove_file(&pdev->dev,
+			   &sensor_dev_attr_temp1_crit.dev_attr);
+	device_remove_file(&pdev->dev,
+			   &sensor_dev_attr_temp1_crit_hyst.dev_attr);
+exit:
+	return err;
+}
+
+static void __devexit k10temp_remove(struct pci_dev *pdev)
+{
+	hwmon_device_unregister(dev_get_drvdata(&pdev->dev));
+	device_remove_file(&pdev->dev, &dev_attr_name);
+	device_remove_file(&pdev->dev, &dev_attr_temp1_input);
+	device_remove_file(&pdev->dev, &dev_attr_temp1_max);
+	device_remove_file(&pdev->dev,
+			   &sensor_dev_attr_temp1_crit.dev_attr);
+	device_remove_file(&pdev->dev,
+			   &sensor_dev_attr_temp1_crit_hyst.dev_attr);
+	dev_set_drvdata(&pdev->dev, NULL);
+}
+
+static struct pci_device_id k10temp_id_table[] = {
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
+	{}
+};
+MODULE_DEVICE_TABLE(pci, k10temp_id_table);
+
+static struct pci_driver k10temp_driver = {
+	.name = "k10temp",
+	.id_table = k10temp_id_table,
+	.probe = k10temp_probe,
+	.remove = __devexit_p(k10temp_remove),
+};
+
+static int __init k10temp_init(void)
+{
+	return pci_register_driver(&k10temp_driver);
+}
+
+static void __exit k10temp_exit(void)
+{
+	pci_unregister_driver(&k10temp_driver);
+}
+
+module_init(k10temp_init)
+module_exit(k10temp_exit)
_

Patches currently in -mm which might be from clemens@ladisch.de are

linux-next.patch
emi62-fix-crash-when-trying-to-load-emi-62-firmware.patch
k10temp-temperature-sensor-driver-for-amd-family-10h-11h-cpus.patch
vt-make-the-default-cursor-shape-configurable.patch


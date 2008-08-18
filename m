From: akpm@linux-foundation.org
Subject: - ibmaem-dont-query-the-entire-sensor-repository-when-reading-energy-meter.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:11 -0700
Message-ID: <200808181940.m7IJeB2I008430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763155AbYHRTqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:46:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ibmaem: don't query the entire sensor repository when reading energy meter
has been removed from the -mm tree.  Its filename was
     ibmaem-dont-query-the-entire-sensor-repository-when-reading-energy-meter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibmaem: don't query the entire sensor repository when reading energy meter
From: "Darrick J. Wong" <djwong@us.ibm.com>

Currently, all sensors are read when the energy meter is queried via
sysfs.  This introduces a considerable amount of delay and variation in
the sysfs reading, which is not desirable when trying to profile energy
use.  Therefore, read only the energy meters when a sysfs query comes in
for them, and don't cache the results so that we always get the latest
reading.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/ibmaem.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/hwmon/ibmaem.c~ibmaem-dont-query-the-entire-sensor-repository-when-reading-energy-meter drivers/hwmon/ibmaem.c
--- a/drivers/hwmon/ibmaem.c~ibmaem-dont-query-the-entire-sensor-repository-when-reading-energy-meter
+++ a/drivers/hwmon/ibmaem.c
@@ -463,12 +463,18 @@ static int aem_read_sensor(struct aem_da
 }
 
 /* Update AEM energy registers */
+static void update_aem_energy_one(struct aem_data *data, int which)
+{
+	aem_read_sensor(data, AEM_ENERGY_ELEMENT, which,
+			&data->energy[which], 8);
+}
+
 static void update_aem_energy(struct aem_data *data)
 {
-	aem_read_sensor(data, AEM_ENERGY_ELEMENT, 0, &data->energy[0], 8);
+	update_aem_energy_one(data, 0);
 	if (data->ver_major < 2)
 		return;
-	aem_read_sensor(data, AEM_ENERGY_ELEMENT, 1, &data->energy[1], 8);
+	update_aem_energy_one(data, 1);
 }
 
 /* Update all AEM1 sensors */
@@ -850,7 +856,7 @@ static ssize_t aem_show_power(struct dev
 	struct timespec b, a;
 
 	mutex_lock(&data->lock);
-	update_aem_energy(data);
+	update_aem_energy_one(data, attr->index);
 	getnstimeofday(&b);
 	before = data->energy[attr->index];
 
@@ -862,7 +868,7 @@ static ssize_t aem_show_power(struct dev
 		return 0;
 	}
 
-	update_aem_energy(data);
+	update_aem_energy_one(data, attr->index);
 	getnstimeofday(&a);
 	after = data->energy[attr->index];
 	mutex_unlock(&data->lock);
@@ -881,7 +887,9 @@ static ssize_t aem_show_energy(struct de
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct aem_data *a = dev_get_drvdata(dev);
-	a->update(a);
+	mutex_lock(&a->lock);
+	update_aem_energy_one(a, attr->index);
+	mutex_unlock(&a->lock);
 
 	return sprintf(buf, "%llu\n",
 			(unsigned long long)a->energy[attr->index] * 1000);
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch


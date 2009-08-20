From: akpm@linux-foundation.org
Subject: [failures] hwmon-enhance-the-sysfs-api-for-power-meters.patch removed from -mm tree
Date: Thu, 20 Aug 2009 16:48:06 -0700
Message-ID: <200908202348.n7KNm7io004460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932119AbZHTXtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 19:49:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, lenb@kernel.org, pavel@ucw.cz, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     hwmon: enhance the sysfs API for power meters
has been removed from the -mm tree.  Its filename was
     hwmon-enhance-the-sysfs-api-for-power-meters.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: enhance the sysfs API for power meters
From: "Darrick J. Wong" <djwong@us.ibm.com>

Augment the documentation of the hwmon sysfs API to accomodate ACPI power
meters.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/sysfs-interface |   60 +++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff -puN Documentation/hwmon/sysfs-interface~hwmon-enhance-the-sysfs-api-for-power-meters Documentation/hwmon/sysfs-interface
--- a/Documentation/hwmon/sysfs-interface~hwmon-enhance-the-sysfs-api-for-power-meters
+++ a/Documentation/hwmon/sysfs-interface
@@ -353,10 +353,20 @@ power[1-*]_average		Average power use
 				Unit: microWatt
 				RO
 
-power[1-*]_average_interval	Power use averaging interval
+power[1-*]_average_interval	Power use averaging interval.  A poll
+				notification is sent to this file if the
+				hardware changes the averaging interval.
 				Unit: milliseconds
 				RW
 
+power[1-*]_average_interval_max	Maximum power use averaging interval
+				Unit: milliseconds
+				RO
+
+power[1-*]_average_interval_min	Minimum power use averaging interval
+				Unit: milliseconds
+				RO
+
 power[1-*]_average_highest	Historical average maximum power use
 				Unit: microWatt
 				RO
@@ -365,6 +375,18 @@ power[1-*]_average_lowest	Historical ave
 				Unit: microWatt
 				RO
 
+power[1-*]_average_max		A poll notification is sent to
+				power[1-*]_average when power use
+				rises above this value.
+				Unit: microWatt
+				RW
+
+power[1-*]_average_min		A poll notification is sent to
+				power[1-*]_average when power use
+				sinks below this value.
+				Unit: microWatt
+				RW
+
 power[1-*]_input		Instantaneous power use
 				Unit: microWatt
 				RO
@@ -381,6 +403,42 @@ power[1-*]_reset_history	Reset input_hig
 				average_highest and average_lowest.
 				WO
 
+power[1-*]_accuracy		Accuracy of the power meter.
+				Unit: Percent
+				RO
+
+power[1-*]_alarm		1 if the system is drawing more power than the
+				cap allows; 0 otherwise.  A poll notification is
+				sent to this file if the power use exceeds the
+				cap.  The action that is taken when this event
+				happens is undefined--it is possible that the
+				hardware will reduce performance to cut the
+				power use, but it is also possible that the
+				system designer expects the OS to try to
+				reduce power consumption.  Contact your
+				machine's vendor to find out which.
+				RO
+
+power[1-*]_cap			If power use rises above this limit, the
+				system should take action to reduce power use.
+				A poll notification is sent to this file if the
+				cap is changed by the hardware.
+				Unit: microWatt
+				RW
+
+power[1-*]_cap_hyst		Margin of hysteresis built around capping and
+				notification.
+				Unit: microWatt
+				RW
+
+power[1-*]_cap_max		Maximum cap that can be set.
+				Unit: microWatt
+				RO
+
+power[1-*]_cap_min		Minimum cap that can be set.
+				Unit: microWatt
+				RO
+
 **********
 * Energy *
 **********
_

Patches currently in -mm which might be from djwong@us.ibm.com are

hwmon-enhance-the-sysfs-api-for-power-meters.patch


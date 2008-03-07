From: akpm@linux-foundation.org
Subject: + regulator-sysfs-abi.patch added to -mm tree
Date: Fri, 07 Mar 2008 00:40:21 -0800
Message-ID: <200803070840.m278eLRK013455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757312AbYCGIlE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 03:41:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com, greg@kroah.com


The patch titled
     regulator: sysfs ABI
has been added to the -mm tree.  Its filename is
     regulator-sysfs-abi.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator: sysfs ABI
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

This patch adds a description of the regulator class sysfs ABI to the testing
directory.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-regulator |  187 ++++++++++++++
 1 file changed, 187 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-class-regulator
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-class-regulator
@@ -0,0 +1,187 @@
+What:		/sys/class/regulator/.../state
+Date:		March 2008
+KernelVersion:	2.6.25
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		state. This holds the regulator output state.
+
+		This will be one of the following strings:
+
+		'enabled'
+		'disabled'
+		'unknown'
+
+		'enabled' means the regulator output is ON and is supplying
+		power to the system.
+
+		'disabled' means the regulator output is OFF and is not
+		supplying power to the system..
+
+		'unknown' means software cannot determine the state.
+
+		NOTE: this field can be used in conjunction with microvolts
+		and microamps to determine regulator output levels.
+
+
+What:		/sys/class/regulator/.../type
+Date:		March 2008
+KernelVersion:	2.6.25
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		type. This holds the regulator type.
+
+		This will be one of the following strings:
+
+		'voltage'
+		'current'
+		'unknown'
+
+		'voltage' means the regulator output voltage can be controlled
+		by software.
+
+		'current' means the regulator output current limit can be
+		controlled by software.
+
+		'unknown' means software cannot control either voltage or
+		current limit.
+
+
+What:		/sys/class/regulator/.../microvolts
+Date:		March 2008
+KernelVersion:	2.6.25
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		microvolts. This holds the regulator output voltage setting
+		measured in microvolts (i.e. E-6 Volts).
+
+		NOTE: This value should not be used to determine the regulator
+		output voltage level as this value is the same regardless of
+		whether the regulator is enabled or disabled.
+
+
+What:		/sys/class/regulator/.../microamps
+Date:		March 2008
+KernelVersion:	2.6.25
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		microamps. This holds the regulator output current limit
+		setting measured in microamps (i.e. E-6 Amps).
+
+		NOTE: This value should not be used to determine the regulator
+		output current level as this value is the same regardless of
+		whether the regulator is enabled or disabled.
+
+
+What:		/sys/class/regulator/.../opmode
+Date:		March 2008
+KernelVersion:	2.6.25
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		opmode. This holds the regulator operating mode setting.
+
+		The opmode value can be one of the following strings:
+
+		'fast'
+		'normal'
+		'idle'
+		'standby'
+		'unknown'
+
+		The modes are described in include/linux/regulator/regulator.h
+
+		NOTE: This value should not be used to determine the regulator
+		output operating mode as this value is the same regardless of
+		whether the regulator is enabled or disabled.
+
+
+What:		/sys/class/regulator/.../min_microvolts
+Date:		March 2008
+KernelVersion:	2.6.25
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		min_microvolts. This holds the minimum safe working regulator
+		output voltage setting for this domain measured in microvolts.
+
+		NOTE: this will return the string 'constraint not defined' if
+		the power domain has no min microvolts constraint defined by
+		platform code.
+
+
+What:		/sys/class/regulator/.../max_microvolts
+Date:		March 2008
+KernelVersion:	2.6.25
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		max_microvolts. This holds the maximum safe working regulator
+		output voltage setting for this domain measured in microvolts.
+
+		NOTE: this will return the string 'constraint not defined' if
+		the power domain has no max microvolts constraint defined by
+		platform code.
+
+
+What:		/sys/class/regulator/.../min_microamps
+Date:		March 2008
+KernelVersion:	2.6.25
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		min_microamps. This holds the minimum safe working regulator
+		output current limit setting for this domain measured in
+		microamps.
+
+		NOTE: this will return the string 'constraint not defined' if
+		the power domain has no min microamps constraint defined by
+		platform code.
+
+
+What:		/sys/class/regulator/.../max_microamps
+Date:		March 2008
+KernelVersion:	2.6.25
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		max_microamps. This holds the maximum safe working regulator
+		output current limit setting for this domain measured in
+		microamps.
+
+		NOTE: this will return the string 'constraint not defined' if
+		the power domain has no max microamps constraint defined by
+		platform code.
+
+
+What:		/sys/class/regulator/.../num_users
+Date:		March 2008
+KernelVersion:	2.6.25
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		num_users. This holds the number of consumer devices that
+		have called regulator_enable() on this regulator.
+
+
+What:		/sys/class/regulator/.../requested_microamps
+Date:		March 2008
+KernelVersion:	2.6.25
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		requested_microamps. This holds the total requested load
+		current in microamps for this regulator from all its consumer
+		devices.
+
+
+What:		/sys/class/regulator/.../parent
+Date:		March 2008
+KernelVersion:	2.6.25
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Some regulator directories will contain a link called parent.
+		This points to the parent or supply regulator if one exists.
_

Patches currently in -mm which might be from lg@opensource.wolfsonmicro.com are

regulator-consumer-interface.patch
regulator-regulator-driver-interface.patch
regulator-platform-interface.patch
regulator-framework-core.patch
regulator-sysfs-abi.patch
regulator-kbuild.patch
regulator-maintainers.patch


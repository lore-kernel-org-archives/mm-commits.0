From: akpm@linux-foundation.org
Subject: + regulator-documentation-abi.patch added to -mm tree
Date: Fri, 02 May 2008 16:58:00 -0700
Message-ID: <200805022358.m42Nw01m021846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764833AbYEBX6Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 19:58:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, greg@kroah.com


The patch titled
     regulator: documentation - ABI
has been added to the -mm tree.  Its filename is
     regulator-documentation-abi.patch

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
Subject: regulator: documentation - ABI
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

This adds documentation describing the sysfs ABI used by the regulator
framework.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-regulator |  187 ++++++++++++++
 1 file changed, 187 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-class-regulator
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-class-regulator
@@ -0,0 +1,187 @@
+What:		/sys/class/regulator/.../state
+Date:		April 2008
+KernelVersion:	2.6.26
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
+Date:		April 2008
+KernelVersion:	2.6.26
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
+Date:		April 2008
+KernelVersion:	2.6.26
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
+Date:		April 2008
+KernelVersion:	2.6.26
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
+Date:		April 2008
+KernelVersion:	2.6.26
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
+Date:		April 2008
+KernelVersion:	2.6.26
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
+Date:		April 2008
+KernelVersion:	2.6.26
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
+Date:		April 2008
+KernelVersion:	2.6.26
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
+Date:		April 2008
+KernelVersion:	2.6.26
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
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		num_users. This holds the number of consumer devices that
+		have called regulator_enable() on this regulator.
+
+
+What:		/sys/class/regulator/.../requested_microamps
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		requested_microamps. This holds the total requested load
+		current in microamps for this regulator from all its consumer
+		devices.
+
+
+What:		/sys/class/regulator/.../parent
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Some regulator directories will contain a link called parent.
+		This points to the parent or supply regulator if one exists.
_

Patches currently in -mm which might be from lg@opensource.wolfsonmicro.com are

regulator-consumer-device-interface.patch
regulator-regulator-driver-interface.patch
regulator-machine-driver-interface.patch
regulator-fixed-regulator-interface.patch
regulator-regulator-framework-core.patch
regulator-add-support-for-fixed-regulators.patch
regulator-regulator-test-harness.patch
regulator-core-kbuild-files.patch
regulator-documentation-overview.patch
regulator-documentation-consumer-interface.patch
regulator-documentation-regulator-driver.patch
regulator-documentation-machine.patch
regulator-documentation-abi.patch


From: akpm@linux-foundation.org
Subject: - acpi-add-acpi_pm_device_sleep_state-helper-routine.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:57 -0700
Message-ID: <200707230935.l6N9ZvZ2016530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36025 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758378AbXGWJpi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, david-b@pacbell.net, lenb@kernel.org, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     ACPI: Add acpi_pm_device_sleep_state helper routine
has been removed from the -mm tree.  Its filename was
     acpi-add-acpi_pm_device_sleep_state-helper-routine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: Add acpi_pm_device_sleep_state helper routine
From: Shaohua Li <shaohua.li@intel.com>, Rafael J. Wysocki <rjw@sisk.pl>

Based on the David Brownell's patch at
http://marc.info/?l=linux-acpi&m=117873972806360&w=2

Add a helper routine returning the lowest power (highest number) ACPI device
power state that given device can be in while the system is in the sleep state
indicated by acpi_target_sleep_state .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |   75 ++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h   |    2 
 2 files changed, 77 insertions(+)

diff -puN drivers/acpi/sleep/main.c~acpi-add-acpi_pm_device_sleep_state-helper-routine drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-add-acpi_pm_device_sleep_state-helper-routine
+++ a/drivers/acpi/sleep/main.c
@@ -255,6 +255,81 @@ static struct hibernation_ops acpi_hiber
 };
 #endif				/* CONFIG_SOFTWARE_SUSPEND */
 
+/**
+ *	acpi_pm_device_sleep_state - return preferred power state of ACPI device
+ *		in the system sleep state given by %acpi_target_sleep_state
+ *	@dev: device to examine
+ *	@wake: if set, the device should be able to wake up the system
+ *	@d_min_p: used to store the upper limit of allowed states range
+ *	Return value: preferred power state of the device on success, -ENODEV on
+ *		failure (ie. if there's no 'struct acpi_device' for @dev)
+ *
+ *	Find the lowest power (highest number) ACPI device power state that
+ *	device @dev can be in while the system is in the sleep state represented
+ *	by %acpi_target_sleep_state.  If @wake is nonzero, the device should be
+ *	able to wake up the system from this sleep state.  If @d_min_p is set,
+ *	the highest power (lowest number) device power state of @dev allowed
+ *	in this system sleep state is stored at the location pointed to by it.
+ *
+ *	The caller must ensure that @dev is valid before using this function.
+ *	The caller is also responsible for figuring out if the device is
+ *	supposed to be able to wake up the system and passing this information
+ *	via @wake.
+ */
+
+int acpi_pm_device_sleep_state(struct device *dev, int wake, int *d_min_p)
+{
+	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
+	struct acpi_device *adev;
+	char acpi_method[] = "_SxD";
+	unsigned long d_min, d_max;
+
+	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
+		printk(KERN_ERR "ACPI handle has no context!\n");
+		return -ENODEV;
+	}
+
+	acpi_method[2] = '0' + acpi_target_sleep_state;
+	/*
+	 * If the sleep state is S0, we will return D3, but if the device has
+	 * _S0W, we will use the value from _S0W
+	 */
+	d_min = ACPI_STATE_D0;
+	d_max = ACPI_STATE_D3;
+
+	/*
+	 * If present, _SxD methods return the minimum D-state (highest power
+	 * state) we can use for the corresponding S-states.  Otherwise, the
+	 * minimum D-state is D0 (ACPI 3.x).
+	 *
+	 * NOTE: We rely on acpi_evaluate_integer() not clobbering the integer
+	 * provided -- that's our fault recovery, we ignore retval.
+	 */
+	if (acpi_target_sleep_state > ACPI_STATE_S0)
+		acpi_evaluate_integer(handle, acpi_method, NULL, &d_min);
+
+	/*
+	 * If _PRW says we can wake up the system from the target sleep state,
+	 * the D-state returned by _SxD is sufficient for that (we assume a
+	 * wakeup-aware driver if wake is set).  Still, if _SxW exists
+	 * (ACPI 3.x), it should return the maximum (lowest power) D-state that
+	 * can wake the system.  _S0W may be valid, too.
+	 */
+	if (acpi_target_sleep_state == ACPI_STATE_S0 ||
+	    (wake && adev->wakeup.state.enabled &&
+	     adev->wakeup.sleep_state <= acpi_target_sleep_state)) {
+		acpi_method[3] = 'W';
+		acpi_evaluate_integer(handle, acpi_method, NULL, &d_max);
+		/* Sanity check */
+		if (d_max < d_min)
+			d_min = d_max;
+	}
+
+	if (d_min_p)
+		*d_min_p = d_min;
+	return d_max;
+}
+
 /*
  * Toshiba fails to preserve interrupts over S1, reinitialization
  * of 8259 is needed after S1 resume.
diff -puN include/acpi/acpi_bus.h~acpi-add-acpi_pm_device_sleep_state-helper-routine include/acpi/acpi_bus.h
--- a/include/acpi/acpi_bus.h~acpi-add-acpi_pm_device_sleep_state-helper-routine
+++ a/include/acpi/acpi_bus.h
@@ -365,6 +365,8 @@ acpi_handle acpi_get_child(acpi_handle, 
 acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
 #define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)((dev)->archdata.acpi_handle))
 
+int acpi_pm_device_sleep_state(struct device *, int, int *);
+
 #endif				/* CONFIG_ACPI */
 
 #endif /*__ACPI_BUS_H__*/
_

Patches currently in -mm which might be from shaohua.li@intel.com are

git-acpi.patch
git-kvm.patch

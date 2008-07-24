From: akpm@linux-foundation.org
Subject: - pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:25:21 -0700
Message-ID: <200807242325.m6ONPLgr010873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754703AbYGXXZj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     pm: remove obsolete piece of PM documentation
has been removed from the -mm tree.  Its filename was
     pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: remove obsolete piece of PM documentation
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove some obsolete PM documentation.

The majority of contents of Documentation/power/pm.txt are
outdated.  Remove the outdated parts of this file and move the rest
to Documentation/power/apm-acpi.txt .  Update the index in
Documentation/power/ as appropriate.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/00-INDEX     |    4 
 Documentation/power/apm-acpi.txt |   32 +++
 Documentation/power/pm.txt       |  257 -----------------------------
 3 files changed, 34 insertions(+), 259 deletions(-)

diff -puN Documentation/power/00-INDEX~pm-remove-obsolete-piece-of-pm-documentation-rev-2 Documentation/power/00-INDEX
--- a/Documentation/power/00-INDEX~pm-remove-obsolete-piece-of-pm-documentation-rev-2
+++ a/Documentation/power/00-INDEX
@@ -1,5 +1,7 @@
 00-INDEX
 	- This file
+apm-acpi.txt
+	- basic info about the APM and ACPI support.
 basic-pm-debugging.txt
 	- Debugging suspend and resume
 devices.txt
@@ -14,8 +16,6 @@ notifiers.txt
 	- Registering suspend notifiers in device drivers
 pci.txt
 	- How the PCI Subsystem Does Power Management
-pm.txt
-	- info on Linux power management support.
 pm_qos_interface.txt
 	- info on Linux PM Quality of Service interface
 power_supply_class.txt
diff -puN /dev/null Documentation/power/apm-acpi.txt
--- /dev/null
+++ a/Documentation/power/apm-acpi.txt
@@ -0,0 +1,32 @@
+APM or ACPI?
+------------
+If you have a relatively recent x86 mobile, desktop, or server system,
+odds are it supports either Advanced Power Management (APM) or
+Advanced Configuration and Power Interface (ACPI).  ACPI is the newer
+of the two technologies and puts power management in the hands of the
+operating system, allowing for more intelligent power management than
+is possible with BIOS controlled APM.
+
+The best way to determine which, if either, your system supports is to
+build a kernel with both ACPI and APM enabled (as of 2.3.x ACPI is
+enabled by default).  If a working ACPI implementation is found, the
+ACPI driver will override and disable APM, otherwise the APM driver
+will be used.
+
+No, sorry, you cannot have both ACPI and APM enabled and running at
+once.  Some people with broken ACPI or broken APM implementations
+would like to use both to get a full set of working features, but you
+simply cannot mix and match the two.  Only one power management
+interface can be in control of the machine at once.  Think about it..
+
+User-space Daemons
+------------------
+Both APM and ACPI rely on user-space daemons, apmd and acpid
+respectively, to be completely functional.  Obtain both of these
+daemons from your Linux distribution or from the Internet (see below)
+and be sure that they are started sometime in the system boot process.
+Go ahead and start both.  If ACPI or APM is not available on your
+system the associated daemon will exit gracefully.
+
+  apmd:   http://worldvisions.ca/~apenwarr/apmd/
+  acpid:  http://acpid.sf.net/
diff -puN Documentation/power/pm.txt~pm-remove-obsolete-piece-of-pm-documentation-rev-2 /dev/null
--- a/Documentation/power/pm.txt
+++ /dev/null
@@ -1,257 +0,0 @@
-               Linux Power Management Support
-
-This document briefly describes how to use power management with your
-Linux system and how to add power management support to Linux drivers.
-
-APM or ACPI?
-------------
-If you have a relatively recent x86 mobile, desktop, or server system,
-odds are it supports either Advanced Power Management (APM) or
-Advanced Configuration and Power Interface (ACPI).  ACPI is the newer
-of the two technologies and puts power management in the hands of the
-operating system, allowing for more intelligent power management than
-is possible with BIOS controlled APM.
-
-The best way to determine which, if either, your system supports is to
-build a kernel with both ACPI and APM enabled (as of 2.3.x ACPI is
-enabled by default).  If a working ACPI implementation is found, the
-ACPI driver will override and disable APM, otherwise the APM driver
-will be used.
-
-No, sorry, you cannot have both ACPI and APM enabled and running at
-once.  Some people with broken ACPI or broken APM implementations
-would like to use both to get a full set of working features, but you
-simply cannot mix and match the two.  Only one power management
-interface can be in control of the machine at once.  Think about it..
-
-User-space Daemons
-------------------
-Both APM and ACPI rely on user-space daemons, apmd and acpid
-respectively, to be completely functional.  Obtain both of these
-daemons from your Linux distribution or from the Internet (see below)
-and be sure that they are started sometime in the system boot process.
-Go ahead and start both.  If ACPI or APM is not available on your
-system the associated daemon will exit gracefully.
-
-  apmd:   http://worldvisions.ca/~apenwarr/apmd/
-  acpid:  http://acpid.sf.net/
-
-Driver Interface -- OBSOLETE, DO NOT USE!
-----------------*************************
-
-Note: pm_register(), pm_access(), pm_dev_idle() and friends are
-obsolete. Please do not use them. Instead you should properly hook
-your driver into the driver model, and use its suspend()/resume()
-callbacks to do this kind of stuff.
-
-If you are writing a new driver or maintaining an old driver, it
-should include power management support.  Without power management
-support, a single driver may prevent a system with power management
-capabilities from ever being able to suspend (safely).
-
-Overview:
-1) Register each instance of a device with "pm_register"
-2) Call "pm_access" before accessing the hardware.
-   (this will ensure that the hardware is awake and ready)
-3) Your "pm_callback" is called before going into a
-   suspend state (ACPI D1-D3) or after resuming (ACPI D0)
-   from a suspend.
-4) Call "pm_dev_idle" when the device is not being used
-   (optional but will improve device idle detection)
-5) When unloaded, unregister the device with "pm_unregister"
-
-/*
- * Description: Register a device with the power-management subsystem
- *
- * Parameters:
- *   type - device type (PCI device, system device, ...)
- *   id - instance number or unique identifier
- *   cback - request handler callback (suspend, resume, ...)
- *
- * Returns: Registered PM device or NULL on error
- *
- * Examples:
- *   dev = pm_register(PM_SYS_DEV, PM_SYS_VGA, vga_callback);
- *
- *   struct pci_dev *pci_dev = pci_find_dev(...);
- *   dev = pm_register(PM_PCI_DEV, PM_PCI_ID(pci_dev), callback);
- */
-struct pm_dev *pm_register(pm_dev_t type, unsigned long id, pm_callback cback);
-
-/*
- * Description: Unregister a device with the power management subsystem
- *
- * Parameters:
- *   dev - PM device previously returned from pm_register
- */
-void pm_unregister(struct pm_dev *dev);
-
-/*
- * Description: Unregister all devices with a matching callback function
- *
- * Parameters:
- *   cback - previously registered request callback
- *
- * Notes: Provided for easier porting from old APM interface
- */
-void pm_unregister_all(pm_callback cback);
-
-/*
- * Power management request callback
- *
- * Parameters:
- *   dev - PM device previously returned from pm_register
- *   rqst - request type
- *   data - data, if any, associated with the request
- *
- * Returns: 0 if the request is successful
- *          EINVAL if the request is not supported
- *          EBUSY if the device is now busy and cannot handle the request
- *          ENOMEM if the device was unable to handle the request due to memory
- *
- * Details: The device request callback will be called before the
- *          device/system enters a suspend state (ACPI D1-D3) or
- *          or after the device/system resumes from suspend (ACPI D0).
- *          For PM_SUSPEND, the ACPI D-state being entered is passed
- *          as the "data" argument to the callback.  The device
- *          driver should save (PM_SUSPEND) or restore (PM_RESUME)
- *          device context when the request callback is called.
- *
- *          Once a driver returns 0 (success) from a suspend
- *          request, it should not process any further requests or
- *          access the device hardware until a call to "pm_access" is made.
- */
-typedef int (*pm_callback)(struct pm_dev *dev, pm_request_t rqst, void *data);
-
-Driver Details
---------------
-This is just a quick Q&A as a stopgap until a real driver writers'
-power management guide is available.
-
-Q: When is a device suspended?
-
-Devices can be suspended based on direct user request (eg. laptop lid
-closes), system power policy (eg.  sleep after 30 minutes of console
-inactivity), or device power policy (eg. power down device after 5
-minutes of inactivity)
-
-Q: Must a driver honor a suspend request?
-
-No, a driver can return -EBUSY from a suspend request and this
-will stop the system from suspending.  When a suspend request
-fails, all suspended devices are resumed and the system continues
-to run.  Suspend can be retried at a later time.
-
-Q: Can the driver block suspend/resume requests?
-
-Yes, a driver can delay its return from a suspend or resume
-request until the device is ready to handle requests.  It
-is advantageous to return as quickly as possible from a
-request as suspend/resume are done serially.
-
-Q: What context is a suspend/resume initiated from?
-
-A suspend or resume is initiated from a kernel thread context.
-It is safe to block, allocate memory, initiate requests
-or anything else you can do within the kernel.
-
-Q: Will requests continue to arrive after a suspend?
-
-Possibly.  It is the driver's responsibility to queue(*),
-fail, or drop any requests that arrive after returning
-success to a suspend request.  It is important that the
-driver not access its device until after it receives
-a resume request as the device's bus may no longer
-be active.
-
-(*) If a driver queues requests for processing after
-    resume be aware that the device, network, etc.
-    might be in a different state than at suspend time.
-    It's probably better to drop requests unless
-    the driver is a storage device.
-
-Q: Do I have to manage bus-specific power management registers
-
-No.  It is the responsibility of the bus driver to manage
-PCI, USB, etc. power management registers.  The bus driver
-or the power management subsystem will also enable any
-wake-on functionality that the device has.
-
-Q: So, really, what do I need to do to support suspend/resume?
-
-You need to save any device context that would
-be lost if the device was powered off and then restore
-it at resume time.  When ACPI is active, there are
-three levels of device suspend states; D1, D2, and D3.
-(The suspend state is passed as the "data" argument
-to the device callback.)  With D3, the device is powered
-off and loses all context, D1 and D2 are shallower power
-states and require less device context to be saved.  To
-play it safe, just save everything at suspend and restore
-everything at resume.
-
-Q: Where do I store device context for suspend?
-
-Anywhere in memory, kmalloc a buffer or store it
-in the device descriptor.  You are guaranteed that the
-contents of memory will be restored and accessible
-before resume, even when the system suspends to disk.
-
-Q: What do I need to do for ACPI vs. APM vs. etc?
-
-Drivers need not be aware of the specific power management
-technology that is active.  They just need to be aware
-of when the overlying power management system requests
-that they suspend or resume.
-
-Q: What about device dependencies?
-
-When a driver registers a device, the power management
-subsystem uses the information provided to build a
-tree of device dependencies (eg. USB device X is on
-USB controller Y which is on PCI bus Z)  When power
-management wants to suspend a device, it first sends
-a suspend request to its driver, then the bus driver,
-and so on up to the system bus.  Device resumes
-proceed in the opposite direction.
-
-Q: Who do I contact for additional information about
-   enabling power management for my specific driver/device?
-
-ACPI Development mailing list: linux-acpi@vger.kernel.org
-
-System Interface -- OBSOLETE, DO NOT USE!
-----------------*************************
-If you are providing new power management support to Linux (ie.
-adding support for something like APM or ACPI), you should
-communicate with drivers through the existing generic power
-management interface.
-
-/*
- * Send a request to all devices
- *
- * Parameters:
- *   rqst - request type
- *   data - data, if any, associated with the request
- *
- * Returns: 0 if the request is successful
- *          See "pm_callback" return for errors
- *
- * Details: Walk list of registered devices and call pm_send
- *          for each until complete or an error is encountered.
- *          If an error is encountered for a suspend request,
- *          return all devices to the state they were in before
- *          the suspend request.
- */
-int pm_send_all(pm_request_t rqst, void *data);
-
-/*
- * Find a matching device
- *
- * Parameters:
- *   type - device type (PCI device, system device, or 0 to match all devices)
- *   from - previous match or NULL to start from the beginning
- *
- * Returns: Matching device or NULL if none found
- */
-struct pm_dev *pm_find(pm_dev_t type, struct pm_dev *from);
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
sky2-adapt-to-use-reworked-pci-pm-code.patch
tg3-adapt-tg3-to-use-reworked-pci-pm-code.patch
drivers-power-fix-platform-driver-hotplug-coldplug.patch
mfd-fix-platform-driver-hotplug-coldplug.patch
parport-fix-platform-driver-hotplug-coldplug.patch
kexec-jump.patch
kexec-jump-save-restore-device-state.patch
shrink_slab-handle-bad-shrinkers.patch


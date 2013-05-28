From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-documentation-update-for-enumeration-changes.patch removed from -mm tree
Date: Tue, 28 May 2013 12:36:36 -0700
Message-ID: <51a50744.fp8+PNH4GcmILg/T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab3E1Tgh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:36:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mporter@kernel.crashing.org, micha.nelissen@Prodrive.nl, leoli@freescale.com, galak@kernel.crashing.org, andre.van.herk@Prodrive.nl, alexandre.bounine@idt.com

Subject: [merged] rapidio-documentation-update-for-enumeration-changes.patch removed from -mm tree
To: alexandre.bounine@idt.com,andre.van.herk@Prodrive.nl,galak@kernel.crashing.org,leoli@freescale.com,micha.nelissen@Prodrive.nl,mporter@kernel.crashing.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:36 -0700


The patch titled
     Subject: rapidio: documentation update for enumeration changes
has been removed from the -mm tree.  Its filename was
     rapidio-documentation-update-for-enumeration-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: documentation update for enumeration changes

Update RapidIO documentation to reflect changes made to
enumeration/discovery build configuration and user space triggering
mechanism.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rapidio/rapidio.txt |  130 +++++++++++++++++++++++++---
 Documentation/rapidio/sysfs.txt   |   17 +++
 2 files changed, 135 insertions(+), 12 deletions(-)

diff -puN Documentation/rapidio/rapidio.txt~rapidio-documentation-update-for-enumeration-changes Documentation/rapidio/rapidio.txt
--- a/Documentation/rapidio/rapidio.txt~rapidio-documentation-update-for-enumeration-changes
+++ a/Documentation/rapidio/rapidio.txt
@@ -79,20 +79,63 @@ master port that is used to communicate
 In order to initialize the RapidIO subsystem, a platform must initialize and
 register at least one master port within the RapidIO network. To register mport
 within the subsystem controller driver initialization code calls function
-rio_register_mport() for each available master port. After all active master
-ports are registered with a RapidIO subsystem, the rio_init_mports() routine
-is called to perform enumeration and discovery.
-
-In the current PowerPC-based implementation a subsys_initcall() is specified to
-perform controller initialization and mport registration. At the end it directly
-calls rio_init_mports() to execute RapidIO enumeration and discovery.
+rio_register_mport() for each available master port.
+
+RapidIO subsystem uses subsys_initcall() or device_initcall() to perform
+controller initialization (depending on controller device type).
+
+After all active master ports are registered with a RapidIO subsystem,
+an enumeration and/or discovery routine may be called automatically or
+by user-space command.
 
 4. Enumeration and Discovery
 ----------------------------
 
-When rio_init_mports() is called it scans a list of registered master ports and
-calls an enumeration or discovery routine depending on the configured role of a
-master port: host or agent.
+4.1 Overview
+------------
+
+RapidIO subsystem configuration options allow users to specify enumeration and
+discovery methods as statically linked components or loadable modules.
+An enumeration/discovery method implementation and available input parameters
+define how any given method can be attached to available RapidIO mports:
+simply to all available mports OR individually to the specified mport device.
+
+Depending on selected enumeration/discovery build configuration, there are
+several methods to initiate an enumeration and/or discovery process:
+
+  (a) Statically linked enumeration and discovery process can be started
+  automatically during kernel initialization time using corresponding module
+  parameters. This was the original method used since introduction of RapidIO
+  subsystem. Now this method relies on enumerator module parameter which is
+  'rio-scan.scan' for existing basic enumeration/discovery method.
+  When automatic start of enumeration/discovery is used a user has to ensure
+  that all discovering endpoints are started before the enumerating endpoint
+  and are waiting for enumeration to be completed.
+  Configuration option CONFIG_RAPIDIO_DISC_TIMEOUT defines time that discovering
+  endpoint waits for enumeration to be completed. If the specified timeout
+  expires the discovery process is terminated without obtaining RapidIO network
+  information. NOTE: a timed out discovery process may be restarted later using
+  a user-space command as it is described later if the given endpoint was
+  enumerated successfully.
+
+  (b) Statically linked enumeration and discovery process can be started by
+  a command from user space. This initiation method provides more flexibility
+  for a system startup compared to the option (a) above. After all participating
+  endpoints have been successfully booted, an enumeration process shall be
+  started first by issuing a user-space command, after an enumeration is
+  completed a discovery process can be started on all remaining endpoints.
+
+  (c) Modular enumeration and discovery process can be started by a command from
+  user space. After an enumeration/discovery module is loaded, a network scan
+  process can be started by issuing a user-space command.
+  Similar to the option (b) above, an enumerator has to be started first.
+
+  (d) Modular enumeration and discovery process can be started by a module
+  initialization routine. In this case an enumerating module shall be loaded
+  first.
+
+When a network scan process is started it calls an enumeration or discovery
+routine depending on the configured role of a master port: host or agent.
 
 Enumeration is performed by a master port if it is configured as a host port by
 assigning a host device ID greater than or equal to zero. A host device ID is
@@ -104,8 +147,58 @@ for it.
 The enumeration and discovery routines use RapidIO maintenance transactions
 to access the configuration space of devices.
 
-The enumeration process is implemented according to the enumeration algorithm
-outlined in the RapidIO Interconnect Specification: Annex I [1].
+4.2 Automatic Start of Enumeration and Discovery
+------------------------------------------------
+
+Automatic enumeration/discovery start method is applicable only to built-in
+enumeration/discovery RapidIO configuration selection. To enable automatic
+enumeration/discovery start by existing basic enumerator method set use boot
+command line parameter "rio-scan.scan=1".
+
+This configuration requires synchronized start of all RapidIO endpoints that
+form a network which will be enumerated/discovered. Discovering endpoints have
+to be started before an enumeration starts to ensure that all RapidIO
+controllers have been initialized and are ready to be discovered. Configuration
+parameter CONFIG_RAPIDIO_DISC_TIMEOUT defines time (in seconds) which
+a discovering endpoint will wait for enumeration to be completed.
+
+When automatic enumeration/discovery start is selected, basic method's
+initialization routine calls rio_init_mports() to perform enumeration or
+discovery for all known mport devices.
+
+Depending on RapidIO network size and configuration this automatic
+enumeration/discovery start method may be difficult to use due to the
+requirement for synchronized start of all endpoints.
+
+4.3 User-space Start of Enumeration and Discovery
+-------------------------------------------------
+
+User-space start of enumeration and discovery can be used with built-in and
+modular build configurations. For user-space controlled start RapidIO subsystem
+creates the sysfs write-only attribute file '/sys/bus/rapidio/scan'. To initiate
+an enumeration or discovery process on specific mport device, a user needs to
+write mport_ID (not RapidIO destination ID) into that file. The mport_ID is a
+sequential number (0 ... RIO_MAX_MPORTS) assigned during mport device
+registration. For example for machine with single RapidIO controller, mport_ID
+for that controller always will be 0.
+
+To initiate RapidIO enumeration/discovery on all available mports a user may
+write '-1' (or RIO_MPORT_ANY) into the scan attribute file.
+
+4.4 Basic Enumeration Method
+----------------------------
+
+This is an original enumeration/discovery method which is available since
+first release of RapidIO subsystem code. The enumeration process is
+implemented according to the enumeration algorithm outlined in the RapidIO
+Interconnect Specification: Annex I [1].
+
+This method can be configured as statically linked or loadable module.
+The method's single parameter "scan" allows to trigger the enumeration/discovery
+process from module initialization routine.
+
+This enumeration/discovery method can be started only once and does not support
+unloading if it is built as a module.
 
 The enumeration process traverses the network using a recursive depth-first
 algorithm. When a new device is found, the enumerator takes ownership of that
@@ -160,6 +253,19 @@ time period. If this wait time period ex
 an agent skips RapidIO discovery and continues with remaining kernel
 initialization.
 
+4.5 Adding New Enumeration/Discovery Method
+-------------------------------------------
+
+RapidIO subsystem code organization allows addition of new enumeration/discovery
+methods as new configuration options without significant impact to to the core
+RapidIO code.
+
+A new enumeration/discovery method has to be attached to one or more mport
+devices before an enumeration/discovery process can be started. Normally,
+method's module initialization routine calls rio_register_scan() to attach
+an enumerator to a specified mport device (or devices). The basic enumerator
+implementation demonstrates this process.
+
 5. References
 -------------
 
diff -puN Documentation/rapidio/sysfs.txt~rapidio-documentation-update-for-enumeration-changes Documentation/rapidio/sysfs.txt
--- a/Documentation/rapidio/sysfs.txt~rapidio-documentation-update-for-enumeration-changes
+++ a/Documentation/rapidio/sysfs.txt
@@ -88,3 +88,20 @@ that exports additional attributes.
 
 IDT_GEN2:
  errlog - reads contents of device error log until it is empty.
+
+
+5. RapidIO Bus Attributes
+-------------------------
+
+RapidIO bus subdirectory /sys/bus/rapidio implements the following bus-specific
+attribute:
+
+  scan - allows to trigger enumeration discovery process from user space. This
+	 is a write-only attribute. To initiate an enumeration or discovery
+	 process on specific mport device, a user needs to write mport_ID (not
+	 RapidIO destination ID) into this file. The mport_ID is a sequential
+	 number (0 ... RIO_MAX_MPORTS) assigned to the mport device.
+	 For example, for a machine with a single RapidIO controller, mport_ID
+	 for that controller always will be 0.
+	 To initiate RapidIO enumeration/discovery on all available mports
+	 a user must write '-1' (or RIO_MPORT_ANY) into this attribute file.
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-switches-remove-tsi500-driver.patch


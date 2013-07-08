From: akpm@linux-foundation.org
Subject: [merged] rapidio-documentation-update.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:36:47 -0700
Message-ID: <51db14cf.23x7quxNwtlH4dvF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3GHTgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stef.van.os@Prodrive.nl, mporter@kernel.crashing.org, micha.nelissen@Prodrive.nl, leoli@freescale.com, jdelvare@suse.de, galak@kernel.crashing.org, andre.van.herk@Prodrive.nl, alexandre.bounine@idt.com

Subject: [merged] rapidio-documentation-update.patch removed from -mm tree
To: alexandre.bounine@idt.com,andre.van.herk@Prodrive.nl,galak@kernel.crashing.org,jdelvare@suse.de,leoli@freescale.com,micha.nelissen@Prodrive.nl,mporter@kernel.crashing.org,stef.van.os@Prodrive.nl,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:47 -0700


The patch titled
     Subject: rapidio: documentation update
has been removed from the -mm tree.  Its filename was
     rapidio-documentation-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: documentation update

Update RapidIO documentation files to reflect modularization changes.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Cc: Stef van Os <stef.van.os@Prodrive.nl>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rapidio/rapidio.txt |   98 ++++++++++++++++++++++++----
 Documentation/rapidio/sysfs.txt   |    1 
 2 files changed, 86 insertions(+), 13 deletions(-)

diff -puN Documentation/rapidio/rapidio.txt~rapidio-documentation-update Documentation/rapidio/rapidio.txt
--- a/Documentation/rapidio/rapidio.txt~rapidio-documentation-update
+++ a/Documentation/rapidio/rapidio.txt
@@ -73,28 +73,44 @@ data structure. This structure includes
 ports that form the same network. It also contains a pointer to the default
 master port that is used to communicate with devices within the network.
 
+2.5 Device Drivers
+
+RapidIO device-specific drivers follow Linux Kernel Driver Model and are
+intended to support specific RapidIO devices attached to the RapidIO network.
+
+2.6 Subsystem Interfaces
+
+RapidIO interconnect specification defines features that may be used to provide
+one or more common service layers for all participating RapidIO devices. These
+common services may act separately from device-specific drivers or be used by
+device-specific drivers. Example of such service provider is the RIONET driver
+which implements Ethernet-over-RapidIO interface. Because only one driver can be
+registered for a device, all common RapidIO services have to be registered as
+subsystem interfaces. This allows to have multiple common services attached to
+the same device without blocking attachment of a device-specific driver.
+
 3. Subsystem Initialization
 ---------------------------
 
 In order to initialize the RapidIO subsystem, a platform must initialize and
 register at least one master port within the RapidIO network. To register mport
-within the subsystem controller driver initialization code calls function
+within the subsystem controller driver's initialization code calls function
 rio_register_mport() for each available master port.
 
-RapidIO subsystem uses subsys_initcall() or device_initcall() to perform
-controller initialization (depending on controller device type).
-
 After all active master ports are registered with a RapidIO subsystem,
 an enumeration and/or discovery routine may be called automatically or
 by user-space command.
 
+RapidIO subsystem can be configured to be built as a statically linked or
+modular component of the kernel (see details below).
+
 4. Enumeration and Discovery
 ----------------------------
 
 4.1 Overview
 ------------
 
-RapidIO subsystem configuration options allow users to specify enumeration and
+RapidIO subsystem configuration options allow users to build enumeration and
 discovery methods as statically linked components or loadable modules.
 An enumeration/discovery method implementation and available input parameters
 define how any given method can be attached to available RapidIO mports:
@@ -115,8 +131,8 @@ several methods to initiate an enumerati
   endpoint waits for enumeration to be completed. If the specified timeout
   expires the discovery process is terminated without obtaining RapidIO network
   information. NOTE: a timed out discovery process may be restarted later using
-  a user-space command as it is described later if the given endpoint was
-  enumerated successfully.
+  a user-space command as it is described below (if the given endpoint was
+  enumerated successfully).
 
   (b) Statically linked enumeration and discovery process can be started by
   a command from user space. This initiation method provides more flexibility
@@ -138,15 +154,42 @@ When a network scan process is started i
 routine depending on the configured role of a master port: host or agent.
 
 Enumeration is performed by a master port if it is configured as a host port by
-assigning a host device ID greater than or equal to zero. A host device ID is
-assigned to a master port through the kernel command line parameter "riohdid=",
-or can be configured in a platform-specific manner. If the host device ID for
-a specific master port is set to -1, the discovery process will be performed
-for it.
+assigning a host destination ID greater than or equal to zero. The host
+destination ID can be assigned to a master port using various methods depending
+on RapidIO subsystem build configuration:
+
+  (a) For a statically linked RapidIO subsystem core use command line parameter
+  "rapidio.hdid=" with a list of destination ID assignments in order of mport
+  device registration. For example, in a system with two RapidIO controllers
+  the command line parameter "rapidio.hdid=-1,7" will result in assignment of
+  the host destination ID=7 to the second RapidIO controller, while the first
+  one will be assigned destination ID=-1.
+
+  (b) If the RapidIO subsystem core is built as a loadable module, in addition
+  to the method shown above, the host destination ID(s) can be specified using
+  traditional methods of passing module parameter "hdid=" during its loading:
+  - from command line: "modprobe rapidio hdid=-1,7", or
+  - from modprobe configuration file using configuration command "options",
+    like in this example: "options rapidio hdid=-1,7". An example of modprobe
+    configuration file is provided in the section below.
+
+  NOTES:
+  (i) if "hdid=" parameter is omitted all available mport will be assigned
+  destination ID = -1;
+  (ii) the "hdid=" parameter in systems with multiple mports can have
+  destination ID assignments omitted from the end of list (default = -1).
+
+If the host device ID for a specific master port is set to -1, the discovery
+process will be performed for it.
 
 The enumeration and discovery routines use RapidIO maintenance transactions
 to access the configuration space of devices.
 
+NOTE: If RapidIO switch-specific device drivers are built as loadable modules
+they must be loaded before enumeration/discovery process starts.
+This requirement is cased by the fact that enumeration/discovery methods invoke
+vendor-specific callbacks on early stages.
+
 4.2 Automatic Start of Enumeration and Discovery
 ------------------------------------------------
 
@@ -266,7 +309,36 @@ method's module initialization routine c
 an enumerator to a specified mport device (or devices). The basic enumerator
 implementation demonstrates this process.
 
-5. References
+4.6 Using Loadable RapidIO Switch Drivers
+-----------------------------------------
+
+In the case when RapidIO switch drivers are built as loadable modules a user
+must ensure that they are loaded before the enumeration/discovery starts.
+This process can be automated by specifying pre- or post- dependencies in the
+RapidIO-specific modprobe configuration file as shown in the example below.
+
+  File /etc/modprobe.d/rapidio.conf:
+  ----------------------------------
+
+  # Configure RapidIO subsystem modules
+
+  # Set enumerator host destination ID (overrides kernel command line option)
+  options rapidio hdid=-1,2
+
+  # Load RapidIO switch drivers immediately after rapidio core module was loaded
+  softdep rapidio post: idt_gen2 idtcps tsi57x
+
+  # OR :
+
+  # Load RapidIO switch drivers just before rio-scan enumerator module is loaded
+  softdep rio-scan pre: idt_gen2 idtcps tsi57x
+
+  --------------------------
+
+NOTE: In the example above, one of "softdep" commands must be removed or
+commented out to keep required module loading sequence.
+
+A. References
 -------------
 
 [1] RapidIO Trade Association. RapidIO Interconnect Specifications.
diff -puN Documentation/rapidio/sysfs.txt~rapidio-documentation-update Documentation/rapidio/sysfs.txt
--- a/Documentation/rapidio/sysfs.txt~rapidio-documentation-update
+++ a/Documentation/rapidio/sysfs.txt
@@ -40,6 +40,7 @@ device_rev - returns the device revision
              (see 4.1 for switch specific details)
    lprev   - returns name of previous device (switch) on the path to the device
              that that owns this attribute
+  modalias - returns the device modalias
 
 In addition to the files listed above, each device has a binary attribute file
 that allows read/write access to the device configuration registers using
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + drivers-edac-add-to-edac-docs.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:32:57 -0700
Message-ID: <200707180032.l6I0WvGs015670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44744 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936606AbXGRAdI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:33:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     drivers/edac: add to edac docs
has been added to the -mm tree.  Its filename is
     drivers-edac-add-to-edac-docs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/edac: add to edac docs
From: Doug Thompson <dougthompson@xmission.com>

Updated the EDAC kernel documentation

Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/drivers/edac/edac.txt |  192 ++++++++++++++++++++++----
 1 files changed, 165 insertions(+), 27 deletions(-)

diff -puN Documentation/drivers/edac/edac.txt~drivers-edac-add-to-edac-docs Documentation/drivers/edac/edac.txt
--- a/Documentation/drivers/edac/edac.txt~drivers-edac-add-to-edac-docs
+++ a/Documentation/drivers/edac/edac.txt
@@ -2,22 +2,42 @@
 
 EDAC - Error Detection And Correction
 
-Written by Doug Thompson <norsk5@xmission.com>
+Written by Doug Thompson <dougthompson@xmission.com>
 7 Dec 2005
+17 Jul 2007	Updated
 
 
-EDAC was written by:
-	Thayne Harbaugh,
-	modified by Dave Peterson, Doug Thompson, et al,
-	from the bluesmoke.sourceforge.net project.
+EDAC is maintained and written by:
 
+	Doug Thompson, Dave Jiang, Dave Peterson et al,
+	original author: Thayne Harbaugh,
+
+Contact:
+	website:	bluesmoke.sourceforge.net
+	mailing list:	bluesmoke-devel@lists.sourceforge.net
+
+"bluesmoke" was the name for this device driver when it was "out-of-tree"
+and maintained at sourceforge.net.  When it was pushed into 2.6.16 for the
+first time, it was renamed to 'EDAC'.
+
+The bluesmoke project at sourceforge.net is now utilized as a 'staging area'
+for EDAC development, before it is sent upstream to kernel.org
+
+At the bluesmoke/EDAC project site, is a series of quilt patches against
+recent kernels, stored in a SVN respository. For easier downloading, there
+is also a tarball snapshot available.
 
 ============================================================================
 EDAC PURPOSE
 
 The 'edac' kernel module goal is to detect and report errors that occur
-within the computer system. In the initial release, memory Correctable Errors
-(CE) and Uncorrectable Errors (UE) are the primary errors being harvested.
+within the computer system running under linux.
+
+MEMORY
+
+In the initial release, memory Correctable Errors (CE) and Uncorrectable
+Errors (UE) are the primary errors being harvested. These types of errors
+are harvested by the 'edac_mc' class of device.
 
 Detecting CE events, then harvesting those events and reporting them,
 CAN be a predictor of future UE events.  With CE events, the system can
@@ -25,9 +45,27 @@ continue to operate, but with less safet
 proactive part replacement of memory DIMMs exhibiting CEs can reduce
 the likelihood of the dreaded UE events and system 'panics'.
 
+NON-MEMORY
+
+A new feature for EDAC, the edac_device class of device, was added in
+the 2.6.23 version of the kernel.
+
+This new device type allows for non-memory type of ECC hardware detectors
+to have their states harvested and presented to userspace via the sysfs
+interface.
+
+Some architectures have ECC detectors for L1, L2 and L3 caches, along with DMA
+engines, fabric switches, main data path switches, interconnections,
+and various other hardware data paths. If the hardware reports it, then
+a edac_device device probably can be constructed to harvest and present
+that to userspace.
+
+
+PCI BUS SCANNING
 
 In addition, PCI Bus Parity and SERR Errors are scanned for on PCI devices
 in order to determine if errors are occurring on data transfers.
+
 The presence of PCI Parity errors must be examined with a grain of salt.
 There are several add-in adapters that do NOT follow the PCI specification
 with regards to Parity generation and reporting. The specification says
@@ -35,11 +73,17 @@ the vendor should tie the parity status 
 to generate parity.  Some vendors do not do this, and thus the parity bit
 can "float" giving false positives.
 
-[There are patches in the kernel queue which will allow for storage of
-quirks of PCI devices reporting false parity positives. The 2.6.18
-kernel should have those patches included. When that becomes available,
-then EDAC will be patched to utilize that information to "skip" such
-devices.]
+In the kernel there is a pci device attribute located in sysfs that is
+checked by the EDAC PCI scanning code. If that attribute is set,
+PCI parity/error scannining is skipped for that device. The attribute
+is:
+
+	broken_parity_status
+
+as is located in /sys/devices/pci<XXX>/0000:XX:YY.Z directorys for
+PCI devices.
+
+FUTURE HARDWARE SCANNING
 
 EDAC will have future error detectors that will be integrated with
 EDAC or added to it, in the following list:
@@ -57,13 +101,14 @@ and the like.
 ============================================================================
 EDAC VERSIONING
 
-EDAC is composed of a "core" module (edac_mc.ko) and several Memory
+EDAC is composed of a "core" module (edac_core.ko) and several Memory
 Controller (MC) driver modules. On a given system, the CORE
 is loaded and one MC driver will be loaded. Both the CORE and
-the MC driver have individual versions that reflect current release
-level of their respective modules.  Thus, to "report" on what version
-a system is running, one must report both the CORE's and the
-MC driver's versions.
+the MC driver (or edac_device driver) have individual versions that reflect
+current release level of their respective modules.
+
+Thus, to "report" on what version a system is running, one must report both
+the CORE's and the MC driver's versions.
 
 
 LOADING
@@ -88,8 +133,9 @@ EDAC sysfs INTERFACE
 EDAC presents a 'sysfs' interface for control, reporting and attribute
 reporting purposes.
 
-EDAC lives in the /sys/devices/system/edac directory. Within this directory
-there currently reside 2 'edac' components:
+EDAC lives in the /sys/devices/system/edac directory.
+
+Within this directory there currently reside 2 'edac' components:
 
 	mc	memory controller(s) system
 	pci	PCI control and status system
@@ -188,7 +234,7 @@ In directory 'mc' are EDAC system overal
 
 Panic on UE control file:
 
-	'panic_on_ue'
+	'edac_mc_panic_on_ue'
 
 	An uncorrectable error will cause a machine panic.  This is usually
 	desirable.  It is a bad idea to continue when an uncorrectable error
@@ -199,12 +245,12 @@ Panic on UE control file:
 
 	LOAD TIME: module/kernel parameter: panic_on_ue=[0|1]
 
-	RUN TIME:  echo "1" >/sys/devices/system/edac/mc/panic_on_ue
+	RUN TIME:  echo "1" >/sys/devices/system/edac/mc/edac_mc_panic_on_ue
 
 
 Log UE control file:
 
-	'log_ue'
+	'edac_mc_log_ue'
 
 	Generate kernel messages describing uncorrectable errors.  These errors
 	are reported through the system message log system.  UE statistics
@@ -212,12 +258,12 @@ Log UE control file:
 
 	LOAD TIME: module/kernel parameter: log_ue=[0|1]
 
-	RUN TIME: echo "1" >/sys/devices/system/edac/mc/log_ue
+	RUN TIME: echo "1" >/sys/devices/system/edac/mc/edac_mc_log_ue
 
 
 Log CE control file:
 
-	'log_ce'
+	'edac_mc_log_ce'
 
 	Generate kernel messages describing correctable errors.  These
 	errors are reported through the system message log system.
@@ -225,12 +271,12 @@ Log CE control file:
 
 	LOAD TIME: module/kernel parameter: log_ce=[0|1]
 
-	RUN TIME: echo "1" >/sys/devices/system/edac/mc/log_ce
+	RUN TIME: echo "1" >/sys/devices/system/edac/mc/edac_mc_log_ce
 
 
 Polling period control file:
 
-	'poll_msec'
+	'edac_mc_poll_msec'
 
 	The time period, in milliseconds, for polling for error information.
 	Too small a value wastes resources.  Too large a value might delay
@@ -241,7 +287,7 @@ Polling period control file:
 
 	LOAD TIME: module/kernel parameter: poll_msec=[0|1]
 
-	RUN TIME: echo "1000" >/sys/devices/system/edac/mc/poll_msec
+	RUN TIME: echo "1000" >/sys/devices/system/edac/mc/edac_mc_poll_msec
 
 
 ============================================================================
@@ -587,3 +633,95 @@ Parity Count:
 
 
 =======================================================================
+
+
+EDAC_DEVICE type of device
+
+In the header file, edac_core.h, there is a series of edac_device structures
+and APIs for the EDAC_DEVICE.
+
+User space access to an edac_device is through the sysfs interface.
+
+At the location /sys/devices/system/edac (sysfs) new edac_device devices will
+appear.
+
+There is a three level tree beneath the above 'edac' directory. For example,
+the 'test_device_edac' device (found at the bluesmoke.sourceforget.net website)
+installs itself as:
+
+	/sys/devices/systm/edac/test-instance
+
+in this directory are various controls, a symlink and one or more 'instance'
+directorys.
+
+The standard default controls are:
+
+	log_ce		boolean to log CE events
+	log_ue		boolean to log UE events
+	panic_on_ue	boolean to 'panic' the system if an UE is encountered
+			(default off, can be set true via startup script)
+	poll_msec	time period between POLL cycles for events
+
+The test_device_edac device adds at least one of its own custom control:
+
+	test_bits	which in the current test driver does nothing but
+			show how it is installed. A ported driver can
+			add one or more such controls and/or attributes
+			for specific uses.
+			One out-of-tree driver uses controls here to allow
+			for ERROR INJECTION operations to hardware
+			injection registers
+
+The symlink points to the 'struct dev' that is registered for this edac_device.
+
+INSTANCES
+
+One or more instance directories are present. For the 'test_device_edac' case:
+
+	test-instance0
+
+
+In this directory there are two default counter attributes, which are totals of
+counter in deeper subdirectories.
+
+	ce_count	total of CE events of subdirectories
+	ue_count	total of UE events of subdirectories
+
+BLOCKS
+
+At the lowest directory level is the 'block' directory. There can be 0, 1
+or more blocks specified in each instance.
+
+	test-block0
+
+
+In this directory the default attributes are:
+
+	ce_count	which is counter of CE events for this 'block'
+			of hardware being monitored
+	ue_count	which is counter of UE events for this 'block'
+			of hardware being monitored
+
+
+The 'test_device_edac' device adds 4 attributes and 1 control:
+
+	test-block-bits-0	for every POLL cycle this counter
+				is incremented
+	test-block-bits-1	every 10 cycles, this counter is bumped once,
+				and test-block-bits-0 is set to 0
+	test-block-bits-2	every 100 cycles, this counter is bumped once,
+				and test-block-bits-1 is set to 0
+	test-block-bits-3	every 1000 cycles, this counter is bumped once,
+				and test-block-bits-2 is set to 0
+
+
+	reset-counters		writing ANY thing to this control will
+				reset all the above counters.
+
+
+Use of the 'test_device_edac' driver should any others to create their own
+unique drivers for their hardware systems.
+
+The 'test_device_edac' sample driver is located at the
+bluesmoke.sourceforge.net project site for EDAC.
+
_

Patches currently in -mm which might be from dougthompson@xmission.com are

drivers-edac-add-edac_mc_find-api.patch
drivers-edac-add-rddr2-memory-types.patch
drivers-edac-split-out-functions-to-unique-files.patch
drivers-edac-add-edac_device-class.patch
drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
drivers-edac-coreh-fix-scrubdefs.patch
drivers-edac-new-i82443bxgz-mc-driver.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-mod-use-edac_coreh.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-new-inte-30x0-mc-driver.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-core-lindent-cleanup.patch
drivers-edac-edac_device-sysfs-cleanup.patch
drivers-edac-cleanup-workq-ifdefs.patch
drivers-edac-lindent-amd76x.patch
drivers-edac-lindent-i5000.patch
drivers-edac-lindent-e7xxx.patch
drivers-edac-lindent-i3000.patch
drivers-edac-lindent-i82860.patch
drivers-edac-lindent-i82875p.patch
drivers-edac-lindent-e752x.patch
drivers-edac-lindent-i82443bxgx.patch
drivers-edac-lindent-r82600.patch
drivers-edac-drivers-to-use-new-pci-operation.patch
drivers-edac-add-device-sysfs-attributes.patch
drivers-edac-device-output-clenaup.patch
drivers-edac-add-info-kconfig.patch
drivers-edac-update-maintainers-files-for-edac.patch
drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
driver-edac-i5000-define-typo.patch
driver-edac-remove-null-from-statics.patch
driver-edac-i5000-code-tidying.patch
driver-edac-edac_device-code-tidying.patch
driver-edac-mod-edac_align_ptr-function.patch
driver-edac-mod-edac_opt_state_to_string-function.patch
driver-edac-remove-file-edac_mc-h.patch
drivers-edac-fix-edac_device-semaphore-to-mutex.patch
drivers-edac-fix-e752x-reversed-csrows.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-fix-leaf-sysfs-attribute.patch
drivers-edac-fix-edac_mc-init-apis.patch
drivers-edac-fix-edac_device-init-apis.patch
drivers-edac-fix-edac_mc-sysfs-completion-code.patch
drivers-edac-fix-edac_device-sysfs-completion-code.patch
drivers-edac-code-tidying-on-export-gpl.patch
drivers-edac-fix-workq-reset-deadlock.patch
drivers-edac-new-i82975x-driver.patch
drivers-edac-new-i82975x-driver-fix.patch
drivers-edac-add-to-maintainers-new-info.patch
drivers-edac-fix-edac_device-sysfs-corner-case-bug.patch
drivers-edac-add-to-edac-docs.patch
